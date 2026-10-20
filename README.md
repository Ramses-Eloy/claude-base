# claude-base

Reglas y plantillas comunes para trabajar con Claude Code en todos mis proyectos (SaaS, apps web, sistemas). Esta carpeta es la madre de los proyectos: cada uno vive dentro con su propio repo y hereda de aquí las reglas globales. Detalle completo en [`base/LEEME.md`](base/LEEME.md).

## Qué contiene

| Ruta | Qué hace |
|---|---|
| `CLAUDE.md` | Núcleo de reglas globales, siempre cargado: arranque, piso crítico de seguridad y qué leer en cada caso. |
| `base/calidad.md` | Calidad de código, diseño y copy, cuándo preguntar, elección de stack y eficiencia de lectura. |
| `base/cierre.md` | Pruebas, pruebas que intentan romper el sistema, revisión final y formato del reporte. |
| `base/flujo-equipo.md` | Equipo de agentes, tamaños de tarea y orden de pasos. |
| `base/github.md` | Issues, ramas, PRs, labels y modelo de ramas. |
| `base/multi-maquina.md` | Trabajar desde varias máquinas. |
| `base/skills.md` | Qué skill usar en cada tarea. |
| `base/principios-agentes.md` | Principios que leen los subagentes. |
| `base/seguridad/` | Índice por tipo de proyecto y un archivo por clase de ataque. |
| `base/plantilla/` | Lo que se copia a cada proyecto: `CLAUDE.md`, `.claude/settings.json`, los agentes `architect`, `reviewer` y `qa`, el hook del qa, `.gitignore`, `.env.example` y `.gitattributes`. |
| `base/agentes-opcionales/` | `dba`, `backend` y `frontend`, que se activan por proyecto. |
| `base/adoptar.sh` | Adopta un proyecto: copia lo que falta, nunca sobrescribe y avisa de lo pendiente. |
| `base/pruebas-qa-bash.sh` | Pruebas del hook del qa. |
| `base/VERSION` | Versión de la base. |
| `base/LEEME.md` | Guía detallada para personas. |

Este README y el LEEME no los carga ningún `CLAUDE.md`, así que no cuestan tokens.

## Clonar en una máquina nueva

```bash
# Windows (Git Bash)
git clone https://github.com/Ramses-Eloy/claude-base.git /c/Claude
# Mac o Linux
git clone https://github.com/Ramses-Eloy/claude-base.git ~/Claude
```

Después, clona cada proyecto dentro de esa carpeta (`git clone <url> Claude/<Proyecto>`). El `.gitignore` de este repo ignora todo salvo `CLAUDE.md`, `README.md` y `base/`, así que los proyectos no se mezclan.

## Qué se repite en cada máquina

- `gh auth login`, o el token de Forgejo si el proyecto lo usa.
- Aceptar la confianza de la carpeta en Claude Code. Sin ella no corren el hook del qa ni el `allow` de `settings.json`.
- `~/.claude/`: configuración personal, memoria y plugins de skills. Nada de eso viaja con el repo.
- Los `.env` reales y `.dev.vars`, que nunca van al repo.
- En Windows, Git Bash (lo necesita el hook) y `gh` en el PATH.

## Adoptar proyectos

- **Nuevo:** crea la carpeta dentro de `Claude/` y abre Claude Code ahí. El agente crea el `CLAUDE.md` desde la plantilla, pregunta el stack y el modelo de ramas y completa el modelo de amenazas.
- **Existente, dentro de `Claude/`:** `bash base/adoptar.sh <Proyecto>`. Copia lo que falta y lista los avisos: RELLENAR, `.env`, hook, scripts, eol, remoto, `Ramas:`.
- **Fuera de `Claude/`:** el mismo comando copia `base/` dentro del proyecto y genera `base/global.md`.
- **Actualizar un proyecto externo:** `bash base/adoptar.sh --actualizar <ruta>`. Refresca su `base/` si tiene `VERSION`. Sube `VERSION` cada vez que cambies la base.

## Modelo de ramas

Se decide por proyecto. El agente propone uno y tú eliges. La decisión queda en el `CLAUDE.md` del proyecto como `Ramas: … Deploy automático desde: …`.

| Modelo | Ramas | Para |
|---|---|---|
| a | `main` + ramas por Issue | Pequeños o estáticos |
| b | `main` (producción) + `development` + ramas por Issue | Apps con usuarios |
| c | `production` + `staging` opcional + `development` + ramas por Issue | SaaS con pagos o multi-tenant |

Nunca se hacen commits directos a producción. Merge, push y borrar ramas requieren confirmación. Antes de un push o un merge se comprueba si la rama dispara un deploy automático.

## Flujo de trabajo

- **Orquestación:** la sesión principal orquesta y hace de product owner.
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
- **Clases de ataque:** `seguridad/README.md` indica qué clases aplican a cada tipo. Se leen solo cuando la tarea toca servidor, auth, datos, formularios, cabeceras, pagos o dependencias.
- **Pruebas que intentan romper el sistema:** IDOR, peticiones sin sesión, montos, repeticiones, rate limit y Origin.
- **Límite:** los permisos de `settings.json` comparan el texto del comando, así que no son una barrera completa. El piso real son las reglas escritas.

## Para Claude Code (uso como referencia)

Si eres un agente y llegaste a este repo para consultar algo, esto es lo que necesitas saber.

- **Qué es este repo.** Una base de reglas y plantillas, no una aplicación: no tiene nada que compilar ni probar, salvo los dos scripts de `base/`.
- **Si trabajas en un proyecto dentro de esta carpeta**, las reglas ya te llegan: el `CLAUDE.md` de la raíz se carga solo, y él te dice qué leer en cada caso. No hace falta leer este README.
- **Si consultas el repo desde fuera**, lee solo lo que responde tu pregunta:

| Quiero saber… | Leer |
|---|---|
| Las reglas que siempre aplican | `CLAUDE.md` |
| Cómo aplicar la base a un proyecto | `base/adoptar.sh` (encabezado y sección "Revisión") y `base/plantilla/CLAUDE.md` |
| Cómo se reparte el trabajo entre agentes | `base/flujo-equipo.md` y `base/principios-agentes.md` |
| Cómo definir un agente | `base/plantilla/.claude/agents/*.md` y `base/agentes-opcionales/*.md` (frontmatter `name`, `description`, `tools`, `model`; el `qa` añade `hooks`) |
| Cómo limitar Bash a un agente | `base/plantilla/.claude/hooks/qa-bash.sh` y sus casos en `base/pruebas-qa-bash.sh` |
| Qué permitir, preguntar o bloquear | `base/plantilla/.claude/settings.json` |
| Seguridad de un cambio | `base/seguridad/README.md`, que indica qué archivos de clase leer según el tipo E/C/S y la tarea |
| Pruebas, revisión y reporte de cierre | `base/cierre.md` |
| Issues, ramas, PRs y modelo de ramas | `base/github.md` |
| Calidad, diseño, copy y elección de stack | `base/calidad.md` |
| Varias máquinas | `base/multi-maquina.md` |
| Qué skill usar | `base/skills.md` |
| Contexto e historia de las decisiones | `base/LEEME.md` (escrito para una persona) |

**Convenciones**
- `RELLENAR` marca un campo que se adapta al proyecto real; nunca se copia tal cual.
- Los archivos de `base/` se leen por demanda. No se agregan `@imports` al `CLAUDE.md`, porque cargarían todo en cada sesión.
- `VERSION` sube con cada cambio de la base. `adoptar.sh --actualizar` la usa para refrescar los proyectos externos.
- Los `.sh` van con LF (`.gitattributes`).

**Cómo usar algo de aquí en otro proyecto**
- Adapta, no copies: el stack, los usuarios, los datos sensibles y el modelo de amenazas son de cada proyecto.
- Las reglas del proyecto mandan sobre estas, salvo que bajen la seguridad.
- No sobrescribas un `CLAUDE.md` existente: propón los cambios.

**Si modificas la base**
- Una regla nueva va al archivo de `base/` que le corresponde. Al `CLAUDE.md` raíz solo entra lo que tiene que estar siempre cargado; hoy son unos 620 tokens y conviene mantenerlo así.
- Después de un cambio, corre `bash base/pruebas-qa-bash.sh` si tocaste el hook, prueba `adoptar.sh` en un proyecto falso (1ª corrida, 2ª corrida y `--actualizar`) y sube `VERSION`.
- Este README y `base/LEEME.md` no se importan ni se citan desde ningún `CLAUDE.md`.
