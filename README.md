# Implementación de Arquitectura SOA

En el contexto de un sistema de gestión de préstamos hipotecarios, debes implementar una arquitectura basada en servicios (SOA) que integre varios componentes del sistema. Los componentes incluyen el originador de créditos, el motor antifraude, el buró de riesgos y el core bancario. Debes decidir entre orquestación y coreografía para la coordinación de servicios, manejar la consistencia en transacciones distribuidas y diseñar una arquitectura orientada a eventos (EDA) para la comunicación entre microservicios y APIs.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | Implementacion de la arquitectura SOA |
| **Nivel** | senior-l3 |
| **Tipo** | mixed |
| **Tiempo estimado** | 10 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y generará un ZIP listo para usar.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Un IDE o editor de código.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y generará un archivo ZIP descargable. Descárgalo y extráelo en la carpeta donde quieras trabajar.
- Verifica que el proyecto arranca sin errores.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no genera el ZIP automáticamente al terminar el análisis, escríbele: "genera el ZIP ahora".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Evaluación de Orquestación vs Coreografía

**Objetivo:** Elegir entre orquestación y coreografía para la coordinación de servicios en el sistema de gestión de préstamos hipotecarios.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Analiza las ventajas y desventajas de ambos enfoques.
- Proporciona ejemplos prácticos de cuándo sería más apropiado utilizar cada enfoque en el contexto del sistema.

**Entregable:** Documento que detalla la elección entre orquestación y coreografía, con justificación y ejemplos prácticos.

<details>
<summary>Pistas de conocimiento</summary>

- Considera la complejidad del sistema y las interacciones entre servicios.
- Evalúa la escalabilidad y mantenibilidad de cada enfoque.

</details>

### Fase 2: Gestión de Consistencia en Transacciones Distribuidas

**Objetivo:** Implementar estrategias para manejar y garantizar la consistencia en las transacciones distribuidas del sistema.

**Tiempo estimado:** 3 horas

**Instrucciones:**

- Identifica posibles inconsistencias en las transacciones distribuidas.
- Proporciona estrategias específicas para garantizar la consistencia, incluyendo ejemplos de herramientas y patrones de diseño que hayas utilizado.

**Entregable:** Documento que describe las estrategias implementadas para manejar la consistencia en las transacciones distribuidas, incluyendo ejemplos de herramientas y patrones de diseño.

<details>
<summary>Pistas de conocimiento</summary>

- Considera patrones como el patrón de compensación y el patrón de saga.
- Evalúa la aplicabilidad de diferentes herramientas y tecnologías para garantizar la consistencia.

</details>

### Fase 3: Implementación de Arquitectura Orientada a Eventos (EDA)

**Objetivo:** Diseñar y describir una arquitectura orientada a eventos (EDA) para la comunicación entre microservicios y APIs en el sistema.

**Tiempo estimado:** 3 horas

**Instrucciones:**

- Describe la arquitectura EDA que implementará en el sistema.
- Proporciona casos de uso en los que EDA ha demostrado ser beneficioso.

**Entregable:** Documento que describe la arquitectura EDA implementada, incluyendo casos de uso y beneficios.

<details>
<summary>Pistas de conocimiento</summary>

- Considera la asincronía y la desacoplamiento que ofrece EDA.
- Evalúa la aplicabilidad de diferentes tecnologías y herramientas para implementar EDA.

</details>

### Fase 4: Revisión y Mejora Continua

**Objetivo:** Revisar y mejorar continuamente la arquitectura implementada, identificando áreas de mejora y proponiendo soluciones.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Identifica áreas de mejora en la arquitectura implementada.
- Propone soluciones para mejorar la arquitectura, considerando factores como escalabilidad, mantenibilidad y rendimiento.

**Entregable:** Documento que describe las áreas de mejora identificadas y las soluciones propuestas para mejorar la arquitectura.

<details>
<summary>Pistas de conocimiento</summary>

- Considera la retroalimentación de los usuarios y las métricas de rendimiento.
- Evalúa la aplicabilidad de diferentes tecnologías y herramientas para implementar las soluciones propuestas.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es la orquestación y la coreografía en el contexto de arquitecturas de servicios?
- **paraQueSirve**: ¿Para qué sirve la arquitectura orientada a eventos (EDA) en el contexto de microservicios y APIs?
- **comoSeUsa**: ¿Cómo se usan las estrategias para manejar la consistencia en las transacciones distribuidas?
- **erroresComunes**: ¿Cuáles son los errores comunes al implementar una arquitectura basada en servicios (SOA)?
- **queDecisionesImplica**: ¿Qué decisiones implica la elección entre orquestación y coreografía para la coordinación de servicios?

## Criterios de Evaluacion

- Explicación clara de las diferencias entre orquestación y coreografía.
- Implementación de estrategias para manejar la consistencia en transacciones distribuidas.
- Diseño y descripción de una arquitectura orientada a eventos (EDA).
- Identificación de áreas de mejora y propuestas de soluciones para mejorar la arquitectura.

## Como trabajar con un asistente de IA

Hay dos caminos, elegi uno:

- **AGENTS.md** (recomendado) — instrucciones nativas del repo. Abri esta carpeta con tu agente local (Claude Code, Cursor, Codex, Copilot, Gemini) y las carga solo. Sabe que archivos faltan y con que comando se verifica, y completa el scaffold escribiendo en disco.
- **PROMPT_MEJORA.md** — para copiar y pegar en un chat (claude.ai, ChatGPT). Devuelve un ZIP con el proyecto. Sirve si no tenes un agente en el IDE.

Ninguno de los dos resuelve las fases del reto: eso es tu trabajo.

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
npx --yes @redocly/cli lint contratos/openapi.yaml
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
