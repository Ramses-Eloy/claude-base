# CSRF y peticiones entre sitios (E con endpoints que causan efectos, C, S)

Comprobar: cookies `SameSite=Lax` o `Strict`; las acciones que cambian estado exigen `Content-Type: application/json` (fuerza preflight) y un `Origin` de la lista propia, o un token CSRF en formularios clásicos.
No hacer: aceptar `text/plain` o `form-urlencoded` en endpoints JSON; acciones con efectos por GET.

