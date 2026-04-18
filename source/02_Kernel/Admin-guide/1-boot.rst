.. contents:: Tabla de contenidos

:depth: 3


.. _1-boot_1:

=============================
Referencias y agradecimientos
=============================

.. _1-boot_2:

El protocolo de arranque de Linux/86
------------------------------------

.. _1-boot_3:

Introducción
~~~~~~~~~~~~

En plataformas x86, el kernel de Linux utiliza una serie de convenciones para el arranque. Estas han evolucionado debido a aspectos históricos, así como la intención, en etapas iniciales, de que el kernel en sí mismo, fuese una imagen arrancable,

El complicado modelo de memoria PC, en un PC […] debido al cambio de espectativas en la insdustria del PC causada por efectiva desaparición, muerte, defunción, término como sistema operativo de *rama principal*, línea general

Actualmente, existen las siguientes versiones para el protocolo de arranque de *Linux/86*.

Anteriores kernels: sólo soporte a_zimage/image\_. Alguno de los primeros kernels, podrían incluso, no dar soporte a la línea de comandos.

**Protocolo 2.00**: (kernel 1.3.73) Añadido el soporte a *bzimage* e *initrd*, así como la formalización de un procedimiento para comunicar al kernel, con el gestor de arranque. ``setup.S`` hizo *recolocable* al miso, aunque el area de configuración tradicional, continúa siendo *escribible*.

**Protocolo 2.01**: (kernel 1.3.76) Añadida una advertencia, para la *sobrecarga de pila*.

**Protocolo 2.02**: (kernel 2.4.0-test3-pre3) Nuevo protocolo, para la línea de comandos. Alcanzado el límite de memoria convencional. No hay sobreescritura en el área de configuración tradicional, facilitando un arranque seguro, en sistemas que utilizan EBDA desde SMM o un punto de entrada en la BIOS de 32-bit. Depreciada *zimage*, aunque mantenido el soporte.

**Protocolo 2.03**: (kernel 2.4.18-pre1) de forma explícita, se pone initdr a disposición del gestor de arranque, en una dirección lo más alta posible.

**Protocol 2.04**: (Kernel 2.6.14) Extendido el tamaño de campo ``syssize``, a cuatro bytes.

**Protocol 2.05**: (Kernel 2.6.20) Construido el modo, *protegido* del kernel como *recolocable*. Son introducidos los campos ``relocatable_kernel`` y ``kernel_alignment``.

**Protocol 2.06**: (Kernel 2.6.22) Añadido un campo, conteniendo el tamaño de la línea de comandos para el arranque.

**Protocol 2.07**: (Kernel 2.6.24) Añadido: *paravirtualización*, como el protocolo de arranque. Son intorucidas ``hardware_subarch``\ y ``hardware_subarch_data`` y, las opciones ``KEEP_SEGMENTS`` en ``load_flags``.

**Protocol 2.08**: (Kernel 2.6.26) Añadida la *suma de comprovación* ``crc32`` y el formato ELF de *payload(punto de carga?)*. Introducidos los campor ``payload_offset`` y ``payload_length`` para ayudar a localizar el *payload*.

**Protocol 2.09**: (Kernel 2.6.26) Añadido un campo tipo *puntero físico* de 64-bit, en una lista enlazada de ``struct  setup_data``.

**Protocol 2.10**: (Kernel 2.6.31) Añadido el protocolo para el *alineamiento relajado*, tras añadir ``kernel_alignment``, nuevos campos ``init_size`` y ``pref_address``. Añadida la extensión de identificador -ID, al gestor de arranque.

**Protocol 2.11**: (Kernel 3.6) Añadido un campo para el *offset* de EFI asistido, protocolo para el punto de entrada.

**Protocol 2.12**: (Kernel 3.8) Añadido el campo ``xloadflags`` y extensión de campos, en el ``struct`` -la estrctura, ``boot_params``, para *bzImage* en carga y, el disco ram por encima de los 4G en 64bit.

.. _1-boot_4:

Capa de memoria
~~~~~~~~~~~~~~~

El mapa de memoria tradicional para el cargador del kernel, utilizó una Imagen o *zImage* del kernel, parecida:

::

           |            |
       0A0000  +------------------------+
           |  Reserved for BIOS     |  Do not use.  Reserved for BIOS EBDA.
       09A000  +------------------------+
           |  Command line      |
           |  Stack/heap        |  For use by the kernel real-mode code.
       098000  +------------------------+  
           |  Kernel setup      |  The kernel real-mode code.
       090200  +------------------------+
           |  Kernel boot sector    |  The kernel legacy boot sector.
       090000  +------------------------+
           |  Protected-mode kernel |  The bulk of the kernel image.
       010000  +------------------------+
           |  Boot loader       |  <- Boot sector entry point 0000:7C00
       001000  +------------------------+
           |  Reserved for MBR/BIOS |
       000800  +------------------------+
           |  Typically used by MBR |
       000600  +------------------------+ 
           |  BIOS use only     |
       000000  +------------------------+

Al utilizar *bzImage*, el *modo protegido* del kernel, fue recolocado en ``0x100000`` -*memoria alta* y, el bloque del kernel en modo real -sector de arranque, configuración, pila/montón, fue hecha recoloable sobre cualquier dirección entre ``0x100000`` y el final de la *memoria baja*. Desafortunadamente, en los protocolos 2.00 y 2.01, el rango de memoria ``0x90000+``, continúa siendo utilizado por el kernel; el protocolo 2.02, resuelve este problema.

Es preferible guardar el *techo de memoria* -el punto más alto en una memoria baja, controlado por el gestor de arranque; tan bajo como sea posible, debido a que recientes BIOS, han empezado a colocar grandes cantidades de memoria. Llamada *Área de Datos Extendida BIOS*; junto a la parte más alta de la *memoria baja*. El gestor de arranque debería utilizar la ``llamada()`` a la BIOS ``INT 12h``, para verificar la cantidad de memoria disponible.

Desgraciadamente, si ``INT 12h`` devuelve una cantidad de memoria demasiado baja(pequeña?), no hay nada que pueda hacer el gestor de arranque, para comunicar el error al usuario. Por lo tanto, el gestor de arranque, debería estar diseñado para tomar espacios de memoria, en la memoria baja, tan pequeños como pueda.

En imágenes ``zimage`` o anteriores imágenes del kernel ``bzimage``, la cuales necesitan escribir datos en el segmento ``0x90000``, el gestor de arranque debería asegurarse de no utilizar memoria por enciama ``0x9A000``; hay muchas BIOS que *fallarán (to break)* por encima de este punto.

En una imagen ``bzimage`` moderna, protocolo de arranque versión *>= 2.02*, es recomendable un *modelo de memoria* como el que sigue:

::

           ~                        ~
                   |  Protected-mode kernel |
       100000  +------------------------+
           |  I/O memory hole   |
       0A0000  +------------------------+
           |  Reserved for BIOS     |  Leave as much as possible unused
           ~                        ~
           |  Command line      |  (Can also be below the X+10000 mark)
       X+10000 +------------------------+
           |  Stack/heap        |  For use by the kernel real-mode code.
       X+08000 +------------------------+  
           |  Kernel setup      |  The kernel real-mode code.
           |  Kernel boot sector    |  The kernel legacy boot sector.
       X       +------------------------+
           |  Boot loader       |  <- Boot sector entry point 0000:7C00
       001000  +------------------------+
           |  Reserved for MBR/BIOS |
       000800  +------------------------+
           |  Typically used by MBR |
       000600  +------------------------+ 
           |  BIOS use only     |
       000000  +------------------------+

… donde la dirección ``X``, es tan baja, como prermite el diseño del gestor de arranque.

.. _1-boot_5:

La cabecera del kernel, modo real
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En el siguiente texto y, en cualquier parte en la secuencia de arranque del kernel, un “sector” es referido como 512 bytes. Es independiente del tamaño de sector del medio subyacente.

El priemer paso para cargar una kernel Linux, debería ser cargar el código en modo *real* -sector de arranque y código de configuración. Después examinar la siguiente *cabecera* en el ``offset`` ``0x01f1``. El código del *modo real*, puede sumar un total de 32K, aunque el gestor de arranque podría escoger, el cargar únicamente los primeros dos sectores (1K) y, examinar entonces, el tamaño del sector de arranque.

La cabecera se parece a ésto:

::

       Offset  Proto   Name        Meaning
       /Size

       01F1/1  ALL(1   setup_sects The size of the setup in sectors
       01F2/2  ALL root_flags  If set, the root is mounted readonly
       01F4/4  2.04+(2 syssize     The size of the 32-bit code in 16-byte paras
       01F8/2  ALL ram_size    DO NOT USE - for bootsect.S use only
       01FA/2  ALL vid_mode    Video mode control
       01FC/2  ALL root_dev    Default root device number
       01FE/2  ALL boot_flag   0xAA55 magic number
       0200/2  2.00+   jump        Jump instruction
       0202/4  2.00+   header      Magic signature "HdrS"
       0206/2  2.00+   version     Boot protocol version supported
       0208/4  2.00+   realmode_swtch  Boot loader hook (see below)
       020C/2  2.00+   start_sys_seg   The load-low segment (0x1000) (obsolete)
       020E/2  2.00+   kernel_version  Pointer to kernel version string
       0210/1  2.00+   type_of_loader  Boot loader identifier
       0211/1  2.00+   loadflags   Boot protocol option flags
       0212/2  2.00+   setup_move_size Move to high memory size (used with hooks)
       0214/4  2.00+   code32_start    Boot loader hook (see below)
       0218/4  2.00+   ramdisk_image   initrd load address (set by boot loader)
       021C/4  2.00+   ramdisk_size    initrd size (set by boot loader)
       0220/4  2.00+   bootsect_kludge DO NOT USE - for bootsect.S use only
       0224/2  2.01+   heap_end_ptr    Free memory after setup end
       0226/1  2.02+(3 ext_loader_ver  Extended boot loader version
       0227/1  2.02+(3 ext_loader_type Extended boot loader ID
       0228/4  2.02+   cmd_line_ptr    32-bit pointer to the kernel command line
       022C/4  2.03+   initrd_addr_max Highest legal initrd address
       0230/4  2.05+   kernel_alignment Physical addr alignment required for kernel
       0234/1  2.05+   relocatable_kernel Whether kernel is relocatable or not
       0235/1  2.10+   min_alignment   Minimum alignment, as a power of two
       0236/2  2.12+   xloadflags  Boot protocol option flags
       0238/4  2.06+   cmdline_size    Maximum size of the kernel command line
       023C/4  2.07+   hardware_subarch Hardware subarchitecture
       0240/8  2.07+   hardware_subarch_data Subarchitecture-specific data
       0248/4  2.08+   payload_offset  Offset of kernel payload
       024C/4  2.08+   payload_length  Length of kernel payload
       0250/8  2.09+   setup_data  64-bit physical pointer to linked list
                       of struct setup_data
       0258/8  2.10+   pref_address    Preferred loading address
       0260/4  2.10+   init_size   Linear memory required during initialization
       0264/4  2.11+   handover_offset Offset of handover entry point

..

(1) Por compatibilidad, si el campo ``setup_sects`` contiene ``0``, el valor real es 4. (2) En versiones de protocolo anteriores a v2.04, los dos bytes más altos en el campo ``syssize`` son no-utilizables, lo que significa que el tamaño de la imagen ``bzimage`` del kernel, no podrá ser determinada. (3) Ignorado, aunque segura su configuración, con protocolos ``v2.02`` a ``v2.09``.

Si el *número mágico* en *HdrS* ``0x53726448`` no es encontrado en el *offset* ``0x202``, la versión del protocolo de arranque es *vieja*. Para la carga de un kernel *antiguo*, deberían asumirse los siguientes parámetros:

::

       Image type = zImage
       initrd not supported
       Real-mode kernel must be located at 0x90000.

De cualquier otra forma, el campo ``versión`` contiene la versión del protocolo. Ejemplo, la versión del protocolo *2.01* contendrá en su campo ``0x0201``. Al establecer los campos en la cabecera, habrá que comprobar que sean configurados únicamente los campos con soporte al protocolo de versión en uso.

.. _1-boot_6:

Detalles en los campos de la cabecera
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Por cada campo, algunos, son información de *lectura* desde el kernel al gestor de arranque. Otros, serán considerados como de *escritura*, para el gestor de arranque y, algunos otros, interpretados como *lectura y escritura*; son *modificables* por el gestor de arranque.

Los gestores de arranque de *propuesta general*, deberían escribir los campos marcados como *obligatorios*. Los gestores de arranque que carguen el kernel en una dirección no estandar, deberían rellenar los campos marcados como ``reloc``; otros gestoroes podrán ignorar estos campos.

El *orden de byte* de todos los campos es **littlleEndian** -esto es x86.

::

       Field name: setup_sects
       Type:       read
       Offset/size:    0x1f1/1
       Protocol:   ALL

El tamaño del código de configuración en sectores de 512-byte. Si el campo es ``0``, el valor real es ``4``. El código del modo real, consiste en el sector de arranque -siempre un sector de 512-byte, más el código de configuración.

::

       Field name:  root_flags
       Type:        modify (optional)
       Offset/size:     0x1f2/2
       Protocol:    ALL

Si el campo no es cero, la raíz será de *sólo lectura*. El uso de este campo es depreciado; utilizar las *opciones de línea* ``ro`` ó ``rw``, en su lugar.

::

       Field name: syssize
       Type:       read
       Offset/size:    0x1f4/4 (protocol 2.04+) 0x1f4/2 (protocol ALL)
       Protocol:   2.04+

El tamaño del código en *modo protegido* en unidades es un parágrafo de 16-byte. En versiones del protocolo anteriores a ``2.04``, el campo es de tan sólo 2-byte de amplitud, por lo que no puede considerarse como el tamaño de un kernel, si la opción ``LOAD_HIGH`` fue establecida.

::

       Field name: ram_size
       Type:       kernel internal
       Offset/size:    0x1f8/2
       Protocol:   ALL

Es un campo obsoleto.

::

       Field name: vid_mode
       Type:       modify (obligatory)
       Offset/size:    0x1fa/2

Por favor, ver la sección Opciones de línea de comando especiales .

::

       Field name: root_dev
       Type:       modify (optional)
       Offset/size:    0x1fc/2
       Protocol:   ALL

El número de dispositivo raiz, por defecto. El empleo de este campo es derpeciado, utlizar la opción de línea\ ``root=`` en su lugar.

::

       Field name: boot_flag
       Type:       read
       Offset/size:    0x1fe/2
       Protocol:   ALL

Contiene ``0xAA55``. Es la *aproximación* más cercana de un kernel antiguo, al *número mágico*.

::

       Field name: jump
       Type:       read
       Offset/size:    0x200/2
       Protocol:   2.00+

Contiene un *salto de instrucción x86*, ``0xEB`` seguido de un *offset* señalado -(de señal +/-)?, relativo al byte ``0x202``. Esto puede ser utilizado para determinar el tamaño de la cabecera.

::

       Field name: header
       Type:       read
       Offset/size:    0x202/4
       Protocol:   2.00+

Contiene el *número mágico* “HdrS” ``0x53726448``.

::

       Field name: version
       Type:       read
       Offset/size:    0x206/2
       Protocol:   2.00+

Contiene la versión del protocolo de arranque, en formato *(major << 8)+minor*. Ejemplo, ``0x0204`` para la versión ``2.04``, y ``0x0a11`` para una hipotética versión ``10.17``.

::

       Field name: realmode_swtch
       Type:       modify (optional)
       Offset/size:    0x208/4
       Protocol:   2.00+

Enlace del gestor de arranque. Ver Enlaces avanzados al gestor de arranque , abajo.

::

       Field name: start_sys_seg
       Type:       read
       Offset/size:    0x20c/2
       Protocol:   2.00+

La carga de segmentos *bajos* ``0x1000``. Obsoleto.

::

       Field name: kernel_version
       Type:       read
       Offset/size:    0x20e/2
       Protocol:   2.00+

Si es establecido a un valor *no-cero*, contendrá un puntero a una *cadena* con el número de versión del kernel, en *formato legible* y, con *terminación nula* menor que ``0x200``. Puede utilizarse para mostrar al usuario, el número de versión del kernel. Debería ser un valor menor, que ``0x200*setup_sects``.

Por ejemplo, si el valor es configurado a ``0x1c00``, el número de versión del kernel podrá encontrarse en el *offset* ``0x1e00``, en el archivo del kernel. El valor es considerado válido, sólo si el campo ``setup_sects`` contiene el valor ``15`` u otro más alto:

::

       0x1c00  < 15*0x200 (= 0x1e00) but
       0x1c00 >= 14*0x200 (= 0x1c00)

``0x1c00 >> 9 = 14``, por lo que esl valor mínimo para ``setup_secs`` es 15.

::

       Field name: type_of_loader
       Type:       write (obligatory)
       Offset/size:    0x210/1
       Protocol:   2.00+

Si tu gestor de arranque tiene asignado un ID -ver más abajo, completar con ``0xTV``, donde ``T`` es un identificador para el gestor de arrqnque y, ``V`` es un número de versión. De caulquier otro modo, completar con ``0xFF``.

Para IDs del gestor de arranque, encima de ``T = 0xD``, completar con ``T = 0xE`` en este campo y, escrubur el ID extendido menos ``0x10`` en el campo ``ext_loader_type``. Similarmente, el campo ``ext_loader_ver``, podrá utilizarse para proporcionar más de cuatro bits a la *versión del gestor de arraque*.

Por ejemplo, en ``T = 0x15, V = 0x234`` completar con:

::

       type_of_loader  <- 0xE4
       ext_loader_type <- 0x05
       ext_loader_ver  <- 0x23

IDs asignados al gestor de arranque(hexadecimal):

::

       0  LILO         (0x00 reservado a gestores pre-2.00)
       1  Loadlin
       2  bootsect-loader  (0x20, reservados, el resto de valores)
       3  Syslinux
       4  Etherboot/gPXE/iPXE
       5  ELILO
       7  GRUB
       8  U-Boot
       9  Xen
       A  Gujin
       B  Qemu
       C  Arcturus Networks uCbootloader
       D  kexec-tools
       E  Extended     (ver ext_loader_type)
       F  Special      (0xFF = undefined)
                 10  Reservado
                 11  Minimal Linux Bootloader <http://sebastian-plotz.blogspot.de>
                 12  OVMF UEFI virtualization stack

Por favor, contactar con hpa@zytor.com si fuese necesario asignar un ID al gestor de arranque.

::

       Field name: loadflags
       Type:       modify (obligatory)
       Offset/size:    0x211/1
       Protocol:   2.00+

Este campo es una máscara de bit -bitmask.

Bit 0 (read): LOADED_HIGH - Si ``0``, el código en modo protegido es cargado en ``0x10000``. - Si ``1``, el código en modo protegido es cargado en ``0x100000``.

Bit 1 (kernel interno): KASLR_FLAG - Utilizado internamente por el kernel comprimido para comunicar - KASLR *estado* apropiado del kernel. - Si ``1``, KASLR activado. - Si ``0``, KASLR desactivado.

Bit 5(escritura): ``QUIET_FLAG`` - Si ``0``, imprime mensajes iniciales. - Si ``1``, suprime mensajes iniciales. Esta petición al kernel -decompresor y kernel temprano, no escribe mensajes iniciales que requieran acceso al *hardware* mostrado directamente.

Bit 6 (escritura): ``KEEP_SEGMENTS`` Protocolo: 2.07+ - Si ``0``, recarga los registros de segmento en el punto de entrada de 32bit. - Si ``1``, no recarga los registros de segmento en el punto de entrada de 32bit. - Asume que ``%cs %ds %ss %es`` serán configurados al nivel de segmento en base a ``0`` -ó su equivalente en su entorno.

Bit 7 (escritura): ``CAN_USE_HEAP`` Establece el bit a ``1``, para indicar que el valor asignado a ``heap_end_ptr`` es válido. Si el campo está vacio, cierta funcionalidad del código de configuración, será desactivada.

::

       Field name: setup_move_size
       Type:       modify (obligatory)
       Offset/size:    0x212/2
       Protocol:   2.00-2.01

Al utilizar el protocolo ``2.00`` o ``2.01``, si el modo real del kernel no es cargado en ``0x90000``, será movido ahí posteriormente, en *cargas sucesisvas*. Completar el campo, si fuese necesarios mover datos adicionales -como la línea de comandos del kernel, en adición al mode real del kernel.

La unidad son bytes, desde el principio del sector de arranque.

Podrá ignorarse el campom cuando el protocolo sea ``2.02`` o más alto, ó si el código del modo real fuese cargado en ``0x90000``.

::

       Field name: code32_start
       Type:       modify (optional, reloc)
       Offset/size:    0x214/4
       Protocol:   2.00+

La dirección de salto, en modo protegido. Establece los valores por defecto, en la dirección de cara del kernel y, puede ser utilizada por el gestor de arranque para determinar la dirección apropiada.

El campo podrá ser modificado:

1. como enlace al gestor de arranque -ver Enlaces avanzados al gestor de arranque

2. si un gestor de arranque, el cuál no instala el enlace, carga un kernel *recolocable*, sobre una dirección no estandar, tendrá que modificar este campo para apuntar la dirección de carga.

   ::

       Field name: ramdisk_image
       Type:       write (obligatory)
       Offset/size:    0x218/4
       Protocol:   2.00+

La dirección lineal de 32bit, del disco ram o ramfs inicial. Deja a ``0`` cero, si no hubiese disco ram inicial, o ramfs.

::

       Field name: ramdisk_size
       Type:       write (obligatory)
       Offset/size:    0x21c/4
       Protocol:   2.00+

Tamaño del disco ram inicial o ramfs. Deja a ``0`` cero, si no hubiese disco ram inicial, o ramfs.

::

       Field name: bootsect_kludge
       Type:       kernel internal
       Offset/size:    0x220/4
       Protocol:   2.00+

Campo obsoleto.

::

       Field name: heap_end_ptr
       Type:       write (obligatory)
       Offset/size:    0x224/2
       Protocol:   2.01+

Establce el campo con el *offset* -desde el principio del código en modo real, del final configurado en pila/montón, menos ``0x0200``.

::

       Field name: ext_loader_ver
       Type:       write (optional)
       Offset/size:    0x226/1
       Protocol:   2.02+

Campo utilizado como extensión al número de versión en ``type_of_loader``. El número de versión total, será considerado ``(type_of_loader & 0x0f) + (ext_loader_ver << 4)``.

Uso de este campo en particular, para el gestor de arranque. Si no está escrito, es ``0`` cero.

Kenels anteriores a ``v2.6.31``, no reconocerán el campo, aunque es seguro escribirlo con protocolos ``v2.02`` o posteriores.

::

       Field name: ext_loader_type
       Type:       write (obligatory if (type_of_loader & 0xf0) == 0xe0)
       Offset/size:    0x227/1
       Protocol:   2.02+

Campo utilizado como extensión al tipo de número en ``type_of_loader``. Si el tipo en ``type_of_loader`` es ``0xE``, entoces será ``ext_loader_type + 0x10``.

El campo es ignorado si el tipo ``type_of_loader`` no es ``0xE``.

Kenels anteriores a ``v2.6.31``, no reconocerán el campo, aunque es seguro escribirlo con protocolos ``v2.02`` o posteriores.

::

       Field name: cmd_line_ptr
       Type:       write (obligatory)
       Offset/size:    0x228/4
       Protocol:   2.02+

Establece el campo en una dirección lineal de la cónsola del kernel. La línea de comandos del kernel, podrá ser localizada en cualquier parte entre en final establecido del montón -heap, y ``0xA0000``; no tiene porqué estar localizado en los mismos 64K del segmento, como lo estaría el *modo real* en sí mismo.

Completar este campo, incluso si el gestor de arranque no soporta la línea de comando, en cuyo caso, puede apuntarse a cualquier cadena vacía -o aún mejor, a la cadena “auto”. Si el campo mantiene ``0``, el kernel asumirá que el gestor de arranque no soporta el protocolo ``2.02+``.

::

       Field name: initrd_addr_max
       Type:       read
       Offset/size:    0x22c/4
       Protocol:   2.03+

La dirección más alta, que pueda ocupar el contenido del disco ram inicial. En protocolos ``2.02`` o anteriores, el campo no estará presente, siendo la máxima dirección ``0x37FFFFFF``. Esta dirección es definida como la dirección más alta de *byte seguro*, por lo que si el disco ram es exáctamente de ``131072`` bytes, en tamaño y, el campo es ``0x37FFFFFF``, el disco ram podrá comenzar en ``0x37FE0000``.

::

       Field name: kernel_alignment
       Type:       read/modify (reloc)
       Offset/size:    0x230/4
       Protocol:   2.05+ (read), 2.10+ (modify)

Unidad de alineamiento requerida por el kernel. Si ``relocatable_kernel`` es ``true``. Un kernel recolocable que sea cargado en un alineamiento incompatible con el valor en este campo, será realineado durante la inicialización del kernel.

Empezando con el protocolo de versión ``2.10``, representa la preferencia de alineamiento, para un rendimiento óptimo. Es posible que el gestor modifique el campo, para evitar menos alineamientos. Ver ``min_alignment`` y ``pref_address`` más abajo.

::

       Field name: relocatable_kernel
       Type:       read (reloc)
       Offset/size:    0x234/1
       Protocol:   2.05+

Si el campo no es cero, la parte del kernel en modo protegido, podrá ser cargada en cualquier dirección, que satisfaga el campo ``kernel_alignment``. Después de la carga, el gestor de arranque deberá establecer ol código del campo ``code32_start`` para que apunte al códig cargado, o al enlace del gestor.

::

       Field name: min_alignment
       Type:       read (reloc)
       Offset/size:    0x235/1
       Protocol:   2.10+

Este campo, si no es cero, indica como potencia de dos, el alineamiento mínimo requerido. En oposición al preferido por el kernel para arrancar. Si el gestor de arranque utiliza este campo, debería actualiza ``kernel_alignment`` con la unidad de alineamiento deseada, típicamente:

::

       kernel_alignment = 1 << min_alignment

Podría haber un considerable coste en rendimiento, de producirse un desalineado excesivo en el kernel. Es más, el gestor debería intentar un alineamiento con potencia de dos, desde ``kernel_alignment`` en adelante.

::

       Field name:     xloadflags
       Type:           read
       Offset/size:    0x236/2
       Protocol:       2.12+

El campo es una máscara de bit -bitmask.

Bit 0 (lectura): ``XLF_KERNEL_64`` - Si ``1``, el kernel tendrá el punto de entrada legado, de 64-bit en ``0x200``.

Bit 1 (read): XLF_CAN_BE_LOADED_ABOVE_4G - Si ``1``, ``kernel/boot_params/cmdline/ramdisk`` podrá superar los 4G.

Bit 2 (read): XLF_EFI_HANDOVER_32 - Si ``1``, el kernel soportará el punto de entrada automático tipo EFI de 32-bit, dado en ``handover_offset``.

Bit 3 (read): XLF_EFI_HANDOVER_64 - Si ``1``, el kernel soportará el punto de entrada automático tipo EFI de 642-bit, dado en ``handover_offset + 0x200``.

Bit 4 (read): XLF_EFI_KEXEC - If 1, the kernel supports kexec EFI boot with EFI runtime support.

Si ``1``, el kernel soportará el arranque EFI con soporte al tiempo de ejecución EFI.

::

       Field name: cmdline_size
       Type:       read
       Offset/size:    0x238/4
       Protocol:   2.06+

El tamaño máximo de la línea de comandos, sin la terminación en cero. Significa que la línea de comandos podrá contener como mucho carácteres ``cmdline_size``. En versiones de protocolos ``2.05`` y anteriores, el tamaño máximo es de ``255``.

::

       Field name: hardware_subarch
       Type:       write (optional, defaults to x86/PC)
       Offset/size:    0x23c/4
       Protocol:   2.07+

En entornos parivirtualizados, los componentes *hardware* a bajo nivel -como el *control de interrupciones*, control de tabla de página y, el acceso al registros para el control de procesos, necesitará ser realizado diréctamente.

El campo permite al gestor de arranque informar al kernel, acerca de su situación en esos entornos.

::

       0x00000000  The default x86/PC environment
       0x00000001  lguest
       0x00000002  Xen
       0x00000003  Moorestown MID
       0x00000004  CE4100 TV Platform

       Field name: hardware_subarch_data
       Type:       write (subarch-dependent)
       Offset/size:    0x240/8
       Protocol:   2.07+

Un puntero a datos específicos de la *sub-arquitectura de hardware*. Actualmente no utilizado, en el entorno por defecto ``x86/PC``, no modificar.

Si no es cero, entonces contiene el *offset* desde el principio del código en modo protegido, al punto de carga -payload.

El punto de carga podrá ser comprimido. Tanto el formato de los datos comprimidos, como los descomprimidos, deberán ser determinados mediante el estandar *números mágicos*. Los formato de compresión actualmente soportados, son gzip (números mágicos 1F 8B or 1F 9E), bzip2 (números mágicos 42 5A), LZMA (números mágicos 5D 00), XZ (números mágicos FD 37), and LZ4 (números mágicos 02 21). El punto de carga es siempre ELF (números mágicos 7F 45 4C 46).

::

       Field name: payload_length
       Type:       read
       Offset/size:    0x24c/4
       Protocol:   2.08+

La longitud del punto de carga.

::

       Field name: setup_data
       Type:       write (special)
       Offset/size:    0x250/8
       Protocol:   2.09+

El puntero físico de 64-bit a ``NULL``, terminado en una lista enlazada simple, del ``struct`` ``setup_data``. Utilizado para definir un mecanismo más extensible, en cuanto a los parámetros del arranque. La definición de la *estructura* ``setup_data``, es como sigue:

::

       struct setup_data {
           u64 next;
           u32 type;
           u32 len;
           u8  data[0];
       };

Dónde, ``next`` es un puntero físico de 64-bit al siguiente nodo de la lista enlazada, el siguiente campo del último nodo es ``0``; el ``type`` es utilizado para identificar el contenido de los datos; ``len`` es la longitud del campo; ``data`` sostiene el *punto de entrada real*.

Esta lista puede ser modificada en cierto grado, durante el proceso de arranque. Es más, al modificar la lista, debería comprobarse siempre, dónde la lista enlazada, contiene entradas.

::

       Field name: pref_address
       Type:       read (reloc)
       Offset/size:    0x258/8
       Protocol:   2.10+

El campo, si no es cero, representa la preferencia, en cuando a la dirección de carga del kernel. Un gestor recolocado, debería intentar cargar en esta dirección, si fuese posible.

Un kernel no recolocable, se moverá a sí mismo de forma incondicional, para *correr* sobre esta dirección.

::

       Field name: init_size
       Type:       read
       Offset/size:    0x260/4

Este campo indica la cantidad de memoria lineal contigua necesaria, empezando desde la dirección del *tiempo de jecución del kernel*, antes de ser capaz de exminar su mapa de memoria. No es lo mismo que el *total de memoria, necesaria para arrancar el kernel*. Puede ser utilizado -el campo, para recolocar el gestor de arranque, en ayuda a una selección segura de dirección de carga del kernel.

La dirección de inicio del *tiempo de ejecución*, es determinada por el siguiente algoritmo:

::

       if (relocatable_kernel)
       runtime_start = align_up(load_address, kernel_alignment)
       else
       runtime_start = pref_address

..

**n. de t.**: los delimitadores de bloque, parecen estar omitidos. Copia literal.

::

       Field name: handover_offset
       Type:       read
       Offset/size:    0x264/4

Es este el ``offset`` desde el principio de la imagen del kernel, al punto de entrada del protocolo EFI. Los *gestores* que utilizen el protocolo EFI, para *arrancar* el kernel, deberían saltar a este punto(``ofsset``).

Ver EFI HANDOVER PROTOCOL  abajo, para más detalles.

.. _1-boot_7:

Suma de comprobación de la imagen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Desde la versión 2.08 en adelante, el CRC-32 es calculado sobre *todo el archivo*, mediante una característica [cita requerida] ``0x04C11DB7`` y un inicial ``0xffffffff``. La suma de comprobación será añadida al final del archivo; consecuentemente el CRC del archivo, hasta el límite especificado con el campo ``syssize`` de la cabecera, es siempre ``0``.

.. _1-boot_8:

Línea de comandos del kernel
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La línea de comandos del kernel, es una herramienta esencial, en la comunicación entre el gestor de arranque y el kernel. Alguna de sus opciones son igulamente relevantes para el própio *gestor*, ver opciones especiales para la línea de comandos .

La línea de comandos es una *cadena* con terminación nula. La longitud máxima podría ser restringida desde el campo ``cmdline_size``. Antes del protocolo version 2.06, el máximo en caracteres fue de 255. Una cadena demasiado larga, será automáticamente alterada por el kernel.

Si la version del protocolo es 2.02, o posterior, la dirección de la línea de comandos la entregará el campo de cabecera ``cmd_line_ptr`` -ver abajo. La dirección podría ser cualquiera; entre el final del montón -*heap*, establecido y, ``0xA0000``.

Si el protocolo de arranque no es la versión 2.02 o posterior, la línea de comandos utilizará el siguiente protocolo:

- En el *offset* ``0x0020`` -palabra, ``cmd_line_magic``, con el *número mágico* ``0xA33F``.

- En el *offset* ``0x0022`` -palabra, ``cmd_line_offset``, introducir el *offset* de la línea del kernel -relativa al inicio del kernel en modo real.

- La línea de comandos del kernel, **debe** estar en la región de memoria cubierta por ``setup_move_size``; podría ser necesario ajustar el campo.

.. _1-boot_9:

Capa de memoria para el código del modo real
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El código del modo real, requiere que la pila/montón -stack/heap, hayan sido configurados, como también la asignación de memoria para la línea de comandos del kernel. Esto es necesario que sea llevado a cabo en en el *megabyte* de memoria más baja en *modo real*.

Destacar en máquinas modernas, amenudo aparece un EBDA -o Area de Datos Extendida de la BIOS, dimensionable. Como resultado, es recomendable utilizar el área más *baja* del *megabyte*.

Desafortunadamente, deberá ser utilizado el segmento de memoria ``0x90000``, bajo las siguientes circunstancias:

- Al cargar una ``zImage`` del kernel ``((loadflags & 0x01) == 0)``. - Al cargar el protocolo de arranque v2.01 o anterior.

..

Con los protocolos de arranque 2.00 y 2.01, el código en *modo real*, puden ser cargados en otra dirección, pero internamente serán recolocados en ``0x90000``. Con el protocolo *antiguo*, el código del *modo real*, deberá ser cargado en ``0x90000``.

Al cargar en ``0x90000``, evitar el uso de memoria por encima de ``0x9a000``.

En el protocolo de arranque 2.02 o posterior, la línea de comandos no tiene que estar localizada en el mismo segmento de 64K, como en el código de configuración del *modo real*; está igualmente permitido dar a la pila/montón, el segmento de 64K al completo y, localizar la línea de comandos por encima.

La línea de comandos del kernel, no debería localizarse debajo del código del *modo real*, ni estar localizada en áreas *altas* de memoria.

.. _1-boot_10:

Ejemplo de configuración de arranque
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Como ejemplo de configuración, es asumida la siguiente capa, en el segmento *modo real*:

Al cargar por encima de ``0x90000``, utilizar el segmento al completo:

::

       0x0000-0x7fff    Modo real del kernel
       0x8000-0xdfff    Pila y montón
       0xe000-0xffff   Kernel command line

Este tipo de gestor de arranque, debería incorporar los siguientes campos en la cabecera:

::

       unsigned long base_ptr; /* base address for real-mode segment */

       if ( setup_sects == 0 ) {
           setup_sects = 4;
       }

       if ( protocol >= 0x0200 ) {
           type_of_loader = <type code>;
           if ( loading_initrd ) {
               ramdisk_image = <initrd_address>;
               ramdisk_size = <initrd_size>;
           }

           if ( protocol >= 0x0202 && loadflags & 0x01 )
               heap_end = 0xe000;
           else
               heap_end = 0x9800;

           if ( protocol >= 0x0201 ) {
               heap_end_ptr = heap_end - 0x200;
               loadflags |= 0x80; /* CAN_USE_HEAP */
           }

           if ( protocol >= 0x0202 ) {
               cmd_line_ptr = base_ptr + heap_end;
               strcpy(cmd_line_ptr, cmdline);
           } else {
               cmd_line_magic  = 0xA33F;
               cmd_line_offset = heap_end;
               setup_move_size = heap_end + strlen(cmdline)+1;
               strcpy(base_ptr+cmd_line_offset, cmdline);
           }
       } else {
           /* Very old kernel */

           heap_end = 0x9800;

           cmd_line_magic  = 0xA33F;
           cmd_line_offset = heap_end;

           /* A very old kernel MUST have its real-mode code
                loaded at 0x90000 */

           if ( base_ptr != 0x90000 ) {
               /* Copy the real-mode kernel */
               memcpy(0x90000, base_ptr, (setup_sects+1)*512);
               base_ptr = 0x90000;      /* Relocated */
           }

           strcpy(0x90000+cmd_line_offset, cmdline);

           /* It is recommended to clear memory up to the 32K mark */
           memset(0x90000 + (setup_sects+1)*512, 0,
                      (64-(setup_sects+1))*512);
       }   

.. _1-boot_11:

Carga del resto del kernel
~~~~~~~~~~~~~~~~~~~~~~~~~~

Los 32-bits del kernel -en *modo no real*, empiezan en el *offset* ``(setup_sects+1)*512``, en el archivo del kernel; de nuevo, si ``setup_sects == 0`` el valor real es *4*. Debería ser cargado en la dirección ``0x10000`` en cuanto a una imagen del kernel tipo\ ``Image/zImage`` y, ``0x100000`` para imágenes del kernel ``bzImage``.

La imagen del kernel es del tipo ``bzImage`` si el protocolo es >= 2.00 y el bit ``0x01`` (LOAD_HIGH) en el campo *loadflags* es configurado:

::

       is_bzImage = (protocol >= 0x0200) && (loadflags & 0x01);
       load_address = is_bzImage ? 0x100000 : 0x10000;

..

Nota, imágenes del kernel ``Image/zImage``, podrán tener un tamaño de hasta 512K y utilizar por completo, el rango de memoria ``0x10000-0x90000``. Esto significa que es algo más que un mero requisito, el cargar la parte ``0x90000`` en *modo real*. Kernels ``bzImage`` permiten mayor flexibilidad.

.. _1-boot_12:

opciones especiales para la línea de comandos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si la línea de comandos proporcionada por el gestor de arranque es introducida por el usuario, cabría espera que las siguientes opciones tomasen efecto. Debería evitarse borrarlas, incluso si el kernel no hiciese uso de las mismas. *Autores* del gestor de arranque, con necesidad de opciones adicionales en *la línea de comandos*, para el própio gestor, deberían registrarlas en ``Documentation/admin-guide/kernel-parameters.rst`` y, comprobar que no existen conflictos con las opciones activas del kernel, ahora o en el futuro.

``vga=<mode>`` ``<mode>`` aquí es un *entero* -con notación C, en decimal, octal o hexadecimal, o una de las cadenas ``normal`` -valor ``0xFFFF``, ``ext`` -valor ``0xFFFE``, o ``ask`` -valor ``0xFFFD``. Estos valores deberían ser introducidos en el campo ``vid_mode``, puesto que son utilizados por el kernel antes del *análisis de sentencia* de la línea de comandos.

``mem=<size>`` es un *entero* con notación C, opcionalmente seguido por -distingue la Capitalización de la letra, K, M, G, T, P o E, valor ``<< 10, << 20,   << 30, << 40, << 50 or << 60``. Esto indica al kernel, el final de memoria. Afecta al posible emplazamiento de un ``initrd``, ya que debería colocarse cerca del final de memoria. Resaltar, como opción para ambos; el kernel y elgestor de arranque!

``initrd=<file>`` Debería cargar un ``initrd``. El significado de ``<file>``, es obviamente dependiente del gestor. Algunos gestores, ejemplo LILO, no contemplan este comando.

Además, otros gestores añaden las siguientes opciones específicadas por el usuario, a la línea de comandos:

``BOOT_IMAGE=<file>`` La imagen de arranque a ser cargada. Nuevamente, el significado de ``<file>`` es obviamente dependiente del gestor.

``auto`` El kernel arrancó sin una intervención explícita del usuario.

De ser añadidas estas opciones por el gestor, es *más que recomendable*, localizarlas **antes**, de la configuración específica, indicada por el usuario. Al contrario, ``init=/bin/sh`` confundirá la opción ``auto``.

.. _1-boot_13:

Trabajando con el kernel
~~~~~~~~~~~~~~~~~~~~~~~~

El kernel es activado, mediante un *salto* al punto de entrada, el cuál es localizado en el **segmento** *offset* ``0x20``, desde el principio del kernel en modo real. Esto significa que de haber sido cargado el código del kernel en modo real en ``0x90000``, el punto de entrada es ``9020:0000``.

La entradad ``ds = es = ss`` debería apuntar al principio del código del kernel en modo real -``0x9000`` si el código es cargado en ``0x90000``, ``sp`` debería ser configurado apropiadamente, apuntando al principio del *montón*, y las interrupciones, desactivadas. Consecuentemente, para evitar errores en el kernel, es recomendable que el gestor de arranque configure ``fs = gs = ds = es = ss``.

En el ejemplo de arriba, tendría este aspecto:

::

       /* Note: in the case of the "old" kernel protocol, base_ptr must
            be == 0x90000 at this point; see the previous sample code */

       seg = base_ptr >> 4;

       cli();  /* Enter with interrupts disabled! */

       /* Set up the real-mode kernel stack */
       _SS = seg;
       _SP = heap_end;

       _DS = _ES = _FS = _GS = seg;
       jmp_far(seg+0x20, 0);   /* Run the kernel */

Si el gestor de arranque tiene acceso a *disco flexible*, es recomendable apagar el motor al mismo, antes de continuar con el kernel, puesto que el arranque del kernel, dejaría interrupciones apagadas, y el motor no retornaría, especialmente, si el kernel cargado tiene un controlador de disco, configurado como módulo.

.. _1-boot_14:

Enlaces avanzados, para el gestor de arranque
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si el gestor de arranque funciona en una entorno particularmente hostil -como en LOADLIN, bajo sistemas DOS, podría ser imposible seguir los requisitos *estandar de memoria*. Éste gestor, podría utilizar los siguientes enlaces -de configurarlos, serán invocados por el kernel en el momento justo. El uso de estos enlaces, probablemente deberían ser considerados como *último recurso*!

IMPORTANTE: todos los enlaces requieren preservar ``%esp, %ebp, %esi`` y ``%edi``, al invocar.

``realmode_swtch``: Un modo real de 16-bit, lejos de la subrutina invocada inmediatamente antes de entrar en modo protegido. La rutina por defecto desactiva NMI, así que *nuestra* rutina también debería hacerlo.

``code32_start``: Un modo selectivo\* 32-bit con **salto** a la rutina inmediatamente después de la transición al modo protegido, pero antes de la decompresión del kernel. No se garantiza la configuración de ningún segmento, excepto CS -kernels actuales lo hacen, *antiguos* no; deberían configurarse a ``BOOT_DS (0x18)``, manualmente.

Tras completar el enlace, es necesario *saltar* a la dirección que hubo en el campo, antes de que el gestor lo sobreescribiese -recolocar, de ser necesario.

(\*) **flat-mode**, modo piso, modo escalonado, modo nivelado, sírvase de referencia!

.. _1-boot_15:

Protocolo de arranque de 32-bit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En máquinas con nuevas BIOS -más allá de las BIOS legadas, como las EFI, LinuxBios, etc y, ``kexec``, el código de configuración de 16-bit, del modo real, basado en un kernel con BIOS legada; no puede utilizarse, siendo necesario definir un protocolo de arranque de 32-bit.

En el protocolo de arranque de 32-bit, el primer paso al cargar un kernel Linux, debería configurar los parámetros de arranque -la estructura ``boot_params``, tradicionalmente conocida como “página cero”. La memoria de esta *estuctura*, sebería ser situada e inicializada con *todo ceros*. Después, la cabecera de configuración desde el *offset* ``0x01f1`` de la imagen del kernel, en cuál debería cargarse el *struct* ``boot_params`` y ser examinado. El final de la cabecera de configuración, podrá ser calculado como sigue:

::

       0x0202 + byte value at offset 0x0201

Además para leer/modificar/escribir la cabecera de configuración del *struct* ``boot_params`` como protocolo de arranque de 16-bit, el gestor deberá complimentar los campos del mismo, tal y como fue descrito en ``zero-page.txt``.

Después de configurar la estructura ``boot_params``, el gestor podrá cargar el kernel de 32/64-bit, de forma similar al protocolo de arranque de 16-bit.

En el protocolo de arranque de 32-bit, el kernel empiza con un salto al punto de entrada de 32-bit del kernel, el cuál es la dirección de inicio del kernel de 32/64-bit.

De? entrada, la CPU debe estar en el modo protegido de 32-bit, con el paginado desactivado; un GDT deberá cargarse junto a los *descriptores* de los *selectores* ``__BOOT_CS(0x10) y __BOOT_DS(0x18)``; ambos descriptores deberán ser segmentos de 4G?; ``__BOOT_CS`` debe tener permisos de lectura y ejecución y, ``__BOOT_DS`` de lectura y escritura; CS deberá ser ``__BOOT_CS`` y, DS, ES, SS ``__BOOT_DS``; la interrupción debe ser desactivada; ``%esi``, contener la dirección *base* de la estructura ``boot_params``; ``%ebp, %edi y %ebx``, será cero.

.. _1-boot_16:

Protocolo de arranque de 64-bitº
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En máquinas con CPUsde 64bit e igual kernel, podrán utilizar un gestor de arranque de 64bit y, protocolo de arranque de 64-bit.

Sobre protocolos de 64-bit, el primer paso en la carga del kernel Linux, deberían configurarse los parámetros de arranque (``struct boot_params``, tradicionalmente conocido como; página cero). La memoria para dicha estructura, podrá situarse en *cualquier parte*, -incluso por encima de los *4G* y, ser inicializada con ceros. Después, configurar la cabecera de en el *offset* ``0x01f1`` de la imagen del kernel, donde debería ser cargada y, examinada, la estructura ``boot_params``. El *final de configuración*, para la cabecera, podrá obtenerse de la siguiente forma:

::

       0x0202 + byte value at offset 0x0201

Además, para leer/escribir/modificar la configuración de la cabecera de la estructura ``boot_params``, como protocolo de arranque de 16-bit, el gestor debería cumplimentar los campos adicionales del mismo *struct* , tal y como fue descrito en ``zero-page.txt.``.

Después de configurar la estructura ``boot_params``, el gestor podrá cargar el kernel de 32/64-bit, de forma similar al protocolo de arranque de 16-bit, pero el kernel podrá ser cargado *por encima de los 4G*.

En el protocolo de arranque de 32-bit, el kernel empiza con un salto al punto de entrada de 64-bit del kernel, el cuál es la dirección de inicio del kernel de 64-bit mas ``0x200``.

De? entrada, la CPU debe estar en el modo protegido de 64-bit, con el paginado activado. El rango con ``setup_header.init_size`` desde el principio de la dirección del kernel cargado, la “página cero” y el *bufer* de la línea de comandos, tendrán un *mapa* idéntico. Un GDT deberá cargarse junto a los *descriptores* de los *selectores* ``__BOOT_CS(0x10) y __BOOT_DS(0x18)``; ambos descriptores deberán ser segmentos de 4G?; ``__BOOT_CS`` debe tener permisos de lectura y ejecución y, ``__BOOT_DS`` de lectura y escritura; CS deberá ser ``__BOOT_CS`` y, DS, ES, SS ``__BOOT_DS``; la interrupción debe ser desactivada; ``%rsi``, contener la dirección *base* de la estructura ``boot_params``.

.. _1-boot_17:

Automatización del protocolo EFI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Este protocolo permite a los gestores de arranque, deferir la instalación EFI en el arranque? (EFI boot stub). Es necesario el gestor para cargar el *kernel/initrd(s)*, desde el medio de arranque y, saltar al punto de entrada de forma automática? -handover, el cuál es ``hdr->handover_offset`` bytes desde el principio de ``startup_{32,64}``.

La función prototipo, para el *punto de entrada*, es algo similar:

::

       efi_main(void *handle, efi_system_table_t *table, struct boot_params *bp)

``handle`` es la imagen EFI negociada por el gestor de arranque, por el *firmware* EFI, ``table`` es el sistema de tablas EFI -son los dos primeros argumentos del estado, tal y como fue descrito en la sección 2.3 de la especificación UEFI. ``bp`` son parámetros de arranque en la *asignación del cargador?*.

El gestor deberá completar los siguientes campos en ``bp``,

::

       o hdr.code32_start
       o hdr.cmd_line_ptr
       o hdr.ramdisk_image (if applicable)
       o hdr.ramdisk_size  (if applicable)

El resto de campos deberían ser cero.

.. _1-boot_18:

Referencias y agradecimientos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**formato legible**, (human-readable), claro, no resulta natural pedirle al frutero un ``0x0011100110``.

**offset**,

**payload**,

**LIFO**, last in first out

**stack**: pila, se trata de variables locales y estáticas.

**heap**: montón, son varibles globales y dinámicas; grandes variables donde la asignación de memoria se realiza al “vuelo” -o de forma dinámica.

**memoria alta**,

**memoria baja**,

**littlleEndian**

**bigEndian**

**número mágico**

**GDT**

**métodos**

**stub**, colilla, parte restante del lápiz, la parte del cigarrillo que es presionada contra algo, para apagarlo.


.. class:: firma

   **Traducción:** Heliogabalo S.J.
   *www.raulvilchez.org*

