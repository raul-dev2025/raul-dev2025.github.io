1. [Tabla de contenidos](#i1)
2. [Información acerca de las _revisiones_](#i2)
3. [Introducción](#i3)
4. [Punto de entrada en `arch/powerpc`](#i3i11)
5. [Punto de entrada en `arch/arm`](#i3i2)
7. [Punto de entrada en `arch/x86`](#i3i3)
8. [Punto de entrada en `arch/mips/bmips`](#i3i4)
9. [Punto de entrada en `arch/sh`](#i1i5)
10. [El formato de bloque en _DT_](#i4)
11. [Cabecera](#i4i1)
12. [Generalidades del árbol de dispositivo](#i4i2)
13. ["Estructura de bloque" del árbol de dispositivo](#i4i3)
14. ["Cadenas" de bloque del árbol de dispositivo](#i4i4)
15. [Contenido necesario en el árbol de dispositivo](#i5)
16. [Notas sobre la representación de celdas y direcciones](#i5i1)
17. [Notas sobre propiedades compatibles](#i5i2)
18. [Notas sobre nombres de propiedades](#i5i3)
19. [Notas sobre node, propiedades y conjuntos de caractéres](#i5i4)
20. [Notas sobre nodos y propiedades](#i5i5)
21. [El nodo raíz](#i5i5i1)
22. [El nodo `/cpus`](#i5i5i2)
23. 22. [El nodo `/cpus`](#i5i5i3)
24. [El nodo/s `/memory`](#i5i5i4)
25. [El nodo `chosen`](#i5i5i5)
26. [El nodo `/soc<SOCname>`](#i5i5i6)
27. [`dtc`, el compilador del árbol de dispositivo](#i6)
28. [Recomendaciones para el _gestor de arranque_](#i7)
29. [Dispositivos _systemas-en-chip(SoC)_ y nodos](#i8)
30. [Definiendo nodos _descendientes_, en un _SoC_](#i8i1)
31. [Representando dispositivos, _sin la especificación_](#i8i2)
32. [Especificando información de interrupción, en dispositivos](#i9)
33. [Propiedades de las _interrupciones_](#i9i1)
34. [Propiedad _interrupción ascendente_](#i9i2)
35. [Controladores de interrupcion `OpenPIC`](#i9i3)
36. [Controladores de interrupcion `ISA`](#i9i4)
37. [Especificando información, para la gestión de energía del _dispositivo(propiedad durmiente)_](i10)
38. [Especificando información para el _bus dma_](#i11)
39. [Apéndice A - Ejemplo de nodo _SoC_ para un _chip_ `MPC8540`](#i12)

99. [Referencias y agradecimientos](#i99)


# El arranque del núcleo deLinux/ppc sin Open Firmware #

#### <a name="i1">Tabla de contenidos</a> ####

1. Tabla de contenidos
2. Información acerca de las _revisiones_
3. Introducción
 1. Punto de entrada en `arch/arm`
 2. Punto de entrada en `arch/powerpc`
 3. Punto de entrada en `arch/x86`
 4. Punto de entrada en `arch/mips/bmips`
 5. Punto de entrada en `arch/sh`
4. El formato de bloque en _DT_
 1. Cabecera
 2. Generalidades del árbol de dispositivo
 3. "Estructura de bloque" del árbol de dispositivo
 4. "Cadenas" de bloque del árbol de dispositivo
5. Contenido necesario en el árbol de dispositivo
 1. Notas sobre la representación de celdas y direcciones
 2. Notas sobre propiedades compatibles
 3. Notas sobre nombres de propiedades
 4. Notas sobre node, propiedades y conjuntos de caractéres
 5. Notas sobre nodos y propiedades
- El nodo raíz
- El nodo `/cpus`
- Los nodos `/cpus/*`
- El nodo/s `/memory`
- El nodo `chosen`
- El nodo `/soc<SOCname>`
6. `dtc`, el compilador del árbol de dispositivo
7. Recomendaciones para el _gestor de arranque_
8. Dispositivos _systemas-en-chip(SoC)_ y nodos
	 1. Definiendo nodos _descendientes_, en un _SoC_
	 2. Representando dispositivos, _sin la especificación_
9. Especificando información de interrupción, en dispositivos
	 1. Propiedades de las _interrupciones_
	 2. Propiedad _interrupción ascendente_
	 3. Controladores de interrupcion `OpenPIC`
	 4. Controladores de interrupcion `ISA`
10. Especificando información, para la gestión de energía del _dispositivo(propiedad durmiente)_
11. Especificando información para el _bus dma_
12. Apéndice A - Ejemplo de nodo _SoC_ para un _chip_ `MPC8540`
13. Referencias y agradecimientos


#### <a name="i2">Información acerca de las _revisiones_</a> ####

* 18 Mayo, 2005: Rev 0.1 
- Borrador inicial, aún no hay capítulo III
* 19 Mayo, 2005: Rev 0.2 
- Añadido el capítulo III, notas y aclarariones
sobre multitud _opciones_; el kernel necesita un árbol de disporitivo
_muy pequeño_, aunque es oportuno, proporcionar uno, tan completo como
sea posible.
* 24 Mayo, 2005: Rev 0.3 
- Precisar que el bloque _DT_ debe estar en _RAM_
- Reparaciones misceláneas
- Definición de la versión 3 y, nuevo formato en la version 16
para el bloque _DT_ -la versión 16, necesita _parches_, será 
tratada por separado.
Las cadenas de bloque, tienen ahora _tamaño_ y, la ruta absoluta
será reemplazada por _nombre de unidad_, por simplificación.
Será opcional el _phandle_ de Linux. Únicamente los nodos 
referenciados por otros nodos, los requerirán.
La propiedad `name` será deducida mediante el _nombre de unidad_.
* 1 Junio, 2005: Rev 0.4 
	- Corregida la confusión entre `OF_DT_END` y `OF_DT_EN_NODE` en
	la definición de la estructura.
	- Cambio en el formato de la versión 16, para que siempre alinée 
	la propiedad de datos a `4 bytes`. Puesto que los _objetos_, han 
	sido alineados, no será necesario ningún otro alineamiento 
	específico entre, el tamaño de la propiedad y, los datos de la 
	misma.
	El anterior _estilo_ variable, imposibilita una simple inserción
	de propiedades, a través de `memmove`. Agradecimiento a __Milton__
	por notificarlo. Actualizado el parche al _kernel_.
	- Corregidas _otras pocas_ restricciones de alineamiento.
	- Añadido el capítulo sobre el compilador del árbol de dispositivo y, 
	la representación textual del _árbol_, pudiendo ser compilado por _dtc_.
* 21 Noviembre, 2005: Rev 0.5
	- Generalidades y adiciones, en `32-bit`.
	- Cambio para reflejar la nueva estructura `arch/powerpc`.
	- Añadido el capítulo VI.
	
TODO:
- Añadidas definiciones de interrupción, en el _árbol_(simples/complejas).
- Añadidas definiciones en el puente _huesped_ del _PCI_.
- Añadidos ejemplos de formato de dirección común. 
- Añadidas definiciones de propiedades y _nombres_ `compatible`, en _celdas_ aún no definidas en especifiaciones existentes.
- Comparación del uso de `FSL SOC` en _PCI_ para estandarizarlo y, asegurar que ninguna otra definición es necesaria.
- Añadida información sobre definiciones de nodo, en dispositivos 	`SoC`, actualmente no _estandarizados_, tales como `FSL CPM`.

#### <a name="i3">Introducción</a> ####

Durante el desarrollo del núcleo de _Linux/ppc64_ y, más específicamente, en la adición de nuevos tipos de plataforma, fuera del par _IBM pSeries/iSeries_, fué decidio reforzar algunas reglas estrictas, respecto a la entrada en el _kernel_ y en el gestor de arranque `<->` en las interfases del mismo(kernel);con objeto de evitar la degeneración, en la que se ha convertido el punto de entrada del _kernel ppc32_ y, la forma en que debería ser añadida una nueva plataforma, al _núcleo_. Las plataformas _legadas_ por la plataforma _iSeries_, rompen estas reglas, puesto que predicen el esquema, pero no será aceptado nuevo soporte a placas, dentro del _árbol_ principal, que no siga las reglas, apropiadamente. Como añadido, será requisito el uso de estas reglas,en la _confluencia_ de arquitecturas_arch/powerpc_sobre plataformas ppc32/ppc64.

El reqquisito principal, definido en detalle más abajo, será la presencia de un árbol de dispositivo cuyo formato sea instruido tras la especificación _Open Firmware_.
Con el fin de facilitar su implementación, a fabricantes de placas embebidas, el kernel no _requerirá_ la representación _DT_, de cada uno de los dispositivos en el  sistema, solicitando -eso sí, la presencia de algunos nodos y propiedades. Explicado en detalle en la sección III. Por ejemplo, el _kernel_ no requerirá ser creado un nodo por cada dispositivo _PCI_. Únicamente es requisito, definir un nodo para el _puente huesped PCI(PCI host bridge)_, a fin de proporcionar la información de _enrutado_ y rangos de memoria _I/O_, entre otros.
Es igualmente más flexible para fabricantes de placas, el hacer actualizaciones menores, sin causar un impacto significativo, al código del núcleo o, atestarlo con casos especiales.

#### <a name="i3i1">Punto de entrada en `arch/arm`</a> ####

Existe un único punto de entrada al _kernel_; al principio de la imagen del núcleo.
El punto de entrada soporta dos llamadas convencionales. El sumario de la interfase será aquí descrita. Podrá encontrarse una completa descripción de los requisitos para el arranque, documentada en `Documentation/arm/Booting`[[f1]](#f1).

1. Interfase ATAGS. Mínima información, pasada por el _firmware_ al _kernel_, con una lista etiquetada, de parámetros predefinidos.
- `r0` : 0
- `r1` : Número, para el tipo de máquina
- `r2` : Dirección física, de la lista etiquetada en el _sistema RAM_
	 
2. Entrada con el bloque _DT_ alineado . El _firmware_, cargará la dirección física del _dtb_[[f2]](#f2) en `r2`, `r1` no es usado, aunque es considerada una buena práctica utilizar un nmero de máquina válido, tal y como se describe en `Documentation/arm/Booting`.

- `r0` : 0
- `r1` : Número válido para el tipo de máquina. Cuanmdo se emplea un árbol de 	dispositivo, será asignado un único número para el tipo de máquina, con el fin de representar una _clase o familia_ de _SoC_s.
- `r2` : Puntero físico al _dtb_(definido en el capítulo II) de la _RAM_. El árbol 	de dispositivo, podría encontrarse en cualquier parte dentro de systema RAM, pero debería ser alineado en un límite de _64 bit_.
	
El núcleo hará la distinción entre _ATAGS_ y el _dt_, arrancando(el sistema) con la lectura de memoria apuntada por `r2` y, _buscando_ el valor[[f3]](#f3) _dtb_ `0xd00dfeed` ó en `ATAG_CORE`, el valor _offset_ `0x4` de `r2` - `0x54410001`.


#### <a name="i3i2">Punto de entrada en `arch/powerpc`</a> ####

Hay un único punto de entrada al _kernel_, al principio de la imagen del mismo. Dicha entrada, soporta dos convencionalismos:

a. El arranque desde _Open Firmware_. Si el _firmware_ de la máquina, es compatible 	con (IEEE 1275) o proporciona, _una interfase de cliente(API), compatible_; el 	soporte para el _intérprete_ de llamadas de palabras adelantadas(forth), no será 	necesario. Podrá indicarse el _kernel_ de esta forma:
	
	- `r5` : _puntero de llamada_ definido en (IEEE 1275) enlaces a _powerpc_. Únicamente la interfase de cliente de `32-bit`, es soportada actualmente.
	
	- `r2, r4` : dirección y tamaño del `initrd`, si hay alguno ó, `0`.
	El `MMU` está apagado -o encendido; el _kernel_, lanzará el _trampolín_, localizado en `arch/powerpc/kernel/prom_init.c` para extraer el _dt_, junto a cierta información del _Open Firmware_ y, construirá el _fdt_, tal y como está descrito en _b)_. Por medio de un segundo método, será _reentrado_ `prom_init()`. Éste código 	_trampolín_ correrá en el contexto del _firmware_, el cuál pretende gestionar todas las excepciones durante _ese tiempo_.
	
b. Entrada directa con _dtb_. Este punto de entrada, es llamado por _a)_, después 	del _trampolín_ y, podrá ser llamado directamente por el _gestor de arranque_ que 	__no soporta__ la interfase de cliente _Open Firmware_. Es también usado por `kexec` para implementar el arranque en _caliente_ de un nuevo núcleo, desde otro previamente _corrriendo_. Éste método está descrito un poco más adelante, en el mismo documento.
	Cómo metodo, __a)__, _OpenFirmware_ es un simple estandar y, por lo tanto, debería estar implementado, en consonancia a las vinculaciones de la plataforma _powerpc_.
	La definición del punto de entrada, serían entonces:
	
	- `r3` : puntero físico al bloque _DT_(definido en capítulo II) en _RAM_.
	
	- `r4` : puntero físico al mismo _kernel_. Esto es usado por la propiedad del código ensamblador, para desactivar apropiadamente el _MMU_, en caso de estar 	_entrando_ el kernel con _MMU_ activado y, un mapa que no es `1:1`.
	
	- `r5` : `NULL`, para diferenciarlo del método __a)__.
	
	> __nota sobre la entrada SMP,__ tanto si el _firmware_, pone _la otra_ CPU en algún tipo de _bucle durmiente_ u otro _tipo de bucle en la ROM_; el cuál podrá extraerse por medio de un "reinicio suabe(soft reset)" o, de alguna otra manera.
	> En tal caso no haríamos más caso de esto. O prodríamos entrar al _kernel_, con todas CPUs. La forma de llevar esto a cabo através del método b) será descrita en una próxima revisión del mismo documento.
	
El soporte de placas -o plataformas, no es exclusiva de las opciones de configuración. Un conjunto arbitrario de soporte a placas, podrá construirse en una sóla imagen del kernel. El kernel, sabe que conjunto de _funciones_ debe utilizar, en el contexto del árbol de dispositivo. Por lo que:

1. Añadir soporte a _la plataforma_, como opción boleana en `arch/powerpc/Kconfig`, 	siguiendo el siguiente ejemplo de `PPC_PSERIES`, `PPC_PMAC`, `PPC_MAPLE`.
	
2. Crear el archivo principal para la _plataforma_ como:
`arch/powerpc/platforms/myplatform/myboard_setup.c` y añadirlo al `Makefile`[f4](#f4) bajo la condición de la opción `CONFIG_`. Éste archivo, definirá el tipo de estructura de `ppc_md`, conteniendo distintas llamadas al código genérico que será usado en el código específico de plataforma.
	 
La imagen del kernel podría dar soporte a múltiples plataformas, pero sólo si las características de la misma, coinciden con la _arquitectura_.
Una sóla _construcción_ -la imagen, no puede dar sopoerte en ambos casos: esto es sobre una configuración tipo `Book E` o el clásico `powerPc`.


#### <a name="i3i3">Punto de entrada para `arch/x86`</a> ####

Existe un sólo punto de entrada de `32bit` para el código del kernel en `code32_start`, el "de-compresor" -el modo, _punto de entrada real_, va al mismo punto de entrada de `32bit`, una vez _intercambiado_ al modo _protegido_. El punto de entrada soporta una convención de llamada -o llamada canónica, documentada en `Documentation/x86/boot.txt`.
El puntero físico al bloque del árbol de dispositivo -definido en capítulo II, es _pasado_ vía `setup_data`, cuya función requiere, por lo menos, de la versión `v2.09`.
El tipo de campo es definido como:

`#define SETUP_DTB2`

Tal árbol de dispositivo es utilizado como extensión a la _página de arranque_. Ya que no traduce `/`(ruta raíz), considera los datos _de hecho_, cubiertos por la _página de arranque_. Ésto incluye el tamaño de memoria, rangos reservados, argumentos de _línea_ y direcciones `initrd`. Simplemente conserva infromación que de otra forma no sería recuperada, como enrutado de interrupciones o, una lista de dispositivos detrás del bus `I2C`.


#### [Punto de entrada para `arch/mips/bmips`](i3i4) ####

Algunos gestores de arranque, soportan un sólo punto de entrada, al principio de la imagen del kernel[f5](#5). Otros gestores _saltarán_  a la dirección de inicio `ELF`.
Ambos esquemas están soportados; `CONFIG_BOOT_RAW=y` y `CONFIG_NO_EXCEPT_FILL=y`, así la primera instrucción _salta_ inmediatamente a la función `kernel_entry()`.

Similar al caso `arch/arm`(b), la advertencia del _DT_ -por parte del gestor, espera configurar los siguientes registros:

		a0 : 0
		a1 : 0xffffffff
		a2 : puntero físico al bloque del árbol de dispositivo -definido en el capítulo II,
		en RAM. El árbol de dispositivo podrá localizar en cualquier lugar, los primeros
		`512MB` del espacio de dirección física (0x00000000 - 0x1fffffff), alineados con 
		el límite de 64 bit.
		
El gestor legado, no utilizará ésta convención, y no lo pasará al bloque _DT_. En éste caso Linux buscará la própia construcción del _DTB_, seleccionada vía `CONFIG_DT_*`.

Convención definida únicamente para sistemas de `32-bit`, puesto que actualmente no hay una implementación `64-bit BMIPS`.


#### <a name="i3i5">Punto de entrada para `arch/sh`</a> ####

La compatibilidad del _DT_ con gestores _SH_, prevée proporcionar una dirección física al péqueño árbol de dispositivo en `r4`. Dado que éstos gestores legados, no garantizan un _registro de estado inicial_ en particular, el kernel está contruido para _inter-operar_ con anteriores gestores, que deberán utilizar una _construcción DTB_, o seleccionar una opción de placa _legada_ -distinta a `CONFIG_SH_DEVICE_TREE`, que no use el árbol de dispositivo. El soporte a ésto último, ha sido deferido en favor del árbol de dispositivo.


#### <a name="i4">El formato de bloque en _DT_</a> ####

El capítulo, define el actual formato _nivelado_, para el árbol de dispositivo pasado al kernel. Su contenido y requisitos, serán descritos posteriormente. Podrá encontrarse ejemplo de código que utilizan éste formato, en distintos lugares, incluidos:
`arch/powerpc/kernel/prom_init.c`, el cuál genera un árbol de dispositivo a nivel de
representaciones _OpenFirmware_, o la utilidad `fs2t`, parte de las herramienta `kexec` que generá _una_, desde la representación del sistema de ficheros.
Es previsible que gestores como _Uboot_, proporcionen algo más de soporte, igualmente discutido en adelante.

> __nota:__ el bloque debe estar en la memoria principal. Debe ser accesible desde el modo _real_ y _virtual_, sin ningun otro mapa, que el de la memoria principal. Si se escribe un gestor _flash_, debería copiarse el bloque a la RAM, antes de pasarlo al kernel.


#### <a name="i4i1">Cabecera</a> ####

El kernel pasa la dirección física, apuntando a un área de memoria descrita aproximadamente en `include/linux/of_fdt.h`, por la estructura `boot_param_header`:

		struct boot_param_header {
						u32 magic;/* magic word OF_DT_HEADER */
						u32 totalsize;/* total size of DT block */
						u32 off_dt_struct;/* offset to structure */
						u32 off_dt_strings; /* offset to strings */
						u32 off_mem_rsvmap; /* offset to memory reserve map
						 */
						u32 version;/* format version */
						u32 last_comp_version;/* last compatible version */

						/* version 2 fields below */
						u32 boot_cpuid_phys;/* Which physical CPU id we're
						 booting on */
						/* version 3 fields below */
						u32 size_dt_strings;/* size of the strings block */

						/* version 17 fields below */
						u32	size_dt_struct;		/* size of the DT structure block */
		};

Junto a las constantes:

		/* Definitions used by the flattened device tree */
		#define OF_DT_HEADER0xd00dfeed/* 4: version,
									 4: total size */
		#define OF_DT_BEGIN_NODE0x1 /* Start node: full name
									 */
		#define OF_DT_END_NODE0x2 /* End node */
		#define OF_DT_PROP0x3 /* Property: name off,
				 size, content */
		#define OF_DT_END 0x9

Todos los valores de la cabecera son escritos en formato _big endian_, los distintos campos en la _cabecera_ son definidos con detalle más abajo. Todos los valores `offset` -_de compensación o referencia_, son expresados en`bytes`desde el principio de la _cabecera_; esto es la dirección física base, del bloque DT.

- `magic` es un valor que _marca_ el principio de bloque DT de cabecera. Contiene el valor `0xd00dfeed` y es definido por la _constante_ `OF_DT_HEADER`.

- `totalsize` es el tamaño total del bloque DT, incluida la cabecera. El bloque DT debería _encerrar_ todos los datos de estructura definidos en este capítulo -quien es apuntado por el `offset` en la cabecera. Esto es, la estructura DT, cadenas y, el mapa de memoria reservada.

- `off_dt_struct` es un `offset` desde el principio de la cabecera, al comienzo de la estructura de datos, parte del DT. Ver _2) [árbol de dispositivo](i4i2)_.

- `off_dt_strings` es un `offset` desde en comienzo de la cabecera al principio de las `strings`(cadenas), parte del DT.

- `off_mem_rsvmap` es un `offset` desde el principio de la cabecera al comienzodel mapa de memoria reservada. Este mapa es una lista de pares _enteros_ de `64-bit`. Cada par, es un tamaño y una dirección física.La lista es terminada por unaentrada de tamaño `0`. Este mapa aprovisiona al kernel, con una lista de _áreas físicas de memoria_ que son reservadas y, por tanto, no serán usadas para la asignación de memoria, en especial, durante la _inicialización temprana_. El kernel necesita asignar memoria, durante el arranque, para cosascomo el _desnivelado_ en el DT, la asignación de _tablas MMU hash_, etc. Dichas asignaciones, deben estar hechas de tal manera,que pueda evitarse sobreescribir datos críticos en, _Open Firmware_, _capable machine_, la instancia _RTAS_, o sobre _pSeries_, las tablas _TCE_, usadas por iommu. El mapa reservado, debería contener -al menos, el bloque DT en sí mismo -cabecera, tamaño total Si se está pasando al kernel un `initrd`, debería reservarse igualmente. Es innecesario reservar la imagen del kernel. El _mapa_ debe estar alineado a `64-bit`.

- Version. Es la versión de la estructura. La versión 1, termina aquí.La versión 2 añade un campo adicional `boot_cpuid_phys`. 
La versión 3, añade el tamaño del bloque cadenas, permitiendo al kernelreasignarlo fácilmentedurante el arranque y, liberar(memoria), la estructura nivelada noutilizada, después de la expansión. La versión 16, un nuevo y, más compacto formato, para el árbol en sí mismo, -de alguna manera, no es compatible con los anteriores. Versión 17, añade un campo adicional, `size_dt_struct`, permitiendo reasignarla o moverla, aún mas facilmente. Es particularmente útil para los_gestores de arranque_, quenecesitan hacer ajustes al DT, basados sobre información probada. Siempre debería generarse una estructura, con el número de versión, más alto, hasta la fecha de la implementación.
Actualmente, es la versión 17, a menos que, explícitamente, convenga por razonesde compatibilidad.

- `last_comp_version`. Última versión compatible. Indica esto, hasta qué version -con anterioridad, es compatible el bloque DT. Por ejemplo, versión 2, es anteriormente compatible con la versión 1 -esto es, la construcción del kernel para laversión 1, podráarrancar con el mformato de versión 2. Debería ponerse un `1` en este camposi fue generado un DT con version de `1` a `3`, o `16` si fué generado un DT con versión `16` o `17`, usando el nuevo formato de nombre de unidad.

- `boot_cpuid_phys`. Este campo sólo existe en las cabeceras de la _versión 2_. Indica cual ID (identificador) de CPU, está llamando al punto de entrada del kernel. Es utilizado,entre otros, por `kexec`. Tratándose de un sistema SMP, el valordebería coincidir con el contenido de la propiedad `reg`, del nodo CPU, en el correspondiente DT, que hace la llamada al punto de entrada del kernel. Ver capítulos secesivos, para más información sobre los requisitos del contenido DT.

- `size_dt_strings`. Este campo sólo existe en la _versión 3_ y, posteriores.
Proporciona el tamaño de la sección `strings`, del DT. Empieza en el `offset` dado por `off_dt_strings`.

- `size_dt_struct`. Aparece únicamente en la _versión 17_ y, posteriores cabeceras. Proporciona el tamaño de la sección _estructura_, DT. Empieza en el _offset_ dado por `off_dt_struct`.

Eldiseño -capa, habitual de un bloque DT -aunque las distintas partes nonecesiten estar en ese orden, son similares a esto:

		------------------------------
		base -> |struct boot_param_header|
		------------------------------
		|(alignment gap) (*) |
		------------------------------
		|memory reserve map|
		------------------------------
		|(alignment gap) |
		------------------------------
		||
		|device-tree structure |
		||
		------------------------------
		|(alignment gap) |
		------------------------------
		||
		| device-tree strings|
		||
		-----> ------------------------------
		|
		|
		--- (base + totalsize)

> Las direcciones van desde arriba al fondo.
> (*) Los espacios de alineamiento, no están necesariamente presentes; su presencia
> y tamaño, de varios requisitos de alineamiento, en los datos de bloque individuales.


#### <a name="i4i2">Generalidades del árbol de dispositivo</a> ####

El árbol de dispositivo en sí mismo,está separado en dos bloques, una bloque de estructuray un bloque de _cadena(string)_. Ámbos necesitan estar alineadosen un límite de _4 byte_.

Primero, es descrito el concepto _DT_, antes de detallar el formato de almacernamiento.
Este capítulo, __no describe__ en detalle, los tipos de _nodoy propiedades_, requeridos por el kernel, cuyo contenido aparece en el __capítulo III__.

La _capa del DT_, asume la definiciónexpuesta en _Open Firmware IEEE 1275_. Es básicamente un _árbol de nodos_; cada nodo contiene dos, o más propiedades. Una propiedad puede tener _ó no_, un valor.

Es un _árbol_, así que cada nodo, tiene un -y sólo un, ascendente; excepto para el nodo raíz que no tiene ninguno.

Un nodo tiene 2 nombres. El nombre de nodo _activo_, generalmente está contenido en la propiedad _tipo_ `name`, dentro de la lista de _propiedades de nodo_, cuyo valor es una cadena con terminación nula [[f7]](#f7), de uso obligado en _versiones de 1 a 3_,para el formato de definición -descrito en Open Firmware. En la _versión 16_ es opcional puesto que podrá ser generado desde la _unidad de nombres_, descrita más abajo.

También hay una _unidad de nombres_,utilizada para diferenciar nodos con el mismo nombre en el mismo nivel, habitualmente, _constucción_ del `node names`, el símbolo `@` y, una `unit address`, cuya definición es específica para el _tipo de bus_, donde reside.

La `unit name`, no exite como propiedad, pero es incluida en la estructura DT.
Es utilizada para representar la_ruta_ al DT. Líneas abajo, será descrito con más detalle.

El código genérico del kernel, no hace ningún uso formal de la _unit addres_-a pesar de que alguna placa podría utilizarla, así que el único requisito real, es asegurar la uniquidad? del nodo _unit name_, en un determinado nivel del árbol.
Nodos sin anotaciones de _dirección_, y sin ningún posible _afín_, con el mismo nombre, como `/memory` o `/cpus`, podrán omitir la _unit address_, en el contexto de esta especificación, la _unit address_ por defecto `@0`.La _unit name_, es utilizada para definir una _ruta absoluta_, la cuál es la concatenación de todos los nodos ascendentes _unit names_, separados por `/`.

El nodo raíz, no tiene definido un_nombre_ y, tampoco es requerido para crear una propiedad nombre, si está siendo utilizada la _versión 3_, o versiones de formato anteriores. Tampoco tiene _unit address_ -sin símbolo `@` seguido por _unit address_.
Elnodo raíz del _unit name_, es entonces un cadena vacía. La ruta completa al nodo raíz es `/`.

Cualquier node representando a un dispositivo -que no sea un nodo _contenedor_, de otros nodos, como lo es `/cpus`; deberá indicar la propiedad `compatible` anontando el _hardware_ específico y, unal lista opcional de dispositivos compatibles.

Finalmente,todos los nodos que puedan ser referenciados desde una propiedad en otro nodo, necesitarán incluir una propiedad _phandle_ o _linux,phandle_. Una implementación _Open Firmware_, poroporciona siempre un único valor _phandle_, para cada nodo donde el código de `prom_init()` transfoma en las propiedades _linux,phandle_. Aunque esto es opcional si el FDT es utilizado directamente. Un ejemplo de un nodo, referenciando a otro nodo vía _phandle_, es al diseñar el árbol de interrupciones. Explicado esto último, en una versión más reciente de este documento.

La propiedad _phandle_ es un valor de _32-bit_, que identifica a un nodo de manera singular, o exclusiva. Es libre la utilización de cualquier valor o sistema de valores, punteros internos, u otro mecanismo, que sirva a éste propósito. El único requisito es que cada nodo indicando la propiedad _phandle_, deberá tener un valor úncio, para éste.

Acontinuación es descrito un simple DT. En el ejemplo, una `o` -_o_ de Ontario, designaun nodo, seguido por otro nodo_unit name_. Las propiedades sonpresentadas con sus nombres acompañadas del contenido. `content` representa cadenas ASCII, con un valor de _terminación nula_(`\0`). 
`<content>` representa un valor de _32 bit_, en código _decimal_ o _hexadecimal_; el prefijo de texto `0x`.Los distintos nodos en el ejemplo, serán discutidos en un capítulo posterior.

En este punto, sólo está destinado a dar una _idea_ sobre qué aspecto tiene el DT. El autor a conservado las propiedades `name` y _linux,phandle_ -las cuales podrían no estar en orden, para dar una mejor idea acerca del aspecto del árbol de dispositivo, en la práctica.

		/ o device-tree
		|- name = "device-tree"
		|- model = "MyBoardName"
		|- compatible = "MyBoardFamilyName"
		|- #address-cells = <2>
		|- #size-cells = <2>
		|- linux,phandle = <0>
		|
		o cpus
		| | - name = "cpus"
		| | - linux,phandle = <1>
		| | - #address-cells = <1>
		| | - #size-cells = <0>
		| |
		| o PowerPC,970@0
		| |- name = "PowerPC,970"
		| |- device_type = "cpu"
		| |- reg = <0>
		| |- clock-frequency = <0x5f5e1000>
		| |- 64-bit
		| |- linux,phandle = <2>
		|
		o memory@0
		| |- name = "memory"
		| |- device_type = "memory"
		| |- reg = <0x00000000 0x00000000 0x00000000 0x20000000>
		| |- linux,phandle = <3>
		|
		o chosen
		|- name = "chosen"
		|- bootargs = "root=/dev/sda2"
		|- linux,phandle = <4>


Arriba descrito_casi_ un árbol mínimo. Bién podría contener, el conjunto mínimo de nodosy propiedades, requeridas para arrancar el kernel de linux; esto es, unmodelo básico de información para _raíz_, las CPUs y, la capa de memoria física. También contiene información miscelánea en `/chosen`, el tipo de plataforma (mandatorio) y, los argumentos de línea de comando del kernel -opcional.

La `/cpus/PowerPC,970@0/64-bit` es un ejemplo propiedad sin valor asignado. Las demás propiedades _lo tienen_. El significado de la propiedad `#address-cells` será explicado en el capítulo _IV_, el cual define en precisión, los nodo requeridos, propiedades y, su contenido.


#### <a name="i4i3">"Estructura de bloque" del árbol de dispositivo</a> ####

La estructura del DT es linal. El _objeto_ `OF_DT_BEGIN_NODE` empieza un nuevo nodo y, `OF_DT_END_NODE`termina la definición de nodo. Nodos descententes serán definidos antes de `OF_DT_END_NODE` -es un nodo dentro de otro. Un _objeto(token)_, es un valor de _32 bit_. El árbol debe ser finalizado con un _objeto_ `OF_DT_END`.

Aquí hay una estructura básica de un único nodo:

- Objeto `OF_DT_BEGIN_NODE` (que es `0x00000001`).
- En las versiones 1 a 3, este es el nodo cuya _ruta_ completa aparece con terminación nula `\0`, cero y, comenzando por `/`. En versiones `16` y posteriores, esto es sólo para el nodo _unit name_ -o una cadena vacía para el nodo raíz.
- Espacio de alineación, para los siguientes `4 bytes` de _límite_.
- Para cada propiedad: 
	* Objeto `OF_DT_PROP`, que es `0x00000003`.
- `32-bit` para el valor de la propiedad `size` expresado en _bytes_ -o `0` si no hay
valor.
- `32-bit` para el valor del `offset` en el bloque de cadena, en la propiedad `name`
	- Valor de la propiedad `data`, si la hay
	- Espacio de alineación, para los siguientes `4 bytes` de _límite_.
- Nodos descendentes si los hay.
- Objeto `OF_DT_END_NODE` que es `0x00000002`.

El contenido del nodo puede ser resumido como un _objeto de inicio_, ruta completa, una listade propiedades, una lista de nodos descendentes y, un _objeto de final_.Cada nodo descendente,es una estructura de nodo completa, en sí misma, tal y como fue definida anteriormente.

__nota__: la definición de arriba, requiere que todas las definiciones de propiedades para un nodo en particular, __deban__ preceder a cualquier definición de subnodo para ese nodo en concreto.
Aunquela estructura no fuese ambigua, si las propiedades de los subnodosestuviesen entremezcladas, el _analizador de sentencias_ del kernel, requerirá que las propiedades sean situadas primero -hasta la versión 2.6.22. Cualquier herramienta para la manipulación de un _árbol nivelado(flattened tree)_, deberá tener cuidado de preservar esta restricción.


#### <a name="i4i4">"Cadenas" de bloque del árbol de dispositivo</a> ####

Con objeto de guardar espacio, los nombres de propiedades, la cuales son generalmente redundantes,serán guardadas por separado en el bloque de "cadenas". Estebloque es simplemente, un grupo de cadenas con _terminación nula_, para todas las propiedades de nombres, _concatenadas juntas_. Las definiciones de propiedades del DT, en laestructura de bloque, contendrán un valor `offset` desde el principio del bloque de cadena.


#### <a name="i5">Contenido necesario en el árbol de dispositivo</a> ####

__Advertencia__: todas la propiedades `linux,*` definidas en este documento son únicamente aplicables a un _árbol nivelado_[[f8]](#f8). Si la plataforma hace uso de una implementación _real_, del _Open Firmware_, o de una implementación compatible con la interfase de cliente del _Open Firmware_, esas propiedades serán creadas por el código _trampolín_, en del archivo del kernel, `prom_init()`. Por ejemplo, aquí es donde será añadido el código para la detección del modelo de placa y, configurado el _número_ para la plataforma. Sin emabargo, cuando es utilizado el punto de entrada del FDT, no hay `prom_init()`, por lo que es necesario proporcionar tales propiedades en expreso.


#### <a name="i5i1">Notas sobre la representación de celdas y direcciones</a> ####

La regla general está documentada en distintos escrito del _Open Firmware_. A la hora de describir un _bus_, con el DT, si existe una __vinculación__ de _bus_, debería utilizarse la especificición. Sin embargo, el kernel no exige que cada dispositivo o bus, sea descrito en el árbol.

En general, el formato de una dirección de un dispositivo, es definido por el tipo de bus _ascendente_, basado en las propiedades `#address-cells` y `#size-cells`. Nótese que las definiciones ascendentes de`#address-cells`y`#size-cells`, no son _heredadas_, por lo que cada nodo con _descendentes_, deberá especificarlas. El kernel requiere que la raíz del nodo defina el formato para las propiedades de _dirección_, en aquellos dispositivos que estén directamente _mapeados_ al bus del procesador.

Esas 2 propiedades, definen _celdas_, para la representación de la dirección y el tamaño. Una _celda_ es un número de `32-bit`. Por ejemplo, si ambas contienen 2, como en el ejemplo representado arriba; la dirección y el tamaño, están compuestos -en ambos casos, por _2 celdas_ y, cada una -propiedad, es un númerode `64-bit`. Las celdas son concatenadas y, expresadas en formato _big-endian_. Otro ejemplo es, la manera en que el _firmware_ de Apple, las define. Con dos celdas para una dirección y, una celda para el tamaño.La mayor parte de las implementaciones en `32-bit`, deberían definir `#address-cells` y `#size-cells` a 1, que representa un valor de `32-bit`.
Algunos procesadores de `32-bit` premite direcciones de más de `32-bit`; estos procesadores, deberían definir `#address-cells`, como dos celdas.

Las propiedades `reg`, son siempre una tupla del tipo _dirección tamaño_, donde el numero de celdas de la _dirección_ y _tamaño_, está especificado por el bus:
`#address-cells` y `#size-cells`. 
Cuando un bus, soporta varios espacios de direcciones y, otras opciones relativas a localizaciones de dirección -si es predecible o no, etc, esas opciones son usualmente añadidas al nivel más alto -en bits, de la dirección fñisica. Por ejemplo, la dirección física de una PCI, está compuesta por 3 celdas; las dos del _fondo_ conteniendo la dirección física en sí misma y, mientras que la de _encima_ encierra la indicación del _espacio de dirección_, _opciones_ y, el _número de dispositivo y bus PCI_.

En buses que soportan _asignación dinámica_, es aceptada la práctica de no proporcionar la dirección en `reg` -guardada a `0`. Aunque es indicada una opción con la dirección dinámicamente asignada y entonces, facilitar una popiedad "asignación de dirección", la _asignación de dirección_ al completo.

Engeneral, un _sencillo bus_, sin espacio de bits de dirección y sin asignación dinámica, es preferible si esto refleja el _hardware_, ya que el existente analizador de sentencias -o funciones, del kernel, hará siempre _su trabajo_.Al definir un formato de bus, con un formato de _direcciones_ más complejo -incluyendo cosas como el espaciode direcciones(bits), deberá añadirse un _traductor_ al bus, en el archivo `prom_parse.c`. Esto es para kernels recientes.

La propiedad `reg` sólo define direcciones y tamaños -si `#size-cells` no es `0`, en un bus determinado.Para realizar la traducciónde direcciones, -dentro del bus de direcciones ascendente y, posiblemente dentro de las direcciones físicas de la CPU. Todos los _bluses_ deben contener la propiedad `ranges`. Si la propiedad es omitida en cierto nivel, deberá asumirse que la _traducción_ no es posible. Por ejemplo, los registros no serán visibles en el bus _ascendente_. El formato de la propiedad `rranges` es una lista para:

		bus address, parent bus address, size

`bus addres`, está en el formato que el _nodo de bus_ ha definido, esto es, en un puente PCI, definido por la dirección del PCI. Así -la dirección de bus, tañaño, define el rango de direccionesendispositivosdescendentes.Las direcciones del bus ascendente mantiene el formato definido por el _blus ascendente_ del mismo.
En un controlador _host_ PCI, sería una dirección de CPU. En un puente PCI<->ISA, sería una dirección PCI. Define la dirección _base_ en el bus ascendente, donde está mapeado ese _rango_.

Para el soporte de nuevas placas `64-bit`, Es recomendado tanto el formato "2/2"como el formato de _Apple 2/1_, el cuál es algo más compacto, puesto que los tamaños coinciden en una palabra de bit`32-bit`. En el soporte a nuevas placas de`32-bit` debería utilizarse el formato 1/1, a menos que el procesador soporte direcciones físicas, mayores de `32-bit`, en cuyo caso, es recomendable un formato 2/1 .

Alternativamente, la propiedad `rangos` podría estar vacía, indicando que los registros son visibles en el bus ascendente, a través de la traducción mapeada. En otras palabras el espacio de dirección del bus ascendente, es el mismo que el _espacio de dirección_ descendente.


#### [Notas sobre propiedades compatibles](i5i2) ####

Estas propiedades son opcionales, aunque recomendado en dispositivos y en el nodo raíz.
El formato de la propiedad `compatible`, es una lista concatenada con terminación nula.
Esto permite a un dispositivo determinar su _compatibilidad_, con un grupo similar de dispositivos. En algunos casos,permite que un único _controlador_, coincida para distintos dispositivos, a pesar de _nombre_.


#### <a name="i5i3">Notas sobre nombres de propiedades</a> ####

Mientras que anteriores _usuarios_ de _Open Firmware_, como los _Macintoshes_ -con el _viejo formato_ de palabra de bit, tienden a utilizar el nombre del dispositivo actual, para la propiedad `name`, en _el presente_ es considerada una buena práctica el uso de un nombre, más cercano a la clase del dispositivo -habitulamente igual al `device_type`(tipo de dispositivo). Por ejemplo, en la actualidad loscontroladores _Ethernet_ son llamados `ethernet` y, la propiedad `compatible`, defina la familia, en caso de un mismo controlador, para más de uno de estos _chips_. A pesar de ello, el kernelno acostumbra a poner restricciones la nombre de la propiedad; esconsiderada una buena prácticaseguir los _estandars_ y su evolución, tan cerca como sea posible.

Nótese también que el nuevo formato de versión 16, hace la propiedad `name` opcional. Si aparece _ausente_ en el onodo, entonces la unidad del nodo es utilizada para reconstruir el nombre. Esto es la parte del nombre, antes de utilizar el símbolo `@`, o el nombre de unidad al completom si tal símbolo está presente.


#### <a name="i5i4">Notas sobre node, propiedades y conjuntos de caractéres</a> ####

Mientras que _Open Firmware_, mayor flexibilidad en el uso de 8859-1, esta especificación fuerza reglas más estrictas. Propiedades y nodos, deberían ser comprimidos sólo en caso de carácteres ASII: 

		'a' to 'z', '0' to
		'9', ',', '.', '_', '+', '#', '?', y '-'.

Nombre de nodo adicionales, permiten carácteres en mayúscula de la `'A' to 'Z'`. Los nombres de propiedades deberían aparecer en minúscula. De hecho, los fabricante de _Apple_,no respetan esta regla, puesto que resulta irrelevante. Adicionalmente, el nodoy los nombres de propiedad deberían siempre,empezar por carácteres en elrango `'a' to 'z'` -o `'A' to 'Z'` para nombres de nodo.

El número máximo de carácteres en ambos casos, nombres de propiedad y nodos, es 31.
En este caso los nombres de nodo,en este caso, es la _menor parte_, de la unidad nombres -referido al _nombre_ de la propiedad. La unidad de dirección no está incluida, la cuál puede extenderse más allá del límite.


#### <a name="i5i5">Notas sobre nodos y propiedades</a> ####

Ésto es todo lo requerido actualmente. Aunque es muy recomendasble, que el puente PCI sea expuesto, tal y comoestá documentado en _vinculación PCI, en el Open Firmware_, y en _árbol de interrupciones_, igualmente documentado en ésta última especificación.


#### <a name="i5i5i1">El nodo raíz</a> ####

El nodo raíz reuiere que algunas propiedades estén presentes:

- __modelo__: modelo de la placa.
- `#address-cells`: representación de las direcciones, para dispositivos "raíz".
- `#size-cells`: representación del tamaño, para dispositivos "raíz".
- `compatible`: aquí suele mostrarse la _familia_ de la placca. Por ejemplo, sobre dos placas con _modelos_ similares, serán controladas, por el mismo código de plataforma. Siendo especificado el modelo exacto, en la propiedad `compatible`, seguida por una entrada representado al _SoC_.

El nodo raíz, generalmente es, donde son añadidas propiedades adicionales, específicas de la placa, como el nmúmero de serie -si hay alguno, y similares.
Es recommendable, al añadir propiedades "personalizadas", que sus nombres encajen con el estardar para ellas definido. Un prefijo con el nombre del fabricante, separado por coma `,`.

Propiedades adicionales al nodo raíz:

- `serial-number`: una _cadena_, representando el número de serie.


#### <a name="i5i5i2">El nodo `/cpus`</a> ####

Es este el nodo ascendente, para todos los nodos individuales CPU. Sin tener requisitos específicos, es habitualmente una buena práctica tener por lo menos:

		#address-cells = <00000001>
		#size-cells= <00000000>

Esto define que la _dirección_ de una CPU, es sólo una celda, sin tamaño concreto. Es innecesario, pero el kernel _asumirá_ el formato, cuando lea las propiedades `reg`, de un nodo CPU, ver más abajo.


#### <a name="i5i5i3">El nodo `/cpus/*`</a> ####

Bajo `/cpus`, _presuponemos_ el crear un nodo, para cada CPU en la máquina. No hay restricciones específicas para elnombre de la CPU, aunque es habitual llamar a
 `<architecture>,<core>`. Por ejemplo, _Appple_, utiliza `PowerPC,G5`, mientrasque IBM usa `PowerPC,970FX`. aunque por convención en nombres genéricos, es mejor utilizar `cpu`,en cada nodo CPU y, el uso de la propiedad `compatible`, para identificar un núcleo CPU específico.

__Propiedades requeridas:__

- `device_type`: debe ser `cpu`.
- `reg`: este es el número _físico_ de la CPU. Única celda de `32'bit` y, es también tal y como _es_, el número de unidad para construir el _nombre de unidad_, de la ruta al completo. Por ejemplo, con dos CPUs, la _ruta completa_ sería:

		/cpus/PowerPC,970FX@0
		/cpus/PowerPC,970FX@1

Las _unidades de dirección_, no requieren ceros _ligados_.
- `d-cache-block-size`: una celda, el tamaño de bloque para la caché de datos `L1`, en bytes[f9](f#9).
- `i-cache-block-size`: una celda, el tamaño de bloque para la caché de instrucciones `L1`, en bytes.
- `d-cache-size`: una celda, el tamaño de la caché de datos `L1`, en bytes.
- `i-cache-size`: una celda, el tamaño de la caché de instrucciones `L1`, en bytes.

[f9](f#9)El tamaño de bloque para la caché, es el tamaño en el que operan las instrucciones de gestión de caché.Con anterioridad, éste documento, utilizó el tamaño de caché `line`,el cuál era incorrecto. El kernel prefiere el _tamaño de bloque de caché_ , utilizando _lo anterior_, por cuestiones de compatibilidad.

__Propiedades recomendadas:__

- `timebase-frequency`: una celda indicando la frecuencia del _tiempo-base_ en Hz. El códigoo genérico, no lo utiliza de forma directa, pero es razonable _copiar/pegar_ el código de `pSeries` para la configuración del kernel, calibrandolo mediante este valor.
- `clock-frequency`: una celda, indicando la frecuencia de reloj -en Hz, del núcleo de la CPU. Definirá una nuevapropiedadbasada enun valor de 64-bit, pero si la frecuencia es `< gGHz`, una celda será suficiente. El código común no utiliza la propiedad, si bién, esposible reutilizar el código de _pSeries_. Una posterior versión del kernel, podría proporcionar una función común para esto.
- `d-cache-line-size`: una celda, para la caché de datos `L1`, si es distinta al tamaño de bloque.
- `i-cache-line-size`:una celda, L1 instruction cache line size in bytes if different from the block size.

> "Será bién recibida, cualquier propiedad relevante a la placa, añadida con posterioridad". Información como el mecanismo utilizado en el _reinicio suave_ de la CPU. Por ejemplo, _Apple_ pone el número GPIO para el _reinicio suave_ de las líneas CPU, ya que la propiedad inicializa CPUs secundarias, reseteándolas.


#### <a name="i5i5i4">22. El nodo/s <code>/memory</code></a> ####

Para definir la capa de la _memoria física_, de la placa, deberían crearse uno o más nodos.Esto es, tanto un único nodo, con todos los rangos de memoria en la propiedad `reg`, como distintos nodos, a discreción. La unidad de dirección -la parte `@`, usada en la ruta _completa_, es la dirección del primer rango de memoria definido por el nodo en cuestión. Si está utilizándose un único nodo de memoria, lo habitual es `@`.

__Propiedades requeridas:__

- `device_type`: debe seer `memory`.
- `reg`: esta propiedadd contiene todos los rangos de memoria de la placa. Es una lista de _direcciones/tamaños_, concatenados, con el número de celda de cada uno, definidos con `#address-cells` y `#size-cells` del nodo raíz. Poer ejemplo, en ambas propiedades es `2`, igual que en el ejemplo anterior. En una máquina tipo `970`, con 6Gb de RAM, es típico tener un registro para la propiedad, con este aspecto:

		00000000 00000000 00000000 80000000
		00000001 00000000 00000001 00000000

Representa un rango comenzando por `0x80000000` bytes y otro por `0x10000000` bytes también uno empezando por `0x10000000` bytes[santoSantorum]. Puede verse que no hay memoria cubriendo el espacio `IO` entre 2gb y 4Gb. Algunos vendedores prefieren separar estos rangos, en segmentos más pequeños, algo que al kernel no le preocupa.

__Propiedades adicionales:__

- `hotpluggable`(conectable en caliente): la presencia de esta propiedad,proporciona una pista _explícita_ al sistema operativo; esta memoria puede ser potencialmente retirada, posteriormente. El kernel tomará esto en consideración, cuano haga asignaciones estáticas -o no movibles, y cuando _despliegue_ las _zonas de memoria_.


#### <a name="i5i5i5">El nodo `chosen`</a> ####

Este nodo es un _bit especial_. Normalmente, aquí es cuando el _Open Firmware_, pone en el sistema operativo, la información de entorno; como los argumentos, o los dispositivos `input/output` por defecto.

La especificación hace uso de esta "regla", pero también define algunas propiedades específicas de _linux_, que seríannormalmenteconstruidas por el _trampolín_ `prom_init()`, al arrancar __una__ interfase de cliente. Pero deberá ser provista _manualmente_ al utilizar el formato FDT.

__Propiedades recomendadas:__

- `bootargs`: esta cadena con _terminación nula_, es pasada como línea de comando del kernel.
- `linux,stdout-path`: es la ruta al completo, del dispositivo de línea de comando, si hay alguno; de tener dispositivos en serie en la _placa_, podría ser interesante poner la _ruta completa_ en una configuración, como cónsola por defecto del _firmware_. Para que el kernel la tome como _su_ cónsola por defecto.

Nótese que `u-boot` crea y rellena el `chosen node`, en plataformas que la usan.

> __nota__: una práctica ya obsoleta, es incluir una propiedad llamada `interrupt-controller` bajo `/chosen`, la cual tiene un valor `phandle` que apunta al controlador de interrupción principal.


#### <a name="#i5i5i6">El nodo `/soc<SOCname>`</a> ####

Este nodo es utilizado para representar un _system-on-chip (SoC)_ y, debe ser presentada si el procesador es un _SoC_. El nivel más alto de un nodo SoC,contiene información global a todos los dispositivos en el SoC. El nombre de nodo, debería contener una _unidad de dirección_ para el SoC, el cual es la dirección _base_, del registro,del _mapa de memoria_, establecido para el SoC.Por ejemplo,el nodo soc de _MPC8540_ sería `soc8540`.

__Propiedades requeridas:__

- `ranges`: debería ser definido tal y como se especifica en [1)](#i3i1), para describir la traducción de las direcciones SoC, en registros de memoria mapeada.
- `bus-frequency`: contiene la freccuencia del bus del nodo SoC. El valor de este campo, acostumbra a ser _completado_, por el gestor de arranque.
- `compatible`: modelo exacto del SoC.

__Propiedades recomendadas:__

- `reg`: esta propiedad define la dirección y tamaño de los registos del _mapa de_ _memoria_, utilizado por el própio nodo SoC.
Carece de los registros, del nodo de dispositivo descendente. Esto sera difinido dentro de cada _nodo descendente_. La dirección especificada en la propiedad `reg`, debería coincidir con la unida de dirección, del nodo SoC.
- `#address-cells`: la representación de direcciones de dispositivos SoC. El formato de este campo, puede variar dependiendo de -_si están, o no_, mapeados los registros de memoria. Para los _anteriorres_ registros, el campo representa el número de celdas necesarias,la dirección de los registros.En SoCs que no utilizan MMIO[siglas](/TerritorioLinux/siglas.html), debería definirse un formato especial, conteniendo las celdas, que representen esta información necesaria.
- `#size-cells`: la representación del tamaño de dispositivos SoC.
- `#interrupt-cells`: define el _ancho_ de las celsdas, utilizada para representar las interrupciones. Este valor suele ser `<2>`, el cual incluye un número de 32-bit, representado el número de interrupciones y,un número de 32-bit, el nively sentido, de las interrupciones. Este campo sólo es necesario, si el SoC contiene un contralador de interrupciones.

El nodo SoC, podría contener nodos descendentes, en cada dispositivo SoC, que usase la plataforma. Nodos de dispositivos ya esistentes en el SoC, sin ser utilizado por ninguna plataforma en particular, no debería ser creados. Ver capítulo IV, para mas información al respecto.

Ejemplo _nodo SOC_ para el MPC8540:

		soc8540@e0000000 {
			#address-cells = <1>;
			#size-cells = <1>;
			#interrupt-cells = <2>;
			device_type = "soc";
			ranges = <0x00000000 0xe0000000 0x00100000>
			reg = <0xe0000000 0x00003000>;
			bus-frequency = <0>;
		}


#### <a name="i6">`dtc`, el compilador del árbol de dispositivo</a> ####

El código del _dtc_ podrá ser encontrado en :
[fuente __dtc__](http://git.jdl.com/gitweb/?p=dtc.git)

>ADVERTENCIA: la siguiente versión se encuentra en un temprano estadio de desarrollo; los resultantes "resumidos(blolbs)" del _DT_, aún no han sido validados con el kernel. Los bloques generados actualmente, distan de tener un mapa de _reserva_ útil -serán arreglados para generar uno vacio, es trabajo del gestor de arranque, su _completado_. La _gestión de errores_, necesita ser revisada y los _errores(bugs)_ están al orden del día ...

El _dtc_ toma un árbol de dispositivo en un formato determinado entregando como salida _otro distinto_. Los formatos soportados actualmente son:


__Formato de entrada:__

- _dtb_: formato blob(resumido), el cuál es nivelado con el bloquye del árbol de dispositivo junto a todos los binarios blob(resumidos, condensados).
- _dts_: formato fuente - `s` de sintaxis. Se trata de un archivo de texto, conteniendo un árbol de dispositivo _fuente_. El formato ers definido más tarde, en éste mismo capítulo.
- Formato _fs_: Es una representación equivalente a la salida en `/proc/device-tree`, donde sus _nodos_ son directorios y, las _propiedades_ archivos.


__Formato de salida:__ 

- _dtb_: formato "blob".
- _dts_: formato "fuente".
- _asm_: archivo en lenguaje ensamblador. Es un archivo, el que ha escrito esta frase, es otro autor, con una interpretación particular. Blob. El archivo puede ser simplemente añadido al `Makefile`. Adicionalmente, el archivo ensamblador, exporta algunos _símbolos_ pudiendo ser utilizados.

La sintaxis de la herramienta _dtc(el compilador)_ es:

dtc [-I <input-format>] [-O <output-format>]
[-o output-filename] [-V output_version] input_filename

La "versión de salida" define qué versión de formato _blob(resumido)_, será generada. Soporta las versiones `1, 2, 3 y 16`. Por defecto se trata con la versión `3`, aunque en un futuro podría cambiar a la versión `16`.

En adición, el _dtc_ llerará a cabo ciertas comprobaciones sobre el árbol. Cómo la _uniquidad_ de linux, propiedades `phandle`, validación de cadenas(strings), etc ...

El formato del archivo fuente `.dts` es del tipo `C`(lenguaje), soportando comentarios en `C` y `C++`.

		/ {
		}

Lo de arriba es la definición del "device-tree". Es la úncia _directriz_ soprotada actualmente, en el _nivel más alton_.

		/ {
			property1 = "string_value";	/* define a property containing a 0
				 * terminated string
						 */

			property2 = <0x1234abcd>;	/* define a property containing a
				 * numerical 32-bit value (hexadecimal)
						 */

			property3 = <0x12345678 0x12345678 0xdeadbeef>;
				/* define a property containing 3
				 * numerical 32-bit values (cells) in
				 * hexadecimal
						 */
			property4 = [0x0a 0x0b 0x0c 0x0d 0xde 0xea 0xad 0xbe 0xef];
				/* define a property whose content is
				 * an arbitrary array of bytes
				 */

			childnode@address {	/* define a child node named "childnode"
				 * whose unit name is "childnode at
						 * address"
				 */

				childprop = "hello\n";/* define a property "childprop" of
				 * childnode (in this case, a string)
				 */
			};
		};


Los nodos podrán contener otros nodos ..., definiendo así, la estructura jerárquica del árbol.

Las _cadenas_, soportan _sequencias de escape comunes en `C`_: `"\n", "\t", "\r", "\(octal value)", "\x(hex value)".`

Es sugerido igualmente, el _encauzar(to pipe)_ el archivo fuente por medio de __cpp__ -preprocesador `gcc`, por lo que podrán utilizarse los `#include`, `#define` para constantes, etc...

Finalmente, se planean varias opciones aún no implementadas; como la generación automática de `phandles`, etiquetas -exportadas al archivo `asm`, y poder apuntar al contenido de la propiedad y cambiarla fácilmente, con _lo que sea que_ enlace al árbol de dispositivo, etiqueta o ruta, en lugar de valor numérico, apuntado al nodo en determinadas _celdas_ (reemplazados por el `phandle` durante la compilación). Exporta el mapa de direcciones _reservado_, al archivo `asm`. La habilidad para especificar el contenido del _mapa reservado_, durante la compilación.

Podría proporcionarse un archivo _include(cabecera `.h`)_, conteniendo definiciones comunes que demuestren su utilidad, para algunas propiedades -como la construcción de propiedades `PCI` o _mapas de interrupción_. Aunque sería más apropiado añadir un noción de definiciones de estructuras(`structs`), al compilador.


#### <a name="i7">Recomendaciones para el _gestor de arranque_</a> ####

A continuación, algunas _ideas/recomendaciones_ que han sido propuestas, durante la definición e implemnentación de todo esto.

- El gestor de arranque, podría querer ser capaz de utilizar el árbol de dispositivo en sí mismo y, querer manipularlo -para _añadir/editar_ algunas propiedades, como el tamaño de la memoria física o los argumentos del _kernel_. En este punto, aparecen 2 opciones a tener en cuenta.
Tanto si el _gestor de arranque_, trabaj a directamente en _formato nivelado_ como si el _gestor de arranque_ tuviese su própia representación del árbol interna con punteros -similar a la del _kernel_, y renivelase el árbol durante el _arranque_ del kernel. El primer caso es algo más complejo de editar/modificar, el segundo, probáblemente requiera cierto código adicional, para _manejar_ la estructura.
Nótese que el formato de la estructura, ha sido diseñada para que resulte "relatívamente" fácil insertar propiedades, nodos, o borrarlos, simplemente "moviendo la memoria" a su alrededor. Carece de `offsets` internos o punteros, al respecto.

>__Advertencia__ aquí se entien una especie de transpolación de lo que entiende el SO, sobre el DT, por eso lo de "a nivel", por que se juega con los datos definidos en la estructura, el DT y lo que interpreta el SO. Se trata de una estructura jerarquica que representa los dispositivos/periféricos/cacharros. Nivelado, por que la aplicación tomará en consideracion, aquellos dispositivos "reales"; que aparezcan en el sistema, nivelando, o poniendo a nivel que toque, el dispositivo en cuestión. Si el ratón cuelga en el "genérico" del bus `i2c` pero nuestro sistema, lo interpreta desde bus ISA PCI; tendrá que sacarlo y ponerlo nuevamente a nivel...

- Un ejemplo de código, para nodos sobre los que _iterar_ y, extraer propiedades directamente desde el formato de árbol _nivelado_, podrá ser encontrado en el archivo del kernel, `drivers/of/fdt.c`. Mirar en la función of_scan_flat_dt(), el uso de la función `early_init_devtree()` y, varias de las llamadas a `early_init_dt_scan_*()`
El código puede ser reutilizado en un gestor de arranque GPL, -el autor del código:

> __traducción__: "discutiré de buen grado, una licencia libre, para cualquier vendedor que desee integrar todo, o parte de este código en un gestor de arranque _no-GPL_".
> **GPL, General Public License by Richard Stallman of the Free Software Fundation.
> Necesita referencia; ¿quien es "Yo", aquí? ---gcl Jan 31, 2011.

...

		/**
		 * of_scan_flat_dt - scan flattened tree blob and call callback on each.
		 * @it: callback function
		 * @data: context data pointer
		 *
		 * This function is used to scan the flattened device-tree, it is
		 * used to extract the memory information at boot before we can
		 * unflatten the tree
		 */
		int __init of_scan_flat_dt(int (*it)(unsigned long node,
								 const char *uname, int depth,
								 void *data),
						 void *data)
		{
			unsigned long p = ((unsigned long)initial_boot_params) +
				be32_to_cpu(initial_boot_params->off_dt_struct);
			int rc = 0;
			int depth = -1;
			do {
				u32 tag = be32_to_cpup((__be32 *)p);
				const char *pathp;
				p += 4;
				if (tag == OF_DT_END_NODE) {
					depth--;
					continue;
				}
				if (tag == OF_DT_NOP)
					continue;
				if (tag == OF_DT_END)
					break;
				if (tag == OF_DT_PROP) {
					u32 sz = be32_to_cpup((__be32 *)p);
					p += 8;
					if (be32_to_cpu(initial_boot_params->version) < 0x10)
						p = ALIGN(p, sz >= 8 ? 8 : 4);
					p += sz;
					p = ALIGN(p, 4);
					continue;
				}
				if (tag != OF_DT_BEGIN_NODE) {
					pr_err("Invalid tag %x in flat device tree!\n", tag);
					return -EINVAL;
				}
				depth++;
				pathp = (char *)p;
				p = ALIGN(p + strlen(pathp) + 1, 4);
				if (*pathp == '/')
					pathp = kbasename(pathp);
				rc = it(p, pathp, depth, data);
				if (rc != 0)
					break;
			} while (1);
			return rc;
		}
...

#### <a name="i8">Dispositivos _systemas-en-chip(SoC)_ y nodos</a> ####

Muchas compañías están ahora desarrollando procesadores _sistemas-en-chips_, donde el núcleo del procesador _la CPU_ y, otros muchos periféricos, existen una _pieza de silicio_. Para estos _SoC's_, debería utilizarse un nodo SoC que definiese nodos descendentes, en dispositivos que _construyesen_ el SoC.
A pesar de ciertas plataformas, sin requerir el uso de este modelo, para arrancar el kernel. Es más que recomendable, _el que todos los SOC_, definan una implementación al completo, del _árbol-deDispositivo-nivelado_ para describir los dispositivos en el SOC.
Esto permitirá la _generalización_ de mucho más código del kernel.


#### <a name="i8i1">Definiendo nodos _descendentes_, en un _SoC_</a> ####

Cada dispositivo parte de un SOC, podrá tener su própia _entrada de nodo_, en el nodo SOC. Por cada dispositivo incluido, la propiedad _unidad de dirección_, representa la dirección `offset`, para los registros del _mapa de memoria_ en el espacio de dirección ascendente.
El espacio de dirección ascendente, es definido por la propiedad `ranges`, en el nivel más alto del nodo soc. La propiedad `reg`, por cada _nodo que exista_, directamente bajo el nodo soc, debería contener el mapa de dirección de memoria, desde el espacio de dirección descendente, hasta el espacio de dirección SOC ascendente. También el tamaño del archivo de registro con el mapa de memoria.

Para muchos dispositivos que podrían existir en un SOC, hay especificaciones predefinidas, en cuanto al formato de nodo, del árbol de dispositivo. Todos los nodos SOC descendentes, deberían seguir estas especificaciones, excepto aquellas anotadas en éste documento.

Ver apéndice A, para un ejemplo parcial, de una definición nodo SOC, para un `MPC8540`.


#### <a name="i8i2">Representando dispositivos, _sin la especificación_</a> ####

Actualmente, hay muchos dispositivos on SoC's, sin una representación estandar definida como parte de la especificación _Open Firmware_, mayormente por que las placas que contienen estos SoC's, no son arrancadas utilizando _Open Firmware_. la documentación de vinculaciones para nuevos dispositivos, debería ser añadida al directorio `Documentation/bindings`. El directorio será expandido, cuando el soporte al árbol de dispositivo, sea añadido a mas Soc's.


#### <a name="i9">Especificando información de interrupción, en dispositivos</a> ####

El árbol de dispositivo representa a los buses y dispositivos de un sistema de _hardware_, en una forma similar, a la topología física de bus del _hardware_.

Por añadidura, un _árbol de interrupciones_ lógicas, existe para representar la jerarquía y, enrutado, de interrupciones en el _hardware_.

El modelo de árbol de interrupciones, está completamente descrito en el documento "Open Firmware Recommended Practice: Interrupt Mapping Version 0.9". El documento está disponible en: <http://www.devicetree.org/open-firmware/practice/>


#### <a name="i9i1">Propiedades de las _interrupciones_</a> ####

Los dispositivos que generan interrupciones en un único controlador de interrupciones, debería usar la representación convencional OF, descrita en la documentación del mapa de interrupciones OF.

Cada dispositivo, generando interrupciones, debe tener una propiedad `interrupt`. El valor de la propiedad `interrupt`, es un número arbitrario dede valores del _especificador de interrupciones_, el cuál describe la interrupción o interrupciones para el dispositivo.

El codificado de un especificador de interrupción, es determinado por el dominio de interrupción, donde es localizado el dispositivo, dentro del árbol de interrupciones. La raíz de un dominio de interrupciones, especifñica en su propiedad `#interrupt-cells`, el número de celdas de 32-bit requeridas, para codificar un especificador de interrupción. Ver documentación _mapa de interrupciones_, para una más detallada descriptión de dominios.

Por ejemplo, la vinculación para el controlador _OpenPIC_, especifica un valor para `#interrupt-cells` de `2`, con objeto de codificar el número de interrupción y, el _nivel/sentido_ de la información. Todas las interrupciones descendentes, en un dominio de interrupciones _OpenPIC_, utilizan 2 celdas por interrupción para la propiedad.

Las vinculaciones del bus PCI, especifican un valor de 1 en `#interrupt-cell`, para codificar el _pin -alfiler,terminal_ de interrupción, son utilizados los valores: `INTA,INTB,INTC,INTD`.


#### <a name="i9i2">Propiedad _interrupción ascendente_</a> ####

La propiedad _interrupción ascendente_, es especificada, para definir un enlace entre un nodo de dispositivo y, su interrupción ascendente dentro del árbol de interrupciones. El valor de la interrupción ascendente, es el `phandle` al nodo ascendente.

Si la propiedad `interrupt-parent?` no es difinida en un nodo, su interrupción ascendente es asumida como _ancestro_ en la jerarquía del nodo, del árbol de dispositivo.


#### <a name="i9i3">Controladores de interrupcion `OpenPIC`</a> ####

Los controladores de interrupción `OpenPIC` requieren 2 celdas para codificar la información de interrupción. La primera celda define el número de interrupción. La segunda celda define el nivel y sentido -dirección de, la información.

La información acerca del sentido y nivel, debería ser codificado como sigue:

	`0` = de _baja_ a _alta_ terminación, de tipo sensitivo, funcionando.
	`1` = activo, bajo nivel de tipo sensitivo, funcionando.
	`2` = activo, alto nivel de tipo sensitivo, funcionando.
	`3` = de _alta_ a _baja_ terminación, de tipo sensitivo, funcionando.


#### <a name="i9i4">Controladores de interrupcion `ISA`</a> ####

Los controladores de interrupciónISA PIC, requieren 2 celdas para codificar la información de interrupción. La primera celda define el número de interrupción. La segunda celda define el nivel y sentido -dirección de, la información.

Controladores de interrupción ISA PIC, deberían adherir al ISA PIC, codificaciones listadas abajo:

	`0` = activo, bajo nivel de tipo sensitivo, funcionando.
	`1` = activo, alto nivel de tipo sensitivo, funcionando.
	`2` = de _alta_ a _baja_ terminación, de tipo sensitivo, funcionando.
	`3` = de _baja_ a _alta_ terminación, de tipo sensitivo, funcionando.


#### <a name="i10">Especificando información, para la gestión de energía del _dispositivo(propiedad durmiente)_</a> ####

Los dispositivos SoCs, a menudo tienen mecanismos par emplazar a dispositivos en estados de _baja energía_, que son desdoblados desde el bloque de registros del dispositivo. Algunas veces, esta información es más complicada que una propiedad `cell-index` que pueda ser descrita razonablemente. Por tanto, cada dispositivo controlado de esta forma, podría contener una propiedad "sleep", la cuál describe esas conexiones.

La propiedad _durmiente_, consiste en uno o más recursos _durmientes_, cada uno de ellos, consistiendo en un `phandle` a un controlador durmiente, seguido por un controlador específico, durmiente, de _cero_ o más celdas.

La semántica acerca del tipo del _modo de baja energía_, son posibles y, definidas, por el controlador durmiente. Algunos ejemplos de estos tipos, de _modos de baja energía_ que podría ser soportados son:

- Dinámicamente: El dispositivo podría ser desactivado o activado, en cualquier momento.
- Sistema en suspenso: El dispositivo podría solicitar ser desactivado, o permanecer alerta, durante la suspensión del sistema; pero no será desactivado hasta entonces.
- Permanente: El dispositivo es desactivado permanentemente -hasta el próximo reinicio completo.

Algunos dispositivos podrían compartir un reloj de dominio, entre ellos, de ser así, deberían ser suspendidos, únicamente, cuando ninguno de los dispositivos estuviesen en uso. Donde es razonable, que estos nodos deban ser emplazados en un bus virtual; el bus tiene la propiedad durmiente. 
Si el reloj de dominio, es compartido junto a otros dispositivos que, de alguna manera, no son agrupados razonablemente; entonces es creado un controlador durmiente virtual -similar a una interrupción nexus, excepto que al definir un _mapa durmiente_ estandarizado, debería esperase, hasta que fuese demostrada su necesidad.


#### <a name="i11">Especificando información para el _bus dma_</a> ####

Algunos dispositivos tienen un rango de memoria DMA, coordinados _relatívamente_, al principio de la RAM, o incluso situados fuera de la RAM del kernel. Por ejemplo, laplaca `Keystone 2` SoC, trabajó en modo LPAE con 4G de memoria, tiene:
- Rango de RAM: [0x8 0000 0000, 0x8 FFFF FFFF]
- Rango DMA: [0x8000 0000, 0xFFFF FFFF]
y el rango DMA es enrasado dentro de los primeros 2G de RAM en HW.

En estos casos, la traducción de direcciones DMA, debería _desarrollarse(performed)_, entre la CPU física y, la dirección DMA. La propiedad `dma'ranges`, pretende ser utilizada para describir la configuración de este tipo de sistema en el DT.

Además, cada dispositivo DMA maestro, en el bus DMA, podría o no, soportar operaciones DMA coherentes. La propiedad `dma-coherent`, tiene la intención de ser usada, para identificar dispositivos que soportan operaciones DMA coherentes, en el DT.

__Bus maestro DMA__

Propiedad opcional:
- `dma-ranges`: <prop-encoded-array> codificado como número arbitrario de _triplete_ (`child-bus-address, parent-bus-address, length`). Cada _triplete_, especifica y, describe un rango contiguo de direcciones DMA.
La propiedad `dma-ranges`, es utilizada para describir la estructura de acceso directo a memoria (DMA), de un mapa de memoria del bus, cuyo árbol de dispositivo ascendente, puede ser accedido desde operaciones DMA iniciadas en el bus. Aporta un significado, en la definición de un mapa o traducción, entre el espacio de dirección físico del bus y, el espacio de dirección físico del bus ascendente.
Para más información, ver `Devicetree Specification`.

__Bus DMA descendente__

Propiedad opcional:
- `dma'ranges`: valor `<vacío>`. De estar presente, significa que la traducción de dirección DMA, debe ser activada para este dispositivo.
- `dma-coherent`: presente si las operaciones DMA son coherentes.

Ejemplo:

`
soc {
		compatible = "ti,keystone","simple-bus";
		ranges = <0x0 0x0 0x0 0xc0000000>;
		dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;

		[...]

		usb: usb@2680000 {
			compatible = "ti,keystone-dwc3";

			[...]
			dma-coherent;
		};
};
`

#### <a name="i12">Apéndice A - Ejemplo de nodo _SoC_ para un _chip_ `MPC8540`</a> ####

		soc@e0000000 {
		#address-cells = <1>;
		#size-cells = <1>;
		compatible = "fsl,mpc8540-ccsr", "simple-bus";
		device_type = "soc";
		ranges = <0x00000000 0xe0000000 0x00100000>
		bus-frequency = <0>;
		interrupt-parent = <&pic>;

		ethernet@24000 {
			#address-cells = <1>;
			#size-cells = <1>;
			device_type = "network";
			model = "TSEC";
			compatible = "gianfar", "simple-bus";
			reg = <0x24000 0x1000>;
			local-mac-address = [ 0x00 0xE0 0x0C 0x00 0x73 0x00 ];
			interrupts = <0x29 2 0x30 2 0x34 2>;
			phy-handle = <&phy0>;
			sleep = <&pmc 0x00000080>;
			ranges;

			mdio@24520 {
				reg = <0x24520 0x20>;
				compatible = "fsl,gianfar-mdio";

				phy0: ethernet-phy@0 {
					interrupts = <5 1>;
					reg = <0>;
				};

				phy1: ethernet-phy@1 {
					interrupts = <5 1>;
					reg = <1>;
				};

				phy3: ethernet-phy@3 {
					interrupts = <7 1>;
					reg = <3>;
				};
			};
		};

		ethernet@25000 {
			device_type = "network";
			model = "TSEC";
			compatible = "gianfar";
			reg = <0x25000 0x1000>;
			local-mac-address = [ 0x00 0xE0 0x0C 0x00 0x73 0x01 ];
			interrupts = <0x13 2 0x14 2 0x18 2>;
			phy-handle = <&phy1>;
			sleep = <&pmc 0x00000040>;
		};

		ethernet@26000 {
			device_type = "network";
			model = "FEC";
			compatible = "gianfar";
			reg = <0x26000 0x1000>;
			local-mac-address = [ 0x00 0xE0 0x0C 0x00 0x73 0x02 ];
			interrupts = <0x41 2>;
			phy-handle = <&phy3>;
			sleep = <&pmc 0x00000020>;
		};

		serial@4500 {
			#address-cells = <1>;
			#size-cells = <1>;
			compatible = "fsl,mpc8540-duart", "simple-bus";
			sleep = <&pmc 0x00000002>;
			ranges;

			serial@4500 {
				device_type = "serial";
				compatible = "ns16550";
				reg = <0x4500 0x100>;
				clock-frequency = <0>;
				interrupts = <0x42 2>;
			};

			serial@4600 {
				device_type = "serial";
				compatible = "ns16550";
				reg = <0x4600 0x100>;
				clock-frequency = <0>;
				interrupts = <0x42 2>;
			};
		};

		pic: pic@40000 {
			interrupt-controller;
			#address-cells = <0>;
			#interrupt-cells = <2>;
			reg = <0x40000 0x40000>;
			compatible = "chrp,open-pic";
			device_type = "open-pic";
		};

		i2c@3000 {
			interrupts = <0x43 2>;
			reg = <0x3000 0x100>;
			compatible= "fsl-i2c";
			dfsrr;
			sleep = <&pmc 0x00000004>;
		};

		pmc: power@e0070 {
			compatible = "fsl,mpc8540-pmc", "fsl,mpc8548-pmc";
			reg = <0xe0070 0x20>;
	 		};
		};


#### <a name="i99">Referencias y agradecimientos</a> ####1553

> _nota d.t._ token, ficha, muestra, vale, bono. Aquí traducido cómo prueba u objeto, puesto que representa un estracto de código, como contrapartida  ante una previa solicitud o petición.

> nota d.t. PCI, componente de interconexión periférica.

> __ppc32/ppc64__: conjunto reducido de instrucciones, para la arquitectura creada por IBM, en 1992. _PowerPC_.

<a name="f1">[f1]</a>
__nota d.t.__ a medida que avance la traducción de la documentación, serán referidos documentos en castellano, sin embargo, se conservará el nombre de los archivos en su lenguaje original.

hay que poner estas, en siglas o enlace desde siglas

<a name="f2">__[f2]__</a>Siglas relacionadas con el árbol de dispositivo:
- __dt__ -- device tree, árbol de dispositivo.
- __dts__ -- device tree structure??, estructura del árbol de dispositivo.
- __dtb__ -- devicee tree binary, binario del árbol de dispositivo.
- __fdt__ -- _standalone_ Flattened device tree, alineado del árbol de dispositivo??
- __dtc__ -- device tree compiler, compilador del árbol de dispositivo.
- __dto__ -- device tree overlay.

[f3](f3)valor mágico.

[f4](f4) Makefile.

[f5](f5) kernel -- para diferenciar el núcleo del sistema operativo y evitar cuaqluier
ambiguedad, con respecto a otras aplicaciones, por ejemplo, el núcleo de un radiador de
calor: _a copper core_; será utilizado el término _kernel_ en adelante.

[f6](f6) picadillo de pimientos y tomate.
- mmu -- Memory managemente Unit. Unidad de gestión de memoria.
- hash -- número identificativo único, generado por un algoritmo de cifrado. 

[f7](f7) terminación nula(zero terminated string), cadena de carácteres almacenados como arreglo, conteniendo los mismos y terminada con un _caracter nulo_ `\0`.

[f8](f8) árbol nivelado, flattened tree, otros nombres para FDT son, _binary blob(pequeño binario)_, `.dtb`(extensión de archivo).

[f9](f9) Bytes, [cita requerida]

[f10](f10) pSeries, referencia al procesador rs/6000 de IBM y al sistema pSeries, iSeries.

[nota d.t.]
 
__nota__:`00000001 00000000`<---> `0x1 0000 0000`

		b = 1
		kb = 1024
		mb = 1024*kb
		gb = 1024*mb

		gcalccmd
		bc

Si utilizamos `bc`, hay que recordar que las variables se escriben en minúscula.
Por lo que al:
		bc$ 1*gb
		bc$ 1073741824
entonces...

		echo "obase=2;1073741824" |bc
		bc$ 1000000000000000000000000000000 
		ó 
		10000000 00000000 00000000 0000000

Un Gb. Dos palabras de 32b.

1. (c) 2005 Benjamin Herrenschmidt <benh at kernel.crashing.org>,
IBM Corp.
2. (c) 2005 Becky Bruce <becky.bruce at freescale.com>,
Freescale Semiconductor, FSL SOC and 32-bit additions
3. (c) 2006 MontaVista Software, Inc.
Flash chip node definition


<ul id="firma">
	<li><b>Traductor:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
