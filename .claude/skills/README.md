# Skills

El `admin` (la sesión principal) conoce todas las skills por este índice y, al invocar un agente, le nombra cuáles usar (mapa abajo). Cada agente lee su archivo de tema y puede proponer otras en su reporte (`Skills sugeridas`); el `admin` decide. Nunca cargarlas "por si acaso".

- Una sola skill por tipo de tarea. Familia de proceso: `agent-skills:*`. Si una tarea no tiene skill aquí, trabajar sin skill.
- Cada `CLAUDE.md` de proyecto lleva `Skills de este proyecto: ...` con el subconjunto que aplica; esa lista manda sobre estos archivos.
- Los nombres salen de las skills instaladas en esta máquina; si una no existe en otra, se ignora.

| Archivo | Tema | Lo leen |
|---|---|---|
| `tokens.md` | Gastar menos contexto, código y salida; compact, clear, graphify, markitdown | todos |
| `process.md` | Specs, planes, ADRs, documentación | architect |
| `design.md` | Dirección visual, marca, sistema de diseño, Figma | design |
| `ui.md` | Componentes, estilos, accesibilidad, gráficos | design, frontend |
| `ux.md` | Flujos, investigación, textos, críticas | design |
| `frontend.md` | Implementación web, rendimiento, animación (GSAP) | frontend |
| `backend.md` | APIs, datos, SQL, arquitectura | backend, dba, architect |
| `security.md` | Revisión, hardening, respuesta a incidentes | security, reviewer, backend |
| `testing.md` | TDD, e2e, depuración, revisión de código | qa, reviewer |
| `deploy.md` | CI/CD, versiones, lanzamiento | deploy |

Documentos: `anthropic-skills:docx`, `xlsx`, `pptx`, `pdf`.

## Mapa del admin: qué skill pedirle a cada agente

Al delegar, el `admin` escribe en el encargo: "usa `<skill>`". Si el agente no puede invocarla (sus `tools` son de solo lectura), el `admin` la aplica o le pasa lo esencial. Aquí van las de primera elección; el resto está en el archivo de cada tema.

| Agente | Skills a pedirle | Tema |
|---|---|---|
| `architect` | `agent-skills:spec-driven-development`, `agent-skills:documentation-and-adrs`, `agent-skills:api-and-interface-design` | `process.md`, `backend.md` |
| `design` | `impeccable:impeccable`, `design-taste-frontend` (por instalar), `ui-ux-pro-max:ui-ux-pro-max`, `design:design-system`, `design:accessibility-review`, `design:ux-copy` | `design.md`, `ui.md`, `ux.md` |
| `frontend` | `agent-skills:frontend-ui-engineering`, `everything-claude-code:frontend-patterns`, `agent-skills:browser-testing-with-devtools` | `frontend.md`, `ui.md` |
| `backend` | `everything-claude-code:backend-patterns`, `agent-skills:api-and-interface-design`, `agent-skills:security-and-hardening` | `backend.md`, `security.md` |
| `dba` | `data:sql-queries`, `agent-skills:deprecation-and-migration` | `backend.md` |
| `security` | `agent-skills:security-and-hardening`, `security-review`; `security-audit` solo en auditoría completa | `security.md` |
| `reviewer` | `agent-skills:code-review-and-quality`, `security-review` | `security.md`, `testing.md` |
| `qa` | `agent-skills:test-driven-development`, `everything-claude-code:e2e`, `agent-skills:browser-testing-with-devtools` | `testing.md` |
| `deploy` | `agent-skills:ci-cd-and-automation`, `agent-skills:shipping-and-launch`, `agent-skills:git-workflow-and-versioning` | `deploy.md` |
| todos | `ponytail:ponytail` (no sobre-construir), `caveman:caveman` (salida corta), `everything-claude-code:strategic-compact` (sesión larga) | `tokens.md` |

## Cuándo usar skills (ahorro de tokens)

| Nivel | Skills | Regla |
|---|---|---|
| Siempre ligeras | `ponytail:ponytail`, `caveman:caveman` | Se pueden usar en cualquier tarea. |
| Pesadas, solo en trabajo nuevo o desde cero | `superpowers:*`, `agent-skills:spec-driven-development`, `agent-skills:planning-and-task-breakdown`, `impeccable:impeccable` (modo craft), `design-taste-frontend`, `ui-ux-pro-max:*` | Solo cuando el usuario pide algo nuevo o un proyecto desde cero. Un arreglo o cambio pequeño no las carga. |
| Pesadas, solo en el momento justo | `security-audit` (auditoría completa) | Cuando la base del frontend y del backend ya está hecha y la app se da por terminada, antes de lanzar; después se sigue mejorando. No durante el desarrollo inicial. |
| Pesadas, solo por petición explícita | `/graphify` (construir el grafo) | Solo si el usuario pide el mapa del repo. |
| Contexto | `/compact`, `/clear`, `markitdown` | Ver `tokens.md`; el `admin` las sugiere cuando toca. |

Las skills `superpowers:*` no están instaladas hoy en esta máquina; si se instalan, siguen esta misma regla.

Skills por instalar (las ejecuta el usuario, no el agente): `design-taste-frontend`, `apple-design`, `security-audit`, `graphify`, `markitdown`. Los comandos están en `design.md`, `security.md` y `tokens.md`.
