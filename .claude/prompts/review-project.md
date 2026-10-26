# Prompt: revisar un proyecto con las reglas, agentes y skills nuevos

Pegar al abrir Claude en la raíz del proyecto. Solo lee y reporta; no modifica código.

```text
Eres el admin de este proyecto. Haz una revisión completa SIN modificar código: solo lees y reportas.

1. Contexto
- Lee el CLAUDE.md del proyecto y las reglas globales de C:\Claude\CLAUDE.md.
- Ejecuta `bash C:/Claude/.claude/adopt.sh --agentes design,security,deploy<,dba si hay base de datos>  .` y dime qué avisos salen (RELLENAR, skills inexistentes, Ramas, .env, etc.). No sobrescribas nada existente.
- Lee C:\Claude\.claude\team-flow.md y C:\Claude\.claude\skills\README.md (mapa del admin).

2. Revisión por agentes (en paralelo los de solo lectura)
Invoca cada agente y en el encargo nómbrale las skills del mapa del admin para su rol:
- architect: contratos, módulos, integraciones, arquitectura real vs documentada.
- frontend (revisa tú o design): UI, accesibilidad, estados de carga/error/vacío, rendimiento, copy y diseño genérico.
- backend / dba (si aplica): validación en servidor, permisos por objeto, aislamiento entre usuarios o tenants, esquema, migraciones, índices, queries.
- security: modelo de amenazas y auditoría de la superficie (auth, permisos, datos, pagos, dependencias, secretos).
- reviewer: checklist de closing.md sobre el estado actual del código.
- qa: corre tests, lint, typecheck y build; reporta la salida real y las pruebas que faltan.
- deploy: CI/CD, ramas con deploy automático, variables de entorno, migraciones, si está listo para producción.

3. Reglas
- Skills ligeras siempre (ponytail, caveman). Las pesadas solo si aplican: la auditoría completa `security-audit` solo si la base del frontend y del backend ya está hecha; si no, dímelo y no la corras.
- Nada irreversible: no deploys, no migraciones, no push, no leer .env reales.
- No inventes datos ni endpoints; si algo no está, dilo.
- Si el contexto se llena, sugiéreme /compact; no cargues skills "por si acaso".

4. Entrega (máx. 40 líneas)
- Estado por área: frontend, backend, datos, seguridad, pruebas, despliegue, reglas/agentes del proyecto.
- Hallazgos ordenados por severidad (Crítico/Alto/Medio/Bajo) con archivo:línea.
- Qué falta para adoptar las reglas nuevas en este proyecto.
- Skills sugeridas por agente y qué recomiendas hacer primero.
Termina con una pregunta: qué arreglo hago primero.
```
