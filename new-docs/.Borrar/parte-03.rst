En este ejemplo, ``ccflags-y`` asignará el valor ``-01`` si la versión ``$(CC)`` es menor a 4.2.
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

- 2. Uso de ``$(always)``.