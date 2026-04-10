### [Soporte a las funciones `$(CC)`](i3i1i11) ###

El kernel podría ser construido junto a distintas versiones `$(CC)`, cada una de ellas, con soporte a un único grupo de características y opciones.
Kbuild proporciona soporte básico a la comprobación de opciones válidas de `$(CC)`.
`$(CC)`, habitualmente el compilador `gcc`. También disponibles, otras alternativas.

		as-option
`as-option`, es utilizada para comprobar si `$(CC) --`, fue empleada para compilar archivos ensamblador `*.S`, soportan la opción dada. Una segunda opción alternativa, podría ser especificada si la primera opción no fuese soportada.

Ejemplo,

		#arch/sh/Makefile
		cflags-y += $(call as-option,-Wa$(comma)-isa=$(isa-y),)

En el ejemplo de arriba, `cflags-y` será asignada la opción `-Wa$(comma)-isa=$(isa-y)`, si es soportada por `$(CC)`.
El segundo argumento es opcional y, de ser porporcionado, será utilizado si el primer argumento no tiene soporte.

		cc-ldoption
`cc-ldoption`, es utilizado para comprobar si `$(CC)` fue empleado para enlazar _archivos objeto_, soportados por una determinada opción. Podrá ser indicada una segunda alternativa, de no haber soporte a la primera.

Ejemplo,
		#arch/x86/kernel/Makefile
		vsyscall-flags += $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
		
En el ejemplo anterior, `vsyscall-flags` asignará la opción `-Wl$(comma)--hash-style=sysv`, si hay soporte a `$(CC)`. El segundo argumento es opcional. Podrá ser indicada una segunda alternativa, de no haber soporte a la primera.

		as-instr
`as-instr` comprueba si el ensamblador, informa acerca de una instrucción específica, imprimiendo tanto la _opción1_ como _opción2_.
_Secuencias de escape_ C, tienen soporte en la _instrucción de ensayo_.

> __Nota__: la opción `as-instr`, utiliza `KBUILD_AFLAGS` en las opciones `$(AS)` -ensamblador.

		cc-option
`cc-option`, es utilizada para comprobar si `$(CC)` da soporte a determinada opción, si no es así, será utilizada una segunda alternativa opcional.

Ejemplo,
		#arch/x86/Makefile
		cflags-y += $(call cc-option,-march=pentium-mmx,-march=i586)

En el ejemplo de arriba, `cflags-y` asignará la opción `-march=pentium-mmx` si es soportado por `$(CC)`, de cualquier otra forma, `-march=i586`.
El segundo argumento a la alternativa `cc-option`, es opcional. Si es omitida, `cflags-y` no asignará ningún valor, de no haber soporte a la primera opción.

> __Nota__: `cc-option` utiliza `KBUILD_CFLAGS` en opciones `$(CC)`.

		cc-option-yn
`cc-option-yn`, es utilizada para comprobar si `gcc` soporta determinada opción, retornando <kbd>y</kbd> en caso afirmativo, <kbd>n</kbd> en caso contrario.

Ejemplo,
		#arch/ppc/Makefile
		biarch := $(call cc-option-yn, -m32)
		aflags-$(biarch) += -a32
		cflags-$(biarch) += -m32

En el ejemplo anterior, `$(biarch)` establece <kbd>y</kbd>, si `$(CC)` soporta la opción `-m32`. Siempre que `$(biarch)` sea igual a <kbd>y</kbd>, las variables _expandidas_ `$(aflags-y)` y `$(cflags-y)`, asignarán los valores `-a32` y `-m32`, respectivamente.

> __Nota__: `cc-option-yn` utiliza `KBUILD_CFLAGS` en opciones `$(CC)`.

		cc-disable-warning
`cc-disable-warning` comprueba si `gcc` da soporte a _advertencias_, retorna el _conmutado de línea_, para desactivarlo. Esta función especial, es necesaria puesto que `gcc v4.4` y posteriores, aceptan cualquier opción `-Wno-*` desconocida y, sólo avisa de ello, si algúna otra advertencia en el archivo fuente.

Ejemplo,
		KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)

El ejemplo añade `-Wno-unused-but-set-variable` a la variable `KBUILD_CFLAGS`, sólo si `gcc` la acepta realmente.

		cc-version
`cc-version`, retorna una versión numérica, de la versión del compilador `$(CC)`.
El formato es `<mayor><menor>`, dónde ambos son dígitos. Por ejemplo, `gcc 3.41` retornará <kbd>0341</kbd>.
`cc-version`, resulta útil cuando una versión específica de `$(CC)`, es erronea en determinda área, por ejemplo, `-mregparm=3` resultó _rota_ en algunas versiones `gcc`, incluso siendo aceptada por el mismo.

Ejemplo,
		#arch/x86/Makefile
		cflags-y += $(shell \
		if [ $(cc-version) -ge 0300 ] ; then \
			echo "-mregparm=3"; fi ;)

El ejemplo de arriba, `-mregparm=3` sólo es utilizado en versiones 3.0 de `gcc`, o posteriores.

		cc-ifversion
`cc-ifversion` _prueba_ la versión de `$(CC)`, e iguala(`:=`) el cuarto parámetro si la _expresión de versión_ es _cierta_, o la quinta -de ser aportada, si la _expresión de versión_ es _falsa_.

Ejemplo,
		#fs/reiserfs/Makefile
		ccflags-y := $(call cc-ifversion, -lt, 0402, -O1)

> __n. de t.__: `ccflags-y <u>:=</u> $(call cc-ifversion, -lt, 0402, <u>-O1</u>)`.