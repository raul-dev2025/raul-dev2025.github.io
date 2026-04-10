.. _i6i7:

Comandos útiles, en la construcción de una imagen de arranque
=============================================================

*Kbuild* proporciona algunas *macros*, útiles durante la construcción de una imagen de arranque.

if_changed
----------

``if_changed`` usado con los siguientes comandos.

Modo de empleo:

.. code-block:: makefile

    target: source(s) FORCE
        $(call if_changed,ld/objcopy/gzip/...)

Cuando es evaluada la regla, comprueba si hay algún archivo que necesite ser actualizado, o si cambió la línea de comandos desde la última invocación. Lo último forzará la reconstrucción si alguna de las opciones del ejecutable cambiaron.
Cualquier objetivo que utilice ``if_changed`` deberá ser listado en ``$(targets)``, en otro sentido, la comprobación en la línea de comandos fallará y, el objetivo será construido.
Asignaciones a ``$(targets)`` son escritas sin el prefijo ``$(obj)/``.
``if_changed`` podría ser utilizado en conjunción con otros comandos pesonalizados, tal y como está definido en `Comando kbuild personalizados`.

.. note::
   es un error habitual, olvidar el requisito FORCE ``--f``?
   Otro error común, es que los espacios en blanco `` ``, son significativos; por ejemplo, lo siguiente fallará(nótese el espacio en blanco después de la coma):

   .. code-block:: makefile

      target: source(s) FORCE
      #WRONG!#    $(call if_changed, ld/objcopy/gzip/...)

ld
--

Link

.. _i99:

Referencias y agradecimientos
=============================

**[f1]Makefile**, archivo constructor.
Objeto, 
Objetivo,
to break, romper; "la secuencia normal en un programa, rompe su ejecución debido a un error en el código".
macros


<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>