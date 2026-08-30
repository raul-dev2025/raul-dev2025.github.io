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

* **3. Auditoría y Rechazo de Operaciones POSIX Tradicionales (lseek, read, write)**

   * **Rechazo de posicionamiento (lseek):** Confirmar que cualquier intento de invocación de lseek() devuelva (off_t)-1 con errno == ESPIPE o EINVAL, certificando que el archivo de dispositivo no soporta despliegue de puntero de archivo.  

   * **Rechazo de lecturas no estructuradas (read):** Intentar invocar read() sobre el descriptor y validar que retorne error ``-1`` con ``errno == EINVAL`` o ``EBADF``, garantizando la denegación de accesos en formato stream.  

   * **Rechazo de escrituras (write):** Intentar invocar write() sobre /dev/hwbusc (abierto en cualquier modo) y confirmar la devolución de error -1 con ``errno == EBADF o EINVAL``


* **4. Verificación de Parámetros de Módulo**

   * **Atributo** ``hwbus_bdf_param``: Leer la ruta ``/sys/module/hwbus_io/parameters/hwbus_bdf_param`` para comprobar que refleja la dirección PCI objetivo (``"0000:02:00.0"``).

* **5. Concurrencia y Mapeo de Memoria**

   * **Acceso concurrente vía IOCTL**: Abrir múltiples descriptores simultáneos de /dev/hwbusc desde distintos hilos/procesos para asegurar que la ejecución de comandos ``ioctl()`` sea atómica y segura entre descriptores independientes.

   * **Rechazo de mapeo mmap()**: Confirmar que invocaciones a mmap() sobre el descriptor fallen devolviendo *MAP_FAILED* con ``errno == ENODEV`` o ``ENOSYS``.