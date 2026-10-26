# Skills: frontend (implementación web)

| Cuándo | Skill |
|---|---|
| Construir UI con calidad de producción | `agent-skills:frontend-ui-engineering` |
| Patrones de frontend (estado, componentes) | `everything-claude-code:frontend-patterns` |
| Rendimiento web (Core Web Vitals) | `agent-skills:webperf`, `agent-skills:performance-optimization` |
| Verificar en un navegador real | `agent-skills:browser-testing-with-devtools` |
| Pruebas e2e de flujos | `everything-claude-code:e2e` |
| Estándares de código | `everything-claude-code:coding-standards` |
| Contrato con la API | `agent-skills:api-and-interface-design` |

## Animación

| Cuándo | Skill |
|---|---|
| Animación con GSAP: tweens, easing, `matchMedia` y reduced-motion | `gsap-core` |
| Secuencias y coreografías | `gsap-timeline` |
| Animación por scroll, pin, scrub | `gsap-scrolltrigger` |
| GSAP en React o Next.js (`useGSAP`, limpieza) | `gsap-react` |
| GSAP en Vue, Svelte u otros | `gsap-frameworks` |
| Plugins (Flip, Draggable, SplitText, ScrollSmoother...) | `gsap-plugins` |
| Rendimiento de animaciones | `gsap-performance` |
| Utilidades (`clamp`, `mapRange`, `snap`...) | `gsap-utils` |

Instaladas (oficiales de GreenSock). Pesadas: pedirlas solo cuando el proyecto anima con GSAP.

Lenis (scroll suave) y React Bits (componentes animados) no son skills sino librerías: se agregan en el proyecto que las use (`npm i lenis`; React Bits con su CLI, ver su documentación), no a `.claude/`.
