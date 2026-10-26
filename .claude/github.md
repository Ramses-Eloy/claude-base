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

- Rama por Issue: `<tipo>/<número>-<slug-corto>`, con `tipo` = `feat`, `fix`, `docs`, `chore`, `refactor` o `test`. Ejemplo: `fix/12-rate-limit-contacto`.
- Commits que mencionan el Issue (`#12`) cuando aplica.
- PR con `Closes #12` en la descripción, resumen del cambio y cómo se verificó.
- Merge: nunca sin mi aprobación.

## Modelo de ramas

No lo elige el agente. Al adoptar un proyecto, o cuando crezca (cuentas, pagos, varios colaboradores, deploy automático), proponer uno con ventajas y desventajas y esperar mi decisión. Se registra en una línea del `CLAUDE.md` del proyecto: `Ramas: <modelo y nombres>. Deploy automático desde: <rama o ninguna>`. Los nombres exactos se deciden por proyecto.

| Modelo | Ramas | Para | Ventaja | Desventaja |
|---|---|---|---|---|
| a | `main` + ramas por Issue | Pequeños o estáticos | Simple, nada que sincronizar | Todo merge a `main` puede llegar a producción |
| b | `main` (producción) + `development` + ramas por Issue | Apps con usuarios | Se integra y prueba antes de producción | Hay que llevar `development` a `main` y mantenerlas al día |
| c | `production` + `staging` opcional + `development` + ramas por Issue | SaaS con pagos o multi-tenant | Ensayo en un ambiente igual a producción | Más ramas y ambientes que mantener |

Reglas comunes:
- Las ramas por Issue salen de `development` (de `main` en el modelo a) y vuelven por PR.
- Nunca commits directos a la rama de producción, ni a `main` si existe `development`.
- Merge, push y borrar ramas: con mi confirmación.
- El deploy a producción sale solo de la rama de producción.
- Antes de proponer push o merge, comprobar si alguna rama dispara deploy automático (`.github/workflows/`, Cloudflare Workers/Pages Builds u otro) y avisarme. Si no se puede comprobar desde el repo (Cloudflare Builds se configura en el panel), decirlo.

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
