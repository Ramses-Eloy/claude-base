# Datos (E, C, S)

Comprobar: minimización (guardar solo lo necesario y decidir cuánto tiempo); cifrado en tránsito (TLS) y en reposo (el de la plataforma, más cifrado de campo para lo muy sensible); respuestas de API con campos seleccionados explícitamente; backups cifrados, con restauración probada y acceso restringido.
No hacer: datos personales, tokens o contraseñas en logs, URLs, query strings, analíticas, reportes de error o Issues; devolver el objeto completo de la DB; errores al cliente con stack, SQL o rutas.

