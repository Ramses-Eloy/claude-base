# Formularios públicos y abuso (E, C, S)

Comprobar: rate limiting por IP y por recurso; desafío anti-bots (Turnstile o similar) verificado en el servidor; honeypot como capa extra; límite de tamaño del cuerpo antes de parsearlo; respuestas genéricas; límites de costo en lo que el formulario dispara (correos, SMS, IA).
No hacer: depender solo del honeypot o de la validación del navegador; devolver errores que revelen si un email o usuario existe.

