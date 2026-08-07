==================================================
Interrupciones y Comunicación con Bus PCI - Teoría
==================================================

.. contents:: Contenidos
   :depth: 2
   :local:

Conceptos Fundamentales del Bus PCI/PCIe
========================================

La interconexión de dispositivos de alto rendimiento en sistemas modernos descansa sobre la arquitectura **PCI Express (PCIe)**, una evolución punto a punto del bus paralelo tradicional PCI. Comprender la gestión de hardware a bajo nivel en Linux requiere analizar cómo el kernel descubre, enumera y proyecta los recursos de estos dispositivos.

1. Jerarquía y Topología PCI
----------------------------

La topología del bus PCI está estructurada en un árbol jerárquico gestionado por la CPU y el chipset del sistema:

* **Host Bridge / Root Complex**: El nodo raíz que conecta la CPU y el subsistema de memoria RAM con el árbol PCIe.
* **PCI Bridge / Switches**: Dispositivos de interconexión que dividen o expanden segmentos del bus primario hacia buses secundarios.
* **Endpoints**: Dispositivos finales (tarjetas de red, controladores NVMe, GPUs) que consumen o generan transacciones en el bus.

2. Identificación BDF y Espacio de Configuración
------------------------------------------------

Cada función individual dentro de la jerarquía PCI se identifica unívocamente mediante la tripleta **BDF** (*Bus:Device.Function*), precedida por su dominio de segmento PCI:

.. code-block:: text

   [Dominio]   Bus : Dispositivo . Función
    0000     :  01  :    00       .   0

* **Espacio de Configuración (Configuration Space)**: Un conjunto estandarizado de registros de 256 bytes (4 KB en PCIe) que incluye los identificadores de hardware (``Vendor ID``, ``Device ID``) y los registros de dirección base (BARs).
* **Base Address Registers (BARs)**: Registros que le indican al sistema operativo qué cantidad de memoria o rango de puertos requiere el dispositivo para exponer sus controles e interfaces.

3. Acceso a Memoria Mapeada (MMIO) vs. Port I/O
-----------------------------------------------

El kernel de Linux interactúa con los registros del hardware PCI mediante dos métodos principales:

.. list-table:: Comparativa de Direccionamiento E/S
   :widths: 25 35 40
   :header-rows: 1

   * - Mecanismo
     - Descripción
     - Uso Actual
   * - **Port I/O**
     - Espacio de direcciones aislado accesible mediante instrucciones explícitas de CPU (``in`` / ``out`` en x86).
     - Obsoleto / Dispositivos Legacy.
   * - **MMIO (Memory-Mapped I/O)**
     - Mapeo de los registros del dispositivo directamente en el espacio de memoria física. Accesible con instrucciones normales de carga y almacenamiento (``mov``, ``readl``, ``writel``).
     - Estándar en PCIe moderno (NVMe, GPUs, GbE/10GbE).

.. seealso::

   Para revisar los casos de prueba prácticos aplicados al descubrimiento y validación del bus, consulte la sección de pruebas asociadas en :doc:`BUS_tests`.


Gestión de Interrupciones y Notificaciones
==========================================

Un componente crítico de la comunicación con hardware es la capacidad de un dispositivo para notificar a la CPU sobre eventos (p. ej., finalización de una transferencia DMA o recepción de paquetes de red).

1. Líneas de Interrupción Tradicionales (INTx)
----------------------------------------------

En la especificación PCI heredada, los dispositivos utilizan líneas físicas compartidas (``INTA#`` a ``INTD#``) vinculadas a un controlador programable de interrupciones (APIC).

* **Limitaciones**: Al ser líneas compartidas por múltiples dispositivos, la CPU debe consultar en serie a cada driver registrado en la línea para determinar el origen del evento, generando latencia y sobrecarga de procesamiento.

2. Interrupciones Señaladas por Mensaje (MSI / MSI-X)
-----------------------------------------------------

PCIe reemplaza las líneas físicas mediante **MSI (Message Signaled Interrupts)** y **MSI-X**:

* En lugar de conmutar un pin de voltaje, el dispositivo realiza una escritura en una dirección de memoria especial gestionada por la CPU/APIC.
* **MSI-X**: Permite a un solo dispositivo asignar hasta 2048 vectores de interrupción independientes. Esto es fundamental para escalar en entornos multinúcleo, permitiendo asociar colas de E/S dedicadas a CPUs específicas.

3. Ciclo de Vida del Procesamiento de Interrupciones en el Kernel
-----------------------------------------------------------------

Para mantener la reactividad del sistema, el kernel divide el procesamiento de interrupciones en dos fases (*Top Half* y *Bottom Half*):

.. list-table:: Fases del Tratamiento de Interrupciones
   :widths: 25 35 40
   :header-rows: 1

   * - Fase
     - Contexto de Ejecución
     - Tareas Típicas
   * - **Top Half (ISR)**
     - Contexto de Interrupción (Atómico, inhabilita IRQs).
     - Acatamiento rápido del evento hardware, limpieza del registro de interrupción y encolado de trabajo pesado.
   * - **Bottom Half**
     - SoftIRQs, Tasklets o Workqueues (Contexto de proceso).
     - Procesamiento de datos recibidos, asignación de memoria y notificación a las capas superiores del kernel.


Estructuras Internas del Kernel y Sysfs
=======================================

Estructuras C del Subcistema PCI
--------------------------------

Dentro del código fuente del kernel de Linux, el subsistema PCI representa las abstracciones del hardware mediante las siguientes estructuras clave:

* ``struct pci_dev``: Representa un dispositivo PCI individual en el sistema. Contiene información BDF, recursos BAR (``struct resource``), clase del dispositivo e información de energía/interrupciones.
* ``struct pci_driver``: Define la estructura del controlador del dispositivo, incluyendo funciones de callback esenciales como ``probe()`` (invocada al asociar un dispositivo) y ``remove()``.
* ``struct pci_bus``: Representa un segmento de bus PCI y gestiona la lista de dispositivos conectados a él.

Interfaz en Espacio de Usuario mediante Sysfs
---------------------------------------------

El kernel expone la jerarquía del bus PCI en el espacio de usuario a través del sistema de archivos virtual **sysfs**:

* **Ruta de dispositivos**: ``/sys/bus/pci/devices/`` contiene enlaces simbólicos para cada dispositivo detectado (p. ej. ``/sys/bus/pci/devices/0000:00:01.0/``).
* **Archivos clave**:

  - ``config``: Permite la lectura/escritura directa del Espacio de Configuración PCI.
  - ``resource``: Muestra los rangos de memoria y BARs asignados al dispositivo.
  - ``vendor`` / ``device``: Contienen los identificadores hexadecimales de fabricante y modelo.

.. seealso::

   Para analizar la ejecución de pruebas y verificación de dispositivos en el entono de laboratorio, consulte :doc:`BUS_tests`.