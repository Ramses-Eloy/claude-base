# claude-base

Reglas y plantillas comunes para trabajar con Claude Code en todos mis proyectos (SaaS, apps web, sistemas). Esta carpeta es la madre de los proyectos: cada uno vive dentro con su propio repo y hereda de aquí las reglas globales. Detalle completo en [`.claude/GUIDE.md`](.claude/GUIDE.md).

## Qué contiene

| Ruta | Qué hace |
|---|---|
| `CLAUDE.md` | Núcleo de reglas globales, siempre cargado: arranque, piso crítico de seguridad y qué leer en cada caso. |
| `.claude/quality.md` | Calidad de código, diseño y copy, cuándo preguntar, elección de stack y eficiencia de lectura. |
| `.claude/closing.md` | Pruebas, pruebas que intentan romper el sistema, revisión final y formato del reporte. |
| `.claude/team-flow.md` | Equipo de agentes, tamaños de tarea y orden de pasos. |
| `.claude/github.md` | Issues, ramas, PRs, labels y modelo de ramas. |
| `.claude/multi-machine.md` | Trabajar desde varias máquinas. |
| `.claude/skills/README.md` | Qué skill usar en cada tarea. |
| `.claude/agent-principles.md` | Principios que leen los subagentes. |
| `.claude/security/` | Índice por tipo de proyecto y un archivo por clase de ataque. |
| `.claude/template/` | Lo que se copia a cada proyecto: `CLAUDE.md`, `.claude/settings.json`, los agentes `architect`, `reviewer` y `qa`, el hook del qa, `.gitignore`, `.env.example` y `.gitattributes`. |
| `.claude/agents/` | Los 9 agentes (`architect`, `reviewer`, `qa`, `design`, `security`, `deploy`, `dba`, `backend`, `frontend`); `adopt.sh` copia los 3 primeros y el admin pide el resto. |
| `.claude/skills/` | Skills por tema (tokens, diseño, UI, UX, frontend, backend, seguridad, pruebas, despliegue). |
| `.claude/adopt.sh` | Adopta un proyecto: copia lo que falta, nunca sobrescribe y avisa de lo pendiente. |
| `.claude/test-qa-bash.sh` | Pruebas del hook del qa. |
| `.claude/VERSION` | Versión de la base. |
| `.claude/GUIDE.md` | Guía detallada para personas. |

Este README y el LEEME no los carga ningún `CLAUDE.md`, así que no cuestan tokens.

## Clonar en una máquina nueva

```bash
# Windows (Git Bash)
git clone https://github.com/Ramses-Eloy/claude-base.git /c/Claude
# Mac o Linux
git clone https://github.com/Ramses-Eloy/claude-base.git ~/Claude
```

Después, clona cada proyecto dentro de esa carpeta (`git clone <url> Claude/<Proyecto>`). El `.gitignore` de este repo ignora todo salvo `CLAUDE.md`, `README.md` y `.claude/`, así que los proyectos no se mezclan.

## Qué se repite en cada máquina

- `gh auth login`, o el token de Forgejo si el proyecto lo usa.
- Aceptar la confianza de la carpeta en Claude Code. Sin ella no corren el hook del qa ni el `allow` de `settings.json`.
- `~/.claude/`: configuración personal, memoria y plugins de skills. Nada de eso viaja con el repo.
- Los `.env` reales y `.dev.vars`, que nunca van al repo.
- En Windows, Git Bash (lo necesita el hook) y `gh` en el PATH.

## Adoptar proyectos

- **Nuevo:** crea la carpeta dentro de `Claude/` y abre Claude Code ahí. El agente crea el `CLAUDE.md` desde la plantilla, pregunta el stack y el modelo de ramas y completa el modelo de amenazas.
- **Existente, dentro de `Claude/`:** `bash .claude/adopt.sh <Proyecto>`. Copia lo que falta y lista los avisos: RELLENAR, `.env`, hook, scripts, eol, remoto, `Ramas:`.
- **Fuera de `Claude/`:** el mismo comando copia `.claude/` dentro del proyecto y genera `.claude/global.md`.
- **Actualizar un proyecto externo:** `bash .claude/adopt.sh --actualizar <ruta>`. Refresca su `.claude/` si tiene `VERSION`. Sube `VERSION` cada vez que cambies la base.

## Modelo de ramas (GitFlow simplificado)

Se decide por proyecto. El agente propone uno y tú eliges. La decisión queda en el `CLAUDE.md` del proyecto como `Ramas: … Deploy automático desde: …`.

| Modelo | Ramas | Para |
|---|---|---|
| a | `main` + ramas por Issue | Pequeños o estáticos |
| b | `main` (producción) + `development` + ramas por Issue | Apps con usuarios |
| c | `production` + `staging` opcional + `development` + ramas por Issue | SaaS con pagos o multi-tenant |

### Qué significa a, b y c

La idea: cuanto más daño puede hacer un error a usuarios reales, más pasos hay entre tu código y producción. Cada modelo añade un escalón.

| | Modelo a | Modelo b | Modelo c |
|---|---|---|---|
| Ramas fijas | `main` | `main` + `development` | `production` + `staging` (opcional) + `development` |
| Producción es | `main` | `main` | `production` |
| Camino de un cambio | rama por Issue → PR a `main` | rama por Issue → PR a `development` → PR a `main` | rama por Issue → PR a `development` → `staging` (ensayo) → `production` |
| Dónde se prueba junto | en la propia rama o en local | en `development` | en `development` y en `staging`, que se parece a producción |
| Riesgo | todo merge a `main` puede llegar a producción | hay que mantener `development` al día con `main` | más ramas y ambientes que mantener |
| Úsalo cuando | sitios estáticos, prototipos, proyectos sin usuarios ni pagos | hay usuarios reales y datos, pero sin cobros críticos | hay pagos, varios clientes (multi-tenant) o datos sensibles |

**Cuándo subir de modelo.** No se sube por gusto, sino cuando aparece una de estas señales: el primer pago real, los primeros usuarios con datos, un segundo colaborador o un deploy automático a producción. La señal concreta de cada proyecto está escrita en su línea `Ramas:`.

**Cómo se sube de a a b.** Se crea `development` desde `main`, las ramas nuevas salen de `development`, se protege `main` contra commits directos y se actualiza la línea `Ramas:` del `CLAUDE.md`. Crear ramas en el remoto y cambiar protecciones requiere tu confirmación.

**Estado actual de los proyectos** (según la línea `Ramas:` de cada `CLAUDE.md`):

| Proyecto | Modelo hoy | Cuándo cambia |
|---|---|---|
| AsegurApp | a | a c antes de cobrar la primera suscripción |
| ControlCenter | a | a c antes del primer pago real |
| MermaWatch | a | a c antes de cobrar la primera suscripción |
| SalonFlow | a | a c antes del primer salón que pague |
| WebDavid | a | a b cuando reciba pedidos reales |
| Radio-WhiteLabel | a, más `release/<marca>-<versión>` | para publicar en tiendas |
| WebKosmos, WebSira | a, con deploy automático desde `main` | todo push a `main` publica la web |
| WebALV | a | sin cambio previsto |
| LauncherDBS, WebFA | sin definir | falta decidirlo |

### Estructura

```text
Modelo a (sitios pequeños)
  main ─────●─────────●─────────●───  (deploy)
             ╲        ╱ PR
              feat/12-...

Modelos b y c (apps y SaaS)
  main/production ───●──────────────●──────●───  (deploy)
                      ╲            ╱ PR     ╲ ╱ PR
                       hotfix/20-...         (y luego a development)
  staging (solo c) ───────●───────╱
                           ╲     ╱ PR
  development ────●─────────●───●─────────●───
                   ╲       ╱ PR
                    feat/12-... · fix/13-... · docs/14-...
```

- Rama por Issue: `<tipo>/<número>-<slug>`, con tipo `feat`, `fix`, `docs`, `chore`, `refactor` o `test`. Sale de `development` (de `main` en el modelo a) y vuelve por PR con `Closes #n`.
- Hotfix (modelos b y c): un fallo urgente en producción va en `hotfix/<n>-<slug>`, que sale de la rama de producción y vuelve a ella por PR con aprobación; después se lleva también a `development`. En el modelo a basta un `fix/`.
- Nunca commits directos a producción, ni a `main` si existe `development`. El deploy sale solo de la rama de producción.
- Merge, push y borrar ramas requieren confirmación. Antes de un push o un merge se comprueba si la rama dispara un deploy automático.

### Comparación con GitFlow clásico

| Pieza | GitFlow clásico | Este flujo |
|---|---|---|
| Producción | `main` | `main` (modelos a y b) o `production` (modelo c) |
| Integración | `develop` | `development` (modelos b y c) |
| Trabajo nuevo | `feature/*` | `<tipo>/<n>-<slug>`, una rama por Issue |
| Preparar versión | `release/*` | No existe; se usa `staging` (modelo c) |
| Arreglo urgente | `hotfix/*` desde `main` | `hotfix/*` desde producción (modelos b y c) |
| Una tarea | No define | Issue → rama → PR con criterios de aceptación y evidencia |
| Commits directos | Solo a `main` prohibidos | Prohibidos a producción y a `main` si existe `development` |
| Deploy | Desde `main` | Solo desde la rama de producción; se avisa si otra rama lo dispara |
| Merge | Libre | Solo con aprobación |

## Flujo de trabajo

- **Orquestación:** la sesión principal hace de `admin`: decide qué agente se invoca y cuándo.
- **Tamaño de la tarea:**
  - Trivial y pequeño: los hace ella directamente.
  - Mediano y grande: van con Issue, rama y PR.
- **Agentes:**
  - `architect` y `dba` dictaminan en solo lectura.
  - Quien implementa escribe las pruebas.
  - `qa` las corre.
  - `reviewer` audita el diff.
  - `backend` y `frontend`, solo en tareas grandes.
- **Cierre:** un reporte de 15 líneas como máximo (Cambió / Verificado / Pendiente) con evidencia.

## Seguridad

- **Piso crítico,** siempre cargado:
  - sin secretos en el código ni en el chat, y sin leer los `.env` reales;
  - confirmar antes de acciones destructivas o de un deploy;
  - validación y permisos en el servidor.
- **Tipos de proyecto:**
  - **E**: estático.
  - **C**: con cuentas.
  - **S**: SaaS con pagos o multi-tenant.
- **Clases de ataque:** `security/README.md` indica qué clases aplican a cada tipo. Se leen solo cuando la tarea toca servidor, auth, datos, formularios, cabeceras, pagos o dependencias.
- **Pruebas que intentan romper el sistema:** IDOR, peticiones sin sesión, montos, repeticiones, rate limit y Origin.
- **Límite:** los permisos de `settings.json` comparan el texto del comando, así que no son una barrera completa. El piso real son las reglas escritas.

## Para Claude Code (uso como referencia)

Si eres un agente y llegaste a este repo para consultar algo, esto es lo que necesitas saber.

- **Qué es este repo.** Una base de reglas y plantillas, no una aplicación: no tiene nada que compilar ni probar, salvo los dos scripts de `.claude/`.
- **Si trabajas en un proyecto dentro de esta carpeta**, las reglas ya te llegan: el `CLAUDE.md` de la raíz se carga solo, y él te dice qué leer en cada caso. No hace falta leer este README.
- **Si consultas el repo desde fuera**, lee solo lo que responde tu pregunta:

| Quiero saber… | Leer |
|---|---|
| Las reglas que siempre aplican | `CLAUDE.md` |
| Cómo aplicar la base a un proyecto | `.claude/adopt.sh` (encabezado y sección "Revisión") y `.claude/template/CLAUDE.md` |
| Cómo se reparte el trabajo entre agentes | `.claude/team-flow.md` y `.claude/agent-principles.md` |
| Cómo definir un agente | `.claude/agents/*.md` (frontmatter `name`, `description`, `tools`, `model`; el `qa` añade `hooks`) |
| Cómo limitar Bash a un agente | `.claude/template/.claude/hooks/qa-bash.sh` y sus casos en `.claude/test-qa-bash.sh` |
| Qué permitir, preguntar o bloquear | `.claude/template/.claude/settings.json` |
| Seguridad de un cambio | `.claude/security/README.md`, que indica qué archivos de clase leer según el tipo E/C/S y la tarea |
| Pruebas, revisión y reporte de cierre | `.claude/closing.md` |
| Issues, ramas, PRs y modelo de ramas | `.claude/github.md` |
| Calidad, diseño, copy y elección de stack | `.claude/quality.md` |
| Varias máquinas | `.claude/multi-machine.md` |
| Qué skill usar | `.claude/skills/README.md` |
| Contexto e historia de las decisiones | `.claude/GUIDE.md` (escrito para una persona) |

**Convenciones**
- `RELLENAR` marca un campo que se adapta al proyecto real; nunca se copia tal cual.
- Los archivos de `.claude/` se leen por demanda. No se agregan `@imports` al `CLAUDE.md`, porque cargarían todo en cada sesión.
- `VERSION` sube con cada cambio de la base. `adopt.sh --actualizar` la usa para refrescar los proyectos externos.
- Los `.sh` van con LF (`.gitattributes`).

**Cómo usar algo de aquí en otro proyecto**
- Adapta, no copies: el stack, los usuarios, los datos sensibles y el modelo de amenazas son de cada proyecto.
- Las reglas del proyecto mandan sobre estas, salvo que bajen la seguridad.
- No sobrescribas un `CLAUDE.md` existente: propón los cambios.

**Si modificas la base**
- Una regla nueva va al archivo de `.claude/` que le corresponde. Al `CLAUDE.md` raíz solo entra lo que tiene que estar siempre cargado; hoy son unos 620 tokens y conviene mantenerlo así.
- Después de un cambio, corre `bash .claude/test-qa-bash.sh` si tocaste el hook, prueba `adopt.sh` en un proyecto falso (1ª corrida, 2ª corrida y `--actualizar`) y sube `VERSION`.
- Este README y `.claude/GUIDE.md` no se importan ni se citan desde ningún `CLAUDE.md`.
