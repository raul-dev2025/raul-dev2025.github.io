============================================
Prototipos, Estructuras y System Calls (rST)
============================================

.. contents:: Contenidos
   :depth: 2
   :local:

Glosario e Índice de Referencia
===============================

En este documento se recopilan los prototipos de llamadas al sistema, estructuras de kernel y llamadas de control más relevantes utilizadas en la suite de pruebas del proyecto **foundry**.

Estructuras de Kernel
=====================

1. ``struct task_struct``
-------------------------

La estructura fundamental en el kernel de Linux para representar un proceso o hilo de ejecución (Descriptor de Proceso). Definida en ``<linux/sched.h>``.

.. code-block:: c

   struct task_struct {
       volatile long state;    /* Estado del proceso (running, sleeping, etc.) */
       void *stack;            /* Puntero a la pila de espacio de kernel */
       pid_t pid;              /* Identificador de proceso (PID) */
       pid_t tgid;             /* Identificador de grupo de hilos (TGID) */
       
       struct mm_struct *mm;   /* Descriptor del espacio de direcciones virtuales */
       struct files_struct *files; /* Tabla de descriptores de archivo abiertos (FDs) */
       
       /* ... campos adicionales de planificación, credenciales y señales ... */
   };

* **Relación con el proyecto**: Contiene el puntero a la tabla de descriptores de archivo (``files``), donde cada índice entero (FD) apunta a una instancia de ``struct file``.

Llamadas al Sistema y Control
=============================

1. ``ioctl()`` - Input/Output Control
-------------------------------------

Llamada al sistema para la manipulación de parámetros de dispositivos subyacentes y comunicación fuera de banda (*out-of-band*). Definida en ``<sys/ioctl.h>`` o ``<unistd.h>``.

.. code-block:: c

   int ioctl(int fd, unsigned long request, ... /* arg */);

* **Parámetros**:
  
  * ``fd``: Descriptor de archivo abierto de un archivo especial o dispositivo.
  * ``request``: Código numérico dependiente del dispositivo que especifica la operación.
  * ``arg``: Puntero no tipado a memoria o valor escalar según la operación solicitada.

* **Retorno**: ``0`` en caso de éxito. En caso de error, retorna ``-1`` y asigna ``errno``.

2. ``fcntl()`` - File Control
-----------------------------

Llamada al sistema utilizada para manipular propiedades y flags de un descriptor de archivo previamente abierto. Definida en ``<fcntl.h>``.

.. code-block:: c

   int fcntl(int fd, int cmd, ... /* arg */);

* **Comandos comunes (``cmd``)**:
  
  * ``F_GETFL`` / ``F_SETFL``: Consultar o establecer flags de estado del archivo (p. ej., ``O_NONBLOCK``, ``O_ASYNC``, ``O_DIRECT``).
  * ``F_DUPFD``: Duplicar un descriptor de archivo.
  * ``F_SETLK`` / ``F_GETLK``: Gestión de bloqueos de archivo (file locking).

Resumen de Interfaces
=====================

.. list-table:: Resumen de Elementos Definidos
   :widths: 20 25 55
   :header-rows: 1

   * - Elemento
     - Tipo
     - Cabecera Principal
   * - ``task_struct``
     - Estructura Kernel
     - ``<linux/sched.h>``
   * - ``ioctl()``
     - Syscall / C Library
     - ``<sys/ioctl.h>``
   * - ``fcntl()``
     - Syscall / C Library
     - ``<fcntl.h>``