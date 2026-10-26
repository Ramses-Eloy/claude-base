# Skills: ahorrar tokens

| Cuándo | Skill |
|---|---|
| Escribir lo mínimo; no sobre-construir | `ponytail:ponytail` |
| Auditar código en busca de sobre-ingeniería | `ponytail:ponytail-audit`, `ponytail:ponytail-review` |
| Listar deuda de complejidad / medir lo ahorrado | `ponytail:ponytail-debt`, `ponytail:ponytail-gain` |
| Respuestas muy cortas | `caveman:caveman` |
| Conversación larga: compactar a tiempo | `everything-claude-code:strategic-compact` |
| Decidir qué contexto cargar | `agent-skills:context-engineering` |
| Simplificar código ya escrito | `agent-skills:code-simplification`, `simplify` |
| Saber en qué se fueron los tokens | `anthropic-skills:explain-usage` |
| Memoria duplicada o vieja | `anthropic-skills:consolidate-memory` |

## Contexto: compactar y limpiar

| Situación | Acción |
|---|---|
| Sesión larga sobre la misma tarea, el contexto se llena | `/compact` (o `everything-claude-code:strategic-compact`) |
| Cambio a una tarea distinta, o terminó una tarea y empieza otra | `/clear` |
| Entender un repo grande sin leer archivo por archivo | `/graphify .` y consultar el grafo (ver abajo) |
| Leer un PDF, Word, Excel o PowerPoint | convertirlo antes con `markitdown` y leer el `.md` |

El `admin` sugiere `/compact` o `/clear` cuando toca; no espera a que el contexto se llene.

## Por instalar (las ejecuta el usuario)

| Skill | Para qué | Instalación |
|---|---|---|
| `graphify` | Grafo de conocimiento del código; consultarlo en vez de usar grep | `uv tool install graphifyy` y luego `graphify install` |
| `markitdown` (Microsoft) | Convierte PDF, Office y otros a Markdown, menos tokens que el binario | `pip install "markitdown[all]"` |
