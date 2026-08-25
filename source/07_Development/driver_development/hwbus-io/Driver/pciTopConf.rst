=================
Configuración PCI
=================


Primeros 64 bytes del espacio de configuración PCI
==================================================

Para definir con total precisión el mapa de memoria que expondrá ``/dev/hwbusc``, se agruparán exhaustivamente todos los campos estándar de la cabecera PCI de Tipo 0 (los 64 bytes principales) según su naturaleza operativa:

1. Campos Informativos e Identificación (Lectura en ``/dev/hwbusc``)
--------------------------------------------------------------------

Registros fijos en ROM o configurados de fábrica. Aportan contexto directo sobre la identidad del hardware y son ideales para lecturas contiguas desde espacio de usuario:

* ``PCI_VENDOR_ID`` **(0x00, 16 bits):** Identificador del fabricante del chip (ej. ``0x1b36``).
* ``PCI_DEVICE_ID`` **(0x02, 16 bits):** Identificador del modelo de dispositivo.
* ``PCI_REVISION_ID`` **(0x08, 8 bits):** Revisión del silicio.
* ``PCI_CLASS_PROG`` **(0x09, 8 bits):** Interfaz de programación específica de la clase.
* ``PCI_CLASS_DEVICE`` **(0x0A, 16 bits):** Código de clase y subclase del dispositivo (ej. red, almacenamiento, puente).
* ``PCI_HEADER_TYPE`` **(0x0E, 8 bits):** Define la maquetación del resto de la cabecera (Tipo 0 para dispositivos finales, Tipo 1 para puentes) y si es un dispositivo multifunción.
* ``PCI_SUBSYSTEM_VENDOR_ID`` **(0x2C, 16 bits):** Identificador del fabricante de la tarjeta/ensamblador.
* ``PCI_SUBSYSTEM_ID`` **(0x2E, 16 bits):** Identificador del submodelo asignado por el ensamblador.
* ``PCI_CAPABILITIES_POINTER`` **(0x34, 8 bits):** Puntero a la lista enlazada de capacidades extendidas (MSI, PCIe, Power Management).


2. Campos Susceptibles de Configuración por el Usuario / Driver (Lectura/Escritura)
-----------------------------------------------------------------------------------

Registros cuya modificación altera directamente el comportamiento operativo del hardware o su gestión de eventos:

* ``PCI_COMMAND`` **(0x04, 16 bits):** Controla la respuesta del dispositivo a ciclos I/O, accesos a memoria, generación de ráfagas, Master Enable y recepción de interrupciones INTx.
* ``PCI_STATUS`` **(0x06, 16 bits):** Estado del dispositivo (errores de paridad, abortos de bus). Varios de sus bits se limpian escribiendo un ``1`` (*Write-1-to-Clear*).
* ``PCI_CACHE_LINE_SIZE`` **(0x0C, 8 bits):** Tamaño de la línea de caché del sistema en palabras de 32 bits (para optimizar accesos DMA).
* ``PCI_LATENCY_TIMER`` **(0x0D, 8 bits):** Tiempo máximo (en relojes PCI) que el dispositivo puede retener el bus como Bus Master.
* ``PCI_INTERRUPT_LINE`` **(0x3C, 8 bits):** Línea de la controladora de interrupciones (IRQ) asignada al dispositivo.
* ``PCI_INTERRUPT_PIN`` **(0x3D, 8 bits):** Pin de interrupción física utilizado (``INTA#``, ``INTB#``, etc.).


3. Campos de Uso Interno e Infraestructura del Kernel
-----------------------------------------------------

Registros de gestión baja que el subsistema PCI del kernel asigna dinámicamente durante la fase de enumeración (*PCI Enumeration/Probing*). Generalmente no se deben modificar a mano desde el espacio de usuario:

* ``PCI_BASE_ADDRESS_0`` a ``5`` **(BARs 0x10 - 0x24, 32 bits c/u):** Regiones de direcciones base para mapas de memoria (MMIO) o puertos I/O.
* ``PCI_CARDBUS_CIS`` **(0x28, 32 bits):** Puntero a la estructura CIS en tarjetas CardBus.
* ``PCI_ROM_ADDRESS`` **(0x30, 32 bits):** Dirección base y control de activación del firmware/Expansion ROM.
* ``PCI_MIN_GNT`` **(0x3E, 8 bits):** Tiempo mínimo de concesión de bus requerido por el dispositivo.
* ``PCI_MAX_LAT`` **(0x3F, 8 bits):** Latencia máxima que puede tolerar el dispositivo para acceder al bus.

