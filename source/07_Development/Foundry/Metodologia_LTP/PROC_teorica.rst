============================================================
Gestión de Procesos y Recursos (Sched & Proc) - Teoría
============================================================

.. contents:: Contenidos
   :depth: 2
   :local:

Ciclo de Vida del Proceso y Espacio de Direcciones
===================================================

La creación de procesos en Linux se basa en la duplicación y reemplazo de espacios de direcciones virtuales mediante llamadas al sistema del VFS y la gestión de tareas del kernel.

1. Duplicación y Ejecución (``fork``, ``vfork``, ``execve``)
-----------------------------------------------------------

* ``fork()`` **y Copy-On-Write (COW)**:
  La llamada ``fork()`` crea un proceso hijo duplicando la estructura ``task_struct`` y la tabla de páginas del proceso padre. Las páginas de memoria física no se copian inmediatamente; se marcan como de solo lectura para ambos procesos. La copia real ocurre solo cuando alguno de los dos intenta escribir en la página (COW).

* **Reemplazo de Imagen con** ``execve()``:
  Sustituye el espacio de direcciones virtuales, el segmento de texto (código), los datos y la pila del proceso actual por los de un nuevo programa ejecutable en formato ELF, manteniendo únicamente atributos específicos como ciertos descriptores de archivo abiertos.

* **Recolección de Estado** (``waitpid``):
  Permite al proceso padre bloquear su ejecución hasta que un hijo cambie de estado (finalización, detención por señal). Evita la proliferación de procesos en estado *Zombie* (procesos finalizados cuya entrada en la tabla de procesos no ha sido leída).

2. Inspección de Recursos y Entorno (``sysconf``)
-------------------------------------------------

La interfaz ``sysconf()`` permite a las aplicaciones consultar límites del sistema y parámetros de configuración en tiempo de ejecución sin hardcodear constantes.

* **Parámetros Clave**:
  - ``_SC_CLK_TCK``: Frecuencia de los tics del reloj del sistema.
  - ``_SC_NPROCESSORS_ONLN``: Número de procesadores activos/en línea.
  - ``_SC_PAGESIZE`` / ``_SC_PAGE_SIZE``: Tamaño de página en bytes.

.. seealso::

   Para revisar los casos de prueba prácticos aplicados a estas llamadas al sistema,
   consulte la sección de pruebas asociadas en :doc:`PROC_tests`.


Planificación y Programación de Tareas (Scheduler)
==================================================

El planificador del kernel (EEVDF / CFS) gestiona la asignación del tiempo de CPU entre los hilos de ejecución (*tasks*).

1. Estructura de Control ``task_struct``
----------------------------------------

Cada proceso e hilo en el sistema está representado internamente por una instancia de ``struct task_struct``. Contiene:

* Identificadores de proceso (PID, TGID, PPID).
* Estado del proceso (``TASK_RUNNING``, ``TASK_INTERRUPTIBLE``, ``TASK_UNINTERRUPTIBLE``).
* Punteros al espacio de memoria (``struct mm_struct *mm``).
* Credenciales de seguridad (UID, GID, capacidades POSIX).

2. Consultas e Interfaces de Kernel
-----------------------------------

El sistema de archivos pseudo-virtual ``/proc`` expone las métricas de estado de cada proceso mediante las entradas ``/proc/<PID>/status`` y ``/proc/<PID>/stat``, permitiendo validar dinámicamente el comportamiento del planificador y la asignación de recursos.

.. seealso::

   Para revisar los resultados y trazado de pruebas reales de gestión de procesos,
   consulte :doc:`PROC_tests`.