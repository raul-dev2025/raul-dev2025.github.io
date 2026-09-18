================
El depurador AML
================

.. contents:: Contenido
   :depth: 2


Copyright (C), Intel Corporation **Autor**: Lv Zheng lv.zheng@intel.com

Este documento describe el uso del depurador AML, embebido en el kernel de Linux.

Construir el depurador
======================

Los siguiente componentes en la configuración del kernel, son necesarios para *activar* la interfase del depurador, en el kernel de Linux:

.. code-block:: bash

   CONFIG_ACPI_DEBUGGER=y
   CONFIG_ACPI_DEBUGGER_USER=m

Las utilidades en el espacio de usuario, podrán ser construidas desde la fuente del kernel, mediante los comandos a continuación:

.. code-block:: bash

   $ cd tools
   $ make acpi

Los resultantes binarios, de las herramientas en el espacio de usuario, están localizadas en:

.. code-block:: bash

   tools/acpi/power/acpi/acpidbg/acpidbg

Podrá ser instalado en los directorios del sistema, ejecutando ``lmake install`` -como usuario con los suficientes permisos.

Iniciar la interfase del depurador, en el espacio de usuario
============================================================

Después de arrancar el kernel, con el *depurador* ya construido, tan sólo queda iniciarlo. Desde la cónsola, escribir los siguientes comandos:

.. code-block:: bash

   # mount -t debugfs none /sys/kernel/debug
   # modprobe acpi_dbg
   # tools/acpi/power/acpi/acpidbg/acpidbg

Aparecerá el entorno del depurador interactivo, donde podrán ejecutarse los comandos del depurador.

Los comandos están documentados en “Resumen ACPICA y Referencias de Programador”, pudiendo ser descargado desde

* `ACPICA Overview and Programmer Reference, en inglés. <https://acpica.org/documentation>`_

Las referencias detalladas a lso comandos, se encuentran en el **capítulo 12**, “ACPICA Debugger Reference”. El comando ``help`` es utilizado para una rápida referencia a ellos.

Parar la interfase del depurador, del espacio de usuario
========================================================

La interfase interactiva del depurador, podrá cerrarse presionando ``Ctrl+C`` o escribiendo los comandos ``quit`` o ``exit``. Al finalizar, deberán *descargarse* los módulos con:

.. code-block:: bash

   # rmmod acpi_dbg

La descarga del módulo, podría fallar si hubiese alguna otra instancia de ``acpidbg`` en activo.

Ejecución del depurador en un escrito(script)
=============================================

Podría resultar útil, iniciar el depurador AML en un escrito, ``acpidbg`` soporta éste modo especial ``batch``. Por ejemplo, el siguiente comando entrega como salida el *espacio de nombres ACPI* al completo:

.. code-block:: bash

   # acpidbg -b "namespace"

.. admonition:: batch
   
   Aplicación de *cónsola*, habitualmente utilizada en entornos Linux.