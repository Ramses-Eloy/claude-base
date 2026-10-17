# Skills

- Usar solo las skills que la tarea y el proyecto necesitan. Nunca cargarlas "por si acaso".
- Una sola skill por tipo de tarea. Familia principal: `agent-skills:*` (de proceso, sirve para cualquier stack). `ecc:*` solo donde `agent-skills` no cubre el tema (bases de datos y patrones de framework).
- Si una tarea no tiene skill en la tabla, trabajar sin skill; no buscar alternativas en otras familias.
- Cada `CLAUDE.md` de proyecto lleva la línea `Skills de este proyecto: ...` con el subconjunto que aplica. Esa lista manda sobre esta tabla.

| Tipo de tarea | Skill |
|---|---|
| Definir requisitos o spec | `agent-skills:spec-driven-development` |
| Planificar y dividir tareas | `agent-skills:planning-and-task-breakdown` |
| Implementar por pasos | `agent-skills:incremental-implementation` |
| Diseño de API o interfaces | `agent-skills:api-and-interface-design` |
| Ingeniería de UI/frontend | `agent-skills:frontend-ui-engineering` |
| Dirección visual y diseño anti-genérico | `impeccable:impeccable` |
| Accesibilidad | `ecc:accessibility` |
| React (hooks, componentes) | `ecc:react-patterns` |
| PostgreSQL (consultas, esquema) | `ecc:postgres-patterns` |
| Prisma | `ecc:prisma-patterns` |
| Migraciones de base de datos | `ecc:database-migrations` |
| Pruebas (TDD) | `agent-skills:test-driven-development` |
| Pruebas en navegador | `agent-skills:browser-testing-with-devtools` |
| Depurar errores | `agent-skills:debugging-and-error-recovery` |
| Revisión de código | `agent-skills:code-review-and-quality` |
| Seguridad y hardening | `agent-skills:security-and-hardening` |
| Simplificar código | `agent-skills:code-simplification` |
| Rendimiento | `agent-skills:performance-optimization` |
| Git y versionado | `agent-skills:git-workflow-and-versioning` |
| CI/CD | `agent-skills:ci-cd-and-automation` |
| Preparar lanzamiento o deploy | `agent-skills:shipping-and-launch` |
| Documentación y ADRs | `agent-skills:documentation-and-adrs` |
| Documentos Word / Excel / PowerPoint / PDF | `anthropic-skills:docx` / `xlsx` / `pptx` / `pdf` |

Subagentes del proyecto (en `.claude/agents/`): `architect`, `dba` y `reviewer`, más los que el proyecto cree para su stack.
