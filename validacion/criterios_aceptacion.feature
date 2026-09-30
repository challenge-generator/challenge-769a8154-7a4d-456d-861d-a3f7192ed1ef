Feature: Validación de la integración SOA para gestión de préstamos hipotecarios
  Como analista de integración
  Quiero validar que la arquitectura SOA cumpla con los requisitos funcionales y no funcionales
  Para asegurar la correcta coordinación entre servicios y la consistencia de datos

  Background:
    Given el sistema de gestión de préstamos está operativo
    And los servicios de originación, antifraude, buró de riesgos y core bancario están disponibles

  Scenario: Solicitud de préstamo hipotecario aprobada exitosamente
    Given una solicitud de préstamo con los siguientes datos:
      | id_solicitud       | tipo_prestamo | monto_solicitado | plazo_meses | tasa_interes | id_cliente      | nombre_cliente | apellido_cliente | tipo_documento | numero_documento | ingresos_mensuales | score_crediticio |
      | SOL-2023-0001      | HIPOTECARIO   | 200000.00      | 240         | 4.5         | CLIENTE-0001    | JUAN           | PEREZ           | DNI            | 12345678        | 5000.00          | 750             |
    When el originador procesa la solicitud
    And el motor antifraude evalúa la solicitud
    And el buró de riesgos consulta el historial crediticio
    And el core bancario registra la solicitud
    Then la solicitud debe quedar en estado "APROBADA"
    And el campo "motivo_rechazo" debe estar vacío
    And el core bancario debe generar un número de préstamo
    And el número de préstamo debe seguir el formato "LOAN-YYYY-NNNNN"

  Scenario: Solicitud de préstamo rechazada por bajo scoring crediticio
    Given una solicitud de préstamo con los siguientes datos:
      | id_solicitud       | tipo_prestamo | monto_solicitado | plazo_meses | tasa_interes | id_cliente      | nombre_cliente | apellido_cliente | tipo_documento | numero_documento | ingresos_mensuales | score_crediticio |
      | SOL-2023-0002      | PERSONAL      | 15000.00       | 36          | 8.5         | CLIENTE-0002    | MARIA          | GONZALEZ        | DNI            | 87654321        | 2000.00          | 550             |
    When el buró de riesgos consulta el historial crediticio
    Then el score crediticio debe ser menor que 600
    And la solicitud debe quedar en estado "RECHAZADA"
    And el campo "motivo_rechazo" debe ser "SCORING_BAJO"

  Scenario: Solicitud de préstamo requiere revisión manual por indicadores de fraude
    Given una solicitud de préstamo con los siguientes datos:
      | id_solicitud       | tipo_prestamo | monto_solicitado | plazo_meses | tasa_interes | id_cliente      | nombre_cliente | apellido_cliente | tipo_documento | numero_documento | ingresos_mensuales | score_crediticio | indicadores_fraude               |
      | SOL-2023-0003      | AUTOMOTRIZ    | 30000.00       | 60          | 6.0         | CLIENTE-0003    | CARLOS         | MARTINEZ        | DNI            | 11223344        | 3500.00          | 680             | DOCUMENTO_DUPLICADO|DIRECCION_SOSPECHOSA |
    When el motor antifraude evalúa la solicitud
    Then la solicitud debe quedar en estado "REVISAR_MANUAL"
    And el campo "indicadores_fraude" debe contener "DOCUMENTO_DUPLICADO"
    And el campo "indicadores_fraude" debe contener "DIRECCION_SOSPECHOSA"

  Scenario: Validación de transformación de datos entre originador y core bancario
    Given los siguientes datos en el originador:
      | id_solicitud       | tipo_prestamo | fecha_solicitud | nombre_cliente | ingresos_mensuales |
      | SOL-2023-0004      | HIPOTECARIO   | 15/05/2023    | Ana López       | 4500            |
    When los datos se transforman al formato del core bancario
    Then los campos transformados deben ser:
      | loanApplicationId | loanType   | applicationDate | customerName | monthlyIncome |
      | SOL-2023-0004      | MORTGAGE      | 2023-05-15    | ANA LOPEZ       | 4500.00        |

  Scenario: Validación de transformación de datos entre antifraude y buró de riesgos
    Given los siguientes datos en el motor antifraude:
      | id_solicitud       | tipo_documento | numero_documento | telefono_contacto       | email                  |
      | SOL-2023-0005      | DNI           | 55-666-777     | (11) 98765-4321        | Juan.Perez@ejemplo.com |
    When los datos se transforman al formato del buró de riesgos
    Then los campos transformados deben ser:
      | loanApplicationId | documentType | documentNumber | phoneNumber    | email                  |
      | SOL-2023-0005      | ID_CARD       | 55666777       | 11987654321     | juan.perez@ejemplo.com |

  Scenario: Fallo en transacción distribuida - timeout en buró de riesgos
    Given una solicitud de préstamo con id_solicitud "SOL-2023-0006"
    And el buró de riesgos no responde dentro de 5 segundos
    When el sistema intenta procesar la solicitud
    Then la solicitud debe quedar en estado "EN_REVISION"
    And se debe registrar un evento "TIMEOUT_BURO_RIESGOS" en el sistema de monitoreo
    And se debe reintentar la consulta al buró de riesgos con exponential backoff

  Scenario: Fallo en transacción distribuida - inconsistencia de datos
    Given una solicitud de préstamo aprobada con id_solicitud "SOL-2023-0007"
    And el core bancario registra la solicitud con estado "APROBADA"
    But el motor antifraude registra la solicitud con estado "RECHAZADA"
    When el sistema detecta la inconsistencia
    Then se debe generar una alerta crítica en el sistema de monitoreo
    And se debe registrar un evento "INCONSISTENCIA_ESTADO_SOLICITUD"
    And se debe invocar el servicio de reconciliación para resolver la inconsistencia

  Scenario: Validación de reglas de negocio - relación deuda/ingresos
    Given una solicitud de préstamo con:
      | id_solicitud       | saldo_deuda_total | ingresos_mensuales |
      | SOL-2023-0008      | 150000.00         | 5000.00          |
    When se calcula la relación deuda/ingresos
    Then la relación debe ser 300%
    And la solicitud debe ser rechazada automáticamente
    And el campo "motivo_rechazo" debe ser "RELACION_DEUDA_INGRESOS_EXCESIVA"