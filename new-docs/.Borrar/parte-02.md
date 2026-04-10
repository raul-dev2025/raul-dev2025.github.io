Ejemplo,
		subdir-ccflags-y := -Werror
		
		CFLAGS_$@, AFLAGS_$@

`CFLAGS_$@` y `AFLAGS_$@`, únicamente son aplicables, a comandos en el makefile kbuild activo.

`$(CFLAGS_$@)` especifica opciones por archivo, con `$(CC)`. La parte `$@`, tiene un valor literal, el cuál especifica el archivo para el que és.

Ejemplo,

		# drivers/scsi/Makefile
		CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
		CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ \
				     -DGDTH_STATISTICS

Estas dos líneas especifican las opciones de compilación para `aha152x.o` y `gdth.o`.

`$(AFLAGS_$@)` es una característica similar, para los archivos fuente, en lenguaje ensamblador.

Ejemplo,
		# arch/arm/kernel/Makefile
		AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)
		AFLAGS_crunch-bits.o := -Wa,-mcpu=ep9312
		AFLAGS_iwmmxt.o      := -Wa,-mcpu=iwmmxt
		

### [Seguimiento de las dependencias](i3i1i9) ###

Kbuild _sigue las dependencias_, así:
- 1. Todos los archivos requeridos(tanto `*.c` como `*.h`).
- 2. Todas las opciones `CONFIG_`, en archivos requeridos.
- 3. La líne de comandos utilizada, para compilar el objetivo.

Por tanto, de cambiar la opción `$(CC)`, todos los archivos afectados serán recompilados.


### [Reglas especiales](#i3i1i10) ###

Son utilizadas reglas especiales cuando la infraestructura kbuild, no proporcione el soporte requerido. Un ejemplo típico, son los archivos de _cabecera_ generados durante el proceso de construcción.
Otro ejemplo, son los Makefiles específicos de la _arquitectura_, los cuales necesitan reglas especiales, en la _composición_ de imágenes de arranque etc.

Las reglas especiales, son escritas como reglas normales Make.
Kbuild no será ejecutado en el directorio, donde el Makefile es localizado, así que las _reglas especiales_, deberían proporcionar una ruta relativa a archivos _pre-requeridos_ y _archivos objetivo_.

Son utilizadas dos variables en el momento de definir una regla especial:

		$(src)
`$(src)` es una ruta relativa, la cuál apunta al directorio donde está localizado el Makefile. Utilizar siempre `$(src)`, al referir alrchivos localizados en el _árbol_ `src` -fuente.

		$(obj)
`$(obj)` es una ruta relativa, la cuál apunta al directorio donde está guardado el objetivo. Utilizar siempre `$(obj)`, al referir alrchivos generados.

Ejemplo,
		#drivers/scsi/Makefile
		$(obj)/53c8xx_d.h: $(src)/53c7,8xx.scr $(src)/script_asm.pl
			$(CPP) -DCHIP=810 - < $< | ... $(src)/script_asm.pl

Es esta una regla especial; siguiendo la sintaxis habitual requerida por make.
El _objetivo_, depende de dos _pre-requisitos_ de archivo. Referencias al _archivo objetivo_, añaden el prefijo `$(obj)`, referencias a _pre-requisitos_, añaden `$(src)` -puesto que no son archivos generados.

		$(kecho)
Presentar información al usuario mediante una _regla_, resulta una buena práctica, pero al ejecutar `make -s`, no cabe esperar ver ninguna salida, exceptuando _avisos/errores_ -warning/errors.
Para dar soporte a lo anterior, kbuild define `$(kecho)`, presentando el texto seguido de `$(kecho)` sobre la salida estandar(fd1), salvo si es utilizado `make -s`.

Ejemplo,
		#arch/blackfin/boot/Makefile
		$(obj)/vmImage: $(obj)/vmlinux.gz
			$(call if_changed,uimage)
			@$(kecho) 'Kernel: $@ is ready'
			

