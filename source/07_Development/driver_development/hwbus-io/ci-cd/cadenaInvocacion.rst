====================
Cadena de invocación
====================

En Linux, los permisos de ejecución (incluyendo el privilegio de root cuando un programa se lanza con sudo) no se evalúan por binario individual en una cadena de subprocesos, sino por proceso y sus descendientes.

.. code-block:: bash

   [ci-runLauncher.sh] (Host / Workstation)
      │
      ▼  SSH / Remote Execution
   [ci-kmod-runner.sh] (Sandbox - Usuario 'builder' / no root)
      │
      ├── 1. Evalúa $TEST_BINARY_NAME ("hwbus_io_suite00r")
      ├── 2. Detecta la 'r' final (``*r``) 
      │
      ▼  Invoca mediante: sudo ./hwbus_io_suite00r
   ┌──────────────────────────────────────────────────────────┐
   │  Proceso PID X: [hwbus_io_suite00r]                      │
   │  EUID: 0 (root) | EGID: 0 (root)                         │
   │                                                          │
   │  1. Inicia suite, setup(), tst_module_load()             │
   │  2. Llama a SAFE_FORK() -> Crea subproceso hijo          │
   │  3. Llama a execv("./hwbus_io01", argv)                  │
   │     │                                                    │
   │     ▼                                                    │
   │  ┌────────────────────────────────────────────────────┐  │
   │  │ Proceso Hijo (PID X+1): [hwbus_io01]               │  │
   │  │ EUID: 0 (root) | EGID: 0 (root) <--- [HEREDADO]    │  │
   │  │                                                    │  │
   │  │ Executa llamados ioctl(), mmap(), etc. como ROOT   │  │
   │  │ Finaliza con exit(0)                               │  │
   │  └────────────────────────────────────────────────────┘  │
   │                                                          │
   │  4. Parent recibe status vía waitpid(PID X+1, ...)       │
   │  5. Siguiente iteración -> repite SAFE_FORK + execv ...  │
   └──────────────────────────────────────────────────────────┘