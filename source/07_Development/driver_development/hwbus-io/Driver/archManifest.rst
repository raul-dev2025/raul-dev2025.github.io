===================================
Manifiesto de Arquitectura hwbus-io
===================================


Este documento define la estructura de directorios, la organización de las cabeceras y las responsabilidades del código dentro del proyecto **hwbus-io**.

Visión General de la Arquitectura
=================================

El proyecto está diseñado bajo el principio de que **el núcleo principal es un controlador de dispositivo del kernel de Linux (driver module)**. Por esta razón, el código reside de forma predeterminada en el espacio de kernel, mientras que el espacio de usuario se aísla explícitamente dentro de subdirectorios denominados ``user/``.

* **Espacio de Kernel (Driver Core):** Implementa la lógica del controlador, acceso a hardware y exposición de interfaces vía ``sysfs``.

* **Espacio de Usuario (Userland/LTP):** Proporciona utilidades y herramientas auxiliares para facilitar la ejecución de pruebas automatizadas (Linux Test Project) y diagnóstico.

Estructura del Árbol de Directorios
===================================

.. code-block:: text

   hwbus-io/
   ├── include/
   │   ├── hwbus-io.h            # Interfaz pública / IOCTL del driver
   │   ├── sysfs_driver.h        # Declaraciones nativas del driver para exponencia en sysfs
   │   ├── sysfs_pci.h           # Estructuras y macros PCI para el driver
   │   └── user/
   │       ├── hwbus_error.h     # Cabecera de errores exclusiva para espacio de usuario
   │       └── sysfs_utils.h     # Helpers POSIX para herramientas de usuario y tests
   │
   └── src/
       ├── core/                 # Lógica genérica y utilidades
       │   ├── source.c          # Abstracciones auxiliares genéricas
       │   └── user/             # Implementación C para espacio de usuario (LTP, CLI)
       │       ├── hwbus_error.c
       │       └── sysfs_utils.c
       │
       └── driver/               # CÓDIGO DEL CONTROLADOR (Infraestructura de estudio)
           └── sysfs_driver.c    # Implementación de callbacks y nodos sysfs
    
   
Definición de Directorios y Componentes
=======================================

1. Directorio ``include/``
--------------------------

* **Raíz de ``include/``:**
  Ámbito exclusivo del controlador. Contiene cabeceras que utilizan tipos del kernel de Linux (``<linux/...>``). No deben incluirse cabeceras de la biblioteca C estándar (``glibc``).
  
* **Subdirectorio ``include/user/``:**
  Alojamiento exclusivo para la infraestructura de espacio de usuario.
  
  * ``hwbus_error.h``: Definición de la interfaz de traducción de errores mediante ``hwbus_strerror()`` para espacio de usuario.

  * ``sysfs_utils.h``: Declaración de utilidades POSIX (``sysfs_read_*``, ``sysfs_build_path``) para inspección de ``/sys`` desde tests.

2. Directorio ``src/``
----------------------

* **``src/core/``:**
  Almacena la lógica genérica y funciones auxiliares transversales (``source.c``).

* **``src/core/user/``:**
  Contiene la implementación en C de las librerías auxiliares de espacio de usuario (``hwbus_error.c``, ``sysfs_utils.c``). Se compila usando la cadena de herramientas estándar POSIX/glibc.

* **``src/driver/``:**
  Contiene el código fuente del controlador del kernel relativo a la infraestructura de estudio (PCI, NVMe, Net).
  
  * Implementa los callbacks ``show``/``store`` y registra los atributos de ``sysfs`` en el módulo (``sysfs_driver.c``).

  * **Regla:** Queda prohibido hacer ``#include`` de archivos ubicados en ``include/user/``.

3. Soporte y Pruebas
---------------------

* **``Scripts/``:**
  Scripts de shell para la orquestación del flujo de CI/CD remoto, firma con certificados Secure Boot (``kmod-sign-file``) y gestión de logs.

* **``tests/``:**
  Entorno de pruebas y arnés Makefile para la compilación de módulos de test independientes (ej. ``hello.ko``).

Reglas de Estilo y Compilación
==============================

1. **Alineación de Punteros:**
   El código C en espacio de kernel y usuario sigue la guía de estilo oficial del Kernel de Linux (*Linux Kernel Coding Style*). Los punteros se alinean con la variable (``char *buf``) y no con el tipo.

2. **Aislamiento de Dependencias:**
   Las fuentes bajo ``src/driver/`` se compilan exclusivamente mediante **Kbuild** contra las cabeceras del kernel objetivo. Las fuentes bajo ``src/core/user/`` se compilan con la biblioteca estándar de C.