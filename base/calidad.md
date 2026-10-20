# Calidad

## Nada genérico

- Prohibido el "IA slop": plantillas por defecto, relleno tipo lorem, marketing vacío ("solución integral", "lleva tu negocio al siguiente nivel"), paletas y layouts de "SaaS típico", componentes copiados sin criterio.
- Antes de diseñar o escribir copy: entender el producto, el público y el tono. Proponer una dirección concreta (qué transmite, para quién, por qué) y validarla conmigo antes de producir en volumen.
- No inventar cifras, clientes, testimonios, cobertura ni capacidades. Si falta el dato real, marcarlo como pendiente.

## Código

- Sin sobreingeniería: nada de abstracciones, capas o configuración sin un caso real que las necesite hoy.
- Reutilizar lo que ya existe en el proyecto antes de crear algo nuevo.
- Sin comentarios obvios; comentar solo el porqué no evidente.
- Nombres con sentido del dominio del proyecto, no genéricos (`data`, `item`, `handler2`).
- Seguir las convenciones existentes del proyecto aunque no sean las que uno elegiría.

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
