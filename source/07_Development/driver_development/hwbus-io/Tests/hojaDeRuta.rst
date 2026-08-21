============================
Pruebas para ``/dev/hwbusc``
============================


Lista Consolidada de Pruebas
============================

* **1. Verificación de Presencia y Registro**

   * **Comprobación de nodo** ``/dev``: Validar la existencia del archivo de dispositivo ``/dev/hwbusc`` mediante ``access()`` o ``stat()``.
   * **Registro en** ``/proc/devices``: Inspeccionar ``/proc/devices`` para confirmar que el driver está registrado con su número *Major* (240).
   * **Registro de Clase SysFS**: Validar la existencia del directorio ``/sys/class/hwbusc/hwbusc/`` y sus archivos asociados (``dev``, ``uevent``).


* **2. Validación de Lecturas y Contenido PCI**

   * **Lectura exacta de IDs** (``VendorID`` / ``DeviceID``): Leer los 4 bytes del dispositivo y comparar el resultado contra los atributos reales expuestos en SysFS (``/sys/bus/pci/devices/0000:02:00.0/vendor`` y ``device``), verificando el ordenamiento *little-endian*.
   * **Lectura parcial**: Solicitar únicamente 2 bytes vía ``read()`` para verificar que retorne correctamente los 2 bytes correspondientes al ``VendorID``.
   * **Lectura con desborde de buffer**: Solicitar un tamaño mayor (ej. 64 bytes) y verificar que ``read()`` trunque la respuesta a 4 bytes y maneje correctamente el desplazamiento del puntero (``f_pos``) retornando ``0`` (``EOF``) en llamadas consecutivas.


* **3. Validación de Restricción de Escritura**

   * **Rechazo de escrituras**: Intentar invocar ``write()`` sobre ``/dev/hwbusc`` (en modo ``O_WRONLY`` u ``O_RDWR``) y asentar como éxito la devolución de error ``-1`` con ``errno == EINVAL``.

* **4. Verificación de Parámetros de Módulo**

   * **Atributo** ``hwbus_bdf_param``: Leer la ruta ``/sys/module/hwbus_io/parameters/hwbus_bdf_param`` para comprobar que refleja la dirección PCI objetivo (``"0000:02:00.0"``).

* **5. Concurrencia y Mapeo de Memoria**

   * **Acceso concurrente**: Abrir múltiples descriptores simultáneos de ``/dev/hwbusc`` desde distintos hilos/procesos para asegurar que el callback ``.open`` mantenga de forma independiente la posición de lectura de cada descriptor.
   * **Mapeo ``mmap()`` (si aplica)**: Ejecutar ``mmap()`` sobre el descriptor de archivo para validar el mapeo de memoria y su posterior liberación con ``munmap()``.