[Tabla de contenidos](#i1)
[Introducción](#i2)
[Quién hace qué](#i3)
[Los archivos _kbuild_](#i3i1)
[Definición de objetivos](#i3i1i1)
[Archivos _objeto_ integrados `obj-y`](#i3i1i2)
[Propósito de los módulos _cargables_ `obj-m`](#i3i1i3)
[Objetos que exportan _símbolos_](#i3i1i4)
[Propósito de los archivos _librerías_ `lib-y`](#i3i1i5)
[Descendiendo a los directorios](#i3i1i6)
[Compilación de opciones](#i3i1i7)
[Seguimiento de las dependencias](#i3i1i9)
[Reglas especiales](#i3i1i10)
[Soporte a las funciones `$(CC)`](#i3i1i11)
[Soporte a las funciones `$(LD)`](#i3i1i12)
[Soporte a programas _Host_](#i4)
[Programas _Host_ simple](#i4i1)
[Composición de programas _Host_](#i4i2)
[Empleo de `C++` en programas _Host_](#i4i3)
[Control de las opciones del compilador en programas _Host_](#i4i4)
[Cuándo son construidos los programas _Host_](#i4i5)
[Utilización de `hostprogs-$(CONFIG_FOO)`](#i4i6)
[_Kbuild_, limpiar infraestructura](#i5)
[Arquitectura de archivos _Makefiles_](#i6)
[Configuración de variables, para complementar la construcción de la arquitectura](#i6i1)
[Añadir _prerrequisitos_, a `archheaders:`](#i6i2)
[Añadir _prerrequisitos_, a `archprepare:`](#i6i3)
[Listar directorios que visitar, al descender](#i6i4)
[Imagenes de arranque, específicos de la arquitectura](#i6i5)
[Construcción de objetivos _no-kabuild_](#i6i6)
[Comandos útiles, en la construcción de una imagen de arranque](#i6i7)
[Comando _kbuild_ personalizados](#i6i8)
[Referencias y agradecimientos](#i99)
--- 

## _Makefiles_ en el kernel de Linux ##

El codumento describe los archivos _Makefiles_ en el kernel de Linux.


### [Tabla de contenidos](i1) ###

- Introducción
- Quién hace qué
- Los archivos _kbuild_
  -	Definición de objetivos
  - Archivos _objeto_ integrados `obj-y`
  - Propósito de los módulos _cargables_ `obj-m`
  - Objetos que exportan _símbolos_
  - Propósito de los archivos _librerías_ `lib-y`
  - Descendiendo a los directorios
  - Compilación de opciones
  - Dependencias de la línea de comandos
  - Seguimiento de las dependencias
  - Reglas especiales
  - Soporte a las funciones `$(CC)`
  - Soporte a las funciones `$(LD)`
- Soporte a programas _Host_
  - Programas _Host_ simple
  - Composición de programas _Host_
  - Empleo de `C++` en programas _Host_
  - Control de las opciones del compilador en programas _Host_
  - Cuándo son construidos los programas _Host_
  - Utilización de `hostprogs-$(CONFIG_FOO)`
- _Kbuild_, infraestructura _limpia_
- Arquitectura de archivos _Makefiles_
  - Configuración de variables, para complementar la construcción de la arquitectura
  - Añadir _prerrequisitos_, a `archheaders:`
  - Añadir _prerrequisitos_, a `archprepare:`
  - Listar directorios que visitar, al descender
  - Imagenes de arranque, específicos de la arquitectura
  - Construcción de objetivos _no-kabuild_
  - Comandos útiles, en la construcción de una imagen de arranque
  - Comando _kbuild_ personalizados
  - Procesando _scripts_ del enlazador
  - Archivos genéricos de cabecera
  - Pasar enlaces _post-link_
- Sintaxis _kbuild_ en cabeceras exportadas
  - Cabeceras no exportables
  - `generic-y`
  - `generated-y`
  - `mandatory-y`
- Variables _kbuild_
- Lenguaje _Makefile_
- Créditos
- `TODO`
  

### [Introducción](i2) ###

Los archivos _Makefiles_ contienen cinco partes:

_Makefile_ 												El principio del archivo.
`.config` 													el archivo de configuración del kernel.
`arch/$(ARCH)/Makefile`  la arquitectura del archivo _Makefile_.
`scripts/Makefile.*`				  reglas comunes etc. para todos los archivos _Makefiles_ en kabuild.
_kbuild Makefiles_						son cerca de 500.

Al principio del archivo Makefile, será leído el archivo `.config`, el cuál proviene del proceso de configuración del kernel.

El principio del archivo, es responsable de la construcción de dos _elementos_ importantes:
`vmlinux`, la imagen residente del kernel y, los módulos -cualquier archivo de módulo.
Todo esto es construido de manera recursiva, descendiendo a los subdirectorios en el _árbol fuente_ del kernel.
La lista de subdirectorios _visitada_, dependerá de la configuración del kernel. El principio del archivo, incluye textualmente, una arquitectura _Makefile_, con el nombre `arch/$(ARCH)/Makefile`. La arquitectura Makefile, porporciona información específica, acerca de la misma indicada al principio del archivo.

Cada subdirectorio, tendrá un _kbuild Makefile_, el cuál sucede los comandos, de forma secuencial; _de arriba a abajo_. El archivo _kbuild Makefile_, utiliza la información del archivo `.config`, para constuir varias listas de archivos, utilizadas por kbuild, para constuir cualquier objetivo modular integrado en la construcción.

`scripts/Makefile.*` contiene todas las definiciones/reglas etc. usada en la construcción del kernel, basado en los archivos _kbuild Makefiles_.


### [Quién hace qué](i3) ###

Las personas, tienen cuatro _relaciones_ distintas, con los Makefiles del kernel.

__Usuarios__: personas que construyen kernels. Aquellos, que escribirían comandos tales como; `make menuconfig` ó `make`. Es habitual que no lean o editen ningún _Makefile_ del kernel -o cualquier otro archivo fuente.

__Desarrollador regular__, trabajan en características tales, como _controladores de dispositivo_, _sistemas de archivo_ y, _protocolos de red_. Estas personas, necesitan _mantener_ los archivos , del subsistema en el que tabajan. Para llevar a cabo esta tarea, es necesario cierto conocimiento acerca de los archivos kbuild Makefiles, además de otros aspectos relacionados con la interfase pública de kbuild.

__Desarrollador de arquitectura__, persnas que trabajan en una _plataforma_ en particular. Como `sparc` o `ia64`. Los desarrollador de plataforma, necesitan conocer tanto el Makefile como los archivos kbuild Makefiles relacionados.

__Desarrollador kbuild__,  trabajan en el _sistema de construcción del kernel_, en sí mismo.
Imprescindible conocer todos los aspectos relativos a los archivos Makefile del kernel.

El presente documento está dirigido al __Desarrollador regular__ y al __Desarrollador de arquitectura__.


### [Los archivos _kbuild_](i3i1) ###

La mayoría de _Makefiles_[f1](#f1) parte del kernel, son archivos tipo _Makefile_, que hará uso de la infraestructura _kbuild_. Este capítulo intruduce la sintaxis utilizada en tales archivos -_kbuild Makefiles_.
El nombre preferido para estos archivos _kbuild_, es _Makefile_, aunque _kbuild_ es igualmente usado. Si ambos archivos existen, será empleado _kbuild_.

La Sección [Definición de objetivos](#i3i1i1) es una rápida introducción, otros capítulos proporcionan más detalle, con ejemplos reales.

### [Definición de objetivos](i3i1i1) ###

La definición de objetivos es la parte principar -el corazón, del los archivos _kbuiild_.
Estas líneas, definen los archivos a ser construidos, cualquier opción de compilación y, cualquier subdirectorio al que _entrar recursivamente_.

El archivo makefile kbuild mas simple, contiene una línea:

Ejemplo,

		obj-y += foo.o

Esto dice a kbuild que hay un objeto en el directorio, llamado `foo.o` a ser construido desde `foo.c` o `foo.S`.

Si `foo.o` debiera ser construido como módulo, será empleada la variable `obj-m`.
Consecuentemente, será utilizado el siguiente patrón.

Ejemplo,

		obj-$(CONFIG_FOO) += foo.o

`$(CONFIG_FOO)` evalua tanto `y` -como parte de, o `m` -por módulo.
Si `CONFIG_FOO` no es ni `y` ni `m`, entonces el archivo no será compilado o enlazado.