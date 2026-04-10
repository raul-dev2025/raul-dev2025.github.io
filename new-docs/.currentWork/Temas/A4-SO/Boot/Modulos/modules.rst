Modulos
-------

modinfo -moudulo modprobe add remove module

Is nonw to be needed on xenconsoled and xenstored start-up.
``modprobe xen-evtchn``.

Como cargar módulos
^^^^^^^^^^^^^^^^^^^

En los apuntes de *Qemu*, hay algo sobre el tema, habría que buscarlo!

Módulos en el kernel
--------------------

cargar y descargar módulos en condición de carrera.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Conocemos que un determinado *módulo* es necesario durante el arranque
del sistema, por ejemplo para asegurar que cierto servicio inicie, en un
estado temprano.

Podemos cargarlo manualmente utilizando un par de instrucciones:

::

       # modinfo modulo -- esto nos da información sobre el "mod".
       # modprobe -- man-page, _carga y decarga_ el módulo.
       

… Pero haciendo esto, la operación no se tomará en cuenta en posteriores
reinicios. Así, que guardaremos la información en un archivo, para que
ell gestor de arranque lea está *opción añadida*.

::

       # echo 'modeprobe myModulo' >> /etc/rc.modules
       # chmod +x /etc/rc.modules
       

..

      **rc.** :race condition, condición de carrera.
