#!/usr/bin/env bash
# Prueba del hook del agente qa: bash _base/pruebas-qa-bash.sh
hook="$(dirname "$0")/plantilla/.claude/hooks/qa-bash.sh"
fallos=0

caso() { # $1 código esperado (0 pasa, 2 bloquea), $2 comando
  json=$(printf '{"tool_name":"Bash","agent_type":"qa","tool_input":{"command":"%s","description":"x"}}' "$2")
  printf '%s' "$json" | bash "$hook" 2> /dev/null
  obtenido=$?
  if [ "$obtenido" = "$1" ]; then echo "ok    [$1] $2"; else echo "FALLA [esperado $1, obtenido $obtenido] $2"; fallos=$((fallos + 1)); fi
}

caso 0 'npm test'
caso 0 'npm run lint'
caso 0 'npm run build'
caso 0 'npx tsc --noEmit'
caso 0 'git diff --stat'
caso 0 'curl -s -X POST http://127.0.0.1:8799/api/contact'
caso 0 'npx wrangler dev --local --port 8799'
caso 2 'npx wrangler deploy'
caso 2 'npm run deploy'
caso 2 'npx prisma migrate deploy'
caso 2 'git push --force'
caso 2 'rm -rf node_modules'
caso 2 'npm test && npx wrangler deploy'
caso 2 'npm test; rm -rf /'
caso 2 'npm test | tee salida.txt'
caso 2 'echo $(cat .env)'
caso 2 'npm run build > log.txt'
caso 2 'curl https://example.com'
caso 2 'curl http://localhost@example.com'
caso 2 'cat .env'
caso 2 'npm install left-pad'
caso 2 'npm test & npx wrangler deploy'

echo "fallos: $fallos"
[ "$fallos" = 0 ]
