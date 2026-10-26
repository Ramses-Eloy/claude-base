# Cierre de tarea

## Pruebas

- Las escribe quien implementa (sesión principal, `backend` o `frontend`). Las corre el `qa` o, en tareas pequeñas, la sesión principal.
- Escribir pruebas para la lógica crítica, la autenticación, los permisos (incluido el acceso de un usuario a datos de otro) y los casos de error.
- Correrlas y reportar el resultado real con la salida. Si fallan o no se pudieron correr, decirlo; nunca darlas por buenas sin ejecutarlas.
- La verificación es proporcional al riesgo: un cambio de texto no necesita lo mismo que un cambio de permisos.

### Pruebas que intentan romper el sistema

En la lógica crítica (acceso a datos, autenticación, permisos, pagos, formularios públicos), el camino feliz no basta. Según lo que aplique, debe haber pruebas que:

- Accedan a un objeto de otro usuario o tenant cambiando el ID (esperado: 403/404, sin datos en la respuesta).
- Llamen sin sesión, con una sesión expirada o revocada, o con un rol inferior (esperado: 401/403).
- Envíen campos que el cliente no debe controlar (`role`, `tenantId`, `price`, `amount`) y comprueben que se ignoran.
- Manipulen montos, cantidades o precios (esperado: el servidor recalcula o rechaza).
- Repitan la misma petición o el mismo webhook (esperado: idempotente, sin doble efecto).
- Salten validaciones: tipos, longitudes, formatos, valores límite, payloads de inyección básicos (esperado: 400 sin efecto).
- Superen el rate limit (esperado: 429) y lleguen desde un `Origin` ajeno o con un `Content-Type` no aceptado (esperado: rechazo).

Si el proyecto no tiene runner de pruebas, el `qa` las reproduce con comandos documentados (por ejemplo, `curl` a `localhost`) y deja la salida como evidencia. Una prueba que solo cubre el camino feliz no cuenta como prueba de seguridad.

## Revisión final

Antes de dar algo por terminado, revisar el diff contra la lista siguiente. La hace el `reviewer` cuando el cambio toca seguridad, datos o permisos; si no, la sesión principal.

- [ ] Las clases de `security/` que toca el cambio.
- [ ] Datos expuestos: campos de más en respuestas, logs, URLs, errores.
- [ ] Validaciones en el servidor para toda entrada nueva.
- [ ] Permisos entre usuarios/tenants verificados en el backend.
- [ ] Manejo de errores: sin fallas silenciosas y sin detalles internos al cliente.
- [ ] Secretos en el diff, incluidos archivos de configuración y ejemplos.
- [ ] Dependencias nuevas justificadas y sin vulnerabilidades conocidas.
- [ ] Diseño o copy genérico (ver `quality.md`).

## Reporte

- Durante el trabajo no se narran avances ("ahora reviso", "voy a").
- Si aparece algo destructivo o un bloqueo, parar y preguntar en ese momento; no esperar al final.
- Al cerrar, un reporte de 15 líneas como máximo, con evidencia. Si ya se publicó en el Issue o PR, enlazar el comentario en vez de repetirlo:
  - **Qué cambió:** archivos y comportamiento.
  - **Qué se verificó:** pruebas, build, lint o revisión manual, con su resultado real.
  - **Pendiente o riesgoso:** lo que no se hizo, lo que no se pudo verificar y las decisiones menores que tomé por mi cuenta.
