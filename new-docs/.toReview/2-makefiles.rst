===============================
Makefiles en el kernel de Linux
===============================

.. _i1:

.. contents:: Tabla de contenidos
   :local:
   :backlinks: none
   :depth: 2

.. _i2:

Introducción
============

El documento describe los archivos *Makefiles* en el kernel de Linux. Los archivos *Makefiles* contienen cinco partes:

* **Makefile**: El principio del archivo.
* **.config**: El archivo de configuración del kernel.
* **arch/$(ARCH)/Makefile**: La arquitectura del archivo *Makefile*.
* **scripts/Makefile.***: Reglas comunes, etc., para todos los archivos *Makefiles* en kbuild.
* **kbuild Makefiles**: Son cerca de 500.

Al principio del archivo *Makefile*, será leído el archivo ``.config``, el cual proviene del proceso de configuración del kernel.

El principio del archivo es responsable de la construcción de dos elementos importantes: ``vmlinux`` (la imagen residente del kernel) y los módulos (cualquier archivo de módulo). Todo esto es construido de manera recursiva, descendiendo a los subdirectorios en el árbol fuente del kernel. La lista de subdirectorios visitada dependerá de la configuración del kernel. El principio del archivo incluye textualmente una arquitectura *Makefile* con el nombre ``arch/$(ARCH)/Makefile``. La arquitectura *Makefile* proporciona información específica acerca de la misma indicada al principio del archivo.

Cada subdirectorio tendrá un *kbuild Makefile*, el cual sucede los comandos de forma secuencial, de arriba a abajo. El archivo *kbuild Makefile* utiliza la información del archivo ``.config`` para construir varias listas de archivos utilizadas por kbuild para construir cualquier objetivo modular integrado en la construcción.

``scripts/Makefile.*`` contiene todas las definiciones/reglas etc. usada en la construcción del kernel, basado en los archivos *kbuild Makefiles*.

.. _i3:

Quién hace qué
==============

Las personas tienen cuatro relaciones distintas con los *Makefiles* del kernel:

**Usuarios**
    Personas que construyen kernels. Aquellos que escribirían comandos tales como ``make menuconfig`` o ``make``. Es habitual que no lean o editen ningún *Makefile* del kernel o cualquier otro archivo fuente.

**Desarrollador regular**
    Trabajan en características tales como controladores de dispositivo, sistemas de archivo y protocolos de red. Estas personas necesitan mantener los archivos del subsistema en el que trabajan. Para llevar a cabo esta tarea, es necesario cierto conocimiento acerca de los archivos *kbuild Makefiles*, además de otros aspectos relacionados con la interfaz pública de kbuild.

**Desarrollador de arquitectura**
    Personas que trabajan en una plataforma en particular, como ``sparc`` o ``ia64``. Los desarrolladores de plataforma necesitan conocer tanto el *Makefile* como los archivos *kbuild Makefiles* relacionados.

**Desarrollador kbuild**
    Trabajan en el *sistema de construcción del kernel*, en sí mismo. Imprescindible conocer todos los aspectos relativos a los archivos Makefile del kernel.

El presente documento está dirigido al **Desarrollador regular** y al **Desarrollador de arquitectura**.

.. _i3i1:

Los archivos *kbuild*
=====================

La mayoría de *Makefiles* parte del kernel, son archivos tipo *Makefile*, que hará uso de la infraestructura *kbuild*. Este capítulo introduce la sintaxis utilizada en tales archivos -*kbuild Makefiles*.
El nombre preferido para estos archivos *kbuild*, es *Makefile*, aunque *kbuild* es igualmente usado. Si ambos archivos existen, será empleado *kbuild*.

La Sección `Definición de objetivos`_ es una rápida introducción, otros capítulos proporcionan más detalle, con ejemplos reales.

.. _i3i1i1:

Definición de objetivos
=======================

La definición de objetivos es la parte principar -el corazón, de los archivos *kbuild*.
Estas líneas, definen los archivos a ser construidos, cualquier opción de compilación y, cualquier subdirectorio al que *entrar recursivamente*.

El archivo makefile kbuild mas simple, contiene una línea:

Ejemplo,

.. code-block:: makefile

    obj-y += foo.o

Esto dice a kbuild que hay un objeto en el directorio, llamado ``foo.o`` a ser construido desde ``foo.c`` o ``foo.S``.

Si ``foo.o`` debiera ser construido como módulo, será empleada la variable ``obj-m``.
Consecuentemente, será utilizado el siguiente patrón:

Ejemplo,

.. code-block:: makefile

    obj-$(CONFIG_FOO) += foo.o

``$(CONFIG_FOO)`` evalúa tanto a ``y`` (integrado) como a ``m`` (módulo). Si ``CONFIG_FOO`` no es ni ``y`` ni ``m``, entonces el archivo no será compilado ni enlazado... _i3i1i2:

Archivos *objeto* integrados ``obj-y``
======================================

El Makefile kbuild, especifica archivos de objeto en la ``vmlinux`` con la lista ``$(obj-y)``. Esta lista, depende de la configuración del kernel.

Kbuild compila todos los archivos ``$(obj-y)``. Después llama a ``$(AR) rcSTP``, para mezclar todos los archivos en un archivo ``integrado.a``.
Es un pequeño *fichero*, sin tabla de símbolos, el cuál resulta impracticable, como entrada al enlazador.

El escrito -*script*, ``scripts/link-vmlinux.sh`` hará después un agregado con ``${AR} rcsTP``, el cuál crea un archivo *ligero*, con una tabla de símbolos y un índice, convirtíendolo en una entrada válida, para la imagen final ``vmlinux``.

El orden de los archivos en ``$(obj-y)`` es imortante. Están permitidos los duplicados: la primera instancia, será enlazada dentro del ``integrado.a``, sucesivas instancias ignoradas.

El orden de enlace es importante, por que ciertas funciones ``module_init() __initcall`` serán llamadas durante el arranque, en orden de aparición. Recordar, que cambiar el orden de los enlaces, podría cambiar el orden en el que los controladores SCSI fuesen detectados, *reenumerando* los discos.

Ejemplo,

.. code-block:: makefile

    # drivers/isdn/i4l/Makefile
    # Makefile for the kernel ISDN subsystem and device drivers.
    # Each configuration option enables a list of files.
    obj-$(CONFIG_ISDN_I4L)         += isdn.o
    obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o

.. _i3i1i3:

Propósito de los módulos *cargables* ``obj-m``
==============================================

``$(obj-m)`` especifica archivos objeto, los cuáles serán construidos como módulos *cargables* por el kernel.

Un módulo podría ser construido desde un archivo fuente, o varios. En el primer caso, el makefile kbuild simplemente añadirá el archivo a ``$(obj-m)``.

Ejemplo,

.. code-block:: makefile

    # drivers/isdn/i4l/Makefile
    obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o

.. note::
   En este ejemplo ``$(CONFIG_ISDN_PPP_BSDCOMP)`` evalua ``m``.

Si un módulo del kernel es construido desde distintas fuentes, la forma de especificar cómo construir el módulo es la misma; aunque kbuild necesitará saber qué *archivos objeto* participarán en la construcción del módulo, así que habrá que especificarlo mediante la variable ``$(<module_name>-y)``.

Ejemplo,

.. code-block:: makefile

    # drivers/isdn/i4l/Makefile
    obj-$(CONFIG_ISDN_I4L) += isdn.o
    isdn-y := isdn_net_lib.o isdn_v110.o isdn_common.o

En el ejemplo, el nombre del módulo será ``isdn.o``. Kbuild compilará los objetos listados en ``$(isdn-y)``, después ejecutará ``$(LD) -r`` sobre la lista de esos archivos, para generar ``isdn.o``.

Dado que kbuild reconoce ``$(<module_name>-y)`` en la composición de objetos, es posible utilizar el valor de un ``CONFIG_ symbol``, para opcionalmente incluir un archivo de objeto como parte de la composición de un objeto.

Ejemplo,

.. code-block:: makefile

    # fs/ext2/Makefile
    obj-$(CONFIG_EXT2_FS) += ext2.o
    ext2-y := balloc.o dir.o file.o ialloc.o inode.o ioctl.o \
              namei.o super.o symlink.o
    ext2-$(CONFIG_EXT2_FS_XATTR) += xattr.o xattr_user.o \
                                    xattr_trusted.o

En este ejemplo, ``xattr.o``, ``xattr_user.o`` y ``xattr_trusted.o`` sólo son parte en la composición del objeto ``ext2.o`` si ``$(CONFIG_EXT2_FS_XATTR)`` evalua ``y``.

.. note::
   Al construir objetos dentro del kernel, la sintaxis de arriba también funcionará. Por tanto, si la opción es ``CONFIG_EXT2_FS=y``, kbuild construirá un archivo ``ext2.o`` al margen de partes individuales, enlazando entonces con ``integrado.a``; tal y como cabría esperar.

.. _i3i1i4:

Objetos que exportan *símbolos*
===============================

Las notaciones requeridas en los makefiles, no son necesarias para los módulos que exportan símbolos.

.. _i3i1i5:

Propósito de los archivos *librerías* ``lib-y``
===============================================

Los objetos listados con ``obj-*`` son utilizados para los módulos, o combinados en un ``integrado.a`` que especifique el directorio. Aparece la posibilidad de listar objetos incluyéndolos en una librería ``lib.a``. Todos los objetos listados con ``lib-y`` serán combinados en una librería única, para ese directorio.

Los objetos listados en ``obj-y`` que adicionalmente estén en ``lib-y`` no serán incluidos en la librería, ya que podrán ser accedidos de igual forma. En cuanto a consistencia, los objetos listados en ``lib-m`` serán incluidos en ``lib.a``.

.. note::
   Algunos makefile kbuild podrían listar archivos por *construir en* y que fuesen parte de una librería. El mismo directorio podría contener ambos: ``integrado.a`` y ``lib.a``.

Ejemplo,

.. code-block:: makefile

    # arch/x86/lib/Makefile
    lib-y := delay.o

Esto creará una librería ``lib.a`` basada en ``delay.o``. Para que kbuild reconozca que está siendo construida ``lib.a``, el directorio deberá ser listado en ``libs-y``. El uso de ``lib-y`` está normalmente restringido a ``lib/`` y a ``arch/*/lib``.

.. _i3i1i6:

Descendiendo a los directorios
==============================

Un *Makefile* sólo es responsable de construir objetos en su propio directorio. Archivos en subdirectorios deberían ser tenidos en cuenta por los *Makefiles* en sus respectivos directorios. El sistema de construcción invocará ``make`` de manera recursiva en los subdirectorios indicados.

Para esto será utilizado ``obj-y`` y ``obj-m``. Por ejemplo, ``ext2`` vive en un directorio separado. El *Makefile* presente en ``fs/`` indica a kbuild cómo descender utilizando la siguiente asignación:

Ejemplo,

.. code-block:: makefile

    # fs/Makefile
    obj-$(CONFIG_EXT2_FS) += ext2/

Si ``CONFIG_EXT2_FS`` es configurado con ``y`` (integrado) o ``m`` (modular), será empleada la correspondiente variable ``obj-`` y kbuild descenderá al directorio ``ext2``. Kbuild sólo usa esta información para decidir cuándo visitar el directorio. El Makefile situado en tal directorio especificará qué es modular y qué es integrado.

Es una buena práctica utilizar la variable ``CONFIG_`` en la asignación de nombres de directorios. Esto permitirá a kbuild omitir el directorio si la correspondiente opción ``CONFIG_`` no contiene ni ``y`` ni ``m``.

.. _i3i1i7:

Compilación de opciones
=======================

``ccflags-y, asflags-y`` y ``ldflags-y``. Estas tres opciones(*flags*) únicamente son aplicables al makefile kbuild asignado. Son utilizadas en todas las invocaciones a ``cc, as`` y ``ld`` sucedidas durante la construcción recursiva.

.. note::
   Opciones con un comportamiento similar que fueron previamente nombradas: ``EXTRA_CFLAGS, EXTRA_AFLAGS`` y ``EXTRA_LDFLAGS``; continuarán siendo soportadas, aunque su empleo es depreciado -obsoleto.

Ejemplo,

.. code-block:: makefile

    # drivers/acpi/acpica/Makefile
    ccflags-y                       := -Os -D_LINUX -DBUILDING_ACPICA
    ccflags-$(CONFIG_ACPI_DEBUG)    += -DACPI_DEBUG_OUTPUT

Esta variable es necesaria, por que el Makefiles *ostenta* la variable ``$(KBUILD_CFLAGS)`` y, la utiliza como opción de compilación, en todo el directorio.

``asflags-y`` especifica la opción de ensamblado, mediane ``$(AS)``.

Ejemplo,

.. code-block:: makefile

    #arch/sparc/kernel/Makefile
    asflags-y := -ansi

``ldflags-y`` especifica la opción de enlazado, mediane ``$(LD)``.

Ejemplo,

.. code-block:: makefile

    #arch/cris/boot/compressed/Makefile
    ldflags-y += -T $(srctree)/$(src)/decompress_$(arch-y).lds

``subdir-ccflags-y, subdir-asflags-y``. Las dos opciones listadas arriba, son similares a ``ccflags-y`` y ``asflags-y``. La diferencia es que la variante ``subdir-``, tiene efecto sobre el archivo kbuild, donde estén presentes y, en todos los subdirectorios.
Las opciones especificadas mediante ``subdir-*`` son añadidas a la *línea de comando*, antes de especificar la opción, por medio de variantes de *non-subdir*.
.. _i3i1i11:

Soporte a las funciones ``$(CC)``
=================================

El kernel podría ser construido junto a distintas versiones ``$(CC)``, cada una de ellas, con soporte a un único grupo de características y opciones.
Kbuild proporciona soporte básico a la comprobación de opciones válidas de ``$(CC)``.
``$(CC)``, habitualmente el compilador ``gcc``. También disponibles, otras alternativas.

as-option
---------

``as-option``, es utilizada para comprobar si ``$(CC) --``, fue empleada para compilar archivos ensamblador ``*.S``, soportan la opción dada. Una segunda opción alternativa, podría ser especificada si la primera opción no fuese soportada.

Ejemplo,

.. code-block:: makefile

    #arch/sh/Makefile
    cflags-y += $(call as-option,-Wa$(comma)-isa=$(isa-y),)

En el ejemplo de arriba, ``cflags-y`` será asignada la opción ``-Wa$(comma)-isa=$(isa-y)``, si es soportada por ``$(CC)``.
El segundo argumento es opcional y, de ser porporcionado, será utilizado si el primer argumento no tiene soporte.

cc-ldoption
-----------

``cc-ldoption``, es utilizado para comprobar si ``$(CC)`` fue empleado para enlazar *archivos objeto*, soportados por una determinada opción. Podrá ser indicada una segunda alternativa, de no haber soporte a la primera.

Ejemplo,

.. code-block:: makefile

    #arch/x86/kernel/Makefile
    vsyscall-flags += $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)

En el ejemplo anterior, ``vsyscall-flags`` asignará la opción ``-Wl$(comma)--hash-style=sysv``, si hay soporte a ``$(CC)``. El segundo argumento es opcional. Podrá ser indicada una segunda alternativa, de no haber soporte a la primera.

as-instr
--------

``as-instr`` comprueba si el ensamblador, informa acerca de una instrucción específica, imprimiendo tanto la *opción1* como *opción2*.
*Secuencias de escape* C, tienen soporte en la *instrucción de ensayo*.

.. note::
   la opción ``as-instr``, utiliza ``KBUILD_AFLAGS`` en las opciones ``$(AS)`` -ensamblador.

cc-option
---------

``cc-option``, es utilizado para comprobar si ``$(CC)`` soporta un determinado conmutador de línea. Si es soportado, retorna la opción; de lo contrario, retorna un segundo parámetro si este fue especificado.

Ejemplo,

.. code-block:: makefile

    # Tarea de Makefile
    KBUILD_CFLAGS += $(call cc-option,-march=winchip-c6,-march=i586)

En el ejemplo de arriba, ``cflags-y`` asignará la opción ``-march=pentium-mmx`` si es soportado por ``$(CC)``, de cualquier otra forma, ``-march=i586``.
El segundo argumento a la alternativa ``cc-option``, es opcional. Si es omitida, ``cflags-y`` no asignará ningún valor, de no haber soporte a la primera opción.

.. note::
   ``cc-option`` utiliza ``KBUILD_CFLAGS`` en opciones ``$(CC)``.

cc-option-yn
------------

``cc-option-yn``, es utilizada para comprobar si ``gcc`` soporta determinada opción, retornando ``y`` en caso afirmativo, ``n`` en caso contrario.

Ejemplo,

.. code-block:: makefile

    #arch/ppc/Makefile
    biarch := $(call cc-option-yn, -m32)
    aflags-$(biarch) += -a32
    cflags-$(biarch) += -m32

En el ejemplo anterior, ``$(biarch)`` establece ``y``, si ``$(CC)`` soporta la opción ``-m32``. Siempre que ``$(biarch)`` sea igual a ``y``, las variables *expandidas* ``$(aflags-y)`` y ``$(cflags-y)``, asignarán los valores ``-a32`` y ``-m32``, respectivamente.

.. note::
   ``cc-option-yn`` utiliza ``KBUILD_CFLAGS`` en opciones ``$(CC)``.

cc-disable-warning
------------------

``cc-disable-warning`` comprueba si ``gcc`` da soporte a *advertencias*, retorna el *conmutado de línea*, para desactivarlo. Esta función especial, es necesaria puesto que ``gcc v4.4`` y posteriores, aceptan cualquier opción ``-Wno-*`` desconocida y, sólo avisa de ello, si algúna otra advertencia en el archivo fuente.

Ejemplo,

.. code-block:: makefile

    KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)

El ejemplo añade ``-Wno-unused-but-set-variable`` a la variable ``KBUILD_CFLAGS``, sólo si ``gcc`` la acepta realmente.

cc-version
----------

``cc-version``, retorna una versión numérica, de la versión del compilador ``$(CC)``.
El formato es ``<mayor><menor>``, dónde ambos son dígitos. Por ejemplo, ``gcc 3.41`` retornará ``0341``.
``cc-version``, resulta útil cuando una versión específica de ``$(CC)``, es erronea en determinda área, por ejemplo, ``-mregparm=3`` resultó *rota* en algunas versiones ``gcc``, incluso siendo aceptada por el mismo.

Ejemplo,

.. code-block:: makefile

    #arch/x86/Makefile
    cflags-y += $(shell \
    if [ $(cc-version) -ge 0300 ] ; then \
        echo "-mregparm=3"; fi ;)

El ejemplo de arriba, ``-mregparm=3`` sólo es utilizado en versiones 3.0 de ``gcc``, o posteriores.

cc-ifversion
------------

``cc-ifversion`` *prueba* la versión de ``$(CC)``, e iguala(``:=``) el cuarto parámetro si la *expresión de versión* es *cierta*, o la quinta -de ser aportada, si la *expresión de versión* es *falsa*.

Ejemplo,

.. code-block:: makefile

    #fs/reiserfs/Makefile
    ccflags-y := $(call cc-ifversion, -lt, 0402, -O1)

.. note::
   **n. de t.**: ``ccflags-y := $(call cc-ifversion, -lt, 0402, -O1)``.Ejemplo,

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
       @$(kecho) '  Kernel: $(obj)/$@ is ready'En este ejemplo, ``ccflags-y`` asignará el valor ``-01`` si la versión ``$(CC)`` es menor a 4.2.
``cc-ifversion`` toma todos los operadores de *shell*:
``-eq, -ne, -lt, -le, -gt, and -ge``
El tercer parámetro podría ser un texto, como lo és, en aquí, aunque podría ser una variable *expandida* o una *macro*.

Ejemplo,

.. code-block:: makefile

		#arch/powerpc/Makefile
		$(Q)if test "$(cc-fullversion)" = "040200" ; then \
			echo -n '*** GCC-4.2.0 cannot compile the 64-bit powerpc ' ; \
			false ; \
		fi

En este ejemplo, una versión específica de GCC, mostrará un error explicando al usuario, por qué se detuvo en la construcción.

cc-cross-prefix
---------------

``cc-cross-prefix`` es utilizado para comprobar si existe un ``$(CC)`` en *la ruta* de alguno de los prefijos listados. El primer prefijo, donde aparece un ``prefix$(CC)``, retornará PATH -si no lo hay, no retornará nada.
Además, los prefijos están separados por una *sólo espacio* en la llamada a ``cc-cross-prefix``.
Esta funcionalidad es útil en arquitecturas, donde los Makefiles tratarán de establecer ``CROSS_COMPILE``, en valores conocidos, entre varios de los mismos.
Es recomendable asignar la variable, en una construcción cruzada -*host arch* es distinta a *target arch*. Si ``CROSS_COMPILE`` ha sido ya asignada, es mejor dejar el valor tal cuál.

Ejemplo,

.. code-block:: makefile

		#arch/m68k/Makefile
		ifneq ($(SUBARCH),$(ARCH))
		        ifeq ($(CROSS_COMPILE),)
		               CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu-)
			endif
		endif

.. _i3i1i12:

Soporte a las funciones ``$(LD)``
=================================

ld-option
---------

``ld-option`` es utilizada para comprobar si ``$(LD)`` soporta la opción proporcionada.
``ld-option`` toma dos opciones como argumento.
El segundo argumento es una opción alternativa, que podrá ser utilizada si la primera opción no es soportada por ``$(LD)``.

Ejemplo,

.. code-block:: makefile

		#Makefile
		LDFLAGS_vmlinux += $(call ld-option, -X)

.. _i4:

Soporte a programas *Host*
==========================

Kbuild soporta la construcción de ejecutables en el anfitrión -host, para utilizarlos durante la fase de compilación. Son necesarios dos pasos, para utilizarlos.

El primer paso, es decir a kbuild, que tal programa existe. Con este propósito es utilizada la variable ``hostprogs-y``.

El segundo paso, consiste en añadir una dependencia explícita, al ejecutable. Hay dos formas de hacerlo; añadiendo la dependencia en una regla, o mediante la variable ``$(always)``.
Ambas posibilidades, serán descritas a continuación.

.. _i4i1:

Programas *Host* simple
=======================

En determinados casos, aparece la necesidad de *compilar y lanzar* un programa, en la computadora donde trabaja la construcción.
La siguiente línea, dice a kbuild, que el programa bin2hex, debería ser constuido en el anfitrión.

ejemplo,

.. code-block:: makefile

		hostprogs-y := bin2hex

Kbuild asume que ``bin2hex`` procede de un archivo *fuente C*, llamado ``bin2hex.c``, localizado en el mismo directorio que el Makefile.

.. _i4i2:

Composición de programas *Host*
===============================

Podrán hacerse programas *anfitrión*, basados en una composición de objetos.
La sintaxis utilizada para definir la composición de objetos, es similar a la sintaxis utilizada para objetos del kernel.
``$(<executable>-objs)`` lista todos los objetos utilizados, para enlazar el ejecutable final.

Ejemplo,

.. code-block:: makefile

		#scripts/lxdialog/Makefile
		hostprogs-y   := lxdialog
		lxdialog-objs := checklist.o lxdialog.o

Objetos con la extensión ``.o``, son compilados desde los correspondientes archivos ``.c``. En el ejemplo de arriba, ``checklist.c`` es compilado en ``checklist.o`` y, ``lxdialog.c`` en ``lxdialog.o``.
Finalmente, los dos archivos ``.o``, serán enlazados al ejecutable ``lxdialog`` .

.. note::
   La sintaxis ``<executable>-y`` no está permitida en *host-programs*.

.. _i4i3:

Empleo de ``C++`` en programas *Host*
======================================

Kbuild ofrece soporte a programas *host*, escritos en C++. La característica se introdujo para dar soporte a *kconfig*; no es recomendable un uso general.

Ejemplo,

.. code-block:: makefile

		#scripts/kconfig/Makefile
		hostprogs-y   := qconf
		qconf-cxxobjs := qconf.o

El ejecutable es compuesto desde el archivo C++ ``qconf.cc`` -identificado por ``$(qconf-cxxobjs)``.

Si ``qconf`` es compuesto por una mezcla de archivos ``.c`` y ``.cc``, podrá utilizarse una línea adicional, para su identificación.

Ejemplo,

.. code-block:: makefile

		#scripts/kconfig/Makefile
		hostprogs-y   := qconf
		qconf-cxxobjs := qconf.o
		qconf-objs    := check.o

.. _i4i4:

Control de las opciones del compilador en programas *Host*
==========================================================

En la compilación de programas *host*, es posible establecer opciones específicas.
El programa siempre compilará pasando las opciones en ``$(HOSTCFLAGS)`` a la varible ``$(HOSTCC)``.
La determinar qué opciones tomarán efecto, en todos los programas *host*, creados en ese Makefile, utilizar la variable ``HOST_EXTRACFLAGS``.

Ejemplo,

.. code-block:: makefile

		#scripts/lxdialog/Makefile
		HOST_EXTRACFLAGS += -I/usr/include/ncurses

Para establecer opciones específicas, para un sólo archivo, es utilizada la siguiente opción:

.. code-block:: makefile

		#arch/ppc64/boot/Makefile
		HOSTCFLAGS_piggyback.o := -DKERNELBASE=$(KERNELBASE)

Es posible también, especificar opciones adicionales en el *enlazador*.

Ejemplo,

.. code-block:: makefile

		#scripts/kconfig/Makefile
		HOSTLOADLIBES_qconf := -L$(QTDIR)/lib

Al enlazar ``qconf``, será *pasado* como opción *extra* ``-L$(QTDIR)/lib``.

.. _i4i5:

Cuándo son construidos los programas *Host*
===========================================

Kbuid únicamente contruye programas *host*, cuando son referenciados como requisito.
Esto es posible de dos formas distintas:

- 1. Listar el requisito de forma explícita, en una regla especial.

Ejemplo,

.. code-block:: makefile

		#drivers/pci/Makefile
		hostprogs-y := gen-devlist
		$(obj)/devlist.h: $(src)/pci.ids $(obj)/gen-devlist
			( cd $(obj); ./gen-devlist ) < $<

El objetivo ``$(obj)/devlist.h`` no será construido antes de actualizar ``$(obj)/gen-devlist``.

.. note::
   referencias al programa *host* en reglas especiales, deben utilizar el prefijo ``$(obj)``.

- 2. Uso de ``$(always)``.Ejemplo,

.. code-block:: makefile

    #scripts/lxdialog/Makefile
    hostprogs-y   := lxdialog
    always        := $(hostprogs-y)

Indica a kbuild, el construir ``lxdialog`` incluso si no hubiese sido referenciado en ninguna regla.

.. _i4i6:

Utilización de ``hostprogs-$(CONFIG_FOO)``
==========================================

Un patrón habitual en archivos kbuild, tienen este aspecto:

.. code-block:: makefile

    #scripts/Makefile
    hostprogs-$(CONFIG_KALLSYMS) += kallsyms

Kbuild entiende ambas asignaciones; ``y``, para *integrados*, ``m``, para módulos.
Por lo que si un símbolo evalúa ``m``, kbuild seguirá construyendo el binario. En otras palablas; kbuild gestiona ``hostprogs-m`` de igual modo a ``hostprogs-y``. Aunque es recomendable el empleo de ``hostprogs-y``, cuando no hay *símbolos de configuración* involucrados.

.. _i5:

*Kbuild*, limpiar infraestructura
=================================

``make clean``, borra la mayoría de archivos generados en el *árbol objetivo*, donde es compilado el kernel. Esto incluye los archivos generados como *programas host*.
Kbuild conoce los objetivos listados en ``$(hostprogs-y), $(hostprogs-m), $(always),$(extra-y)`` y ``$(targets)``. Estos serán borrados los archivos durante ``make clean``.
Archivos que coincidan con el patrón ``*.[oas]``, ``*.ko``, además de otros generados por kbuild, serán borrados del árbol fuente, al ejecutar dicho comando.

Es posible especificar archivos adicionales, mediante la variable ``$(clean-files)``.

Ejemplo,

.. code-block:: makefile

    #lib/Makefile
    clean-files := crc32table.h

Al ejecutar ``make clean``, el archivo ``crc32table.h`` será borrado.
Kbuild asumirá que los archivos están en el mismo directorio relativo al archivo ``Makefile``, excepto si fue utilizado el prefijo ``$(objtree)``.

Para borrar la *jerarquía* de directorio -recursivamente:

Ejemplo,

.. code-block:: makefile

    #scripts/package/Makefile
    clean-dirs := $(objtree)/debian/

Esto borrará el directorio *debian*, empezando por el nivel más alto del directorio, e incluyendo todos los subdirectorios. 

Para exluir ciertos archivos, utilizar la variable ``$(no-clean-files)``. Se trata de un caso especial, utilizado en el nivel *más alto* del archivo kbuild:

Ejemplo,

.. code-block:: makefile

    #Kbuild
    no-clean-files := $(bounds-file) $(offsets-file)

Habitualmente, kbuild desciende a los subdirectorios mediante ``obj-* := dir/"``, aunque en estructuras *makefiles*, donde la infraestructura kbuild no es suficiente, algunas veces necesitará ser explicitado.

Ejemplo,

.. code-block:: makefile

    #arch/x86/boot/Makefile
    subdir- := compressed/

La asignación de arriba, instruye a kbuild para descender al directorio ``compressed/``, al ejecutar ``make clean``.

El soporte a la infraestructura *clean* el los *Makefiles*, que construyen la imagen arrancable, dispone de un *objetivo opcional* llamado *archclean*:

Ejemplo,

.. code-block:: makefile

    #arch/x86/Makefile
    archclean:
        $(Q)$(MAKE) $(clean)=arch/x86/boot

``make clean`` descenderá en ``arch/x86/boot`` y, hará la limpieza habitual. El Makefile localizado en ``arch/x86/boot/``, podría utilizar el artificio ``subdir-``, para descender *afondo*.

.. note::
   **Nota 1**: ``arch/$(ARCH)/Makefile`` no podrá utilizar ``subdir-``, puesto que el archivo es incluido en el nivel más alto de *makefile* y, la infraestructura kbuild no es operativa en ese punto.
   
   **Nota 2**: todos los directorios listados en ``core-y, libs-y, drivers-y`` y ``net-y``, serán visitados durante ``make clean``.

.. _i6:

Arquitectura de archivos *Makefiles*
====================================

La *raiz* de Makefile establece el entorno y, hace los preparativos antes de empezar a cescender a directorios individuales.
Contiene una parte genérica, donde ``arch/$(ARCH)/Makefile`` decidirá qué es requerido con objeto de establecer kbuild, en la arquitectura mencionada.
Así, ``arch/$(ARCH)/Makefile`` establece un número de variables y define nuevos objetivos.

En la ejecución de kbuild, los siguientes pasos tomarán efecto -aproximádamente:

1. Configuración del kenrel => produce ``.config``.
2. Guarda la versión del kernel en ``include/linux/version.h``.
3. Actualizar el resto de requisitos, para preparar el *objetivo*:
    - Requisitos adicionales serán especificados en ``arch/$(ARCH)/Makefile``
4. Descenso recursivo a los directorios en ``init-* core* drivers-* net-* libs-*`` y la construcción de los objetivos.
    - El valor de las anteriores variables, son expandidos en ``arch/$(ARCH)/Makefile``.
5. Todos los archivos *objeto* son enlazados y, el archivo resultante ``vmlinux``, localizado en la raíz del ábol objetivo.
   Los primeros objetos enlazados, serán listados en ``head-y``; asignados por ``arch/$(ARCH)/Makefile``.
6. Finalmente, la parte específica de la arquitectura, efectuará cualquier *pos-procesado* requerido y, construirá la imagen de arranque final.
    - Esto incluye la construcción de registros de arranque.
    - Preparar la imagen *initrd* y similares.

.. _i6i1:

Configuración de variables, para complementar la construcción de la arquitectura
=================================================================================

``LDFLAGS``
    Generic ``$(LD)`` options. Opciones utilizadas en todas las invocaciones del enlazador. Especificar *la emulación*, amenudo es suficiente.

Ejemplo,

.. code-block:: makefile

    #arch/s390/Makefile
    LDFLAGS         := -m elf_s390

.. note::
   ``ldflags-y`` puede ser utilizado para personalizar las opciones utilizadas. Ver capítulo `Compilación de opciones`_.

``LDFLAGS_vmlinux``
    Options for ``$(LD)`` when linking *vmlinux*. ``LDFLAGS_vmlinux`` utilizada para especificar opciones adicionales, pasadas al enlazador, en el momento de concluir el enlace final de la imagen *vmlinx*. ``LDFLAGS_vmlinux`` utiliza el soporte a ``LDFLAGS_@``.

Ejemplo,

.. code-block:: makefile

    #arch/x86/Makefile
    LDFLAGS_vmlinux := -e stext

``OBJCOPYFLAGS``
    objcopy flags. En el empleo de ``$(call if_changed,objcopy)`` para traducir archivos ``.o``, serán utilizadas las opciones especificadas en ``OBJCOPYFLAGS``. ``$(call if_changed,objcopy)`` es habitualmente usado para generar *binarios en crudo*, soble *vmlinux*.

Ejemplo,

.. code-block:: makefile

    #arch/s390/Makefile
    OBJCOPYFLAGS := -O binary

    #arch/s390/boot/Makefile
    $(obj)/image: vmlinux FORCE
        $(call if_changed,objcopy)

En el ejemplo, el binario ``$(obj)/image`` es el vinario de una versión de *vmlinux*. El método de uso de ``$(call if_changed,xxx)``, será descrita más tarde.

``KBUILD_AFLAGS``
    ``$(AS)`` assembler flags. Valor por defecto; ver *raíz* de *Makefile*. Anexar o modificar, de ser requerido por la arquitectura.

Ejemplo,

.. code-block:: makefile

    #arch/sparc64/Makefile
    KBUILD_AFLAGS += -m64 -mcpu=ultrasparc

``KBUILD_CFLAGS``
    ``$(CC)`` compiler flags. Valor por defecto; ver *raíz* de *Makefile*. Anexar o modificar, de ser requerido por la arquitectura.

Frecuentemente, la variable ``KBUILD_CFLAGS`` depende de la configuración.Ejemplo,

.. code-block:: makefile

		#arch/x86/boot/compressed/Makefile
		cflags-$(CONFIG_X86_32) := -march=i386
		cflags-$(CONFIG_X86_64) := -mcmodel=small
		KBUILD_CFLAGS += $(cflags-y)

Muchos de los *Makefiles* específicos de arquitectura, lanzan el compilador de C, para testar el *soporte a opciones*.

.. code-block:: makefile

		#arch/x86/Makefile

		...
		cflags-$(CONFIG_MPENTIUMII)     += $(call cc-option,\
						-march=pentium2,-march=i686)
		...
		# Disable unit-at-a-time mode ...
		KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time)
		...

El primer ejemplo, utiliza el "truco" de expandir la opción de configuración, cuando es seleccionada ``y``.

``KBUILD_AFLAGS_KERNEL $(AS)`` opciones específicas con *integrados*.

``$(KBUILD_AFLAGS_KERNEL)`` contiene *opciones extra* del compilador C, empleadas para compilar el código del kernel residente.

``KBUILD_AFLAGS_MODULE`` Opciones para ``$(AS)`` en la construcción de módulos.

``$( KBUILD_AFLAGS_MODULE)`` empleado para añadir opciones específicas de la arquitectura, utilizadas por ``$(AS)``.
Desde la línea de comandos, debería ser usado ``AFLAGS_MODULE``. Ver ``kbuild.txt``.

``KBUILD_CFLAGS_KERNEL $(CC)`` opciones específicas con *integrados*.

``$(KBUILD_CFLAGS_KERNEL)`` contiene *opciones extra* del compilador C, empleadas para compilar el código del kernel residente.

``KBUILD_CFLAGS_MODULE`` Opciones para ``$(CC)`` en la construcción de módulos.

``$(KBUILD_CFLAGS_MODULE)`` empleado para añadir opciones específicas de la arquitectura, utilizadas por ``$(CC)``.
Desde la línea de comandos, debería ser usado ``CFLAGS_MODULE``. Ver ``kbuild.txt``.

``KBUILD_LDFLAGS_MODULE`` Opciones para ``$(LD)`` en el enlazado de módulos.

``$(KBUILD_LDFLAGS_MODULE)`` empleado para añadir opciones específicas de la arquitectura, utilizadas al enlazar módulos. A menudo un escrito del enlazador.
Desde la línea de comandos, debería ser usado ``LDFLAGS_MODULE``. Ver ``kbuild.txt``.

``KBUILD_ARFLAGS`` Opciones para ``$(AR)`` al crear archivos.

``$(KBUILD_ARFLAGS)`` configurado por la *raíz de Makefile* a D, (modo determinista) -si es que la opción es soportadapor ``$(AR)``.

``ARCH_CPPFLAGS, ARCH_AFLAGS, ARCH_CFLAGS`` sobreesrcribe los valores por defecto de kbuiild.

Estas variables son un apéndice de ``KBUILD_CPPFLAGS``, ``KBUILD_AFLAGS`` y ``KBUILD_CFLAGS``, respectivamente, después de haber sido configuradas otras opciones, por la *raíz Makefile*. Da sentido, a la sobreescritura de los valores por defecto en la arquitectura.


Añadir *prerrequisitos*, a ``archheaders:``
-------------------------------------------

Cabeceras: la regla es utilizada para generar *archivos cabecera*, que podrían ser instalados en el espacio de usuario, mediante ``make header install`` o ``make headers install all``. Para dar soporte a ``make headers install all``, el objetivo debe ser capaz de trabajar con un *árbol* no configurado, o un *árbol* configurado para otra arquitectura.

Es lanzado antes de ``make archprepare`` sobre la própia arquitectura.


Añadir *prerrequisitos*, a ``archprepare:``
-------------------------------------------

``archprepare:`` regla usada para listar pre-requisitos, que necesiten ser construidos antes de comenzar a descender en subdirectorios.
Habitualmente usado por archivos de cabecera, conteniendo *constantes* de ensamblador.

Ejemplo,

.. code-block:: makefile

		#arch/arm/Makefile
		archprepare: maketools
		
El objetivo ``maketools`` será procesado antes de descender a subdirectorios.
Ver también capítulo XXX-TODO, que describe cómo kabuild, soporta generar el *offset* de archivos de cabecera.


Listar directorios que visitar, al descender
--------------------------------------------

El archivo *Makefile* especíifico de la arquitectura, trabaja en colaboración con el *Makefile* principal, para definir variables utilizadas en la construcción del archivo *vmlinux*. Nótese que no hay una correspondiente sección para módulos, en este mismo sentido; la maquinaria de construcción de modulos es independiente.

.. code-block:: makefile
    
		head-y, init-y, core-y, libs-y, drivers-y, net-y

``$(head-y)`` lista objetos a enlazar primero, en vmlinux.
``$(libs-y)`` lista directorios donde un fichero ``lib.a`` podrá ser localizado.
El resto, lista directorios donde un archivo objeto ``integrado.a``, podrá ser localizado.

``$(init-y)`` objetos que serán localizados después de ``$(head-y)``.
El resto seguirá este orden:
``$(core-y), $(libs-y), $(drivers-y)`` y ``$(net-y)``.

El *Makefile* principal, define valores en directorios genéricos, y ``arch/$(ARCH)/Makefile`` sólo añade deirectorios específicos de la arquitectura.

Ejemplo,

.. code-block:: makefile

		#arch/sparc64/Makefile
		core-y += arch/sparc64/kernel/
		libs-y += arch/sparc64/prom/ arch/sparc64/lib/
		drivers-$(CONFIG_OPROFILE)  += arch/sparc64/oprofile/


Imagenes de arranque, específicos de la arquitectura
----------------------------------------------------

Un *Makefile*específico, persigue un fin tomado en consideración por el archivo *vmlinux*, lo comprime, agrupa en código y, copia los archivos resultantes *en algún lugar*. Esto incluye distintos tipos de comandos de instalación. El fin primario, no es un estandar entre arquitecturas.

Es común localizar otros adicionales, bajo ``arch/$(ARCH)/`` en el directorio ``boot/``.

*Kbuild* no proporciona ninguna forma simple de dar soporte a la construcción de objetivos específicos en ``boot/``. Es más ``arch/$(ARCH)/Makefile`` deberá llamar a ``make`` manualmente, para construir el objetivo en ``boot/``.

La aproximación recomendada, es incluir *atajos* en ``arch/$(ARCH)/Makefile`` y, utilizar la ruta completa en llamadas a ``arch/$(ARCH)/boot/Makefile``.

Ejemplo,

.. code-block:: makefile

		#arch/x86/Makefile
		boot := arch/x86/boot
		bzImage: vmlinux
			$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@

``$(Q)$(MAKE) $(build)=<dir>`` es la forma recomendada de invocar a ``make`` en un subdirectorio.

Sin reglas específicas de nombrado, el comando ``make help`` imprimirá una lista de objetivos relevantes. El soporte a esta característica es conseguido definiendo ``$(archhelp)``.

Ejemplo,

.. code-block:: makefile

		#arch/x86/Makefile
		define archhelp
		  echo  '* bzImage      - Image (arch/$(ARCH)/boot/bzImage)'
		endif

Ejecutar ``make`` sin argumentos, construirá el primer *objetivo* encontrado. El primer objetivo en el *Makefile principal* es ``all:``
Una *arquitectura*, debería siempre, construir una imagen arrancable. En ``make help``, la opción por defecto es destacada con ``*``. Habrá que añadir un nuevo *prerrequsito*, para construir un objetivo distinto en su defecto.

Ejemplo,

.. code-block:: makefile

		#arch/x86/Makefile
		all: bzImage

Cuando ``make`` es ejecutado sin argumentos, será construida ``bzimage``.


Construcción de objetivos *no-kabuild*
--------------------------------------

**extra-y**

``extra-y`` especifica objetivos adicionales, creados en el directorio activo, en adición a cualquier objetivo especificado por ``obj-*``.

Listar todos los objetivos en ``extra-y`` es necesario por dos motivos:
1. Activar *kbuild* para comprobar cambios en líneas de comando
  - Cuando es utilizado ``$(call if_changed,xxx)``.
2. Kbuild sabrá que archivos borrar, durante ``make clean``.

Ejemplo,

.. code-block:: makefile

		#arch/x86/kernel/Makefile
		extra-y := head.o init_task.o

En este ejemplo, ``extra-y`` es utilizado para listar archivos objeto, que deban ser construidos, pero no debería ser enlazado como parte de ``integrado.a``.. _i6i7:

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