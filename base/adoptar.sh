#!/usr/bin/env bash
# Adopta las reglas base en un proyecto. Seguro de repetir: nunca sobrescribe
# archivos del proyecto; con --actualizar solo refresca su copia de base/.
# Solo copia plantilla/; los agentes de base/agentes-opcionales/ se activan a mano (flujo-equipo.md).
set -euo pipefail

uso() { echo "Uso: $0 [--actualizar] <ruta-del-proyecto>" >&2; exit 1; }

actualizar=0
if [ "${1:-}" = "--actualizar" ]; then actualizar=1; shift; fi
[ $# -eq 1 ] && [ -d "$1" ] || uso

base=$(cd "$(dirname "$0")" && pwd -P)
raiz=$(dirname "$base")
plantilla="$base/plantilla"
dest=$(cd "$1" && pwd -P)

case "$dest" in
  "$raiz" | "$base" | "$base"/*) echo "Destino inválido: $dest" >&2; exit 1 ;;
esac
case "$dest/" in
  "$raiz"/*) externo=0 ;;
  *) externo=1 ;;
esac

copiar() { # $1 origen, $2 ruta relativa en el proyecto
  if [ -e "$dest/$2" ]; then
    echo "  ya existía  $2"
  else
    mkdir -p "$(dirname "$dest/$2")"
    cp "$1" "$dest/$2"
    echo "  agregado    $2"
  fi
}

claude_nuevo=0
[ -e "$dest/CLAUDE.md" ] || claude_nuevo=1

echo "Proyecto: $dest ($([ $externo = 1 ] && echo fuera || echo dentro) de $raiz)"
echo "Archivos:"
(cd "$plantilla" && find . -type f | sed 's#^\./##' | sort) | while IFS= read -r rel; do
  copiar "$plantilla/$rel" "$rel"
done

echo "Reglas base:"
if [ $externo = 0 ]; then
  echo "  heredadas de $raiz/CLAUDE.md (no se copian)"
elif [ -d "$dest/base" ] && [ ! -f "$dest/base/VERSION" ]; then
  echo "  base/ ya existe y no es de estas reglas: no se toca" >&2
  exit 1
elif [ -d "$dest/base" ] && [ $actualizar = 0 ]; then
  echo "  ya existía  base/ ($(cat "$dest/base/VERSION")); usar --actualizar para refrescarla"
else
  accion=$([ -d "$dest/base" ] && echo actualizado || echo agregado)
  mkdir -p "$dest/base"
  cp -R "$base/." "$dest/base/"
  # Las reglas globales importan @base/...; dentro de base/ los imports son relativos a ella.
  sed 's#^@base/#@#' "$raiz/CLAUDE.md" > "$dest/base/global.md"
  echo "  $accion  base/ ($(cat "$base/VERSION")) con base/global.md"
  if [ $claude_nuevo = 1 ]; then
    { echo '@base/global.md'; echo; cat "$dest/CLAUDE.md"; } > "$dest/CLAUDE.md.tmp"
    mv "$dest/CLAUDE.md.tmp" "$dest/CLAUDE.md"
  fi
fi

echo "Revisión:"
avisos=0
aviso() { echo "  - $1"; avisos=$((avisos + 1)); }

c="$dest/CLAUDE.md"
grep -q 'RELLENAR' "$c" && aviso "CLAUDE.md tiene campos sin completar (RELLENAR): adaptarlo al proyecto"
grep -q 'Skills de este proyecto:' "$c" || aviso "CLAUDE.md no tiene la línea 'Skills de este proyecto: ...'"
grep -q '^Ramas:' "$c" || aviso "CLAUDE.md no tiene la línea 'Ramas: ...': proponer un modelo (github.md → Modelo de ramas) y esperar decisión"
grep -qE '^[A-Za-z0-9_./-]+\.md[[:space:]]*$' "$c" && aviso "CLAUDE.md tiene una ruta .md suelta: ¿falta la @ del import?"
if [ $externo = 1 ] && ! grep -q '^@base/global.md' "$c"; then
  aviso "CLAUDE.md no importa las reglas base: agregar '@base/global.md' al inicio"
fi
grep -qE '^/?\.env\*?[[:space:]]*$' "$dest/.gitignore" || aviso ".gitignore no excluye .env"
grep -q '\.env' "$dest/.claude/settings.json" || aviso ".claude/settings.json no bloquea la lectura de .env*"
grep -q '"allow"' "$dest/.claude/settings.json" || aviso ".claude/settings.json no tiene el allow de verificación que usa el agente qa"
if [ -f "$dest/.claude/agents/qa.md" ] && [ ! -f "$dest/.claude/hooks/qa-bash.sh" ]; then
  aviso "existe el agente qa pero falta su hook .claude/hooks/qa-bash.sh"
fi
[ -f "$dest/package.json" ] && aviso "revisar que los scripts test/lint/build/typecheck de package.json no desplieguen ni migren (el allow los ejecuta sin confirmar)"
grep -q 'eol=lf' "$dest/.gitattributes" 2> /dev/null || aviso ".gitattributes no fija eol=lf para *.sh (los scripts pueden romperse con CRLF)"
if ! git -C "$dest" rev-parse --git-dir > /dev/null 2>&1; then
  aviso "no es un repositorio git: el flujo de Issues no aplica, usar la conversación"
else
  [ -n "$(git -C "$dest" remote)" ] || aviso "sin remoto: el flujo de Issues no aplica hasta configurarlo (github.md)"
  versionados=$(git -C "$dest" ls-files | grep -E '(^|/)\.env($|\.)' | grep -v '\.example$' || true)
  [ -n "$versionados" ] && aviso "archivos .env versionados en git: $(echo $versionados)"
fi
if [ $avisos = 0 ]; then echo "  sin problemas detectados"; fi
