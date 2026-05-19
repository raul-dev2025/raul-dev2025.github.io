============================================================
DOCUMENTACIÓN TÉCNICA: INFRAESTRUCTURA DE HARDWARE (NODO 01)
============================================================

:Estado: Fase de Documentación Técnica
:Host: Gigabyte B550 Aorus Elite V2
:Ingeniero: Gemini Tech Doc Engineer

Objetivo Técnico
================

Establecer la configuración de bajo nivel del hardware host para garantizar la integridad física y la estabilidad de los buses de comunicación de la infraestructura. El problema principal abordado fue la validación de interfaces no documentadas, la implementación de un sistema de detección de intrusión perimetral en el chasis y la optimización de la topología USB para periféricos de control.

Procedimiento
=============

1. Configuración de Seguridad Física (Chassis Intrusion)
-------------------------------------------------------

Se ha integrado un mecanismo de seguridad basado en el cabezal **CI** (Chassis Intrusion). El procedimiento de activación en el firmware se detalla a continuación:

.. code-block:: bash

   # Acceso a configuración de seguridad en BIOS
   # Settings > IO Ports > Chassis Intrusion > Enabled
   
   # Reinicio del flag de alerta tras mantenimiento
   # Settings > IO Ports > Reset Chassis Intrusion > Yes

2. Asignación de Buses USB para HID
-----------------------------------

Se ha procedido al mapeo físico del teclado **Corsair K70 Rapidfire** para asegurar la disponibilidad del dispositivo en estados de pre-ejecución del hipervisor.

.. code-block:: bash

   # Identificación de puertos en panel trasero (Back Panel)
   # Puerto ID: USB_2.0_1 (Color: Negro) -> Conexión Data/Power
   # Puerto ID: USB_2.0_2 (Color: Negro) -> Conexión Passthrough (Opcional)

Justificación
=============

* **Uso de Pulsador Normalmente Abierto (NO)**: Se eligió este componente para aprovechar la presión mecánica de la tapa del chasis. Al cerrar la tapa, el pulsador pasa a estado de **continuidad**, cerrando el circuito. Esta configuración es crítica porque cualquier fallo en el cableado o manipulación física (corte de cable) disparará inmediatamente el estado de alerta por circuito abierto.
* **Selección de Bus USB 2.0**: El teclado Corsair K70 requiere estabilidad sobre ancho de banda. Se ha evitado el uso de puertos **USB 3.2 (5Gbps/10Gbps)** para mitigar problemas de compatibilidad en el arranque y reservar las líneas de datos de alta velocidad para la futura implementación de almacenamiento persistente externo o NICs de alta velocidad.
* **Aislamiento del puerto LED_DEMO**: Se ha documentado la exclusión de este puerto para evitar riesgos de **sobretensión o retroalimentación** de 5V/12V hacia el circuito de iluminación de la placa base, ya que su propósito es puramente de exhibición comercial y no funcional para el hipervisor.

Verificación
============

Para validar que la infraestructura es correcta y operativa, se ejecutaron las siguientes pruebas:

1. **Validación Eléctrica**: Comprobación de **resistencia mínima** mediante multímetro en los terminales del pulsador, confirmando una soldadura sólida y sin intermitencias tras el proceso de mecanizado.
2. **Prueba de POST**: Verificación de la interrupción del arranque y visualización del mensaje **"Chassis Intruded"** al desconectar el terminal con el sistema en frío.
3. **Persistencia del Log**: Se confirmó que el sistema mantiene el registro de "Caja Abierta" en la BIOS hasta que se ejecuta el comando manual de **Reset** en los parámetros de **PC Health Status**.

```

---

¿Deseas que proceda con la documentación de la configuración de los **fan headers** y el mapeo de los sensores térmicos integrados del chipset para el control de flujo de aire?