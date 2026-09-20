====================================
Capacidades Actuales del Controlador
====================================

El módulo del kernel ``hwbus_io.ko`` actúa como un controlador de dispositivo de caracteres enfocado en la inspección y exposición de parámetros PCI en espacio de usuario. En su estado de desarrollo actual, el controlador implementa los siguientes mecanismos funcionales:

* **Gestión de Parámetros de Módulo:** El driver define e inicializa el parámetro ``hwbus_bdf_param``, configurado por defecto con la dirección BDF ``"0000:02:00.0"``. Este parámetro se expone dinámicamente en el árbol de ``sysfs`` bajo la ruta ``/sys/module/hwbus_io/parameters/hwbus_bdf_param``.

* **Registro de Dispositivo de Caracteres y Clase:** Durante la fase de inicialización (``init``), el controlador reserva un número *Major* dinámico (registrado con el identificador 240 en ``/proc/devices``) y crea la clase de dispositivo ``hwbusc``. Esto automatiza la creación del nodo de carácter ``/dev/hwbusc`` a través de ``udev``, así como su jerarquía asociada en ``/sys/class/hwbusc/hwbusc/``.

* **Operación de Lectura** (``.read``): Al invocar operaciones de lectura sobre ``/dev/hwbusc``, la implementación interna consulta los registros del espacio de configuración PCI correspondientes al BDF asignado. La función mapea los identificadores de hardware y entrega exactamente **4 bytes** estructurados como ``[VendorID (2 bytes) | DeviceID (2 bytes)]`` respetando la ordenación *little-endian*. La operación gestiona adecuadamente el puntero de archivo (``f_pos``), retornando los bytes leídos en la primera llamada y ``0`` (``EOF``) en accesos subsecuentes dentro de la misma sesión.

* **Protección de Escritura** (``.write``): El controlador opera estrictamente en modo de solo lectura para las operaciones del dispositivo de caracteres. Las peticiones de escritura dirigidas a ``/dev/hwbusc`` son interceptadas y rechazadas intencionadamente en espacio de kernel, devolviendo la constante de error ``-EINVAL`` (*Invalid argument*).

Aislamiento Arquitectónico
==========================

El diseño del controlador cumple estrictamente con el principio de separación de espacio de kernel y espacio de usuario definido en el manifiesto:

* **Espacio de Kernel** (``src/driver/``): La lógica de callbacks, gestión de estructuras PCI y comunicación con ``sysfs`` se compila exclusivamente mediante Kbuild contra los encabezados del kernel. No existe ninguna dependencia con bibliotecas de espacio de usuario.

* **Espacio de Usuario** (``include/user/``, ``src/core/user/``): Las librerías auxiliares (``sysfs_utils``, ``hwbus_error``) para las herramientas de diagnóstico y pruebas POSIX se compilan contra ``glibc`` de forma totalmente aislada al módulo principal.