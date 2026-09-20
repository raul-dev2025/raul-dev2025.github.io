.. SPDX-License-Identifier: GPL-2.0-or-later

=====================
Programación en Linux
=====================

Documentación técnica y notas sobre herramientas de compilación, depuración en espacio de usuario y utilidades para el análisis del kernel de Linux.

Herramientas del Compilador y Enlazador
=======================================

* **nm**: Inspecciona y lista la tabla de símbolos contenida en archivos objeto y bibliotecas ejecutable ELF.
* **ranlib**: Genera un índice con el contenido de un archivo de biblioteca estática (``.a``) y lo guarda dentro de la misma estructura.
* **ld**: Enlazador GNU (*linker*) encargado de combinar objetos compilados y bibliotecas para generar ejecutables o bibliotecas compartidas.
* **ldd**: Muestra las bibliotecas compartidas dinámicas requeridas por un ejecutable binario.

  .. code-block:: bash

     $ ldd /bin/ls

Opciones Clave del Compilador (GCC)
-----------------------------------

* ``-l<nombre>``: Especifica la biblioteca a enlazar sin el prefijo ``lib`` ni la extensión. Por ejemplo, ``-lm`` enlaza la biblioteca matemática estática o dinámica (``libm.a`` / ``libm.so``).
* ``-L<directorio>``: Especifica una ruta de directorio adicional para la búsqueda de bibliotecas fuera de los directorios estándar del sistema (p. ej., ``-L/home/usuario/lib``).

Depuración con GDB
==================

GDB (*GNU Debugger*) permite la inspección en tiempo de ejecución, el análisis de trazado de pila y el control de ejecución paso a paso de binarios compilados con símbolos de depuración (flag ``-g``).

Automatización de Compilación y Depuración
------------------------------------------

Para compilar un programa con símbolos de depuración e iniciar inmediatamente la sesión en GDB:

.. code-block:: bash

   #!/usr/bin/env bash

   read -p "Archivo fuente a compilar: " fuente
   read -p "Nombre del ejecutable: " aplicacion

   if [ -f "$fuente" ]; then
       gcc -g "$fuente" -o "$aplicacion" $(pkg-config --cflags --libs x11 xcb xcb-atom)
       if [ $? -eq 0 ]; then
           gdb "./$aplicacion"
       fi
   else
       echo "Error: El archivo fuente especificado no existe."
   fi

Utilidades para Depuración del Kernel
======================================

* **Kprobes**: Mecanismo del kernel que permite registrar puntos de prueba (*probes*) en casi cualquier instrucción del kernel para ejecutar rutinas de diagnóstico.
* **Kallsyms**: Mecanismo que mantiene la tabla de símbolos de direcciones de funciones y variables del kernel en tiempo de ejecución (accesible desde ``/proc/kallsyms``).
* **CONFIG_DEBUG_INFO**: Opción de configuración del kernel que incluye información de símbolos DWARF, necesaria para depurar el kernel con herramientas como GDB o Crash.
* **virtme**: Entorno de virtualización ligera basado en QEMU que permite arrancar e inspeccionar versiones del kernel en desarrollo de forma aislada y segura sin alterar el sistema anfitrión.