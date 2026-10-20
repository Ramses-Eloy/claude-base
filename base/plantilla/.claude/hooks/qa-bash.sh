#!/usr/bin/env bash
# Hook PreToolUse del agente qa (ver .claude/agents/qa.md): solo deja pasar comandos de verificación.
# Sale con 2 para bloquear; el motivo va por stderr al agente. Las reglas de settings.json siguen aplicando.
# Adaptar la lista "permitidos" al stack del proyecto al adoptarlo.

# sed -E (no \| de GNU) para que funcione igual en Git Bash y en macOS.
cmd=$(tr -d '\r\n' | sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')

bloquear() { echo "qa: comando bloqueado ($1): $cmd" >&2; exit 2; }

[ -n "$cmd" ] || bloquear "no se pudo leer el comando"

case "$cmd" in
  *'&'* | *';'* | *'|'* | *'`'* | *'$('* | *'>'* | *'<'*) bloquear "encadenado, subshell o redirección" ;;
esac

# Red: solo localhost.
if printf '%s' "$cmd" | grep -oE '[a-zA-Z]+://[^ "\\]+' | grep -qvE '^https?://(localhost|127\.0\.0\.1)(:[0-9]+)?(/|$)'; then
  bloquear "URL fuera de localhost"
fi

permitidos='^(npm (test|run (test|lint|build|typecheck))|pnpm (test|run (test|lint|build|typecheck))|yarn (test|lint|build|typecheck)|npx (tsc --noEmit|vitest run|jest|eslint)|pytest|python -m pytest|ruff check|go (test|vet)|cargo (test|clippy)|git (status|diff|log|show)|curl|npx wrangler dev)( |$)'
printf '%s' "$cmd" | grep -qE "$permitidos" || bloquear "fuera de la lista de verificación"

exit 0
