Ejemplo,

		#scripts/lxdialog/Makefile
		hostprogs-y   := lxdialog
		always        := $(hostprogs-y)

Indica a kbuild, el construir `lxdialog` incluso si no hubiese sido referenciado en ninguna regla.


### [Utilización de `hostprogs-$(CONFIG_FOO)`](i4i6) ###

Un patrón habitual en archivos kbuild, tienen este aspecto:

		#scripts/Makefile
		hostprogs-$(CONFIG_KALLSYMS) += kallsyms

Kbuild entiende ambas asignaciones; `y`, para _integrados_, `m`, para módulos.
Por lo que si un símbolo evalúa `m`, kbuild seguirá construyendo el binario. En otras palablas; kbuild gestiona `hostprogs-m` de igual modo a `hostprogs-y`. Aunque es recomendable el empleo de `hostprogs-y`, cuando no hay _símbolos de configuración_ involucrados.


### [_Kbuild_, limpiar infraestructura](i5) ###

`make clean`, borra la mayoría de archivos generados en el _árbol objetivo_, donde es compilado el kernel. Esto incluye los archivos generados como _programas host_.
Kbuild conoce los objetivos listados en `$(hostprogs-y), $(hostprogs-m), $(always),$(extra-y)` y ` $(targets)`. Estos serán borrados los archivos durante `make clean`.
Archivos que coincidan con el patrón `*.[oas]`, `*.ko`, además de otros generados por kbuild, serán borrados del árbol fuente, al ejecutar dicho comando.

Es posible especificar archivos adicionales, mediante la variable `$(clean-files)`.

Ejemplo,

		#lib/Makefile
		clean-files := crc32table.h

Al ejecutar `make clean`, el archivo `crc32table.h` será borrado.
Kbuild asumirá que los archivos están en el mismo directorio relativo al archivo `Makefile`, excepto si fue utilizado el prefijo `$(objtree)`.

Para borrar la _jerarquía_ de directorio -recursivamente:

Ejemplo,

		#scripts/package/Makefile
		clean-dirs := $(objtree)/debian/

Esto borrará el directorio _debian_, empezando por el nivel más alto del directorio, e incluyendo todos los subdirectorios. 

Para exluir ciertos archivos, utilizar la variable `$(no-clean-files)`. Se trata de un caso especial, utilizado en el nivel _más alto_ del archivo kbuild:

Ejemplo,

		#Kbuild
		no-clean-files := $(bounds-file) $(offsets-file)
		
Habitualmente, kbuild desciende a los subdirectorios mediante `obj-* := dir/"`, aunque en estructuras _makefiles_, donde la infraestructura kbuild no es suficiente, algunas veces necesitará ser explicitado.

Ejemplo,

		#arch/x86/boot/Makefile
		subdir- := compressed/

La asignación de arriba, instruye a kbuild para descender al directorio `compressed/`, al ejecutar `make clean`.

El soporte a la infraestructura _clean_ el los _Makefiles_, que construyen la imagen arrancable, dispone de un _objetivo opcional_ llamado _archclean_:

Ejemplo,

		#arch/x86/Makefile
		archclean:
			$(Q)$(MAKE) $(clean)=arch/x86/boot
			
`make clean` descenderá en `arch/x86/boot` y, hará la limpieza habitual. El Makefile localizado en `arch/x86/boot/`, podría utilizar el artificio `subdir-`, para descender _afondo_.

> __Nota 1__: `arch/$(ARCH)/Makefile` no podrá utilizar `subdir-`, puesto que el archivo es incluido en el nivel más alto de _makefile_ y, la infraestructura kbuild no es operativa en ese punto. <br><br> __Nota 2__: todos los directorios listados en `core-y, libs-y, drivers-y` y	`net-y`, serán visitados durante `make clean`.


### [Arquitectura de archivos _Makefiles_](i6) ###

La _raiz_ de Makefile establece el entorno y, hace los preparativos antes de empezar a cescender a directorios individuales.
Contiene una parte genérica, donde `arch/$(ARCH)/Makefile` decidirá qué es requerido con objeto de establecer kbuild, en la arquitectura mencionada.
Así, `arch/$(ARCH)/Makefile` establece un número de variables y define nuevos objetivos.

En la ejecución de kbuild, los siguientes pasos tomarán efecto -aproximádamente:
- 1 Configuración del kenrel => produce `.config`.
- 2 Guarda la versión del kernel en `include/linux/version.h`.
- 3 Actualizar el resto de requisitos, para preparar el _objetivo_:
  - Requisitos adicionales serán especificados en `arch/$(ARCH)/Makefile`
- 4 Descenso recursivo a los directorios en `init-* core* drivers-* net-* libs-*` y la construcción de los objetivos.
  - El valor de las anteriores variables, son expandidos en `arch/$(ARCH)/Makefile`.
- 5 Todos los archivos _objeto_ son enlazados y, el archivo resultante `vmlinux`, localizado en la raíz del ábol objetivo. <br> Los primeros objetos enlazados, serán listados en `head-y`; asignados por `arch/$(ARCH)/Makefile`.
- 6 Finalmente, la parte específica de la arquitectura, efectuará cualquier _pos-procesado_ requerido y, construirá la imagen de arranque final.
  - Esto incluye la construcción de registros de arranque.
  - Preparar la imagen _initrd_ y similares.


### [Configuración de variables, para complementar la construcción de la arquitectura](i6i1) ###

		LDFLAGS		Generic $(LD) options

Opciones utilizadas en todas las invocaciones del enlazador.
Especificar _la emulación_, amenudo es suficiente.

Ejemplo,

		#arch/s390/Makefile
		LDFLAGS         := -m elf_s390
		
> __Nota__: `ldflags-y` puede ser utilizado para personalizar las opciones utilizadas. Ver capítulo [Compilación de opciones](i3i1i7).

`LDFLAGS_vmlinux	Options` for `$(LD)` when linking _vmlinux_.

`LDFLAGS_vmlinux` utilizada para especificar opciones adicionales, pasadas al enlazador, en el momento de concluir el enlace final de la imagen _vmlinx_.
`LDFLAGS_vmlinux` utiliza el soporte a `LDFLAGS_@`.

Ejemplo,
		#arch/x86/Makefile
		LDFLAGS_vmlinux := -e stext

		OBJCOPYFLAGS	objcopy flags
		
En el empleo de `$(call if_changed,objcopy)` para traducir archivos `.o`, serán utilizadas las opciones especificadas en `OBJCOPYFLAGS`.
`$(call if_changed,objcopy)` es habitualmente usado para generar _binarios en crudo_, soble _vmlinux_.

Ejemplo,
		#arch/s390/Makefile
		OBJCOPYFLAGS := -O binary

		#arch/s390/boot/Makefile
		$(obj)/image: vmlinux FORCE
			$(call if_changed,objcopy)

En el ejemplo, el binario `$(obj)/image` es el vinario de una versión de _vmlinux_. El método de uso de `$(call if_changed,xxx)`, será descrita más tarde.

		KBUILD_AFLAGS		$(AS) assembler flags

Valor por defecto; ver _raíz_ de _Makefile_.
Anexar o modificar, de ser requerido por la arquitectura.

Ejemplo,
		#arch/sparc64/Makefile
		KBUILD_AFLAGS += -m64 -mcpu=ultrasparc

		KBUILD_CFLAGS		$(CC) compiler flags

Valor por defecto; ver _raíz_ de _Makefile_.
Anexar o modificar, de ser requerido por la arquitectura.

Frecuentemente, la variable `KBUILD_CFLAGS` depende de la configuración.


