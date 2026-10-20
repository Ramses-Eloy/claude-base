# Trabajo en varias máquinas

Trabajo en Windows, Mac y una laptop. Ninguna máquina guarda estado que las demás necesiten.

## Nada de estado local

- Lo importante vive en el Issue, el PR o una rama con push: decisiones, avances, pendientes y el siguiente paso.
- No dejar trabajo solo en el working tree, en stashes ni en notas locales al cerrar una sesión.
- Push solo con confirmación (piso crítico del `CLAUDE.md` global); si no se hace push, decirlo en el reporte de cierre.

## Inicio de sesión

1. `git fetch` y, si la rama actual sigue a un remoto y no hay cambios locales, `git pull --ff-only`.
2. `gh auth status` (o la herramienta del remoto, `github.md`).
3. Rama actual y estado: `git status -sb`.
4. PRs abiertos: `gh pr list`.
5. Issue en curso: leerlo con sus comentarios (`gh issue view <n> --comments`) y retomar desde el último "siguiente paso".

Si algo no coincide (cambios locales sin push, rama atrasada, autenticación caída), reportarlo antes de tocar código.

## Cierre de sesión

1. Commit de lo terminado.
2. Push de la rama, con confirmación.
3. Comentario en el Issue: estado, lo verificado y el siguiente paso concreto.

## Portabilidad

- Sin rutas absolutas en archivos del repo (`C:\...`, `/Users/...`): rutas relativas a la raíz del proyecto o `$CLAUDE_PROJECT_DIR` en hooks.
- Scripts en Bash portable: funcionan en Git Bash (Windows) y en macOS. Nada de extensiones solo de GNU (por ejemplo `sed` con `\|`; usar `sed -E`).
- `.gitattributes` con `*.sh text eol=lf`, para que los scripts no se rompan con CRLF en Windows.
- Los hooks de Claude Code en Windows corren con Git Bash si está instalado; sin Git Bash, un hook en Bash no funciona.

## Lo que es por máquina (repetir en cada una)

- `.env` y `.dev.vars` reales: nunca viajan por git.
- `~/.claude/`: `settings.json` de usuario, `CLAUDE.md` de usuario, skills, agentes y MCP de usuario.
- Plugins: un repo puede declararlos en `.claude/settings.json`, pero cada máquina los instala.
- Hooks de usuario; los de proyecto (y los del frontmatter de agentes) solo corren tras aceptar la confianza de la carpeta en esa máquina.
- Autenticación: login de Claude Code, `gh auth login` y tokens de Forgejo.

Lo que sí viaja con cada repo: `CLAUDE.md`, `.claude/settings.json`, `.claude/agents/`, `.claude/hooks/`, `.mcp.json` (con aprobación por máquina), `.gitattributes` y `.env.example`.
