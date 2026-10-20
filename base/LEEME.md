# LEEME: cómo funciona esta base

Documento para ti, no para los agentes. Ningún `CLAUDE.md` lo importa ni lo cita, así que no consume tokens en las sesiones.

## Qué es

`C:\Claude` es la carpeta madre de todos tus proyectos. Su `CLAUDE.md` contiene las reglas globales. Claude Code lo carga en cualquier subcarpeta porque lee los `CLAUDE.md` subiendo por el árbol, así que todo agente que abras en un proyecto de aquí dentro las hereda. `base/` guarda el resto de las reglas, que se leen solo cuando hacen falta, la plantilla para proyectos nuevos y el script de adopción.

| Archivo | Para qué |
|---|---|
| `CLAUDE.md` (raíz) | Núcleo que siempre está cargado: arranque, piso crítico de seguridad y qué leer en cada caso. |
| `base/calidad.md` | Calidad de código, diseño y copy sin genéricos, cuándo preguntar, elección de stack y eficiencia de lectura. |
| `base/cierre.md` | Pruebas, pruebas que intentan romper el sistema, revisión final y formato del reporte. |
| `base/flujo-equipo.md` | Equipo de agentes, tamaños de tarea, quién implementa, orden de pasos y agentes adicionales. |
| `base/github.md` | Issues, ramas, PRs, labels, comentarios con evidencia y modelo de ramas. |
| `base/multi-maquina.md` | Trabajar en varias máquinas: qué viaja con el repo y qué no. |
| `base/skills.md` | Qué skill usar en cada tarea (una sola por tarea). |
| `base/principios-agentes.md` | Los 9 principios que leen los subagentes. |
| `base/seguridad/` | `README.md`, que indica qué clase de ataque leer según el tipo de proyecto y la tarea, más un archivo por clase. |
| `base/plantilla/` | Lo que se copia a cada proyecto: `CLAUDE.md` con campos RELLENAR, `.claude/settings.json`, los agentes `architect`, `reviewer` y `qa`, el hook del qa, `.gitignore`, `.env.example` y `.gitattributes`. |
| `base/agentes-opcionales/` | `dba`, `backend` y `frontend`. Se activan a mano, solo cuando el proyecto los necesita. |
| `base/adoptar.sh` | Copia lo que le falta a un proyecto y revisa su configuración. |
| `base/pruebas-qa-bash.sh` | 22 casos para comprobar el hook del qa. |
| `base/VERSION` | Versión de la base. Sirve para `adoptar.sh --actualizar` en proyectos que están fuera de `C:\Claude`. |
| `base/LEEME.md` | Este archivo. |

La carpeta `C:\Claude` es un repo git local: solo versiona `CLAUDE.md`, `base/` y `.gitignore`. Cada proyecto tiene su propio repo.

## El día a día

1. Crea o copia el proyecto dentro de `C:\Claude\<Proyecto>` y abre Claude Code ahí.
2. El agente arranca solo:
   - **Lee el `CLAUDE.md` del proyecto.** Si no existe, lo crea desde la plantilla adaptándolo al proyecto real. Si existe, no lo sobrescribe: propone cambios.
   - **Si el proyecto ya existía, ejecuta `base/adoptar.sh`** y te reporta lo que falta antes de tocar código.
   - **Completa el modelo de amenazas:** el tipo E/C/S, activos, atacantes, vectores y controles.
   - **Si no indicaste el stack, conversa contigo** y te da 2 o 3 opciones. No crea nada hasta que decidas.
   - **Si no hay línea `Ramas:`**, te propone un modelo de ramas y espera tu decisión.
3. A partir de ahí trabaja en silencio. Cierra con un reporte de 15 líneas como máximo, dividido en Cambió / Verificado / Pendiente y con evidencia.

## Flujo de trabajo

La sesión principal, que es la que abres tú, hace de orquestadora y de product owner: decide el alcance, reparte el trabajo y te pregunta lo que solo tú puedes decidir. Los subagentes no pueden lanzar a otros, así que todo pasa por ella.

| Tamaño | Ejemplo | Cómo se trabaja |
|---|---|---|
| Trivial | Un typo, un texto | La sesión principal lo hace directamente, sin agentes ni Issue. |
| Pequeño | Un componente, un fix acotado | La sesión principal implementa y corre las pruebas. `reviewer` solo si toca seguridad, datos o permisos. Sin Issue. |
| Mediano | Una funcionalidad con backend | Issue y rama. `architect` si cruza módulos, `dba` si toca el esquema, luego `qa` y `reviewer`. |
| Grande | Varias áreas o semanas | Lo de mediano, y además `backend` y `frontend` en paralelo, cada uno en su rama o worktree. |

| Agente | Modelo | Cuándo | Qué puede hacer |
|---|---|---|---|
| `architect` | opus | Antes de cambios entre módulos, contratos o integraciones | Solo leer y dar un dictamen. |
| `dba` (opcional) | opus | Siempre antes de cambiar el esquema, las migraciones o los índices | Solo leer y dar un dictamen. |
| `qa` | sonnet | Después de implementar: tests, lint, typecheck, build y escenarios en localhost | Bash limitado por un hook. No edita. |
| `reviewer` | opus | Antes de cerrar: auditoría del diff por clases de ataque | Solo leer. Clasifica los hallazgos como Crítico, Alto, Medio o Bajo. |
| `backend` / `frontend` (opcionales) | sonnet | Solo en tareas grandes | Implementan su parte y escriben sus pruebas. |

- **Pruebas:** las escribe quien implementa y las corre el `qa`. Hay como máximo 2 ciclos de qa y reviewer. Si siguen fallando, la sesión principal te pregunta.
- **Comunicación:** los subagentes reportan a la sesión principal y, en tareas medianas o grandes, ella publica los dictámenes y la evidencia en el Issue. Si un subagente necesita algo tuyo, termina con `Bloqueado: <pregunta>`.
- **Agentes adicionales:** solo se crean con tu aprobación y en el `.claude/agents/` de ese proyecto, y se listan en la línea "Agentes de este proyecto:". Si un agente sirve para varios proyectos, se generaliza y se mueve a `base/agentes-opcionales/`.

## GitHub

- **Issues solo en tareas medianas o grandes.** Las triviales y pequeñas se resuelven en la conversación.
- **Cada Issue lleva criterios de aceptación.** Sin ellos no se implementa.
- **Ramas** con el formato `<tipo>/<N>-<slug>` (por ejemplo `fix/12-rate-limit-contacto`).
- **PRs** con `Closes #N`. El merge solo lo hace alguien con tu aprobación.
- **Labels:** solo `feature`, `bug`, `docs`, `chore`, `seguridad` y `bloqueado`, y solo si ya existen en el repo. Crear uno requiere tu aprobación.
- **Herramienta:** `gh` en GitHub; `fj` o `tea` en Forgejo; sin remoto, la conversación.

**Modelo de ramas** (detalle en `github.md`). El agente no lo elige: lo propone con ventajas y desventajas y tú decides. Queda registrado en una línea del `CLAUDE.md` del proyecto: `Ramas: … Deploy automático desde: …`.

| Modelo | Ramas | Para |
|---|---|---|
| a | `main` + ramas por Issue | Proyectos pequeños o estáticos |
| b | `main` (producción) + `development` + ramas por Issue | Apps con usuarios |
| c | `production` + `staging` opcional + `development` + ramas por Issue | SaaS con pagos o multi-tenant |

En todos los modelos:
- nunca hay commits directos a la rama de producción;
- push, merge y borrar ramas, solo con tu confirmación;
- antes de proponer un push o un merge, el agente revisa si alguna rama dispara un deploy automático (workflows de GitHub o Cloudflare Builds) y te avisa.

## Seguridad

- **Piso crítico.** Está en el núcleo, siempre cargado:
  - nada de secretos en el código ni en el chat, y no se leen los `.env` reales;
  - se confirma antes de cualquier acción destructiva o de un deploy;
  - sin datos personales en logs ni en URLs;
  - toda entrada se valida en el servidor y los permisos se verifican en el backend.
- **Tipos de proyecto:**
  - **E**, estático o landing: cabeceras, formularios, datos, dependencias y respuesta; además inyección y CSRF si tiene backend.
  - **C**, con cuentas: todo lo de E, más acceso, autenticación y archivos.
  - **S**, SaaS con pagos o multi-tenant: todo lo de C, más pagos.
- **Clases de ataque** (un archivo cada una en `seguridad/`): inyección, CSRF, acceso, auth, cabeceras, archivos, formularios, pagos, datos, dependencias y respuesta, que incluye la gestión de secretos. Cada archivo tiene una sección "Comprobar" y otra "No hacer".
- **Cómo se usa.** El agente lee `seguridad/README.md` solo cuando la tarea toca el servidor, la autenticación, datos, formularios, cabeceras, pagos o dependencias. La tabla le indica qué clases leer, y lee solo esas.
- **Pruebas que intentan romper el sistema** (`cierre.md`): IDOR, peticiones sin sesión o con un rol inferior, campos que controla el cliente, montos, repeticiones, validaciones, rate limit, Origin y Content-Type. El `reviewer` señala como hallazgo las que falten.

## Ahorro de tokens

Al arrancar solo se carga el núcleo, de unos 620 tokens, más el `CLAUDE.md` del proyecto. Antes se importaba todo y el arranque costaba unos 10.100 tokens; ahora cuesta unos 1.470. El resto se lee cuando la tarea lo requiere, y además:
- se busca con Grep o Glob antes de leer un archivo;
- no se relee lo ya leído;
- no se lista el árbol completo;
- solo se lanzan subagentes cuando aportan.

La razón: todo lo que se carga al inicio se paga en cada turno y diluye la atención del modelo en reglas que no aplican.

## Varias máquinas (Windows, Mac, laptop)

| Viaja con el repo | Se repite en cada máquina |
|---|---|
| `CLAUDE.md`, `base/` y, en cada proyecto, `.claude/agents/`, `.claude/hooks/`, `.claude/settings.json`, `.gitattributes` y `.env.example` | `gh auth login` (o el token de Forgejo) |
| Issues, ramas y PRs, que viven en el remoto | Aceptar la confianza de la carpeta en Claude Code (sin ella no corren el hook del qa ni el `allow`) |
| | `~/.claude/` (configuración personal, memoria y plugins de skills) |
| | Los `.env` reales y `.dev.vars`, que nunca van al repo |
| | Git Bash en Windows (lo necesita el hook) y `gh` en el PATH |

Al empezar en otra máquina: `git pull`, comprobar `gh auth status` y leer el Issue en curso. Al cerrar: commit y push de la rama, con tu confirmación, y dejar el estado en el Issue. Detalle en `multi-maquina.md`.

## Adoptar proyectos y actualizar la base

- **Nuevo, dentro de `C:\Claude`:** abre Claude Code en la carpeta. El agente crea el `CLAUDE.md` desde la plantilla y te pregunta el stack y el modelo de ramas.
- **Existente, dentro de `C:\Claude`:** ejecuta `bash base/adoptar.sh <Proyecto>`. Copia solo los archivos que faltan, nunca sobrescribe ni copia los agentes opcionales, e imprime una lista de avisos (RELLENAR, `.env`, hook, scripts, eol, remoto, `Ramas:`…). Las reglas se heredan del `CLAUDE.md` de la raíz.
- **Fuera de `C:\Claude`:** `adoptar.sh` copia también `base/` dentro del proyecto con un `base/global.md`. Si el `CLAUDE.md` es nuevo, le agrega `@base/global.md` al inicio.
- **Actualizar la base en un proyecto externo:** `bash base/adoptar.sh --actualizar <ruta>`. Refresca su `base/` solo si encuentra un `VERSION` ahí; si `base/` no es de estas reglas, no la toca. Sube `VERSION` (v1, v2…) cada vez que cambies la base, para saber qué versión tiene cada proyecto.

## Permisos y hooks

- **`settings.json` de cada proyecto:**
  - `allow` (corre sin preguntar): tests, lint, build, typecheck y las lecturas de `gh`.
  - `ask` (pide confirmación): deploys de wrangler, migraciones de prisma, `git push`, `reset --hard`, `clean`, `branch -D`, `rm -rf`, crear o comentar Issues y PRs, `gh label create` y `gh api`.
  - `deny` (bloqueado): leer `.env*` reales, `*.pem`, `*.key`, `secrets/` y `.dev.vars`; force push, `push --delete` y `gh repo delete`.
- **Hook del `qa`** (`.claude/hooks/qa-bash.sh`): solo deja pasar su lista de comandos de verificación. Bloquea `&`, `;`, `|`, subshells, redirecciones y las URLs que no sean localhost.
- **Límites:**
  - Las reglas comparan el texto del comando, no lo que hace. El deny de Read sobre `.env` no impide un `cat .env` por Bash; un comando con otra forma puede pasar el `ask`.
  - El hook y el `allow` solo funcionan después de aceptar la confianza de la carpeta.
  - Los scripts de `package.json` que están en `allow` corren sin confirmar, así que conviene revisar que no desplieguen.
  - El piso real son las reglas escritas del núcleo.

## Límites y cosas por vigilar

- **Hook Fact-Forcing Gate** (de tu configuración personal): a veces bloquea escrituras o comandos y pide justificar. El agente responde sus puntos y reintenta, sin desactivarlo. Si molesta demasiado, se ajusta en `~/.claude/` y solo lo hace el agente si tú se lo pides.
- **Errores de SessionStart de los plugins:** algunos plugins fallan al arrancar o no conectan (por ejemplo, servidores MCP caídos). No afectan a estas reglas, aunque ensucian el inicio de la sesión.
- **`gh` fuera del PATH** en esta máquina: los agentes usan `"/c/Program Files/GitHub CLI/gh.exe"`. Agregarlo al PATH lo simplifica.
- **Agent teams, descartado:** es experimental, requiere una variable de entorno y su comportamiento puede cambiar. El modelo de sesión principal más subagentes cubre lo necesario y es estable.
- **Ramas desconocidas:** si aparece una rama que no creaste, por ejemplo `claude/...` de otra sesión, revísala antes de borrarla.

## Mantener la base

- **Cuándo actualizar las reglas:** cuando un error se repite en dos proyectos o una decisión tuya vale para todos. Una regla nueva va al archivo de `base/` que corresponde, no al núcleo. Al núcleo solo entra lo que tiene que estar siempre cargado. Después: commit y subir `VERSION`.
- **Crear un agente adicional:** pídeselo a la sesión principal. Lo propone y tú lo apruebas; vive en el `.claude/agents/` de ese proyecto y se agrega a "Agentes de este proyecto:". Lleva frontmatter `name`, `description`, `tools` y `model`, y su reporte termina en `Bloqueado:` cuando necesita algo de ti.
- **Moverlo a `agentes-opcionales/`:** cuando lo uses en un segundo proyecto. Se quita lo específico, se dejan los campos RELLENAR y se lista en `flujo-equipo.md`.
- **Sincronizar entre máquinas:** `C:\Claude` es el repo privado `Ramses-Eloy/claude-base`. El `.gitignore` limita lo versionado a `CLAUDE.md`, `README.md` y `base/`. En otra máquina: clonarlo como carpeta madre (pasos en el `README.md`) y clonar cada proyecto dentro. Cambiar la base: commit y push con tu confirmación; en las otras máquinas, `git pull`.

## Estado al 2026-10-16

- **Base:** v2, en el repo privado `github.com/Ramses-Eloy/claude-base` (rama `main`).
- **Adoptados:** WebKosmos (tipo E, modelo a: solo `main`; agentes `architect`, `reviewer` y `qa`). `main` va varios commits por delante de `origin`, sin push. La rama `rate-limit-contacto` está lista y sin merge.
- **Issues abiertos de WebKosmos** (label `seguridad`):
  - #5 Cabeceras de seguridad y HTTPS obligatorio
  - #6 Rechazar envíos del formulario desde otros orígenes
  - #7 Desplegar el rate limiting de /api/contact
  - #8 Evaluar avisos de npm audit en Next 14
  - #9 Turnstile en el formulario de contacto
- **Sin adoptar:**
  - ControlCenter: su `CLAUDE.md` no se sobrescribe y lleva `.env.neon` en el deny.
  - WebSira: usa GitHub; hay que arreglar los `@` y el `.gitignore`.
- **Pendientes tuyos:**
  - Revisar en Cloudflare si Workers Builds despliega `main` antes de cualquier push de WebKosmos.
  - Merge y deploy de #7.
  - Agregar la línea `Ramas:` a WebKosmos.
  - Pruebas manuales: el hook del qa en una sesión con confianza, el bloqueo de `.env` y el mensaje 429 en el navegador.
  - Remoto para `C:\Claude`.
  - Las preguntas abiertas del `CLAUDE.md` de WebKosmos.
