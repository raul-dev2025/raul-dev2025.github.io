=================================================
Interrupciones y Comunicación con Bus PCI - Tests
=================================================

.. contents:: Pruebas Evaluadas
   :depth: 2
   :local:

Análisis del Caso de Prueba: Identificación del Bus y Espacio de Configuración
==============================================================================

* **Subsistema**: ``drivers/pci`` / ``sysfs``
* **Objetivo**: Verificar la correcta detección, enumeración y lectura del Espacio de Configuración de los dispositivos PCI en la topología del sistema.
* **Fundamento Teórico**: Consulte :doc:`BUS_teorica` para revisar la estructura de la jerarquía BDF, los registros BAR y la exposición en ``sysfs``.

Análisis de Ejecución
---------------------

1. **Configuración del Entorno** (``setup``):
   Se comprueba la existencia de la jerarquía de dispositivos PCI en ``/sys/bus/pci/devices/`` y la disponibilidad de permisos para la lectura de los recursos del bus.

2. **Invocación y Lectura** (``run``):
   Acceso a los atributos de los dispositivos (identificadores ``vendor``, ``device`` y archivo de configuración ``config``) para validar la consistencia de la lectura de cabeceras PCI.

3. **Verificación**:
   Comprobación de que las direcciones de memoria mapeada (MMIO) declaradas en los registros BAR corresponden a rangos válidos del mapa de memoria del sistema.

Resultados en Entorno ``buildlab``
----------------------------------

.. admonition:: Test pci_config01   

   Sección reservada para documentar las salidas de ejecución y registros en ``buildlab``
   clasificando los resultados según la metodología LTP (``TPASS``, ``TFAIL``, ``TCONF``).

.. code-block:: text

   tst_test.c:1900: TINFO: LTP version: 20250130
   tst_test.c:1904: TINFO: Tested kernel: 6.12.0-124.8.1.el10_1.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Nov 11 22:54:28 UTC 2025 x86_64
   tst_kconfig.c:88: TINFO: Parsing kernel config '/lib/modules/6.12.0-124.8.1.el10_1.x86_64/build/.config'
   tst_test.c:1722: TINFO: Overall timeout per run is 0h 00m 30s
   pci_config_test.c:30: TINFO: Escaneando dispositivos en /sys/bus/pci/devices...
   pci_config_test.c:48: TINFO: BDF: 0000:03:00.0 -> VendorID: 0x1af4 | DeviceID: 0x1043
   pci_config_test.c:48: TINFO: BDF: 0000:00:1f.2 -> VendorID: 0x8086 | DeviceID: 0x2922
   pci_config_test.c:48: TINFO: BDF: 0000:0a:01.0 -> VendorID: 0x1234 | DeviceID: 0x1111
   pci_config_test.c:48: TINFO: BDF: 0000:09:00.0 -> VendorID: 0x1b36 | DeviceID: 0x000e
   pci_config_test.c:48: TINFO: BDF: 0000:00:01.2 -> VendorID: 0x1b36 | DeviceID: 0x000c
   pci_config_test.c:65: TPASS: Se leyo correctamente el Espacio de Configuracion PCI de 5 dispositivos

   Summary:
   passed   1
   failed   0
   broken   0
   skipped  0
   warnings 0


Análisis del Caso de Prueba: Asignación y Control de Interrupciones (MSI/MSI-X)
================================================================================

* **Subsistema**: ``kernel/irq`` / ``drivers/pci``
* **Objetivo**: Validar el registro y la entrega de vectores de interrupción en dispositivos PCI, verificando la transición a mecanismos MSI/MSI-X.
* **Fundamento Teórico**: Consulte :doc:`BUS_teorica` para revisar el ciclo de vida de las interrupciones, las diferencias entre líneas INTx y vectores MSI-X, y la gestión mediante *Top Half* / *Bottom Half*.

Análisis de Ejecución
---------------------

1. **Configuración del Entorno** (``setup``):
   Inspección de las líneas de interrupción asignadas al dispositivo en prueba a través de la interfaz ``/proc/interrupts``.

2. **Invocación y Eventos** (``run``):
   Generación de eventos de E/S sobre el dispositivo seleccionado para provocar el disparo de interrupciones y verificar la respuesta del manejador (*Interrupt Service Routine* - ISR).

3. **Verificación**:
   Confirmación del incremento en los contadores de vectores de interrupción en la CPU correspondiente y ausencia de anomalías o desbalanceo de líneas compartidas.

Resultados en Entorno ``buildlab``
----------------------------------

.. admonition:: Test pci_msi01   

   Sección reservada para documentar las salidas de ejecución y registros en ``buildlab``
   clasificando los resultados según la metodología LTP (``TPASS``, ``TFAIL``, ``TCONF``).

.. code-block:: text

   tst_test.c:1900: TINFO: LTP version: 20250130
   tst_test.c:1904: TINFO: Tested kernel: 6.12.0-124.8.1.el10_1.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Nov 11 22:54:28 UTC 2025 x86_64
   tst_kconfig.c:88: TINFO: Parsing kernel config '/lib/modules/6.12.0-124.8.1.el10_1.x86_64/build/.config'
   tst_test.c:1722: TINFO: Overall timeout per run is 0h 00m 30s
   pci_msi_test.c:73: TINFO: Analizando asignacion de interrupciones en /sys/bus/pci/devices...
   pci_msi_test.c:40: TINFO: BDF: 0000:03:00.0 -> Asignados 2 vectores MSI/MSI-X
   pci_msi_test.c:40: TINFO: BDF: 0000:00:1f.2 -> Asignados 1 vectores MSI/MSI-X
   pci_msi_test.c:54: TINFO: BDF: 0000:0a:01.0 -> Asignada linea IRQ tradicional (INTx): 0
   pci_msi_test.c:54: TINFO: BDF: 0000:09:00.0 -> Asignada linea IRQ tradicional (INTx): 22
   pci_msi_test.c:40: TINFO: BDF: 0000:00:01.2 -> Asignados 1 vectores MSI/MSI-X
   pci_msi_test.c:89: TPASS: Se verifico correctamente la asignacion de interrupciones en 5 dispositivos
   
   Summary:
   passed   1
   failed   0
   broken   0
   skipped  0
   warnings 0

Análisis del Caso de Prueba: Mapeo de Memoria y Regiones BAR (MMIO/PIO)
========================================================================

* **Subsistema**: ``drivers/pci`` / ``sysfs`` / ``mm``
* **Objetivo**: Inspeccionar la asignación de espacios de memoria MMIO y direcciones de puerto (Port I/O) declarados en los registros BAR (Base Address Registers) de los dispositivos PCI.
* **Fundamento Teórico**: Consulte :doc:`BUS_teorica` para revisar el mapeo de memoria E/S, la diferenciación entre rangos de 32/64 bits, atributos de prefetcheabilidad y la reserva en espacio físico.

Análisis de Ejecución
---------------------

1. **Configuración del Entorno** (``setup``):
   Lectura de la interfaz de recursos en ``/sys/bus/pci/devices/<BDF>/resource`` para verificar los rangos de inicio, fin y atributos (*flags*) de cada región.

2. **Invocación y Cálculo** (``run``):
   Parseo de las direcciones mapeadas, cálculo del tamaño de ventana por BAR ($Base_{end} - Base_{start} + 1$) y clasificación entre regiones MMIO (Prefetchable / Non-Prefetchable) y Port I/O.

3. **Verificación**:
   Confirmación de la validez de los rangos declarados en el archivo de recursos frente a las reservas de memoria física expuestas en el sistema.

Resultados en Entorno ``buildlab``
----------------------------------

.. admonition:: Test pci_bar01

   Sección reservada para documentar las salidas de ejecución y registros en ``buildlab``
   clasificando los resultados según la metodología LTP (``TPASS``, ``TFAIL``, ``TCONF``).


.. code-block:: text

   # Tu código aquí
   tst_test.c:1900: TINFO: LTP version: 20250130
   tst_test.c:1904: TINFO: Tested kernel: 6.12.0-124.8.1.el10_1.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Nov 11 22:54:28 UTC 2025 x86_64
   tst_kconfig.c:88: TINFO: Parsing kernel config '/lib/modules/6.12.0-124.8.1.el10_1.x86_64/build/.config'
   tst_test.c:1722: TINFO: Overall timeout per run is 0h 00m 30s
   pci_bar_test.c:83: TINFO: Analizando regiones BAR/MMIO en /sys/bus/pci/devices...
   pci_bar_test.c:55: TINFO: BDF: 0000:03:00.0 | BAR1: [0x82800000 - 0x82800fff] | Tamano: 4 KB | Tipo: MMIO (Non-Prefetchable)
   pci_bar_test.c:55: TINFO: BDF: 0000:03:00.0 | BAR4: [0x381000000000 - 0x381000003fff] | Tamano: 16 KB | Tipo: MMIO (Prefetchable)
   pci_bar_test.c:55: TINFO: BDF: 0000:00:1f.2 | BAR4: [0x6040 - 0x605f] | Tamano: 0 KB | Tipo: Port I/O
   pci_bar_test.c:55: TINFO: BDF: 0000:00:1f.2 | BAR5: [0x82e40000 - 0x82e40fff] | Tamano: 4 KB | Tipo: MMIO (Non-Prefetchable)
   pci_bar_test.c:55: TINFO: BDF: 0000:0a:01.0 | BAR0: [0x80000000 - 0x80ffffff] | Tamano: 16384 KB | Tipo: MMIO (Prefetchable)
   pci_bar_test.c:55: TINFO: BDF: 0000:0a:01.0 | BAR2: [0x81000000 - 0x81000fff] | Tamano: 4 KB | Tipo: MMIO (Non-Prefetchable)
   pci_bar_test.c:55: TINFO: BDF: 0000:09:00.0 | BAR0: [0x81100000 - 0x811000ff] | Tamano: 0 KB | Tipo: MMIO (Non-Prefetchable)
   pci_bar_test.c:55: TINFO: BDF: 0000:00:01.2 | BAR0: [0x82e4d000 - 0x82e4dfff] | Tamano: 4 KB | Tipo: MMIO (Non-Prefetchable)
   pci_bar_test.c:99: TPASS: Se inspeccionaron correctamente las regiones BAR de 5 dispositivos

   Summary:
   passed   1
   failed   0
   broken   0
   skipped  0
   warnings 0
