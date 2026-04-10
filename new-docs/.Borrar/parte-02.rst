Ejemplo,

.. code-block:: makefile

   subdir-ccflags-y := -Werror

   CFLAGS_$@, AFLAGS_$@


``CFLAGS_$@`` y ``AFLAGS_$@``, únicamente son aplicables, a comandos en el makefile kbuild activo.

``$(CFLAGS_$@)`` especifica opciones por archivo, con ``$(CC)``. La parte ``$@``, tiene un valor literal, el cuál especifica el archivo para el que és.

Ejemplo,

.. code-block:: makefile

   # drivers/scsi/Makefile
   CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
   CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ \
                        -DGDTH_STATISTICS

Estas dos líneas especifican las opciones de compilación para ``aha152x.o`` y ``gdth.o``.

``$(AFLAGS_$@)`` es una característica similar, para los archivos fuente, en lenguaje ensamblador.

Ejemplo,

.. code-block:: makefile

   # arch/arm/kernel/Makefile
   AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)
   AFLAGS_crunch-bits.o := -Wa,-mcpu=ep9312
   AFLAGS_iwmmxt.o      := -Wa,-mcpu=iwmmxt

.. _i3i1i9:

Seguimiento de las dependencias
===============================

Kbuild *sigue las dependencias*, así:

- 1. Todos los archivos requeridos(tanto ``*.c`` como ``*.h``).
- 2. Todas las opciones ``CONFIG_``, en archivos requeridos.
- 3. La líne de comandos utilizada, para compilar el objetivo.

Por tanto, de cambiar la opción ``$(CC)``, todos los archivos afectados serán recompilados.

.. _i3i1i10:

Reglas especiales
=================

Son utilizadas reglas especiales cuando la infraestructura kbuild, no proporcione el soporte requerido. Un ejemplo típico, son los archivos de *cabecera* generados durante el proceso de construcción.
Otro ejemplo, son los Makefiles de arquitectura, que necesitan reglas especiales para preparar la imagen final.

Las reglas especiales son escritas como reglas normales de ``make``.
Kbuild no se ejecuta en el directorio donde el Makefile está presente, por lo que todas las *reglas especiales*, deberían proporcionar una ruta relativa a archivos *pre-requeridos* y *archivos objetivo*.

Son utilizadas dos variables en el momento de definir una regla especial:

``$(src)``
    ``$(src)`` es una ruta relativa, la cuál apunta al directorio donde está localizado el Makefile. Utilizar siempre ``$(src)``, al referir alrchivos localizados en el *árbol* ``src`` -fuente.

``$(obj)``
    ``$(obj)`` es una ruta relativa, la cuál apunta al directorio donde está guardado el objetivo. Utilizar siempre ``$(obj)``, al referir alrchivos generados.

Ejemplo,

.. code-block:: makefile

   #drivers/scsi/Makefile
   $(obj)/53c8xx_d.h: $(src)/53c7,8xx.scr $(src)/script_asm.pl
       $(CPP) -DCHIP=810 - < $< | ... $(src)/script_asm.pl

Es esta una regla especial; siguiendo la sintaxis habitual requerida por make.
El *objetivo*, depende de dos *pre-requisitos* de archivo. Referencias al *archivo objetivo*, añaden el prefijo ``$(obj)``, referencias a *pre-requisitos*, añaden ``$(src)`` -puesto que no son archivos generados.

``$(kecho)``
    Presentar información al usuario mediante una *regla*, resulta una buena práctica, pero al ejecutar ``make -s``, no cabe esperar ver ninguna salida, exceptuando *avisos/errores* -warning/errors.
    Para dar soporte a lo anterior, kbuild define ``$(kecho)``, presentando el texto seguido de ``$(kecho)`` sobre la salida estandar(fd1), salvo si es utilizado ``make -s``.

Ejemplo,

.. code-block:: makefile

   # arch/arm/Makefile
   $(BOOT_TARGETS): vmlinux TARGET
       $(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(obj)/$@
       @$(kecho) '  Kernel: $(obj)/$@ is ready'