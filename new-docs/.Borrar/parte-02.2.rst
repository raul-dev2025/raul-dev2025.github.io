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
   **n. de t.**: ``ccflags-y := $(call cc-ifversion, -lt, 0402, -O1)``.