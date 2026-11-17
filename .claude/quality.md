# Calidad

## Nada genérico

- Prohibido el "IA slop": plantillas por defecto, relleno tipo lorem, marketing vacío ("solución integral", "lleva tu negocio al siguiente nivel"), paletas y layouts de "SaaS típico", componentes copiados sin criterio.
- Antes de diseñar o escribir copy: entender el producto, el público y el tono. Proponer una dirección concreta (qué transmite, para quién, por qué) y validarla conmigo antes de producir en volumen.
- No inventar cifras, clientes, testimonios, cobertura ni capacidades. Si falta el dato real, marcarlo como pendiente.

## Código

- Sin sobreingeniería: nada de abstracciones, capas o configuración sin un caso real que las necesite hoy. El código más corto y limpio que resuelve el caso real.
- Reutilizar lo que ya existe en el proyecto antes de crear algo nuevo; después lo nativo de la plataforma y las dependencias ya instaladas.
- Sin comentarios, emojis ni explicaciones, ni en el código ni en commits, UI o respuestas. Solo cuando sea imprescindible (un porqué que el código no puede expresar) o cuando yo pida comentar o documentar.
- Nombres con sentido del dominio del proyecto, no genéricos (`data`, `item`, `handler2`).
- Seguir las convenciones existentes del proyecto aunque no sean las que uno elegiría.

## Diseño (toda interfaz)

1. **Plan antes del código.** Para una página, pantalla o rediseño: paleta (valores y uso de cada color), tipografías (familias y escala), estilo visual (qué transmite y referencias) y un boceto de baja fidelidad por pantalla, en móvil y en escritorio. Esperar mi aprobación; lo aprobado se guarda en `features/design_system.md`. Un ajuste pequeño sigue el `design_system.md` existente, sin plan nuevo.
2. **Móvil siempre.** Toda página web se diseña primero para móvil y se comprueba a 375 px y 1280 px: sin scroll horizontal, texto legible sin zoom, áreas táctiles de 44 px o más, navegación, formularios y tablas usables en pantalla pequeña.
3. **Capturas y crítica al terminar.** Sacar capturas reales en ambos anchos con un navegador (`playwright-cli` o `agent-skills:browser-testing-with-devtools`) y criticarlas contra el plan (`design:design-critique`): jerarquía, espaciado, contraste, consistencia, estados y aspecto genérico. Corregir y volver a capturar, máximo 2 rondas; lo que quede va a Pendiente. Sin navegador disponible, decirlo: nunca dar un diseño por verificado sin haberlo visto.

## Documentos del proyecto

Cada proyecto lleva en `features/`:

| Archivo | Contiene |
|---|---|
| `PRD.md` | Problema, usuarios, alcance, fuera de alcance y criterios de aceptación. |
| `design_system.md` | Paleta, tipografías, espaciado, componentes, estados y bocetos aprobados. |
| `architecture.md` | Módulos, contratos, integraciones y decisiones técnicas con su porqué. |
| `database.md` | Esquema, relaciones, índices y migraciones. Solo si hay base de datos. |

- Crear cada uno cuando su contenido esté decidido: sin plantillas vacías ni contenido inventado.
- Leer el que corresponde antes de tocar su área y actualizarlo en el mismo cambio que altera lo que describe.
- Si difiere del código, manda el código y se corrige el documento.

## Conectores

Si la tarea necesita una app o servicio y no hay conector disponible (MCP, skill o CLI oficial instalado), no abandonar ni improvisar llamadas sueltas: construir un CLI propio en `tools/<servicio>` del proyecto.

- Solo los subcomandos que la tarea necesita, sobre la API oficial documentada; sin inventar endpoints.
- Credenciales por variables de entorno, declaradas en `.env.example`; nunca en el código ni en la salida.
- Leer del servicio no requiere permiso; escribir, enviar o borrar en él sí (piso crítico).

## Preguntar o decidir

- Preguntar cuando falte información o cuando la decisión cambie el resultado (alcance, datos, UX, costo, seguridad).
- Si la decisión es menor y reversible, decidir, seguir y avisarme en el reporte de cierre.
- No preguntar lo que ya está en el código, la documentación o el contexto.
- Un subagente no puede preguntarme directamente: termina con `Bloqueado: <pregunta concreta>` y la sesión principal me la pasa.

## Stack

Si no propongo un stack, **no armar nada**:

1. Conversar primero: problema, usuarios, escala esperada, hosting, presupuesto y qué tecnologías sé usar.
2. Presentar 2 o 3 opciones con ventajas, desventajas y una recomendación justificada.
3. Esperar mi decisión antes de crear archivos o instalar dependencias.

## Eficiencia

- Grep o Glob antes de leer; leer archivos grandes con offset/limit, solo la parte que importa.
- No releer lo ya leído en la sesión salvo que haya cambiado.
- No listar el árbol completo ni cargar el repo "para entender": partir de la tarea y buscar.
- No ejecutar tareas, comandos ni verificaciones que no pedí ni que la tarea no requiere.
- Usar subagentes solo cuando aportan información nueva o aíslan contexto grande.
