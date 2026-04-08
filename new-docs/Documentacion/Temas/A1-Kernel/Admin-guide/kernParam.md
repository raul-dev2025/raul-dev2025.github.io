1. [Parámetros para la línea de comandos del _kernel_](#i1)
2. [Listas de CPU](#i2)

3. [Referencias y agradecimientos](#i3)

</br>
</br>
#### <a name="i1">Parámetros para la línea de comandos del _kernel_</a>

Los siguientes, son una lista consolidada de parámetros del núcleo implementados por las funciones(macros) `__setup()`, `core_param()` y `module_param()`. Han sido ordenadas alfabéticamente siguiendo el orden del alfabeto Inglés.

El núcleo analiza los parámetros desde la línea de comandos hasta encontrar `--`; si no reconoce el parámetro y no contiene un `.`, el parámetro es pasado a `init`: parámetros con `=` van al entorno de `init`, otros son pasados como argumentos de la línea de comandos a `init`.

Los parámetros de módulos, pueden ser especificados de dos formas: _via_ línea de comandos con un prefijo de nombre de módulo, o _via_ `modprobe`, ejem.

		(línea de comandos kernel) usbcore.blinkenlights=1
		(líne de comandos modprobe)modprobe usbcore blinkenlights=1
		
Los parámetros para módulos, los cuales están construidos _dentro_ del núcleo, necesitan ser especificados en la línea de comandos kernel. `modprobe` busca a través de la línea de comandos kernel (`/proc/cmdline`) y recoge los parámetros de los módulos cuando lee uno, así que la línea de comandos kernel, puede usarse para cargar módulos también.

Los guiones `-` y guión bajo `_` son equivalentes en los nombres de parámetros, así:

		log_buf_len=1M print-fatal-signals=1
		
puede intrerpretarse igual que:
		
		log-buf-len=1M print_fatal_signals=1

Las dobles comillas `"`, son usadas para proteger espacios ` ` en _valores_:

		param="spaces in here"
		
> __parser:__ analizador de sentencias.


#### <a name="i2">Listas de CPU</a>

Algunos parámetros del _kernel_ toman una lista de CPUs como valor ejem.
`isolcpu`, `nohz_full`, `irqaffinity`, `rcu_nocbs`. El formato de estas listas es: 

		<cpu number>,....,<cpu number>

ó

		<cpu number>-<cpu number>
		(debe ser un rango positivo en orden ascendente)

ó una mezcla

		<cpu number>,...,<cpu number>-<cpu number>


Nótese, que para el caso especial de un rango, podría separarse el rango en dos grupos de igual tamaño y, para cada grupo, usar cierta cantidad desde el comienzo de ese grupo:

		<cpu number>-cpu number>:<used size>/<group size>

Por ejemplo, uno podría añadir el siguiente parámetro a la línea de comandos: 

		isolcpus=1,2,10-20,100-2000:2/25
		
Donde el objeto final, representa CPUs 100,101,125,126,150,151,...

El comando `modinfo $(modulName)` muestra una lista actualizada de todos los parámetros de un módulo _cargable_.
Los módulos _cargables_, después de ser cargados dentro del kernel en carrera, también revelarán sus parámetros desde `/sys/module/$(modulname)/parameters/$(parm)`.

Los parámetros listados más abajo, sólo son válidos si ciertas opciones de núcleo, fueron activadas y, si cierto _hardware_ está presente. El texto entre corchetes `[]` al principio de cada descripción, establece las restricciones en el que es aplicable un parámetro:


		ACPI	activado soporte para ACPI
		AGP	AGP (Accelerated Graphics Port) is enabled.
		ALSA	ALSA sound support is enabled.
		APIC	APIC support is enabled.
		APM	Advanced Power Management support is enabled.
		ARM	ARM architecture is enabled.
		AX25	Appropriate AX.25 support is enabled.
		BLACKFIN Blackfin architecture is enabled.
		CLK	Common clock infrastructure is enabled.
		CMA	Contiguous Memory Area support is enabled.
		DRM	Direct Rendering Management support is enabled.
		DYNAMIC_DEBUG Build in debug messages and enable them at runtime
		EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
		EFI	EFI Partitioning (GPT) is enabled
		EIDE	EIDE/ATAPI support is enabled.
		EVM	Extended Verification Module
		FB	The frame buffer device is enabled.
		FTRACE	Function tracing enabled.
		GCOV	GCOV profiling is enabled.
		HW	Appropriate hardware is enabled.
		IA-64	IA-64 architecture is enabled.
		IMA Integrity measurement architecture is enabled.
		IOSCHED	More than one I/O scheduler is enabled.
		IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
		IPV6	IPv6 support is enabled.
		ISAPNP	ISA PnP code is enabled.
		ISDN	Appropriate ISDN support is enabled.
		JOY	Appropriate joystick support is enabled.
		KGDB	Kernel debugger support is enabled.
		KVM	Kernel Virtual Machine support is enabled.
		LIBATALibata driver is enabled
		LP	Printer support is enabled.
		LOOP	Loopback device support is enabled.
		M68k	M68k architecture is enabled.
				These options have more detailed description inside of
				Documentation/m68k/kernel-options.txt.
		MDA	MDA console support is enabled.
		MIPS	MIPS architecture is enabled.
		MOUSE	Appropriate mouse support is enabled.
		MSI	Message Signaled Interrupts (PCI).
		MTD	MTD (Memory Technology Device) support is enabled.
		NET	Appropriate network support is enabled.
		NUMA	NUMA support is enabled.
		NFS	Appropriate NFS support is enabled.
		OSS	OSS sound support is enabled.
		PV_OPS	A paravirtualized kernel is enabled.
		PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
		PARISC	The PA-RISC architecture is enabled.
		PCI	PCI bus support is enabled.
		PCIE	PCI Express support is enabled.
		PCMCIA	The PCMCIA subsystem is enabled.
		PNP	Plug & Play support is enabled.
		PPC	PowerPC architecture is enabled.
		PPT	Parallel port support is enabled.
		PS2	Appropriate PS/2 support is enabled.
		RAM	RAM disk support is enabled.
		RDT	Intel Resource Director Technology.
		S390	S390 architecture is enabled.
		SCSI	Appropriate SCSI support is enabled.
				A lot of drivers have their options described inside
				the Documentation/scsi/ sub-directory.
		SECURITY Different security models are enabled.
		SELINUX SELinux support is enabled.
		APPARMOR AppArmor support is enabled.
		SERIAL	Serial support is enabled.
		SH	SuperH architecture is enabled.
		SMP	The kernel is an SMP kernel.
		SPARC	Sparc architecture is enabled.
		SWSUSP	Software suspend (hibernation) is enabled.
		SUSPEND	System suspend states are enabled.
		TPM	TPM drivers are enabled.
		TS	Appropriate touchscreen support is enabled.
		UMS	USB Mass Storage support is enabled.
		USB	USB support is enabled.
		USBHID	USB Human Interface Device support is enabled.
		V4L	Video For Linux support is enabled.
		VMMIO Driver for memory mapped virtio devices is enabled.
		VGA	The VGA console has been enabled.
		VT	Virtual terminal support is enabled.
		WDT	Watchdog support is enabled.
		XT	IBM PC/XT MFM hard disk support is enabled.
		X86-32	X86-32, aka i386 architecture is enabled.
		X86-64	X86-64 architecture is enabled.
				More X86-64 boot options can be found in
				Documentation/x86/x86_64/boot-options.txt .
		X86	Either 32-bit or 64-bit x86 (same as X86-32+X86-64)
		X86_UV	SGI UV support is enabled.
		XEN	Xen support is enabled


El siguiente texto explica otras opciones:

	BUGS=	Relacionado con posibles errores(bugs) del procesador, en dicho procesador.

	KNL	es un parámetro de arranque del kernel
	BOOT	es un parámetro del gestor de arranque

Los parámetros marcados con BOOT son de hecho, interpretados por el gestor de arranque, y no tienen un significado directo para el kernel.

!!!!!!!!!!!CARD WARNING AQUI
No modificar la sintaxis de los parámetros del gestor de arranque, sin una necesidad extrema o sin ser coordinados con la documentación aportada en:

		<Documentacion>$plataforma/boot.txt

Nótese que todos los parámetros del kernel listados más abajo[Doc](#ref1), hacen distinción entre mayúsculas o no. El símbolo `=` en el nombre de stado de un parámetro, será _entrado_ como _variable de entorno_, donde su ausencia indica que aparecerá como argumente del _kernel_ leíble via `/proc/cmdline` por los programas en carrera, una vez el sistema este en marcha.

El número de parámetros del núcleo, _no es límitado_, pero su longitud _lo está_, a un número fijo de carácteres. Éste límite depende de la arquitectura y, está comprendida entre _256 y 4096 carácteres_. Definido en el archivo `./include/asm/setup.h` como `COMMAND_LINE_SIZE`.

Finalmente, el sufijo `[KMG]` es comunmente descrito después de un número de valores de parámetro. Éstas letras 'K', 'M' y 'G', representan el multiplicador _Kilo, Mega, Giga_, iguales a 2^10, 2^20, and 2^30, `bytes` respectivamente. Estos sufjos de letras, podrán ser omitidos completamente.


> Éste documento podría no estar completamente actualizado.
> Efestivamente, no hay corchetes. La lista de parámetros está copiada, tal y como el traductor la encontró al descargar la fuente.


#### <a name="i3">Referencias y agradecimientos</a>

Documentación extraida de la fuente del _núcleo de linux_.
<a name="ref1">documentación :`kernel-parameters.txt`<a>
