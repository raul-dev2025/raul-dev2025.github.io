=======================
Arquitectura del Módulo
=======================

Dispositivo de Caracteres como Capa de Inspección y Telemetría
==============================================================

1. Justificación del Diseño
---------------------------

En el kernel de Linux, los dispositivos PCI conectados al sistema ya disponen de controladores nativos que gestionan la funcionalidad operativa del hardware (gestión de bus, interrupciones y operaciones de red o bloque). Reimplementar esta lógica no solo sería ineficiente, sino que rompería la abstracción del sistema.

En lugar de duplicar o reemplazar la abstracción lógica existente, este proyecto propone la creación de un **dispositivo de caracteres propio** (``cdev``) que actúa como un **canal de inspección y monitorización**. El controlador nativo mantiene el control total del dispositivo, mientras que nuestro módulo actúa como una capa superpuesta ("llantas y neumáticos sobre la rueda existente") que recopila y expone métricas y registros seleccionados hacia el espacio de usuario a través de un nodo ``/dev``.

2. Automatización de la Interfaz en Espacio de Usuario
------------------------------------------------------

Para evitar la creación manual del nodo de dispositivo mediante ``mknod``, la definición e instanciación del dispositivo se gestiona directamente en C dentro del ciclo de vida del módulo:

1. **Asignación Dinámica:** Obtención de los identificadores *Major* y *Minor* mediante ``alloc_chrdev_region()``.
2. **Vinculación de Operaciones:** Registro del dispositivo de caracteres (``cdev_init`` y ``cdev_add``) asociándolo a una estructura ``file_operations`` que gestiona las llamadas de lectura/escritura (``read``, ``open``, ``release``).
3. **Notificación al Sistema** (``sysfs`` / ``udev``): Creación de la clase mediante ``class_create()`` e instanciación del dispositivo con ``device_create()``. Esto dispara un evento *uevent* en el kernel que el demonio ``udev`` procesa para generar automáticamente el archivo correspondiente en ``/dev/`` con los permisos adecuados.


3. Estrategias de Extracción e Inspección de Datos
--------------------------------------------------

Para nutrir el dispositivo de caracteres con información del hardware PCI sin interferir con el controlador activo, se contemplan tres aproximaciones técnicas:

A. Inspección a través de ``pci_dev`` y ``sysfs``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Localización de la estructura ``struct pci_dev`` del dispositivo objetivo (mediante APIs del subsistema PCI como ``pci_get_device()``) para consultar sus espacios de configuración, estados de energía y registros expuestos.

B. Mapeo de Memoria de Entrada/Salida (MMIO)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Acceso directo a las regiones BAR (*Base Address Registers*) del dispositivo PCI mediante ``ioremap()``. Esto permite consultar contadores internos o registros de estado mapeados en memoria en tiempo real de forma no intrusiva.

C. Intercepción mediante *Kprobes* / *Tracepoints*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Captura dinámica de eventos en tiempo de ejecución enganchando puntos de prueba (*kprobes*) a las funciones del controlador nativo. Al ejecutarse las rutinas del driver original (por ejemplo, gestión de interrupciones o buffers de procesamiento), los datos se copian a un *ring buffer* interno administrado por nuestro módulo y se sirven a través del nodo ``/dev`` cuando una aplicación de espacio de usuario realiza una lectura (``read``).