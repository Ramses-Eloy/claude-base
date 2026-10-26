# Archivos subidos (C, S si suben archivos)

Comprobar: tipo real por contenido (no por la extensión ni por el `Content-Type`); tamaño máximo; nombre regenerado por el servidor; guardado fuera de rutas ejecutables o en almacenamiento de objetos; servido con `Content-Disposition` y su propio dominio o CSP; imágenes reprocesadas para quitar metadatos y payloads; SVG tratado como código.
No hacer: servir lo subido desde el mismo origen de la app sin esas defensas; confiar en el nombre de archivo del cliente.

