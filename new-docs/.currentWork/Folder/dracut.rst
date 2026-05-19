Dracut
======

Es una infraestructura ``initramfs``.
Cuando *dracut* es cargado, initramfs tiene un sólo propósito: cargar un
*sistema de ficheros raíz* y, poder hacer la transición, hacia un *FSroot*
real.rm

Es un conductor de eventos para la infraestructura ``initramfs``. ``dracut`` -la herrameieta,
es usada para crear una imagen ``initramfs`` por medio del copiado de herramientas y archivos
desde un systema ya instalado y, combinándolo con el *framework* ``dracut``, normalmente
encontrado en ``/usr/lib/dracut/modules.d``

- udev

- ``/dev/kmsg``

Redirección de la salida no interactiva
---------------------------------------

.. code-block:: shell

    exec >/dev/kmsg 2>&1 </dev/console

Definiciones
------------

Estos comandos se utilizan sobre la línea de comando del nucleo.

- rdshell: carga la cónsola.
- rdshell rdinitdebug: imprime los comandos *dracut*.

Referencias
-----------

`Dracut <https://en.wikipedia.org/wiki/Dracut_(software)>`_
`dracut <https://dracut.wiki.kernel.org>`_
`fedoraproject <https://fedoraproject.org/wiki/How_to_debug_Dracut_problems>`_