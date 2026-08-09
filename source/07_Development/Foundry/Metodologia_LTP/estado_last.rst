## Estado Global del Proyecto (`foundry`)

* **Objetivo principal**: Desarrollo y validación de una suite de pruebas modulares sobre llamadas al sistema e infraestructura del kernel de Linux utilizando la librería LTP (`tst_test.h`).
* **Entorno de compilación y ejecución**:
* **OS / Kernel**: Rocky Linux 10 / RHEL 10.1 (`6.12.0-124.8.1.el10_1.x86_64`).
* **Host de build remoto**: `builder@buildlab` (`/mnt/build-output/Repos/foundry`).
* **Usuario de ejecución**: `builder` (pruebas sin privilegios de `root`).


* **Estado de Fases**:
* **Fase 1 (I/O & Memory)**: Concluida y validada (`mmap01`, `direct_io01`).
* **Fase 2 (Bus PCI & Interrupciones)**: Concluida y validada (`pci_config_test`, `pci_bar_test`, `pci_msi_test`).
* **Fase 3 (Gestión de Procesos y Recursos)**: Concluida y validada (`sysconf01`, `fork01`).

---

## Hitos Completados por Subsistema

.. csv-table:: Resumen de Binarios Ejecutados y Validados en laboratorio
:header: "Módulo", "Binario", "Syscalls / Interfaces", "Resultado"
:widths: 15, 15, 45, 15

"IO_tests", "mmap01", "mmap(), munmap(), msync()", "TPASS"
"IO_tests", "direct_io01", "open(O_DIRECT), write(), read()", "TPASS"
"BUS_tests", "pci_config_test", "sysfs /proc/bus/pci", "TPASS"
"BUS_tests", "pci_bar_test", "sysfs MMIO resource spaces", "TPASS"
"BUS_tests", "pci_msi_test", "/proc/interrupts, MSI/MSI-X", "TPASS"
"PROC_tests", "sysconf01", "sysconf()", "TPASS"
"PROC_tests", "fork01", "fork(), waitpid(), COW", "TPASS"

---

## Comparativa de Estructuras de Archivos (Código vs Documentación)

Para facilitar la visualización conjunta, a continuación se muestran en paralelo la estructura actual del código fuente (`src/`) y la estructura del árbol de documentación en Sphinx (`docs/`):

```text
Estructura Código Fuente (src/)              Estructura Documentación (docs/)
===============================              ================================
src/                                         docs/
├── BUS_tests                                ├── index.rst
│   ├── Makefile                             ├── BUS_teorica.rst
│   ├── pci_bar_test.c                       ├── BUS_tests.rst
│   ├── pci_config_test.c                    ├── IO_teorica.rst
│   └── pci_msi_test.c                       ├── IO_tests.rst
├── hello                                    ├── PROC_teorica.rst
│   ├── hello.c                              └── PROC_tests.rst
│   └── Makefile
├── IO_tests
│   ├── direct_io_test.c
│   ├── Makefile
│   └── mmap01.c
├── Makefile
├── pci_dw
│   ├── bus_map_log.rst
│   ├── device_watcher.c
│   ├── device_watcher.h
│   ├── Makefile
│   └── radeon_drv.c
└── PROC_tests
    ├── fork_test.c
    ├── Makefile
    └── sysconf_test.c

6 directories, 18 files                      1 directory, 7 files

```

---

## Próximos Pasos

.. csv-table:: Plan de Trabajo Consolidado
:header: "Etapa", "Objetivo Principal", "Enfoque"
:widths: 20, 50, 30

"Estudio de Subsistemas", "Análisis profundo de la arquitectura de E/S, PCI y Procesos", "Todos los tests que hagamos estarán relacionados con el objeto de estudio"
"Revisión de Casos de Estudio", "Evaluación de trazas y comportamiento del kernel en Rocky 10", "Análisis teórico-práctico"

---

> **Nota interna de formato**: En caso de requerir la reintroducción de este reporte en un nuevo hilo, mantén el renderizado en Markdown legible estándar para garantizar la continuidad fluida de la conversación.