# Skills

Las skills están en archivos por tema. Cada agente lee solo los suyos (ver su línea `Skills:`) y **propone** en su reporte las que aplican; el admin (la sesión principal) decide cuáles se cargan. Nunca cargarlas "por si acaso".

- Una sola skill por tipo de tarea. Familia de proceso: `agent-skills:*`. Si una tarea no tiene skill aquí, trabajar sin skill.
- Cada `CLAUDE.md` de proyecto lleva `Skills de este proyecto: ...` con el subconjunto que aplica; esa lista manda sobre estos archivos.
- Los nombres salen de las skills instaladas en esta máquina; si una no existe en otra, se ignora.

| Archivo | Tema | Lo leen |
|---|---|---|
| `tokens.md` | Gastar menos contexto, código y salida | todos |
| `process.md` | Specs, planes, ADRs, documentación | architect |
| `design.md` | Dirección visual, marca, sistema de diseño, Figma | design |
| `ui.md` | Componentes, estilos, accesibilidad, gráficos | design, frontend |
| `ux.md` | Flujos, investigación, textos, críticas | design |
| `frontend.md` | Implementación web, rendimiento | frontend |
| `backend.md` | APIs, datos, SQL, arquitectura | backend, dba, architect |
| `security.md` | Revisión, hardening, respuesta a incidentes | security, reviewer, backend |
| `testing.md` | TDD, e2e, depuración, revisión de código | qa, reviewer |
| `deploy.md` | CI/CD, versiones, lanzamiento | deploy |

Documentos: `anthropic-skills:docx`, `xlsx`, `pptx`, `pdf`.
