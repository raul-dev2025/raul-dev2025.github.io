.. SPDX-License-Identifier: GPL-2.0-or-later

=======================================================
Herramientas de Trazado e Inspección de Procesos
=======================================================

En los sistemas operativos tipo UNIX/Linux, el análisis en tiempo de ejecución de las ejecuciones binarias se apoya en mecanismos de trazado que permiten interceptar la interacción de un proceso con el espacio de usuario, las bibliotecas compartidas y el propio núcleo del sistema.

Relación y Vocabulario Técnico
==============================

* **ptrace** (*Process Trace*): Es la **llamada al sistema** (*syscall*) fundamental de bajo nivel que proporciona a un proceso (*debugger* o trazador) la capacidad de observar, controlar, pausar, inspeccionar la memoria y modificar los registros de otro proceso trazado (*tracee*). Constituye el bloque de construcción sobre el que se ejecutan los depuradores como **GDB** y las utilidades de análisis en tiempo de ejecución.
* **strace** (*System Call Trace*): Es una herramienta de diagnóstico en espacio de usuario que utiliza la llamada al sistema ``ptrace`` para interceptar y registrar las **llamadas al sistema** (*syscalls*) que realiza un proceso, así como las señales (*signals*) que este recibe.
* **ltrace** (*Library Call Trace*): Es una utilidad de depuración que intercepta y registra las **llamadas a bibliotecas dinámicas** (*shared libraries*, como ``libc``) realizadas por un programa compilado dinámicamente, además de poder registrar las llamadas al sistema subyacentes.

.. code-block:: text

   +-------------------------------------------------------------+
   |                     Espacio de Usuario                      |
   |                                                             |
   |  [ Proceso Trazado ] --(Llamada a Biblioteca)--> [ ltrace ]  |
   |           |                                                 |
   +-----------|-------------------------------------------------+
               | (Llamada al Sistema / Syscall)
   +-----------|-------------------------------------------------+
   |           v             Espacio del Kernel                  |
   |      [ strace ] <=====[ syscall ptrace() ]=====> [ GDB ]    |
   +-------------------------------------------------------------+

Comparativa de Herramientas
===========================

.. list-table:: Diferencias entre ptrace, strace y ltrace
   :widths: 20 25 25 30
   :header-rows: 1

   * - Herramienta
     - Tipo de Componente
     - Nivel de Intercepción
     - Caso de Uso Principal
   * - ``ptrace``
     - Llamada al sistema (Kernel)
     - Control total de registros/memoria
     - Desarrollo de depuradores (GDB, LLDB).
   * - ``strace``
     - Utilidad CLI (Espacio de Usuario)
     - Interfaz Kernel / Syscalls
     - Diagnóstico de E/S, archivos y permisos.
   * - ``ltrace``
     - Utilidad CLI (Espacio de Usuario)
     - Funciones de bibliotecas (Symphony/libc)
     - Análisis de flujo de ejecuciones y APIs.

* Ver :doc:`Guía práctica de aplicación </04_System_Administration/workFlow-strace>`