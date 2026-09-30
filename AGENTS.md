# AGENTS.md

Instrucciones para el agente de IA que abra este repositorio (Claude Code, Cursor, Codex, Copilot, Gemini). Se cargan solas: no hay que pegar nada en ningun chat.

## Que es este repositorio

Es el codigo base de un reto de aprendizaje de Pragma: **Implementación de Arquitectura SOA**.

| | |
|---|---|
| Tema | Implementacion de la arquitectura SOA |
| Nivel | senior-l3 |
| Chapter | Integración — Analista |
| Especialidad | SOA |
| Stack | YAML / OpenAPI 3.1 |
| Patron arquitectonico | SOA con enfoque en contratos primero y patrones de integración (orquestación/coreografía + EDA) |
| Tiempo estimado | 10 horas |

## Receta del stack

Esqueleto obligatorio:

- `openapi.yaml`
- `proceso.bpmn.md`
- `mapeo-de-datos.csv`

Dependencias:

- @redocly/cli 1.12.0
- OpenAPI 3.1 Specification 3.1.0
- BPMN 2.0 n/a
- Gherkin n/a
- ISO 20022 (para esquemas financieros) 2023
- BIAN Service Domains (para alineación con estándares bancarios) n/a

## Tu tarea

Dejar este conjunto de artefactos en estado **verificable**: que el comando de verificacion corra sin errores. Escribi los archivos en disco, en este repositorio. No generes ZIPs ni archivos adjuntos.

En orden:

1. Corre `npx --yes @redocly/cli lint contratos/openapi.yaml` y mira que falla.
2. Completa lo que falte de la lista de abajo: manifiesto de dependencias, punto de entrada, capa de interfaz y las capas del patron declarado.
3. Arregla SOLO los errores que impiden compilar o arrancar.
4. Volve a correr `npx --yes @redocly/cli lint contratos/openapi.yaml` hasta que pase.
5. Pará ahí.

## Regla dura: las fases son trabajo del humano

**PROHIBIDO implementar los entregables de las fases.** El valor del reto esta en que la persona los resuelva. Tu trabajo es que tenga un proyecto que arranca; el hueco pedagogico se queda como esta.

No resuelvas nada de esto:

- **Fase 1 — Evaluación de Orquestación vs Coreografía**: Documento que detalla la elección entre orquestación y coreografía, con justificación y ejemplos prácticos.
- **Fase 2 — Gestión de Consistencia en Transacciones Distribuidas**: Documento que describe las estrategias implementadas para manejar la consistencia en las transacciones distribuidas, incluyendo ejemplos de herramientas y patrones de diseño.
- **Fase 3 — Implementación de Arquitectura Orientada a Eventos (EDA)**: Documento que describe la arquitectura EDA implementada, incluyendo casos de uso y beneficios.
- **Fase 4 — Revisión y Mejora Continua**: Documento que describe las áreas de mejora identificadas y las soluciones propuestas para mejorar la arquitectura.

Distincion operativa:

- **Arreglar** (si): import faltante, tipo que no existe, dependencia sin declarar, error de sintaxis, archivo referenciado que no existe.
- **No tocar** (no): logica de negocio incompleta, validaciones ausentes, secretos hardcodeados, APIs deprecadas que funcionan, concurrencia insegura, patrones mejorables. Eso es lo que la persona tiene que encontrar.

## Superficie de practica (NO completes)

Estos archivos SON el ejercicio de la persona. No los implementes; deja stubs. No toques la logica que el reto pide completar.

- [ ] `contratos/openapi.yaml` — El topic pide el contrato de API: openapi.yaml es el ejercicio.

## Lo que falta y tenes que completar

No se detectaron huecos: estan los archivos declarados, el boilerplate del stack y ninguna referencia quedo colgando. Igual corre el comando de verificacion — que los archivos existan no garantiza que compilen.

### Presentes (13)

- `contratos/openapi.yaml`
- `validacion/criterios_aceptacion.feature`
- `proceso.bpmn.md`
- `mapeo-de-datos.csv`
- `README.md`
- `flujos/proceso_orquestacion.bpmn.md`
- `flujos/proceso_coreografia.bpmn.md`
- `mapeo/mapeo_datos_originador_core.csv`
- `mapeo/mapeo_datos_antifraude_buro.csv`
- `riesgos/analisis_riesgo.md`
- `docs/decision_arquitectura.md`
- `docs/eda_implementation.md`
- `docs/consistencia_transacciones.md`

### Capas del patron declarado

Cada una tiene que existir como directorio real con al menos un archivo. Codigo plano en la raiz no satisface el patron.

- `contratos`
- `flujos`
- `mapeo`
- `validacion`
- `riesgos`
- `docs`

## Verificacion

```bash
npx --yes @redocly/cli lint contratos/openapi.yaml
```

El comando tiene que pasar SIN implementar los archivos de la superficie de practica: solo andamiaje.

Ese comando pasando es la definicion de "terminado" para vos.

## Convenciones que tenes que respetar

- Un solo ecosistema: no declares librerias de otro lenguaje ni mezcles gestores de paquetes.
- Toda libreria que uses tiene que estar declarada en el manifiesto de dependencias.
- Todo import declarado tiene que usarse; todo tipo usado tiene que existir o venir de una dependencia declarada.
- El patron es **SOA con enfoque en contratos primero y patrones de integración (orquestación/coreografía + EDA)**: los contratos (interfaces, puertos) los define la capa interna y los implementa la externa, nunca al revés.
- Los archivos que crees llevan implementacion real, no stubs: sin `TODO`, sin cuerpos vacios, sin `// getters y setters`.

## Contexto del candidato

Sirve para calibrar el nivel del codigo, no para resolver las fases.

- Perfil: Chapter Integración, Especialidad Analista SOA, Tecnología SOA, Senior
- Brecha que el reto ataca: ¿Puede explicar las diferencias clave entre la orquestación y la coreografía en el contexto de arquitecturas de servicios, y proporcionar ejemplos prácticos de cuándo sería más apropiado utilizar cada enfoque? En entornos de microservicios y arquitecturas basadas en servicios, ¿cómo maneja y garantiza la consistencia en las transacciones distribuidas? ¿Puede describir estrategias específicas y herramientas que haya utilizado? ¿Cómo implementa una arquitectura orientada a eventos (EDA) en el contexto de microservicios y APIs? ¿Puede compartir casos de uso en los que EDA haya demostrado ser beneficioso?
- Mision: Candidato con experiencia como Analista SOA Senior, especializado en arquitecturas de integración.

---

*Generado por Challenge Generator — Pragma. `README.md` tiene el enunciado completo del reto para la persona. `PROMPT_MEJORA.md` es la variante para pegar en un chat, si se prefiere ese flujo.*
