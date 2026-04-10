`Construir el depurador <#i1>`__ `Iniciar la interfase <#i2>`__ `Parar
la interfase del depurador <#i3>`__ `Ejecución del depurador en un
escrito <#i4>`__

El depurador AML
----------------

Copyright (C), Intel Corporation **Autor**: Lv Zheng lv.zheng@intel.com

Este documento describe el uso del depurador AML, embebido en el kernel
de Linux.

#### Construir el depurador ####

Los siguiente componentes en la configuración del kernel, son necesarios
para *activar* la interfase del depurador, en el kernel de Linux:

::

       CONFIG_ACPI_DEBUGGER=y
       CONFIG_ACPI_DEBUGGER_USER=m

Las utilidades en el espacio de usuario, podrán ser construidas desde la
fuente del kernel, mediante los comandos a continuación:

::

       $ cd tools
       $ make acpi

Los resultantes binarios, de las herramientas en el espacio de usuario,
están localizadas en:

::

       tools/acpi/power/acpi/acpidbg/acpidbg

Podrá ser instalado en los directorios del sistema, ejecutando
``lmake install`` -como usuario con los suficientes permisos.

#### Iniciar la interfase del depurador, en el espacio de usuario ####

Después de arrancar el kernel, con el *depurador* ya construido, tan
sólo queda iniciarlo. Desde la cónsola, escribir los siguientes
comandos:

::

       # mount -t debugfs none /sys/kernel/debug
       # modprobe acpi_dbg
       # tools/acpi/power/acpi/acpidbg/acpidbg

Aparecerá el entorno del depurador interactivo, donde podrán ejecutarse
los comandos del depurador.

Los comandos están documentados en “Resumen ACPICA y Referencias de
Programador”, pudiendo ser descargado desde

::

       [https://acpica.org/documentation](https://acpica.org/documentation)

..

   ACPICA Overview and Programmer Reference, en inglés.

Las referencias detalladas a lso comandos, se encuentran en el
**capítulo 12**, “ACPICA Debugger Reference”. El comando ``help`` es
utilizado para una rápida referencia a ellos.

#### Parar la interfase del depurador, del espacio de usuario. ####

La interfase interactiva del depurador, podrá cerrarse presionando
``Ctrl+C`` o escribiendo los comandos ``quit`` o ``exit``. Al finalizar,
deberán *descargarse* los módulos con:

::

       # rmmod acpi_dbg

La descarga del módulo, podría fallar si hubiese alguna otra instancia
de ``acpidbg`` en activo.

#### Ejecución del depurador en un escrito(script) ####

Podría resultar útil, iniciar el depurador AML en un escrito,
``acpidbg`` soporta éste modo especial ``batch``. Por ejemplo, el
siguiente comando entrega como salida el *espacio de nombres ACPI* al
completo:

::

       # acpidbg -b "namespace"

..

   **batch**: aplicación de *cónsola*, habitualmente utilizada en
   entornos Linux.

--------------

.. raw:: html

   <ul id="firma">

.. raw:: html

   <li>

Traducción: Heliogabalo S.J.

.. raw:: html

   </li>

.. raw:: html

   <li>

www.territoriolinux.net

.. raw:: html

   </li>

.. raw:: html

   </ul>
