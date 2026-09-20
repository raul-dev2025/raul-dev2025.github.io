.. SPDX-License-Identifier: GPL-2.0-or-later

===================
Depuración dinámica
===================

Introducción
============

Este documento describe cómo usar la característica de *depurador dinámico* (``dyndbg``). El depurador dinámico permite activar o desactivar dinámicamente mensajes de depuración en el *kernel* sin necesidad de recompilar. Actualmente, si la opción ``CONFIG_DYNAMIC_DEBUG`` está configurada, las llamadas a ``pr_debug()``, ``dev_dbg()``, ``print_hex_dump_debug()`` y ``print_hex_dump_bytes()`` se pueden controlar de forma individual (*per-callsite*).

Si ``CONFIG_DYNAMIC_DEBUG`` no está activado, ``print_hex_dump_debug()`` actúa simplemente como un atajo para ``print_hex_dump(KERN_DEBUG)``.

Características principales:

- Permite filtrar y alternar los mensajes de depuración mediante coincidencias de:

  - Nombre de archivo fuente.
  - Nombre de función.
  - Número de línea o rangos de líneas.
  - Nombre de módulo.
  - Formato de cadena.

- Proporciona un archivo de control en ``debugfs``:

  - ``<debugfs>/dynamic_debug/control``: se puede leer para examinar la lista completa de puntos de depuración registrados y sus estados actuales.

Controlando el comportamiento del depurador dinámico
===================================================

El comportamiento de ``pr_debug()`` y ``dev_dbg()`` se controla mediante la escritura en el archivo de control dentro del sistema de archivos ``debugfs``. Habitualmente, ``debugfs`` se encuentra montado en ``/sys/kernel/debug``. Si no estuviera montado, se puede montar manualmente con:

.. code-block:: bash

   # mount -t debugfs none /sys/kernel/debug

El archivo de control se ubica en ``<debugfs>/dynamic_debug/control``. Por ejemplo, para activar el registro de depuración en la línea 1603 del archivo fuente ``svcsock.c``:

.. code-block:: bash

   # echo 'file svcsock.c line 1603 +p' > /sys/kernel/debug/dynamic_debug/control

Si la sintaxis del comando es incorrecta, el sistema devolverá un error de argumento:

.. code-block:: bash

   # echo 'file svcsock.c wtf 1 +p' > /sys/kernel/debug/dynamic_debug/control
   -bash: echo: write error: Invalid argument

Ver el comportamiento del depurador dinámico
============================================

Se puede inspeccionar la configuración actual de los mensajes de depuración leyendo el archivo de control:

.. code-block:: bash

   # cat /sys/kernel/debug/dynamic_debug/control
   # filename:lineno [module]function flags format
   /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup =_ "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
   /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init =_ "\011max_inline : %d\012"
   /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init =_ "\011sq_depth : %d\012"
   /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init =_ "\011max_requests : %d\012"

Se pueden aplicar herramientas habituales de filtrado en Unix:

.. code-block:: bash

   # grep -i rdma /sys/kernel/debug/dynamic_debug/control | wc -l
   62
   # grep -i tcp /sys/kernel/debug/dynamic_debug/control | wc -l
   42

La tercera columna muestra las banderas (*flags*) activas en cada sentencia de depuración. El valor por defecto (sin banderas activas) es ``=_``. Para filtrar las sentencias que tienen alguna bandera habilitada:

.. code-block:: bash

   # awk '$3 != "=_"' /sys/kernel/debug/dynamic_debug/control
   # filename:lineno [module]function flags format
   /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]vc_send p "svc_process: st_sendto returned %d\012"

Referencias de comandos del lenguaje
====================================

A nivel léxico, los comandos comprenden una secuencia de palabras separadas por espacios o tabuladores. Se pueden enviar múltiples comandos separados por punto y coma (``;``) o salto de línea (``\n``):

.. code-block:: bash

   # echo "func pnpacpi_get_resources +p; func pnp_assign_mem +p" > /sys/kernel/debug/dynamic_debug/control

Para conjuntos de reglas más extensos, se puede volcar un archivo por lotes (*batch file*):

.. code-block:: bash

   # cat query-batch-file > /sys/kernel/debug/dynamic_debug/control

Estructura de la ruta en debugfs
================================

- ``<debugfs>/``: Directorio donde el núcleo o la distribución montan el sistema de archivos de depuración (generalmente ``/sys/kernel/debug``).
- ``dynamic_debug/control``: Ubicación del archivo de interfaz para interactuar con la depuración dinámica del kernel.

Referencias
===========

* Documentación oficial del kernel: ``Documentation/admin-guide/dynamic-debug-howto.rst``
* Guía de referencia: `How to enable and tune dynamic debugging <https://burzalodowa.wordpress.com/2013/09/18/how-to-enable-and-tune-dynamic-debugging-for-xhci/>`_