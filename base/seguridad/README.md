# Seguridad: qué leer

El piso crítico está en el `CLAUDE.md` global. Aquí está el detalle por clase de ataque: leer solo las clases del tipo del proyecto (su "Modelo de amenazas") que toca la tarea. Lo que no aplica se omite diciendo por qué.

| Tipo | Clases |
|---|---|
| E: web estática (puede tener formularios o un Worker) | `cabeceras`, `formularios`, `datos`, `dependencias`, `respuesta`; más `inyeccion` y `csrf` si hay backend |
| C: app con cuentas | las de E, más `inyeccion`, `csrf`, `acceso`, `auth` y `archivos` (si se suben archivos) |
| S: SaaS con pagos y multi-tenant | las de C, más `pagos` |

| Si la tarea toca… | Leer |
|---|---|
| Consultas, comandos, HTML, cabeceras HTTP o de correo, URLs externas, redirecciones | `inyeccion.md` |
| Endpoints que cambian estado, cookies | `csrf.md` |
| Lectura o escritura de objetos, roles, tenants | `acceso.md` |
| Login, registro, recuperación, MFA, sesiones | `auth.md` |
| CSP, HSTS, CORS, cookies, cabeceras del sitio | `cabeceras.md` |
| Subida de archivos | `archivos.md` |
| Formularios públicos, bots, rate limiting | `formularios.md` |
| Cobros, precios, webhooks | `pagos.md` |
| Qué se guarda, logs, backups, cifrado | `datos.md` |
| Dependencias, lockfile, scripts de terceros, CI | `dependencias.md` |
| Logs de seguridad, alertas, filtración de secretos o datos | `respuesta.md` |
