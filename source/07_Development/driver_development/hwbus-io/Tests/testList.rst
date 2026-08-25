============================
Pruebas para ``/dev/hwbusc``
============================


Lista Consolidada de Pruebas
============================

* **1. Verificación de Presencia y Registro**

   * **Comprobación de nodo** ``/dev``: Validar la existencia del archivo de dispositivo ``/dev/hwbusc`` mediante ``access()`` o ``stat()``.
   * **Registro en** ``/proc/devices``: Inspeccionar ``/proc/devices`` para confirmar que el driver está registrado con su número *Major* (240).
   * **Registro de Clase SysFS**: Validar la existencia del directorio ``/sys/class/hwbusc/hwbusc/`` y sus archivos asociados (``dev``, ``uevent``).


* **2. Validación de Lecturas y Contenido PCI vía IOCTL**

   * **Lectura atómica de registros**: Invocar comandos ``_IOR`` (como ``HWBUS_IOC_READ_VENDOR`` y ``HWBUS_IOC_READ_DEVICE``) y verificar que devuelvan exactamente el tamaño del registro (``u16``) y coincidan con SysFS (``/sys/bus/pci/devices/0000:02:00.0/vendor`` y ``device``) en ordenamiento *little-endian*.
   * **Cobertura de ancho de datos**: Validar transferencias de 8, 16 y 32 bits mediante ioctls específicas (ej. ``PCI_REVISION_ID`` como ``u8``, ``PCI_COMMAND`` como ``u16`` y ``PCI_BASE_ADDRESS_0`` como ``u32``).
   * **Rechazo de comandos IOCTL no válidos**: Enviar una orden ioctl no definida en la cabecera y confirmar la devolución de error ``-1`` con ``errno == ENOTTY``.


* **3. Validación de Posicionamiento y Lectura Continua (lseek + read)**

   * **Lectura posicionada con SEEK_SET**: Ejecutar ``lseek()`` apuntando al offset de un registro específico (ej. ``PCI_DEVICE_ID`` en ``0x02``) y comprobar que ``read()`` obtenga los bytes exactos correspondientes.
   * **Rechazo de accesos desalineados/parciales**: Solicitar lecturas parciales o desalineadas respecto a los límites del registro objetivo y verificar que el driver rechace la operación devolviendo error ``-1`` con ``errno == EINVAL``.
   * **Límites de offset y EOF**: Verificar que intentas de ``lseek()`` o lectura más allá del rango de configuración PCI (``0x00`` - ``0xFF``) retornen error ``-EINVAL`` o fin de archivo (``EOF``).


* **4. Validación de Restricción de Escritura**

   * **Rechazo de escrituras**: Intentar invocar ``write()`` sobre ``/dev/hwbusc`` (en modo ``O_WRONLY`` u ``O_RDWR``) y asentar como éxito la devolución de error ``-1`` con ``errno == EBADF`` o ``EINVAL``.


* **5. Verificación de Parámetros de Módulo**

   * **Atributo** ``hwbus_bdf_param``: Leer la ruta ``/sys/module/hwbus_io/parameters/hwbus_bdf_param`` para comprobar que refleja la dirección PCI objetivo (``"0000:02:00.0"``).


* **6. Concurrencia y Mapeo de Memoria**

   * **Acceso concurrente**: Abrir múltiples descriptores simultáneos de ``/dev/hwbusc`` desde distintos hilos/procesos para asegurar que el callback ``.open`` mantenga de forma independiente la posición de lectura de cada descriptor.
   * **Mapeo ``mmap()`` (si aplica)**: Ejecutar ``mmap()`` sobre el descriptor de archivo para validar el mapeo de memoria y su posterior liberación con ``munmap()``.