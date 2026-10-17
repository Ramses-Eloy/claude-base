# Cadena de suministro (E, C, S)

Comprobar: lockfile versionado e instalación reproducible (`npm ci`); `npm audit` o equivalente al agregar o actualizar dependencias y antes de cada release, evaluando si cada aviso aplica al uso real; versiones fijadas de acciones de CI y de scripts de terceros (con `integrity` si van por CDN); justificar cada dependencia nueva.
No hacer: agregar paquetes para lo que resuelven unas líneas; scripts de terceros sin necesidad; ignorar un aviso crítico sin dejar constancia de por qué no aplica.

