=========
Cabeceras
=========

1. Cabeceras del Controlador (Raíz de ``include/``) — *Exclusivas de Espacio de Kernel*
=======================================================================================

Estas cabeceras forman parte del driver (``.ko``), compilan exclusivamente con el entorno Kbuild del Kernel de Linux y consumen las cabeceras nativas del sistema (``<linux/...>``).

A. ``include/hwbus-io.h``
-------------------------

* **Ámbito:** Kernel.
* **Propósito:** Cabecera principal del módulo del controlador.
* **Contenido:**

   * Definición del nombre del módulo, versión y macros globales del driver.
   * Estructuras de estado interno del módulo (por ejemplo, el contexto principal del driver ``struct hwbus_dev``).
   * Declaración de las funciones del ciclo de vida del controlador (``init``/``exit``) y punteros de inicialización.

B. ``include/sysfs_driver.h``
-----------------------------

* **Ámbito:** Kernel.
* **Propósito:** Interfaz de comunicación con la infraestructura ``sysfs`` del Kernel.
* **Contenido:**

   * Prototypes de las funciones de creación/destrucción de grupos de atributos (``sysfs_create_group``, ``sysfs_remove_group``).
   * Declaración externa de las estructuras ``struct kobject``, ``struct attribute_group`` y callbacks ``show``/ ``store`` que el driver utilizará para publicar métricas hacia ``/sys``.

C. ``include/sysfs_pci.h``
--------------------------

* **Ámbito:** Kernel.
* **Propósito:** Abstracciones para la inspección y manejo del bus PCI/PCIe.
* **Contenido:**

   * Inclusión explícita de ``<linux/pci.h>`` (siguiendo la regla **DRY**, sin redefinir offsets ni registros estándar PCI).
   * Estructuras propias del driver para mapeo de regiones BAR (Base Address Registers).
   * Prototypes de funciones auxiliares del driver para leer/escribir registros del PCI Configuration Space utilizando las APIs nativas del Kernel (``pci_read_config_word``, ``pci_read_config_dword``).


2. Cabeceras de Espacio de Usuario (``include/user/``) — *Exclusivas de Userland / Tests (LTP)*
===============================================================================================

Estas cabeceras son consumidas por las aplicaciones CLI, utilidades de diagnóstico y el harness de pruebas LTP. Compilan con la cadena de herramientas C estándar de ``glibc`` y bibliotecas POSIX.

A. ``include/user/hwbus_error.h``
---------------------------------

* **Ámbito:** Usuario.
* **Propósito:** Gestión y traducción de errores en espacio de usuario.
* **Contenido:**

   * Definición de códigos de error propios de la herramienta de prueba (``HWBUS_SUCCESS``, ``HWBUS_ERR_BASE 5000``, etc.).
   * Prototipo de la función de traducción ``const char *hwbus_strerror(int errnum);``.
   * Inclusión de cabeceras POSIX estándar (``<errno.h>``, ``<stddef.h>``).

B. ``include/user/sysfs_paths.h``
---------------------------------

* **Ámbito:** Usuario.
* **Propósito:** Catálogo estático de rutas relativas y nombres de atributos dentro del sistema de archivos ``/sys``.
* **Contenido:**

   * Definición de cadenas de texto puras para que las herramientas de usuario sepan dónde buscar en el sistema de archivos (ej. ``/sys/bus/pci/devices``, ``/sys/class/nvme``, ``/sys/class/net``).

C. ``include/user/sysfs_utils.h``
---------------------------------

* **Ámbito:** Usuario.
* **Propósito:** Prototipos de funciones de asistencia para interactuar con ``/sys`` mediante llamadas de sistema POSIX.
* **Contenido:**

   * Declaración de utilidades de lectura/escritura de ficheros tipo sysfs (``sysfs_read_uint``, ``sysfs_read_string``, ``sysfs_read_binary``, ``sysfs_build_path``).
   * Inclusión de cabeceras POSIX (``<sys/types.h>``, ``<stddef.h>``).


Resumen de la Separación de Roles
=================================

.. list-table::
   :widths: 30 30 40
   :header-rows: 1

   * - Fichero de Cabecera
     - Ámbito de Ejecución
     - Entorno / Headers Base
   * - ``include/hwbus-io.h``
     - **Kernel (Driver)**
     - Kernel C (``<linux/module.h>``, ``<linux/init.h>``)
   * - ``include/sysfs_driver.h``
     - **Kernel (Driver)**
     - Kernel C (``<linux/sysfs.h>``, ``<linux/kobject.h>``)
   * - ``include/sysfs_pci.h``
     - **Kernel (Driver)**
     - Kernel C (``<linux/pci.h>``)
   * - ``include/user/hwbus_error.h``
     - **Usuario (Tests/LTP)**
     - User C (``<errno.h>``, ``<stddef.h>``)
   * - ``include/user/sysfs_paths.h``
     - **Usuario (Tests/LTP)**
     - User C (Literales ``#define``)
   * - ``include/user/sysfs_utils.h``
     - **Usuario (Tests/LTP)**
     - User C (``<sys/types.h>``, ``<stddef.h>``)