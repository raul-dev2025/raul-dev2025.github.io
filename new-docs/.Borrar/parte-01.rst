.. _i3i1i2:

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
