# Control de acceso (C, S; no aplica a E sin cuentas)

Comprobar:
- Cada endpoint verifica en el backend quién es el usuario y si puede actuar sobre ese objeto, no solo sobre la ruta.
- IDOR: cambiar un ID por el de otro usuario devuelve 403/404.
- Escalada de privilegios: el rol sale de la sesión del servidor, nunca del cuerpo de la petición; `role`, `isAdmin`, `tenantId` y `ownerId` se ignoran si vienen del cliente (sin mass assignment).
- Multi-tenant (S): cada consulta filtra por tenant en el servidor (RLS si el motor lo permite); cachés, colas, archivos y búsquedas también llevan el tenant.

No hacer: ocultar un botón como control de acceso; IDs secuenciales expuestos sin control por objeto; endpoints de administración sin verificación propia.

