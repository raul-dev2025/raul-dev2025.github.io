Ejemplo,

		#arch/x86/boot/compressed/Makefile
		cflags-$(CONFIG_X86_32) := -march=i386
		cflags-$(CONFIG_X86_64) := -mcmodel=small
		KBUILD_CFLAGS += $(cflags-y)

Muchos de los _Makefiles_ específicos de arquitectura, lanzan el compilador de C, para testar el _soporte a opciones_.

		#arch/x86/Makefile

		...
		cflags-$(CONFIG_MPENTIUMII)     += $(call cc-option,\
						-march=pentium2,-march=i686)
		...
		# Disable unit-at-a-time mode ...
		KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time)
		...

El primer ejemplo, utiliza el "truco" de expandir la opción de configuración, cuando es seleccionada `y`.

`KBUILD_AFLAGS_KERNEL	$(AS)` opciones específicas con _integrados_.

`$(KBUILD_AFLAGS_KERNEL)` contiene _opciones extra_ del compilador C, empleadas para compilar el código del kernel residente.

` KBUILD_AFLAGS_MODULE` Opciones para `$(AS)` en la construcción de módulos.

`$( KBUILD_AFLAGS_MODULE)` empleado para añadir opciones específicas de la arquitectura, utilizadas por `$(AS)`.
Desde la línea de comandos, debería ser usado `AFLAGS_MODULE`. Ver `kbuild.txt`.

`KBUILD_CFLAGS_KERNEL	$(CC)` opciones específicas con _integrados_.

`$(KBUILD_CFLAGS_KERNEL)` contiene _opciones extra_ del compilador C, empleadas para compilar el código del kernel residente.

`KBUILD_CFLAGS_MODULE` Opciones para `$(CC)` en la construcción de módulos.

`$(KBUILD_CFLAGS_MODULE)` empleado para añadir opciones específicas de la arquitectura, utilizadas por `$(CC)`.
Desde la línea de comandos, debería ser usado `CFLAGS_MODULE`. Ver `kbuild.txt`.

`KBUILD_LDFLAGS_MODULE` Opciones para `$(LD)` en el enlazado de módulos.

`$(KBUILD_LDFLAGS_MODULE)` empleado para añadir opciones específicas de la arquitectura, utilizadas al enlazar módulos. A menudo un escrito del enlazador.
Desde la línea de comandos, debería ser usado `LDFLAGS_MODULE`. Ver `kbuild.txt`.

`KBUILD_ARFLAGS` Opciones para `$(AR)` al crear archivos.

`$(KBUILD_ARFLAGS)` configurado por la _raíz de Makefile_ a D, (modo determinista) -si es que la opción es soportadapor `$(AR)`.

`ARCH_CPPFLAGS, ARCH_AFLAGS, ARCH_CFLAGS` sobreesrcribe los valores por defecto de kbuiild.

Estas variables son un apéndice de `KBUILD_CPPFLAGS`, `KBUILD_AFLAGS` y `KBUILD_CFLAGS`, respectivamente, después de haber sido configuradas otras opciones, por la _raíz Makefile_. Da sentido, a la sobreescritura de los valores por defecto en la arquitectura.


### [Añadir _prerrequisitos_, a `archheaders:`](i6i2) ###

Cabeceras: la regla es utilizada para generar _archivos cabecera_, que podrían ser instalados en el espacio de usuario, mediante `make header install` o `make headers install all`. Para dar soporte a `make headers install all`, el objetivo debe ser capaz de trabajar con un _árbol_ no configurado, o un _árbol_ configurado para otra arquitectura.

Es lanzado antes de `make archprepare` sobre la própia arquitectura.


### [Añadir _prerrequisitos_, a `archprepare:`](i6i3) ###

`archprepare:` regla usada para listar pre-requisitos, que necesiten ser construidos antes de comenzar a descender en subdirectorios.
Habitualmente usado por archivos de cabecera, conteniendo _constantes_ de ensamblador.

Ejemplo,
		#arch/arm/Makefile
		archprepare: maketools
		
El objetivo `maketools` será procesado antes de descender a subdirectorios.
Ver también capítulo XXX-TODO, que describe cómo kabuild, soporta generar el _offset_ de archivos de cabecera.


### [Listar directorios que visitar, al descender](i6i4) ###

El archivo _Makefile_ especíifico de la arquitectura, trabaja en colaboración con el _Makefile_ principal, para definir variables utilizadas en la construcción del archivo _vmlinux_. Nótese que no hay una correspondiente sección para módulos, en este mismo sentido; la maquinaria de construcción de modulos es independiente.

		head-y, init-y, core-y, libs-y, drivers-y, net-y

`$(head-y)` lista objetos a enlazar primero, en vmlinux.
`$(libs-y)` lista directorios donde un fichero `lib.a` podrá ser localizado.
El resto, lista directorios donde un archivo objeto `integrado.a`, podrá ser localizado.

`$(init-y)` objetos que serán localizados después de `$(head-y)`.
El resto seguirá este orden:
`$(core-y), $(libs-y), $(drivers-y)` y `$(net-y)`.

El _Makefile_ principal, define valores en directorios genéricos, y `arch/$(ARCH)/Makefile` sólo añade deirectorios específicos de la arquitectura.

Ejemplo,
		#arch/sparc64/Makefile
		core-y += arch/sparc64/kernel/
		libs-y += arch/sparc64/prom/ arch/sparc64/lib/
		drivers-$(CONFIG_OPROFILE)  += arch/sparc64/oprofile/


### [Imagenes de arranque, específicos de la arquitectura](i6i5) ###

Un _Makefile_específico, persigue un fin tomado en consideración por el archivo _vmlinux_, lo comprime, agrupa en código y, copia los archivos resultantes _en algún lugar_. Esto incluye distintos tipos de comandos de instalación. El fin primario, no es un estandar entre arquitecturas.

Es común localizar otros adicionales, bajo `arch/$(ARCH)/` en el directorio `boot/`.

_Kbuild_ no proporciona ninguna forma simple de dar soporte a la construcción de objetivos específicos en `boot/`. Es más `arch/$(ARCH)/Makefile` deberá llamar a `make` manualmente, para construir el objetivo en `boot/`.

La aproximación recomendada, es incluir _atajos_ en `arch/$(ARCH)/Makefile` y, utilizar la ruta completa en llamadas a `arch/$(ARCH)/boot/Makefile`.

Ejemplo,
		#arch/x86/Makefile
		boot := arch/x86/boot
		bzImage: vmlinux
			$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@

`$(Q)$(MAKE) $(build)=<dir>` es la forma recomendada de invocar a `make` en un subdirectorio.

Sin reglas específicas de nombrado, el comando `make help` imprimirá una lista de objetivos relevantes. El soporte a esta característica es conseguido definiendo `$(archhelp)`.

Ejemplo,
		#arch/x86/Makefile
		define archhelp
		  echo  '* bzImage      - Image (arch/$(ARCH)/boot/bzImage)'
		endif

Ejecutar `make` sin argumentos, construirá el primer _objetivo_ encontrado. El primer objetivo en el _Makefile principal_ es `all:`
Una _arquitectura_, debería siempre, construir una imagen arrancable. En `make help`, la opción por defecto es destacada con `*`. Habrá que añadir un nuevo _prerrequsito_, para construir un objetivo distinto en su defecto.

Ejemplo,
		#arch/x86/Makefile
		all: bzImage

Cuando `make` es ejecutado sin argumentos, será construida `bzimage`.


### [Construcción de objetivos _no-kabuild_](i6i6) ###

		extra-y

`extra-y` especifica objetivos adicionales, creados en el directorio activo, en adición a cualquier objetivo especificado por `obj-*`.

Listar todos los objetivos en `extra-y` es necesario por dos motivos:
1. Activar _kbuild_ para comprobar cambios en líneas de comando
  - Cuando es utilizado `$(call if_changed,xxx)`.
2. Kbuild sabrá que archivos borrar, durante `make clean`.

Ejemplo,
		#arch/x86/kernel/Makefile
		extra-y := head.o init_task.o

En este ejemplo, `extra-y` es utilizado para listar archivos objeto, que deban ser construidos, pero no debería ser enlazado como parte de `integrado.a`

