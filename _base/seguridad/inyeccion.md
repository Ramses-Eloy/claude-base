# Inyección (E si tiene backend, C, S)

Comprobar:
- SQL/NoSQL: consultas parametrizadas u ORM; filtros NoSQL construidos con tipos validados, no con objetos del cliente (`{"$gt": ""}`).
- Comandos: nada de `exec`/`spawn` con entrada del usuario; si es inevitable, lista blanca de argumentos y sin shell.
- XSS: salida escapada según el contexto; HTML del usuario solo con un sanitizador mantenido; JSON dentro de `<script>` con `<` escapado como `<`.
- Inyección de cabeceras (HTTP y correo): quitar `\r` y `\n` de todo valor que vaya a una cabecera (`Subject`, `Reply-To`, `Location`, `Set-Cookie`); codificar los no ASCII.
- SSRF: si el servidor descarga una URL dada por el usuario, lista blanca de hosts; bloquear IPs privadas, `localhost` y metadatos del cloud (169.254.169.254); sin seguir redirecciones a otros hosts.
- Redirecciones abiertas: `?next=` y similares solo a rutas relativas propias o a una lista blanca.

No hacer: concatenar SQL, usar variantes `raw`/`unsafe` con datos del usuario, `dangerouslySetInnerHTML`/`innerHTML` con contenido no propio, ni confiar en la validación del cliente.

