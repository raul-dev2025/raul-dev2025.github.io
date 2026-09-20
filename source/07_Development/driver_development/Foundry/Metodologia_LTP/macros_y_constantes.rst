===========================================
Macros, Constantes y Helpers (LTP y Kernel)
===========================================

.. contents:: Contenidos
   :depth: 2
   :local:

Categorización General
======================

En el desarrollo de la suite de pruebas del proyecto **foundry**, distinguimos dos categorías principales de macros y definiciones auxiliares:

1. **Helpers Seguros de LTP (LTP Safe Macros)**: Encapsuladores provistos por la API de LTP (``tst_test.h``) que ejecutan la función/syscall correspondiente y realizan una comprobación automática de errores. Si la llamada falla, la macro invoca internamente ``tst_brk(TBROK, ...)`` abortando la ejecución con una descripción clara.
2. **Flags y Constantes de Sistema (POSIX / Kernel Linux)**: Definiciones mediante directivas ``#define`` provenientes de las cabeceras del sistema (``<fcntl.h>``, ``<unistd.h>``, ``<sys/mman.h>``) que configuran el comportamiento de las llamadas al sistema.

Macros de Seguridad de LTP (LTP Safe Macros)
============================================

1. ``SAFE_OPEN()``
------------------

Encapsula la llamada al sistema ``open()`` o ``openat()``.

.. code-block:: c

   #define SAFE_OPEN(path, flags, ...)

* **Uso**: Abre el archivo especificado por ``path``. Si la operación falla (devuelve ``-1``), reporta un fallo de infraestructura en LTP (``TBROK``) y detiene la prueba.
* **Firma equivalente**: ``int safe_open(const char *file, int lineno, const char *path, int flags, ...);``

2. ``SAFE_FTRUNCATE()``
-----------------------

Encapsula la llamada al sistema ``ftruncate()``.

.. code-block:: c

   #define SAFE_FTRUNCATE(fd, length)

* **Uso**: Define o modifica el tamaño del archivo referenciado por el descriptor ``fd`` a la longitud especificada por ``length`` (en bytes). Si falla, interrumpe la prueba con error ``TBROK``.

Constantes de Sistema y POSIX
=============================

1. Flags de Apertura de Archivos (``<fcntl.h>``)
------------------------------------------------

.. list-table:: Flags de Apertura de Descriptor
   :widths: 20 20 60
   :header-rows: 1

   * - Constante
     - Origen
     - Descripción
   * - ``O_RDWR``
     - POSIX
     - Solicita acceso de lectura y escritura al archivo.
   * - ``O_CREAT``
     - POSIX
     - Si el archivo especificado no existe, el kernel lo creará. Requiere el parámetro de permisos (p. ej. ``0666``).
   * - ``O_DIRECT``
     - Linux (Específico)
     - Minimiza el uso de caché de página (Page Cache). La E/S se realiza directamente entre espacio de usuario y dispositivo.

Glosario Comparativo
====================

.. list-table:: Tabla Recapitulativa de Macros e Interfaces
   :widths: 25 25 50
   :header-rows: 1

   * - Elemento
     - Tipo / Origen
     - Función Principal
   * - ``SAFE_OPEN``
     - Macro (LTP)
     - Apertura segura de archivo con verificación implícita de error.
   * - ``SAFE_FTRUNCATE``
     - Macro (LTP)
     - Ajuste seguro de tamaño de archivo mediante FD.
   * - ``O_RDWR``
     - Constante (POSIX)
     - Flag de estado: Lectura/Escritura.
   * - ``O_CREAT``
     - Constante (POSIX)
     - Flag de creación si el recurso no existe.
   * - ``getpagesize()``
     - Función C (POSIX)
     - Consulta del tamaño de página de memoria en bytes (arquitectura/kernel).