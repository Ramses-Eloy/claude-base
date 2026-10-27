# Issues, ramas y PRs

Solo para tareas medianas y grandes; las triviales y pequeñas van por la conversación. En esas, el trabajo vive en el repositorio: cada tarea es un Issue, cada Issue una rama, y cada rama un PR que lo cierra.

## Qué herramienta usar

Detectar el remoto con `git remote get-url origin`:

| Remoto | Herramienta | Autenticación (por máquina) |
|---|---|---|
| `github.com` | `gh` | `gh auth login`; comprobar con `gh auth status`. |
| Instancia Forgejo/Gitea | `fj` (forgejo-cli) o `tea` | Token de la instancia con `read:issue` y `write:issue` (y `read:repository`/`write:repository` para PRs). Antes de usar un subcomando, confirmarlo con `--help`: su sintaxis no está verificada en estas reglas. |
| Sin remoto, o repo sin Issues | La conversación | Alcance, criterios y reporte van en el chat (por ejemplo, proyectos de preparación o estudio). |

Si la herramienta no está instalada o no está autenticada, no improvisar con la API: avisarme y seguir en la conversación.

## Issue

```
Título: <verbo + resultado concreto>
Contexto: <por qué y para quién>
Criterios de aceptación:
- [ ] <comprobable>
Fuera de alcance: <lo que no entra>
```

Sin criterios de aceptación, el Issue no está listo para implementarse: proponerlos y esperar mi visto bueno.

## Ramas, commits y PR

- Rama por Issue: `feature/<número>-<slug-corto>` (arreglos y mejoras no urgentes también). Ejemplo: `feature/12-rate-limit-contacto`. Las urgentes de producción van en `hotfix/` (ver "GitFlow").
- Commits que mencionan el Issue (`#12`) cuando aplica.
- PR con `Closes #12` en la descripción, resumen del cambio y cómo se verificó.
- Merge: nunca sin mi aprobación.

## GitFlow

Un solo flujo para todos los proyectos. Se registra en el `CLAUDE.md` del proyecto con la línea `Ramas: GitFlow. Deploy automático desde: <rama o ninguna>`.

| Rama | Sale de | Vuelve a | Para |
|---|---|---|---|
| `main` | | | Producción. Solo recibe `release/*` y `hotfix/*` |
| `develop` | | | Integración: aquí se juntan y prueban las features |
| `feature/<n>-<slug>` | `develop` | `develop` por PR | Una tarea (un Issue) |
| `release/<versión>` | `develop` | `main` y `develop` | Preparar y estabilizar una versión. Opcional en sitios pequeños |
| `hotfix/<n>-<slug>` | `main` | `main` y `develop` | Fallo urgente en producción |

Reglas:
- Nunca commits directos a `main` ni a `develop`: todo entra por PR.
- Un `release` o un `hotfix` entra a `main` por PR y después se lleva también a `develop`, para que nada se pierda.
- Cada versión que entra a `main` lleva un tag (`v1.2.0`).
- El deploy a producción sale solo de `main`.
- Merge, push y borrar ramas: con mi confirmación.
- Antes de proponer push o merge, comprobar si alguna rama dispara deploy automático (`.github/workflows/`, Cloudflare Workers/Pages Builds u otro) y avisarme. Si no se puede comprobar desde el repo (Cloudflare Builds se configura en el panel), decirlo.
- Crear `develop` en un proyecto nuevo (desde `main`) y proteger `main` y `develop` requiere mi confirmación.

## Labels

Solo estos, y solo si ya existen en el repo (`gh label list`): `feature`, `bug`, `docs`, `chore`, `security`, `bloqueado`. No inventar otros. Crear un label, aunque sea de esta lista, requiere mi aprobación.

## Comentarios con evidencia

Los subagentes reportan a la sesión principal; la sesión principal publica en el Issue o el PR:

- Dictámenes de `architect` y `dba`, con su encabezado (`**architect · dictamen**`) y su formato de reporte.
- Resultado del `qa`: comandos y resultado real.
- Hallazgos del `reviewer`.
- Reporte de cierre: Cambió / Verificado / Pendiente.

Nada de "listo" sin evidencia: cada afirmación de verificación cita el comando y su resultado, o el `archivo:línea`. Publicar con `--body-file` desde un archivo temporal fuera del repo, para no romper el formato con comillas.

En comentarios, Issues y PRs nunca van secretos, valores de `.env`, tokens ni datos personales: el repo puede ser o volverse público.

## Permisos

En `.claude/settings.json`: lectura de `gh` (`issue view/list`, `pr view/list/checks/diff`, `repo view`, `label list`, `auth status`) en `allow`; crear y comentar Issues y PRs, `git push`, `gh pr merge`, `gh label create` y `gh api` en `ask`; force push, borrar ramas remotas y borrar el repo en `deny`. Las reglas comparan el texto del comando, no el programa: no son una barrera de seguridad completa (el piso crítico del `CLAUDE.md` global sigue mandando). En un proyecto con Forgejo, agregar las reglas equivalentes de `fj` o `tea` al adoptarlo.
