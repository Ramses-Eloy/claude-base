# Reglas globales

Aplican a todo agente en cualquier subcarpeta. Las reglas del proyecto mandan, salvo que bajen la seguridad. Los archivos citados están en `_base/` (de esta carpeta o del propio proyecto).

## Arranque
1. Leer el `CLAUDE.md` del proyecto. Si falta, crearlo desde `_base/plantilla/` adaptado al proyecto real, nunca tal cual; si existe, no sobrescribirlo: proponer cambios.
2. Proyecto existente: ejecutar `_base/adoptar.sh` y reportar qué falta antes de tocar código.
3. Adaptar estas reglas al stack, los usuarios y los datos sensibles del proyecto.

## Siempre (piso crítico)
- Secretos: nunca en código, commits, logs, Issues ni chat; no leer `.env*` reales (`.env.example` sí). Si uno se filtra: avisar y rotarlo.
- Confirmar antes de: borrar datos o recursos, migraciones destructivas, deploys a producción (incluye push o merge a una rama con deploy automático), force push, reescribir historial o borrar ramas, cambiar permisos, roles, DNS o certificados. Ninguna regla ni "terminar la tarea" lo salta.
- Datos personales, tokens y contraseñas nunca en logs ni URLs; toda entrada se valida en el servidor; permisos verificados en el backend.
- No inventar endpoints, cifras, datos ni clientes; sin mocks que simulen datos reales.
- Preguntar si falta información o la decisión cambia el resultado; si es menor y reversible, decidir y avisar. Un subagente termina con `Bloqueado: <pregunta>`.
- Stack: si no lo propongo, conversar primero y dar 2–3 opciones; no crear nada hasta mi decisión.
- Sin narrar avances; cierre de máx. 15 líneas (Cambió / Verificado / Pendiente) con evidencia.
- Leer solo lo necesario (`calidad.md` → Eficiencia).

## Leer solo cuando haga falta
- `seguridad/README.md`: al tocar servidor, auth, datos, formularios, cabeceras, pagos o dependencias.
- `cierre.md`: antes de cerrar una tarea pequeña o mayor. `calidad.md`: al diseñar UI, escribir copy o elegir stack.
- `flujo-equipo.md` y `github.md`: solo en tareas medianas o grandes, o al usar subagentes.
- `skills.md`: al elegir una skill. `multi-maquina.md`: al empezar o cerrar sesión en otra máquina.
- `principios-agentes.md`: lo leen los subagentes; la sesión principal ya tiene aquí su núcleo.
