# claude-base

Reglas y plantillas comunes para trabajar con Claude Code en todos mis proyectos (SaaS, apps web, sistemas). Esta carpeta es la madre de los proyectos: cada uno vive dentro con su propio repo y hereda de aquí las reglas globales. Detalle completo en [`_base/LEEME.md`](_base/LEEME.md).

## Qué contiene

| Ruta | Qué hace |
|---|---|
| `CLAUDE.md` | Núcleo de reglas globales, siempre cargado: arranque, piso crítico de seguridad y qué leer en cada caso. |
| `_base/calidad.md` | Calidad de código, diseño y copy, cuándo preguntar, elección de stack y eficiencia de lectura. |
| `_base/cierre.md` | Pruebas, pruebas que intentan romper el sistema, revisión final y formato del reporte. |
| `_base/flujo-equipo.md` | Equipo de agentes, tamaños de tarea y orden de pasos. |
| `_base/github.md` | Issues, ramas, PRs, labels y modelo de ramas. |
| `_base/multi-maquina.md` | Trabajar desde varias máquinas. |
| `_base/skills.md` | Qué skill usar en cada tarea. |
| `_base/principios-agentes.md` | Principios que leen los subagentes. |
| `_base/seguridad/` | Índice por tipo de proyecto y un archivo por clase de ataque. |
| `_base/plantilla/` | Lo que se copia a cada proyecto: `CLAUDE.md`, `.claude/settings.json`, los agentes `architect`, `reviewer` y `qa`, el hook del qa, `.gitignore`, `.env.example` y `.gitattributes`. |
| `_base/agentes-opcionales/` | `dba`, `backend` y `frontend`, que se activan por proyecto. |
| `_base/adoptar.sh` | Adopta un proyecto: copia lo que falta, nunca sobrescribe y avisa de lo pendiente. |
| `_base/pruebas-qa-bash.sh` | Pruebas del hook del qa. |
| `_base/VERSION` | Versión de la base. |
| `_base/LEEME.md` | Guía detallada para personas. |

Este README y el LEEME no los carga ningún `CLAUDE.md`, así que no cuestan tokens.

## Clonar en una máquina nueva

```bash
# Windows (Git Bash)
git clone https://github.com/Ramses-Eloy/claude-base.git /c/Claude
# Mac o Linux
git clone https://github.com/Ramses-Eloy/claude-base.git ~/Claude
```

Después, clona cada proyecto dentro de esa carpeta (`git clone <url> Claude/<Proyecto>`). El `.gitignore` de este repo ignora todo salvo `CLAUDE.md`, `README.md` y `_base/`, así que los proyectos no se mezclan.

## Qué se repite en cada máquina

- `gh auth login`, o el token de Forgejo si el proyecto lo usa.
- Aceptar la confianza de la carpeta en Claude Code. Sin ella no corren el hook del qa ni el `allow` de `settings.json`.
- `~/.claude/`: configuración personal, memoria y plugins de skills. Nada de eso viaja con el repo.
- Los `.env` reales y `.dev.vars`, que nunca van al repo.
- En Windows, Git Bash (lo necesita el hook) y `gh` en el PATH.

## Adoptar proyectos

- **Nuevo:** crea la carpeta dentro de `Claude/` y abre Claude Code ahí. El agente crea el `CLAUDE.md` desde la plantilla, pregunta el stack y el modelo de ramas y completa el modelo de amenazas.
- **Existente, dentro de `Claude/`:** `bash _base/adoptar.sh <Proyecto>`. Copia lo que falta y lista los avisos: RELLENAR, `.env`, hook, scripts, eol, remoto, `Ramas:`.
- **Fuera de `Claude/`:** el mismo comando copia `_base/` dentro del proyecto y genera `_base/global.md`.
- **Actualizar un proyecto externo:** `bash _base/adoptar.sh --actualizar <ruta>`. Refresca su `_base/` si tiene `VERSION`. Sube `VERSION` cada vez que cambies la base.

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
