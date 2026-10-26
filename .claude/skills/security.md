# Skills: seguridad

| Cuándo | Skill |
|---|---|
| Revisar los cambios pendientes por seguridad | `security-review` |
| Hardening: validación, auth, secretos, dependencias | `agent-skills:security-and-hardening` |
| Revisión de seguridad con lista OWASP | `everything-claude-code:security-review` |
| Auditoría más profunda | agente `agent-skills:security-auditor` |
| Hay un incidente en curso | `engineering:incident-response` |
| Cumplimiento y datos personales | `legal:compliance-check` |

Las clases de ataque están en `.claude/security/`; las skills no las reemplazan.

## Por instalar (la ejecuta el usuario)

| Cuándo | Skill | Instalación |
|---|---|---|
| Auditoría completa o pentest de un código, con hallazgos verificados | `security-audit` (Cloudflare) | `npx skills add cloudflare/security-audit-skill` |

Pedirla solo para una auditoría completa explícita; para una consulta puntual funciona en modo guía y gasta poco.
