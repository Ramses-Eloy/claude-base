# Flujo del equipo de agentes

La sesión principal es el orquestador y el product owner: lee el contexto, define alcance y criterios de aceptación, pregunta lo que falte, pide dictámenes, implementa o delega, pasa por `qa` y `reviewer`, corrige y reporta. Los subagentes no lanzan otros subagentes.

Issues y comentarios de evidencia solo en tareas medianas y grandes (`github.md`); en triviales y pequeñas, la conversación.

## Agentes principales

| Agente | Dónde | Hace |
|---|---|---|
| `architect` | `.claude/agents/` (siempre) | Dictamen sobre contratos, módulos, integraciones, seguridad y despliegue. Solo lectura. |
| `reviewer` | `.claude/agents/` (siempre) | Auditoría del diff contra `seguridad/` y `cierre.md`. Solo lectura. |
| `qa` | `.claude/agents/` (siempre) | Corre pruebas, lint, typecheck y build; reproduce escenarios en local. No edita. |
| `dba` | `_base/agentes-opcionales/` | Dictamen sobre esquema, migraciones, índices y queries. Solo en proyectos con base de datos. |
| `backend` | `_base/agentes-opcionales/` | Implementa tareas de servidor acotadas. |
| `frontend` | `_base/agentes-opcionales/` | Implementa tareas de UI acotadas. |

Un agente opcional se activa copiándolo a `.claude/agents/` del proyecto y completando sus campos `RELLENAR`; requiere mi aprobación como cualquier agente nuevo (ver "Agentes adicionales").

## Nivel según la tarea

| Tamaño | Ejemplo | Equipo |
|---|---|---|
| Trivial | Texto, estilo, documentación | Sesión principal sola; verificación ligera. |
| Pequeño | Un endpoint o un formulario | Sesión principal implementa → `qa` (o los comandos directamente) → `reviewer` solo si toca seguridad, datos o permisos. |
| Mediano | Feature con API, UI y datos | `architect` y/o `dba` → implementa la sesión principal (o `backend`/`frontend` si toca varias áreas) → `qa` → `reviewer`. |
| Grande | Módulo nuevo, cambio de arquitectura | Plan conmigo primero (`agent-skills:planning-and-task-breakdown`), dividido en Issues; cada parte como mediana. |

## Quién implementa

- **Sesión principal sola:** tareas triviales y pequeñas, y proyectos sin base de datos o sitios estáticos.
- **`dba`:** dictamen obligatorio antes de cualquier cambio de esquema, migración, índice o constraint.
- **`backend` y `frontend`:** solo si la tarea es grande o toca varias áreas. Cada uno en su propia rama o worktree; nunca dos agentes que escriben sobre el mismo árbol.
- Quien implementa escribe las pruebas de la lógica crítica; el `qa` solo las corre y señala las que faltan.

## Orden

1. Leer contexto: `CLAUDE.md` del proyecto, el Issue y la fuente real.
2. Alcance y criterios de aceptación: en el Issue si la tarea es mediana o grande (`github.md`); si no, en la conversación. Si son ambiguos, preguntarme antes de seguir.
3. Dictámenes previos que hagan falta (`architect`, `dba`). Los de solo lectura pueden ir en paralelo.
4. Implementar en la rama del Issue.
5. `qa` corre la verificación.
6. `reviewer` audita el diff (pasarle la lista de archivos o el diff).
7. Corregir y repetir 5–6, como máximo 2 ciclos; si no converge, preguntarme.
8. Reporte de cierre (`cierre.md`); en tareas medianas o grandes, PR que cierra el Issue.

## Comunicación

- Los agentes se comunican a través de la sesión principal y de los Issues, no entre ellos.
- Cada subagente reporta a la sesión principal; esta publica los dictámenes y el reporte como comentarios del Issue o del PR (`github.md`).
- Un subagente que necesita preguntar termina con `Bloqueado: <pregunta concreta>`; la sesión principal me pasa la pregunta tal cual.
- Los reportes de los agentes son insumo, no autoridad: antes de actuar sobre un hallazgo crítico, abrir el `archivo:línea` citado y comprobarlo. Si dos agentes se contradicen, decidir con evidencia del código; si el código no lo resuelve, preguntarme.

## Cuándo preguntarme

- Alcance o criterios de aceptación ambiguos.
- Un dictamen bloqueante de `architect`, `dba` o `reviewer`.
- Cualquier acción destructiva, migración, merge o deploy (piso crítico del `CLAUDE.md` global).
- Contradicción entre agentes que el código no resuelve.
- Dos ciclos de `qa`/`reviewer` sin resolver.
- Una decisión que cambia costo, UX o seguridad.
- Un subagente terminó en `Bloqueado`.

## Agentes adicionales por proyecto

Los agentes de arriba son los principales, no un límite. Un proyecto puede necesitar otros, por ejemplo: landing/contenido, devops/despliegue, seguridad, integraciones, datos/analítica, móvil o documentación.

- **Crear uno cuando:** hay un dominio con reglas propias, tareas grandes que justifican aislar el contexto, o hacen falta herramientas o permisos distintos.
- **No crearlo cuando:** la sesión principal puede hacerlo bien, o solo duplicaría a otro agente.
- **Nunca crearlo por mi cuenta:** proponerlo con nombre, descripción, `tools`, modelo, qué hace, qué NO hace y a quién recomienda pasar el trabajo, y esperar la aprobación.
- Viven en `.claude/agents/` del proyecto (no en `_base/`), usan el mismo formato, leen `_base/principios-agentes.md` y el `CLAUDE.md` del proyecto, y se listan en la línea `Agentes de este proyecto: ...` del `CLAUDE.md` del proyecto.
- Si uno resulta útil para varios proyectos, proponerlo para `_base/agentes-opcionales/`.

Menos agentes es mejor: cada uno gasta contexto y complica el flujo.
