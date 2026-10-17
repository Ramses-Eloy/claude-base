# Autenticación y sesiones (C, S)

Comprobar:
- Contraseñas con argon2id o bcrypt.
- Fuerza bruta y credential stuffing: límite por cuenta y por IP con retraso progresivo y bloqueo temporal; aviso de inicio de sesión nuevo.
- Verificación de email; recuperación con token de un solo uso, vida corta y guardado como hash, con la misma respuesta exista o no la cuenta (sin enumeración, también en registro y login).
- MFA obligatorio para administradores y disponible para el resto; reautenticación para cambiar email, contraseña o MFA, pagos y borrado de cuenta.
- Sesiones con expiración absoluta e inactiva, rotación del ID al iniciar sesión y al cambiar privilegios, logout que invalida en el servidor y "cerrar todas las sesiones" tras un cambio de contraseña.

No hacer: JWT de larga vida sin revocación; tokens en `localStorage`; mensajes distintos para "usuario no existe" y "contraseña incorrecta".

