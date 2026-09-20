=====================================================
Gestión de Procesos y Recursos (Sched & Proc) - Tests
=====================================================

.. contents:: Pruebas Evaluadas
   :depth: 2
   :local:

Análisis del Caso de Prueba: ``sysconf01``
==========================================

* **Subsistema**: ``syscalls/sysconf`` / ``kernel/sched``
* **Objetivo**: Verificar la correcta consulta de parámetros de configuración del sistema y límites de recursos en tiempo de ejecución mediante ``sysconf()``.
* **Fundamento Teórico**: Consulte :doc:`PROC_teorica` para revisar la inspección de recursos, frecuencias de reloj (``_SC_CLK_TCK``), procesadores en línea (``_SC_NPROCESSORS_ONLN``) y tamaño de página del sistema.

Análisis de Ejecución
---------------------

1. **Configuración del Entorno** (``setup``):
   Comprobación de acceso a la llamada de sistema e inicialización de las variables de almacenamiento de métricas del kernel.

2. **Invocación de Syscall** (``run``):
   Invocación secuencial de ``sysconf()`` pasando los nombres de configuración POSIX predefinidos (``_SC_PAGESIZE``, ``_SC_NPROCESSORS_ONLN``, ``_SC_OPEN_MAX``, etc.).

3. **Verificación**:
   Validación de que los valores retornados sean mayores a cero y coherentes con las constantes del entorno reportadas por el sistema operativo.

Resultados en Entorno ``buildlab``
----------------------------------

.. admonition:: Test sysconf01   

   Sección reservada para documentar las salidas de ejecución y registros en ``buildlab``
   clasificando los resultados según la metodología LTP (``TPASS``, ``TFAIL``, ``TCONF``).

.. code-block:: text

   tst_test.c:1900: TINFO: LTP version: 20250130
   tst_test.c:1904: TINFO: Tested kernel: 6.12.0-124.8.1.el10_1.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Nov 11 22:54:28 UTC 2025 x86_64
   tst_kconfig.c:88: TINFO: Parsing kernel config '/lib/modules/6.12.0-124.8.1.el10_1.x86_64/build/.config'
   tst_test.c:1722: TINFO: Overall timeout per run is 0h 00m 30s
   sysconf_test.c:26: TINFO: Querying system parameters via sysconf()...
   sysconf_test.c:41: TINFO: Page size (bytes): 4096
   sysconf_test.c:41: TINFO: Processors online: 4
   sysconf_test.c:41: TINFO: Maximum open files per process: 1024
   sysconf_test.c:41: TINFO: Clock ticks per second (CLK_TCK): 100
   sysconf_test.c:41: TINFO: Total physical memory pages: 2989962
   sysconf_test.c:41: TINFO: Available physical memory pages: 2842003
   sysconf_test.c:50: TPASS: All sysconf() queries succeeded with valid values

   Summary:
   passed   1
   failed   0
   broken   0
   skipped  0
   warnings 0



Análisis del Caso de Prueba: ``fork01``
=======================================

* **Subsistema**: ``syscalls/fork`` / ``mm`` / ``kernel/sched``
* **Objetivo**: Verificar el ciclo de vida de creación de un proceso hijo mediante ``fork()``, confirmando la duplicación del espacio de direcciones virtuales, el comportamiento Copy-On-Write (COW) y la sincronización con ``waitpid()``.
* **Fundamento Teórico**: Consulte :doc:`PROC_teorica` para revisar la duplicación de la estructura ``task_struct``, la jerarquía de procesos (PID/PPID) y la eliminación de procesos *Zombie*.

Análisis de Ejecución
---------------------

1. **Configuración del Entorno** (``setup``):
   Preparación de variables de prueba en el espacio de memoria del proceso padre antes de la bifurcación.

2. **Invocación de Syscall** (``run``):
   Invocación de ``fork()``. El proceso hijo modifica una variable local para comprobar el aislamiento COW y finaliza con un código de salida controlado. El proceso padre espera la finalización usando ``waitpid()``.

3. **Verificación**:
   Confirmación de que la variable en el proceso padre permanece inalterada tras la modificación en el hijo (aislamiento de memoria) y comprobación del estado de salida recuperado por ``waitpid()``.

Resultados en Entorno ``buildlab``
----------------------------------

.. admonition:: Test fork01   

   Sección reservada para documentar las salidas de ejecución y registros en ``buildlab``
   clasificando los resultados según la metodología LTP (``TPASS``, ``TFAIL``, ``TCONF``).

.. code-block:: text

   tst_test.c:1900: TINFO: LTP version: 20250130
   tst_test.c:1904: TINFO: Tested kernel: 6.12.0-124.8.1.el10_1.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Nov 11 22:54:28 UTC 2025 x86_64
   tst_kconfig.c:88: TINFO: Parsing kernel config '/lib/modules/6.12.0-124.8.1.el10_1.x86_64/build/.config'
   tst_test.c:1722: TINFO: Overall timeout per run is 0h 00m 30s
   fork_test.c:28: TINFO: Iniciando prueba de fork() con aislamiento de memoria...
   fork_test.c:51: TINFO: Proceso padre esperando al hijo (PID: 3340)...
   fork_test.c:39: TINFO: Proceso hijo en ejecucion (PID: 3340, PPID: 3339)
   fork_test.c:44: TINFO: Proceso hijo modifico shared_var a 200
   fork_test.c:62: TINFO: Proceso hijo finalizo correctamente con codigo de salida 42
   fork_test.c:74: TPASS: Memoria aislada correctamente (COW): shared_var permanece en 100 en el proceso padre

   Summary:
   passed   1
   failed   0
   broken   0
   skipped  0
   warnings 0
