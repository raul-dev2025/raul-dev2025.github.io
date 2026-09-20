.. SPDX-License-Identifier: GPL-2.0-or-later

=======================================================
Flujo de Trabajo para la Captura de Llamadas con strace
=======================================================

La herramienta **``strace``** permite rastrear, interceptar y analizar las llamadas al sistema (*system calls*) ejecutadas por un proceso en entornos Linux, así como las señales que este recibe. A continuación se detalla el flujo de trabajo práctico para la captura y diagnóstico de procesos.

Instalación de la Utilidad
==========================

Asegúrese de contar con la herramienta instalada en el sistema host:

.. code-block:: bash

   # En distribuciones basadas en Debian / Ubuntu:
   sudo apt-get install strace

   # En distribuciones basadas en RHEL / Rocky Linux / Fedora:
   sudo dnf install strace

Uso Básico
==========

Para rastrear la totalidad de las llamadas al sistema generadas por un ejecutable, invoque la herramienta anteponiéndola al comando:

.. code-block:: bash

   strace <comando>

Ejemplo de ejecución:

.. code-block:: bash

   strace ls -l

Filtrado de Llamadas Específicas
================================

Para acotar la salida a llamadas al sistema concretas, utilice el parámetro ``-e trace=``:

.. code-block:: bash

   strace -e trace=openat,read <comando>

Ejemplo para inspeccionar únicamente operaciones de apertura y lectura de archivos:

.. code-block:: bash

   strace -e trace=openat,read cat /etc/passwd

Intercepción de Procesos en Ejecución
====================================

Para asociar ``strace`` a un proceso que ya se encuentra activo en el sistema, emplee la opción ``-p`` especificando su PID (*Process ID*):

.. code-block:: bash

   strace -p <PID>

Ejemplo de vinculación a un demonio en ejecución:

.. code-block:: bash

   strace -p 1234

Redirección de Resultados a Archivo
===================================

Dado que ``strace`` redirige su salida por defecto a la salida de error estándar (``stderr``), utilice la opción ``-o`` para guardar la traza en un archivo de texto:

.. code-block:: bash

   strace -o traza_proceso.log ls -l

Rastreo con Marcas de Tiempo
============================

Para evaluar latencias o momentos exactos de ejecución, añada marcas de tiempo absolutas mediante el parámetro ``-tt``:

.. code-block:: bash

   strace -tt ls -l

Seguimiento de Procesos Hijos (*Forks*)
=======================================

Para interceptar llamadas realizadas por hilos o procesos derivados creados por el proceso principal, utilice el indicador ``-f``:

.. code-block:: bash

   strace -f ./script_automatizacion.sh

Resumen Estadístico y Perfilado
==============================

Para obtener un reporte consolidado con el recuento, tiempo total consumido y tasa de errores por cada llamada al sistema, aplique la opción ``-c``:

.. code-block:: bash

   strace -c ls -l

Filtrado Avanzado e Inyección de Errores
========================================

Es posible filtrar llamadas que resulten exclusivamente en error o simular fallos en llamadas del kernel para pruebas de resiliencia:

.. code-block:: bash

   # Capturar llamadas openat que devuelvan error:
   strace -e trace=openat -e status=failed cat /archivo_inexistente

   # Inyectar un error simular (ENOENT) ante la llamada openat:
   strace -e inject=openat:error=ENOENT cat /etc/hosts

Ejemplo Integrado de Flujo Práctico
===================================

Ejecución típica para diagnóstico completo guardando marcas de tiempo y siguiendo subprocesos:

.. code-block:: bash

   strace -o traza_completa.log -tt -f ./binario_a_depurar