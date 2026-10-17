# Cabeceras y navegador (E, C, S)

Comprobar:
- CSP restrictiva (`default-src 'self'`, sin `unsafe-eval`, `frame-ancestors 'none'`; `script-src` con hashes o nonces si hay scripts inline).
- HSTS (`max-age` de al menos 6 meses, `includeSubDomains`) y redirección de HTTP a HTTPS.
- `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy` mínima, `X-Frame-Options: DENY` (o `frame-ancestors`).
- CORS: sin cabeceras CORS si no hacen falta; si hacen falta, lista exacta de orígenes, nunca `*` con credenciales.
- Cookies `HttpOnly`, `Secure` y `SameSite`.

No hacer: reflejar el `Origin` recibido en `Access-Control-Allow-Origin`; quitar la CSP "para que funcione".

