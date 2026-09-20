============================
Espacio de configuración PCI
============================

El mapa estándar del encabezado del espacio de configuración PCI (Type 0 Header), especificando el desplazamiento (offset) y tamaño de los registros principales en los primeros 64 bytes:

Mapa del Espacio de Configuración PCI (Header Type 0)



.. list-table::
   :widths: 15 15 30 40
   :header-rows: 1

  * - Offset (Hex)
    - Tamaño
    - Registro PCI
    - Descripción
  * - ``0x00``
    - 2 Bytes
    - ``PCI_VENDOR_ID``
    - Identificador del fabricante de la tarjeta
  * - ``0x02``
    - 2 Bytes
    - ``PCI_DEVICE_ID``
    - Identificador del dispositivo PCI
  * - ``0x04``
    - 2 Bytes
    - ``PCI_COMMAND``
    - Registro de control de funciones de E/S y MMIO
  * - ``0x06``
    - 2 Bytes
    - ``PCI_STATUS``
    - Registro de estado de eventos del bus PCI
  * - ``0x08``
    - 1 Byte
    - ``PCI_REVISION_ID``
    - Revisión de silicio del dispositivo
  * - ``0x09``
    - 3 Bytes
    - ``PCI_CLASS_PROG`` / ``DEVICE_CLASS``
    - Código de clase de dispositivo y programación de interfaz
  * - ``0x0C``
    - 1 Byte
    - ``PCI_CACHE_LINE_SIZE``
    - Tamaño de la línea de caché del sistema
  * - ``0x0D``
    - 1 Byte
    - ``PCI_LATENCY_TIMER``
    - Temporizador de latencia del bus en ciclos de reloj
  * - ``0x0E``
    - 1 Byte
    - ``PCI_HEADER_TYPE``
    - Tipo de cabecera (0x00 para endpoint, 0x01 para puente PCI-to-PCI)
  * - ``0x0F``
    - 1 Byte
    - ``PCI_BIST``
    - Registro de autocomprobación de encendido (*Built-In Self Test*)
  * - ``0x10`` - ``0x27``
    - 24 Bytes
    - ``PCI_BASE_ADDRESS_0..5``
    - Registros BAR (Mapeo de memoria MMIO y direcciones I/O)
  * - ``0x2C``
    - 2 Bytes
    - ``PCI_SUBSYSTEM_VENDOR_ID``
    - Identificador del ensamblador de la tarjeta (OEM)
  * - ``0x2E``
    - 2 Bytes
    - ``PCI_SUBSYSTEM_ID``
    - Identificador del modelo específico asignado por el ensamblador
  * - ``0x30``
    - 4 Bytes
    - ``PCI_ROM_ADDRESS``
    - Base de la ROM de expansión (*Option ROM*)
  * - ``0x34``
    - 1 Byte
    - ``PCI_CAPABILITY_LIST``
    - Puntero a la lista enlazada de capacidades extendidas (MSI, PCIe, Power Mgmt)
  * - ``0x3C``
    - 1 Byte
    - ``PCI_INTERRUPT_LINE``
    - Línea del controlador de interrupción IRQ asignada
  * - ``0x3D``
    - 1 Byte
    - ``PCI_INTERRUPT_PIN``
    - Pin de interrupción física (INTA#, INTB#, INTC#, INTD#)

-----

Relación con la lógica actual de hwbus_pci_config_read()

Actualmente, el callback read expone únicamente los primeros 4 bytes del mapa (0x00 a 0x03):  

.. code-block:: C

   En *f_pos == 0: Lee PCI_VENDOR_ID (2 Bytes en 0x00).  
   En *f_pos == 2: Lee PCI_DEVICE_ID (2 Bytes en 0x02).  

Si en el futuro se condsidera ampliar el alcance del driver de inspección para recorrer más registros de la tabla (por ejemplo, leer PCI_COMMAND o los BARs), la estructura de lectura basada en desplazamientos de ``f_pos`` se podrá mapear directamente contra estos offsets estandarizados del bus PCI. 