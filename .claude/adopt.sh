#!/usr/bin/env bash
# Adopta las reglas base en un proyecto. Seguro de repetir: nunca sobrescribe
# archivos del proyecto; con --actualizar solo refresca su copia de .claude/ (reglas).
# Copia template/ y los agentes por defecto (architect, reviewer, qa); el admin
# pide más con --agentes dba,backend,... (team-flow.md). Los agentes viven en .claude/agents/.
set -euo pipefail

uso() { echo "Uso: $0 [--actualizar] [--agentes a,b,...] <ruta-del-proyecto>" >&2; exit 1; }

actualizar=0
agentes="architect reviewer qa"
while [ $# -gt 1 ]; do
  case "$1" in
    --actualizar) actualizar=1; shift ;;
    --agentes) [ $# -gt 2 ] || uso; agentes="$agentes ${2//,/ }"; shift 2 ;;
    *) uso ;;
  esac
done
[ $# -eq 1 ] && [ -d "$1" ] || uso

base=$(cd "$(dirname "$0")" && pwd -P)
raiz=$(dirname "$base")
template="$base/template"
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
(cd "$template" && find . -type f | sed 's#^\./##' | sort) | while IFS= read -r rel; do
  copiar "$template/$rel" "$rel"
done
for a in $agentes; do
  [ -f "$base/agents/$a.md" ] || { echo "  agente desconocido: $a" >&2; exit 1; }
  copiar "$base/agents/$a.md" ".claude/agents/$a.md"
done

echo "Reglas base:"
if [ $externo = 0 ]; then
  echo "  heredadas de $raiz/CLAUDE.md (no se copian)"
elif [ -f "$dest/.claude/VERSION" ] && [ $actualizar = 0 ]; then
  echo "  ya existía  .claude/ ($(cat "$dest/.claude/VERSION")); usar --actualizar para refrescarla"
else
  accion=$([ -f "$dest/.claude/VERSION" ] && echo actualizado || echo agregado)
  mkdir -p "$dest/.claude"
  # Reglas, seguridad, skills y scripts; los agentes y la template no se copian aquí.
  for p in "$base"/*; do
    case "$(basename "$p")" in agents | template | settings.local.json) continue ;; esac
    cp -R "$p" "$dest/.claude/"
  done
  # Las reglas globales importan @.claude/...; dentro de .claude/ los imports son relativos a ella.
  rm -rf "$dest/.claude/skills/design-taste-frontend" # skill de terceros por máquina, no viaja
  sed 's#^@.claude/#@#' "$raiz/CLAUDE.md" > "$dest/.claude/global.md"
  echo "  $accion  .claude/ ($(cat "$base/VERSION")) con .claude/global.md"
  if [ $claude_nuevo = 1 ]; then
    { echo '@.claude/global.md'; echo; cat "$dest/CLAUDE.md"; } > "$dest/CLAUDE.md.tmp"
    mv "$dest/CLAUDE.md.tmp" "$dest/CLAUDE.md"
  fi
fi


echo "Revisión:"
avisos=0
aviso() { echo "  - $1"; avisos=$((avisos + 1)); }

c="$dest/CLAUDE.md"
grep -q 'RELLENAR' "$c" && aviso "CLAUDE.md tiene campos sin completar (RELLENAR): adaptarlo al proyecto"
grep -q 'Skills de este proyecto:' "$c" || aviso "CLAUDE.md no tiene la línea 'Skills de este proyecto: ...'"
grep -q '^Ramas:' "$c" || aviso "CLAUDE.md no tiene la línea 'Ramas: ...': agregar 'Ramas: GitFlow. Deploy automático desde: ...' (github.md → GitFlow)"
grep -qE '^[A-Za-z0-9_./-]+\.md[[:space:]]*$' "$c" && aviso "CLAUDE.md tiene una ruta .md suelta: ¿falta la @ del import?"
if [ $externo = 1 ] && ! grep -q '^@.claude/global.md' "$c"; then
  aviso "CLAUDE.md no importa las reglas base: agregar '@.claude/global.md' al inicio"
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
