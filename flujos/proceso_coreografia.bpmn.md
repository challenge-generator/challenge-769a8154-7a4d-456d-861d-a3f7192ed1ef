# Proceso de Coreografía para Gestión de Préstamos Hipotecarios

```mermaid
flowchart TD
    A([Inicio]) --> B[Solicitud Recibida]
    B --> C[Emitir Evento: SOLICITUD_RECIBIDA]
    
    C --> D[Motor Antifraude: Suscribirse a SOLICITUD_RECIBIDA]
    D --> E{Validar Antifraude}
    E -->|Aprobado| F[Emitir Evento: ANTIFRAUDE_APROBADO]
    E -->|Rechazado| G[Emitir Evento: ANTIFRAUDE_RECHAZADO]
    
    F --> H[Buró de Riesgos: Suscribirse a ANTIFRAUDE_APROBADO]
    H --> I{Evaluar Riesgo}
    I -->|Aprobado| J[Emitir Evento: RIESGO_APROBADO]
    I -->|Rechazado| K[Emitir Evento: RIESGO_RECHAZADO]
    
    J --> L[Core Bancario: Suscribirse a RIESGO_APROBADO]
    L --> M{Registrar Préstamo}
    M -->|Éxito| N[Emitir Evento: PRESTAMO_REGISTRADO]
    M -->|Fallo| O[Emitir Evento: ERROR_REGISTRO]
    
    N --> P[Notificar Cliente]
    P --> Q([Fin: Préstamo Aprobado])
    
    %% Manejo de errores con compensación
    G --> R[Originador: Suscribirse a ANTIFRAUDE_RECHAZADO]
    R --> S[Rechazar Solicitud]
    S --> T([Fin: Rechazo por Antifraude])
    
    K --> U[Originador: Suscribirse a RIESGO_RECHAZADO]
    U --> V[Rechazar Solicitud]
    V --> W([Fin: Rechazo por Riesgo])
    
    O --> X[Originador: Suscribirse a ERROR_REGISTRO]
    X --> Y[Compensar: Revertir Antifraude y Riesgo]
    Y --> Z([Fin: Error en Registro])

    %% Trade-offs de coreografía
    subgraph Trade-offs["Trade-offs de Coreografía"]
        direction TB
        T1["✅ Ventajas:"]
        T1 --> T1a["- Alta escalabilidad (servicios autónomos)"]
        T1 --> T1b["- Menor acoplamiento entre servicios"]
        T1 --> T1c["- Flexibilidad para modificar flujos"]
        
        T2["❌ Desventajas:"]
        T2 --> T2a["- Dificultad para depurar flujos complejos"]
        T2 --> T2b["- Riesgo de ciclos infinitos en eventos"]
        T2 --> T2c["- Mayor latencia en decisiones condicionales"]
    end
```

## Descripción del Flujo

### Actores
- **Originador de Créditos**: Servicio que emite el evento inicial y maneja compensaciones.
- **Motor Antifraude**: Servicio que suscribe a `SOLICITUD_RECIBIDA` y emite resultados.
- **Buró de Riesgos**: Servicio que suscribe a `ANTIFRAUDE_APROBADO` y emite resultados.
- **Core Bancario**: Servicio que suscribe a `RIESGO_APROBADO` y registra préstamos.
- **Bus de Eventos**: Medio de comunicación entre servicios (ej. Kafka, RabbitMQ).

### Eventos Clave
| Evento                     | Emisor               | Suscriptores                | Payload                                                                 |
|-----------------------------|----------------------|-----------------------------|--------------------------------------------------------------------------|
| `SOLICITUD_RECIBIDA`        | Originador           | Motor Antifraude            | `{ solicitudId, clienteId, monto, plazoMeses }`                          |
| `ANTIFRAUDE_APROBADO`       | Motor Antifraude     | Buró de Riesgos             | `{ solicitudId, resultado: "SIN_RIESGO", metodoValidacion }`           |
| `ANTIFRAUDE_RECHAZADO`      | Motor Antifraude     | Originador                  | `{ solicitudId, motivo: "IDENTIDAD_SOSPECHOSA" }`                      |
| `RIESGO_APROBADO`           | Buró de Riesgos      | Core Bancario               | `{ solicitudId, score: 750, aprobado: true }`                            |
| `RIESGO_RECHAZADO`          | Buró de Riesgos      | Originador                  | `{ solicitudId, motivo: "SCORE_INSUFICIENTE" }`                        |
| `PRESTAMO_REGISTRADO`       | Core Bancario        | Originador                  | `{ solicitudId, numeroPrestamo: "PR-2023-4567" }`                      |
| `ERROR_REGISTRO`            | Core Bancario        | Originador                  | `{ solicitudId, error: "FALLO_EN_BASE_DE_DATOS" }`                     |

### Mecanismo de Compensación
- **Patrón Saga Coreografiado**: Cada servicio emite eventos de compensación:
  - Antifraude: `ANTIFRAUDE_COMPENSADO` (ej. liberar recursos).
  - Riesgo: `RIESGO_COMPENSADO` (ej. actualizar score).
  - Core: `PRESTAMO_REVERTIDO` (ej. eliminar registro).

- **Originador**: Suscribe a eventos de error y emite compensaciones en cascada:
  1. Si recibe `ERROR_REGISTRO`, emite `REVERTIR_RIESGO`.
  2. El servicio de riesgo suscribe a `REVERTIR_RIESGO` y emite `RIESGO_COMPENSADO`.
  3. El originador suscribe a `RIESGO_COMPENSADO` y emite `REVERTIR_ANTIFRAUDE`.

### Puntos de Decisión
1. **Validación Antifraude**
   - **Regla**: `resultado = 'SIN_RIESGO'`
   - **Acción**: Emite `ANTIFRAUDE_APROBADO` si se cumple, `ANTIFRAUDE_RECHAZADO` si no.

2. **Evaluación de Riesgo**
   - **Regla**: `score >= 700`
   - **Acción**: Emite `RIESGO_APROBADO` si se cumple, `RIESGO_RECHAZADO` si no.

3. **Registro en Core Bancario**
   - **Regla**: Validación interna del core.
   - **Acción**: Emite `PRESTAMO_REGISTRADO` si tiene éxito, `ERROR_REGISTRO` si falla.

### Trade-offs vs Orquestación
- **Coreografía** es ideal para este caso si:
  1. **Escalabilidad**: Se espera alto volumen de solicitudes (ej. >1000 solicitudes/hora).
  2. **Autonomía**: Cada servicio puede evolucionar independientemente.
  3. **Tolerancia a Fallos**: Los servicios pueden fallar sin bloquear el flujo completo.

- **Desafíos**:
  - **Depuración**: Seguir el flujo requiere correlacionar eventos (necesita trazabilidad con `solicitudId`).
  - **Consistencia Eventual**: Los estados temporales pueden ser inconsistentes.
  - **Latencia**: Las decisiones condicionales (ej. validar antifraude antes de riesgo) requieren orquestación de eventos.

### Herramientas Recomendadas
- **Bus de Eventos**: Apache Kafka, AWS EventBridge o Azure Event Grid.
- **Trazabilidad**: OpenTelemetry + Jaeger para correlacionar eventos.
- **Resiliencia**: Patrones como Circuit Breaker (Resilience4j) y Retry (Spring Retry).