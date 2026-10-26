# Detección y respuesta (E, C, S)

Comprobar: logs de eventos de seguridad (login fallido, cambios de permisos, 403/429 repetidos, firmas de webhook inválidas) sin datos sensibles; alertas ante picos; un responsable y un canal de aviso.

Ante una filtración o sospecha:
1. Contener (desactivar el endpoint o la clave).
2. Rotar los secretos afectados.
3. Revocar sesiones y tokens.
4. Revisar logs para medir el alcance.
5. Corregir la causa con una prueba que la reproduzca.
6. Avisar a los afectados según corresponda.
7. Registrar lo ocurrido en el Issue, sin datos sensibles.


## Secretos (E, C, S)

Comprobar: secretos solo en variables de entorno o en el gestor del hosting; `.env.example` solo con nombres y valores ficticios; el diff no contiene claves, tokens ni URLs con credenciales.
No hacer: leer o mostrar `.env*` reales (`.env.example` sí se puede leer y editar; si hace falta un valor real, pedírmelo). Borrar un secreto filtrado y seguir: hay que rotarlo (ver "Detección y respuesta").

