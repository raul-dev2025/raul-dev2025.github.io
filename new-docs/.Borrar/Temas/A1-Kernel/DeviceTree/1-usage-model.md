* [El modelo Linux de uso, para el árbol de dispositivo](#i1)
* [Historia](#i2)
* [Modelo de datos](#i3)
* [Vista de _alto nivel_](#i4)
* [Identificación de plataforma](#i5)
* [Configuración del _tiempo de ejecución_](#i6)
* [_Lista_ de dispositivos](#i7)
* [Apéncice A: dispositivos AMBA](#i8)
* [Referencias y agradfecimientos](#i9)

***************

## Linux y el árbol de dispositivo ##

#### <a name="i1">El modelo Linux de uso, para el árbol de dispositivo</a> ####

El siguiente artículo, describe como _Linux_, utiliza el árbol de dispositivo.   Otra  
visión maś general sobre el tema,   podrá encontrarse en la página usdo del _árbol de_  
_dispositivos_, en [f2][devicetree.org](http://devicetree.org/Device_Tree_Usage).  

El "Open Firmware Device Tree", o símplemente árbol de dispositivo (DT), es una  
estructura de datos y un lenguaje descriptivo de _hardware_. Más específicamente, es  
una descripción de _hardware_ comprensible para un sistema operativo, de tal forma, que  
éste último, no necesite _reescribir_ detalles de la máquina.

Estructuralmente, el _DT_, es un árbol o, un gráfico acíclico con nombre de nodos,  
los cuáles podrían tener un número arbitrario de propiedades _enumeradas_, encapsulando  
datos de manera arbitraria.
Existe un mecanismo, para crear enlaces desde un nodo a otro, fuera de la _estructura_  
_de árbol_, natural.

Conceptualmente, es un conjunto de _convenciones_ comunes, llamadas  
vinculaciones(bindings). Definidas para determinar cómo los datos, deberían aparecer  
en el árbol, para decribir características típicas de _hardware_, incluyendo _buses_ de  
datos, líneas de interrupción, conexiones GPIO y dispositivos periféricos.

El _hardware_ es descrito -tanto como es posible, utilizando vinculaciones existentes,  
para maximizar, el uso de código ya existente. Puesto que las propiedades y los nombres  
de nodo, son símplemente cadenas de texto, es _fácil_ extender vinculaciones ya exis-  
tentes o, crear nuevas, definiendo nuevos _nodos_ y _propiedades_. Se deberá ser  
cauteloso a la hora de crear nuevas vinculaciones, comprobando antes si ya existen. 
Actualmente hay dos tipos de incompatibilidades diferentes. Vinculaciones para buses  
`i2c`, que aparecen, por haber creado otras nuevas, sin primero investigar, cómo los  
dispositivos `i2c` fueron enumerados, en sistemas existentes.


#### <a name="i2">Historia</a> ####

El _DT_ fué originalmente creado, como _código abierto de fabricante(Open Firmware)_,  
parte del método de comunicación, con el que pasar datos entre _Open Firmaware_ y el  
programa cliente -ejem. un sistema operativo. Un sistema operativo usó el _árbol de _
_dispositivo_, para descubrir la topología de _hardware_ en _tiempo de carrera_ y, 
de este modo, dar soporte a la mayoría de hardware disponible, sin tener que _reecribir_  
información  -asumiendo que  los controladores,  estuviesen disponibles para todos los 
dispositivos.

Puesto que  _Open  firmware_,  es habitualmente utilizado en  plataformas _PowerPc_ y  
_SPARC_, el soporte _Linux_ para tales arquitecturas, ha usado el _árbol de dispositivo_  
durante un largo príodo de tiempo.

En 2005, cuando _PowerPc Linux_, comenzó  "las obras" para hacer confluir el soporte en  
plataformas 32-bit y 64-bit, se tomó la decisión de _requerir_ el soporte _DT_, en todas  
ellas, independientemente de si usaban ó no, _Open Firmware_. 
Para ésto, una  representación _DT_,  llamada _ábol de  dispositivo reducido_[f1], fue  
creado para posder pasar al _kernel_, como  _pequeño_  binario, sin tener que requerir  
una implementación _real_ del _Open Firmware_.  `U-boot`,  `kexec` y otros gestores de  
arranque, fueron modificados para soportar éste _árbol de dispositivo binario(dtb)_ y,  
para modificar un _dtb_ durante  el arranque del sistema.  También fué añadido el _DT_  
al arranque de _PowerPc_( arch/powerpc/boot/* ) así, el _dtb_ pudiera ser _envuelto_,  
junto a la imagen del _núcleo_, y dar soporte a máquinas ya existentes, con _firmware_  
_no DT(sis esta característica)_.

Tiempo después, la infraestructura  _FDT_ se usó de forma generalizada, en todo tipo de  
arquitecturas. Al momento  de  éste escrito, 6 _líneas  de  arquitectura_ principales,  
(arm,  microblaze,  mips,  powerpc,  sparc  y  x86),  también otra fuera de la _línea_  
principal(nios), tienen _cierto_ nivel de soporte a _DT_.


#### <a name="i3">Modelo de datos</a>  ####
Si aún no has leído la página _uso del aŕbol de dispositivo[f2]_, entonces hazlo, es  
correcto, yo esperaré aquí...

#### <a name="i4">Vista de _alto nivel_</a> ####

Entender  lo  siguiente,  como lo  más importante;  el árbol de  dispositivo,  es una  
estructura  que describe el  _hardware_.  Nada mágico se esconde detrás, tampoco hace  
que problemas con el _hardware_ desaparezcan por _arte de mágia_. Aunque sí porporciona  
un lenguaje,  para "desmenuzar" la  configuarción soportada por el  _hardware_, de la  
_placa_ y del _controlador de dispositivo_, en el _núcleo_ de Linux -o cualquier otro  
_sistema operativo_ a  éste respecto. Al utilizarlo,  permite al soporte de  placas y  
dispositivos, el _poder ser conducidos_; esto es,  tomar decisiones  de configuración  
basadas en los datos expuestos en el _kernel_, en lugar de `codigos` específicos, para  
_máquinas_ concretas.  

Es preferible, una configuración de datos _por plataforma_, que pueda resultar en menos  
código duplicado y,  hacer más fácil,  el dar soporte,  a un ámplio rango de _hardware_  
con sólamente una imagen del núcleo.  

Linux utiliza los datos _DT_, en tres propuestas principales:

1. Identificación de plataforma.
2. Configuración en _tiempo de carrera_ y,
3. población de dispositivo.

#### <a name="i5">Identificación de plataforma</a> ####

Primero y ante todo ,  el _kernel_  usará los  datos en el _DT_,  para identificar la  
máquina específica. En un mundo perfecto, la plataforma concreta, no debería importar  
al _núcleo_, por que todos los detalles de _plataforma_, deberían estar perfectamente  
dscritos, de forma segura y consistente, por el árbol de dispositivo.
Aunque el _hardware_ no es perfecto, el _kernel_ deberá identificar la máquina durante  
el _arranque_, así, tendrá la oportunidad de realizar ajustes específicos.

En la mayoría de casos,  la _identidad_ de la máquina es irrelevante,  en su lugar el  
_núcleo_,  seleccionará una configuración  de código,  basada en la _CPU_ ó _SoC_, de  
la máquina. En _ARM_, por ejemplo, `setup_arch()` en `arch/arm/kernel/setup.c` llamará  
a  `setup_machine_fdt()`,  en  `arch/arm/kernel/devtree.c`  el cuál busca a través de  
la tabla `machine_desc` y, selecciona `machine_desc` que mejor coincida con los datos  
del  árbol de  dispositivo. Determina  la mejor coincidencia mirando  en la propiedad  
`compatible` en  el nodo de la ráiz,  del árbol de dispositivo y, comparándolo con la  
lista  `dt_compat`  en la estructura  `machine_desc`  -la cuál está definida en  
`arch/arm/include/asm/mach/arch.h` -por si alguien es curioso.

La propiedad `compatible`, mcontiene una lista ordenada de _cadenas_, empezando por el  
nombre exacto de  la máquina, seguido por una lista  opcional de _placas_ compatibles,  
ordenadas de más, a menos compatible. Por ejemplo, las propiedades compatibles con la  
raíz, para la placa _TI BeagleBoard_ y sus secesoras _BeagleBoard xM_, podría parecerse  
a esto, respectivamente:

		compatible = "ti,omap3-beagleboard", "ti,omap3450", "ti,omap3";
		compatible = "ti,omap3-beagleboard-xm", "ti,omap3450", "ti,omap3";

Donde "ti,omap3-beagleboard" especifíca el modelo exacto, además de establecer, que es  
compatible con el _SoC_ `OMAP 3450`, y la familia de _SoC_ `omap3` en general. Notará,  
que la lista,   está ordenada desde la más específica (placa exacta) a menos (familia  
_Soc_).  

Lectores astutos, podrán imaginar que _Beagle xM_ podría reclamar compatibilidad, con  
la _placa_ original _Beagle_.   Aunque _uno_ debe ser cauto haciendo ésto, ya que a  
nivel de placa, es verdad que exista un alto grado de compatibilidad entre ellas, pero  
será difícil,  averiguar  exactamente,  qué signifíca  exactamente  que una placa sea  
_compatible_ con otra. Será preferible pecar de cáuto, en lugar de dar por sentado la  
_compatibilidad entre ellas_ . Una excepción podría ser si una _placa_ es portadora de  
otra, como en el caso de un módulo CPU, acoplado a una plac portadora.

Una nota más sobre _valores compatibles_. Cualquier `string`(cadena), en una propiedad  
`compatible`, deberá estar documentada, tal y como se indica. Ver la documentación para	 
_cadenas_ compatibles en _Documentation/devicetree/bindings_.

De nuevo, en _ARM_, para cada `machine_desc`, el _kernel_ buscará cualquier entrada de  
lista en `dt_compat`, para ver si aparece la propiedad `compatible`.   Si aparece,  
entonces `machine_desc` será un _candidato_ para la máquina. Después de bustac en toda  
la tabla, de `machine_desc`s, `setup_machine_fdt()`, retornará la `machine_desc` más  
compatible, basándose en qué entrada coincide con la propiedad _compatible_. Si no hay  
ninguna coincidencia, retornará `NULL`.

El razonamiento detrás de éste esquema, es mediante la observación; en la mayoría de  
casos, _una sóla_ `machine_desc`, podrá soportar una gran cantidad de placas, si todas  
ellas utilizan  el mismo `SoC`, o la misma famila de `Soc`s.   Aunque invariablemente,  
habrá algunas excepciones, dónde una placa específica, necesitará de una configuraci´on  
especial de código, poco útil en casos más genéricos.
Los casos especiales son _controlados_, comprobando explícitamente el incomodo código  
genérico de configuración, sin embargo no es la mejor de las soluciones, si hay más de  
_un par_ de casos.

En su lugar, la lista `compatile`, permite a una `machine_desc` genérica, proporcionar  
soporte a un ámplio rango de placas, especificando valores `less compatible`(menos  
compatibles), en la lista `dt_compat`. En el ejemplo de arriba, el soporte de la placa  
genérica, podrá exponer la compatibilidad con `ti,omap3` ó `ti,omap3450`.    Si fué  
descubierto un error(bug) en la placa original _beagleboard_, necesitando una solución  
alternativa _de código_,   durante el arranque,  podría ser añadido una nueva  
`machine_desc`, implementando dicha _alternativa_ para que sólo coincidiese sobre  
`ti,omap3-beagleboard`.

PowerPc usa un esquema ligéramente distinto, cuando llama al enlace `.probe()` desde  
`machine_desc`; será utilizado el primero en retornar `TRUE`. Aunque esta aproximación  
no se toma en cuenta la propiedad de la lista _compatible_, y probablemente debería ser  
evitada en el soporte a nuevas arquitecturas.

#### <a name="i6">Configuración del _tiempo de ejecución_</a>
 ####

En la mayoría de casos, _DT_ será el único método de comunicación entre el _firmware_  
y el núcleo, así pués, también será usado para pasar datos de configuración durante el  
_tiempo de ejecución_. Tales como parámetros o la localización de la imagen `initrd`.

Muchos de estos datos,  están contenidos en el nodo  `/chosen`  y, cuando Linux es  
_arrancado_, buscará algo parecido a esto:

		chosen {
			bootargs = "console=ttyS0,115200 loglevel=8";
			initrd-start = <0xc8000000>;
			initrd-end = <0xc8200000>;
		};

Los _argumentos de arranque_, conmtienen los argumentos del _kernel_ y, las propiedades  
de `initrd` define las direcciones y tamaño de un _pequeño_ `initrd`.    Nótese que  
`initrd-end`  es la  primera dirección  después de la imagen `initrd`, por lo que no  
coincide con la semántica habitual del `struct` `resource`(_recurso_). El nodo escogido  
puede contener opcionalmente, un número arbitrario de propiedades adicionales. Para la  
configuración de datos específica a la plataforma.

Durante el _arranque temprano_,   las llamadas de código  de  configuración  de  la  
arquitectura `of_scan_flat_dt()`, tendrán jlugar en distintos momentos,  mediante el  
_ayudante de llamadas_ para analizar los datos del arból de dispositivo antes de que la  
_paginación_ sea configurada.

El código `of_scan_flat_dt()` escanea a través del árbol de dispositivo, y utilizará  
los _ayudantes_, para extraer, durante el qrranque, la información necesaria.   El  
ayudante `early_init_dt_scan_chosen()` es utilizado para analizar el nodo escogido,  
incluyendo parámetros del núcleo.  
`early_init_dt_scan_root()` para inicializar el model de spacio de direcciones _DT_ y,  
`early_init_dt_scan_memory()` para determinar el tamaño y localización de la _RAM_  
utilizable.

En _ARM_, la función `setup_machine_fdt()`, es responsable del _pronto escaneado_, del  
árbol de dispositivo, después de seleccionar la `machine_desc` que soporte la placa.

#### <a name="i7">_Lista_ de dispositivos</a> ####

Una vez identificada la _placa_, tras haber traspasado los datos de configuración, la  
inicialización del núcleo procederá con normalidad. En _algún_ punto de este proceso  
se llamará a `unflatten_device_tree()`, para convertir los datos en una representación  
más eficiente del _tiempo de ejecución_.
Igualmente sucederá cuando la configuración de los enlaces _específicos de máquina_,  
sean llamados, como `machine_desc`, `.init_early()`, `.init_irq()`, `.init_machine(),`
-son enlaces para la plataforma _ARM_.
El resto de la sección, utilizará ejemplos de la implementación _ARM_, pero todas las  
arquitecturas, llevarán a cabo algo muy similar, en cuanto a la utilizaación el _DT_.

Tal y como se intuye por los nombres,   `.init_early()`   es utilizado para la  
configuración  _ específica de máquina _, que necesite ser _ejecutada_ en un pronto  
arranque del sistema, `.init_irq()` es utilizado para gestionar las _interrupciones_.  
El uso de _DT_, no cambia el comportamiento de ninguna de éstas funciones.
Al proporcionar un _DT_, tanto `.init_early()` como `.init_irq()`, serán capaces de  
_llamar_ a cualquier función de _DT_ -`of_*` in `include/linux/of*.h` para obtener  
datos adicionales sobre la plataforma.

El enlace más interesante, en el contexto _DT_ es `.init_machine()` el cuál es el prin-  
cipal responsable de _poblar_ el _modelo de dispositivo_ Linux, con los datos sobre la  
plataforma.   Históricamente,  ésto ha sido implementado  en  plataformas embebidas,  
definiendo un conjunto de _estructuras de reloj estáticas_, `platform_devices` y otros  
datos para el soporte de _placa_ en archivos `.c`. Registrándolos _en masa_, en  
`.init_machine()`, al utilizar _DT_ y, colocando estructuras dinámicas de dispositivo.  

El caso más simple, es cuando ` .init_machine() `  sólo es responsable de registar un  
bloque de `platform_devices`. Un `platform_devices` es un concepto usado por la memoria  
de Linux  o por  dispositivos _mapeados_  en memoria  _I/O_, los cuáles no pueden ser  
detectados por el _hardware_, o por dispositivos "compuestos" o "virtuales" -ver más  
adelante.
Mientras que no existe la términología "dispositivo de plataforma" para el _DT_, los  
dispositivos de plataforma, corresponde de forma aproximada, a nodos de dispositivo,  
en la _ráiz del árbol_ y, al _nodo bus hijo_, simplemente asignado a memoria.  

Es un buen momento para poner un ejemplo. Aquí se representa _parte_ de un árbol de  
dispositivo para la _placa_ de `NVIDIA Tegra`.

		/{
			compatible = "nvidia,harmony", "nvidia,tegra20";
			#address-cells = <1>;
			#size-cells = <1>;
			interrupt-parent = <&intc>;

			chosen { };
			aliases { };

			memory {
				device_type = "memory";
				reg = <0x00000000 0x40000000>;
			};

			soc {
				compatible = "nvidia,tegra20-soc", "simple-bus";
				#address-cells = <1>;
				#size-cells = <1>;
				ranges;

				intc: interrupt-controller@50041000 {
					compatible = "nvidia,tegra20-gic";
					interrupt-controller;
					#interrupt-cells = <1>;
					reg = <0x50041000 0x1000>, < 0x50040100 0x0100 >;
				};

				serial@70006300 {
					compatible = "nvidia,tegra20-uart";
					reg = <0x70006300 0x100>;
					interrupts = <122>;
				};

				i2s1: i2s@70002800 {
					compatible = "nvidia,tegra20-i2s";
					reg = <0x70002800 0x100>;
					interrupts = <77>;
					codec = <&wm8903>;
				};

				i2c@7000c000 {
					compatible = "nvidia,tegra20-i2c";
					#address-cells = <1>;
					#size-cells = <0>;
					reg = <0x7000c000 0x100>;
					interrupts = <70>;

					wm8903: codec@1a {
						compatible = "wlf,wm8903";
						reg = <0x1a>;
						interrupts = <347>;
					};
				};
			};

			sound {
				compatible = "nvidia,harmony-sound";
				i2s-controller = <&i2s1>;
				i2s-codec = <&wm8903>;
			};
		};

Durante `.init_machine()`, la placa _Tegra_, soporta el código necesario, para buscar  
en _DT_ y y decidir en que nodos crear el `platform_devices`. 
En cualquier  caso,  mirando en el árbol,  no es inmediatamente obvio qué clase de  
dispositivo representa a cada nodo, e incluso si un dispositivo representa al nodo. Los  
nodos `/chosen`, `/aliases`, y `/mmemory` son nodos informativos, que no describen  
dispositivos -aunque podría decirse, que la memoria es considerada un dispositivo.  
El _hijo_ del nodo `/soc`, es un dispositivo de memoria _mapeado_, pero el `code@1a`  
es un dispositivo `12c`, y el nodo de sonido, no representa a un dispositivo. En su  
lugar es creado el _subsistema_ de audio. Es posible conocer cada dispositivo si _uno_  
está familiarizado con el diseño de la placa, pero ¿cómo sabe el núcleo qué hacer en  
cada nodo?

El _truco_ radica en que el _kernel_ empieza en la _raíz del árbol_ y, busca los nodos  
con la propiedad `compatible`. Primero, es asumido que cualquier nodocon la propiedad  
`compatible`, represente a un dispositivo; segundo, es asumido igualmente, que un nodo  
en la _raíz del árbol_ está directamente acoplado al _bus_ del procesador, o a un  
sistema _misceláneo_ de dispositivo, que no puede ser descrito de otra manera.

¿ Por qué un `platform_device` utiliza una _asumción fiable_, para el nodo? 
Bien, en la medida en que _el modelo de dispositivo_ Linux, asume , que sus dispositivos 
son descendientes(children) de un controlador bus, en casi todos los `bus_types`(tipos  
de buses).   Por ejemplo, cada `i2c_client` es _hijo_ de un `i2c_master`.   Cada  
`spi_device` es _hijo_ de un _bus SPI_. De forma similar, en _USB, PCI, MDIO,_ etc. La  
misma jerarquía es encontrada en el _DT_, donde nodos de dispositivos `i2c` únicamente  
aparecerán como _hijos_ del bus nodo  `I2C`; idem. para _USB, PCI, MDIO, etc. El único  
dispositivo que no requiere este tipo de parentesco, son los `platforme_devices` -y  
los `amba_devices`, se hablará de ello más adelante; los cuáles residen _alegremente_  
en la _base del árbol_ de Linux `/sys/devices`. Por lo tanto, si un nodo _DT_ está en  
la _raíz del árbol_, probáblemente entonces, será más adecuado registrarlo como una  
`platforme_device`.

El código para el soporte de placa Linux, _llama_ a `of_platform_populate(NULL, NULL,`  
`NULL, NULL)`, para tratar de descubrir los dispositivos en _la raíz del árbol_. Los  
parámetros son todos `NULL`, por que cuando se empiza desde el `struct` _base del_  
_árbol_, no es necesario proporcionar un nodo desde el que comenzar -el primero es  
`NULL`, otro `struct` relacionado, el último, también es `NULL` y, aún no se está  
utilizando una tabla de _coincidencia_. Para una placa que sólo necesita registrar  
dispositivos, `.init_machine()` podrá estar completamente vacío, excepto la llamada  
`of_platform_populate()`.

Con el ejemplo de _Tegra_, es aplicable a los nodos`/soc` y `/sound`, pero ¿qué pasa  
con el nodo descendiente `SoC`? ¿ Debería ser registrado también como dispositivo de  
plataforma ? Para el soporte _DT_ de Linux, el comportamiento genérico, es que los  
dispositivos relacionados, sean registrados por el controlador del dispositivo ascen-  
dente, durante `.probe()`(las pruebas del controlador). Así que, un controlador de  
dispositivo de bus `i2c`, registrará un `i2c_client` para cada nodo relacionado. Un  
controlador de bus `SPI`, registrará su `spi_device` relacionado y, de mforma similar  
para otros tipos de _buses_.
De acuerdo con el modelo, un controlador podrá ser escrito, como vínculo al nodo `SoC`  
y registrar la `platform_devices`, para cada uno de sus _descendientes_. El código de  
soporte de placa, colocará y registrará un dispositivo `SoC`, un controlador de dispo-  
sitivo `SoC` -teóricamente, podría vincular el diapositivo `SoC` y, registrar  
`platform_devices` para `/soc/iterrupt-mcontroller`, `/soc/serial, /soc/i2s` y  
`/soc/i2c` en su enlace .probe()` ¿Verdad que és fácil?


De hecho, registrar descendientes de alguna `platform_device`, es un patrón común, y el  
código de soporte al _árbol de dispositivo_, refeja ésto y, que el ejemplo -líneas  
arriba, sea más simple. El segundo argumento en `of_platform_populate()` es una tabla  
`of_device_id` y, cualquier nodo que coincida con una _entrada_ en la tabla, también  
registrará sus nodos descendientes. En el caso de _Tegra_, podría parecerse a lo  
siguiente:

		static void __init harmony_init_machine(void)
		{
			/* ... */
			of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
		}

En la especificación `Devicetree` el `simple'bus` es definido como una propiedad,  
significando esto,  _un mapa de memoria simple, para el bus_, de esta forma, el código  
de  `of_platform_populate()` podrá ser escrito asumiendo que un nodo _simple-bus_  
compatible, siempre será _transversal_. En cualquier caso, ha sido pasado como  
argumento, por lo que el código de soporte a la placa, podrá ser sobreescribir el  
comportamiento normalizado.

[necesaria nota sobre descendientes `i2c/spi/etc`]

#### <a name="i8">Apéndice A: dispoditivos AMBA</a>  ####

Las principales céldas -o células, ARM, constan de cierto dispositivo acoplado al bus  
_ARM AMBA_, el cuál incluye _algo_ de soporte a la detección de _harwdware_ y gestión  
de energía. En Linux, el `struct` `amba_device` y `amba_bus_type`, es usado para  
representar dispositivos de céldas principales. Para el sistema operativo Linux, esto  
es habitual en ambos  casos,  en instancias  `amba_devicce`  y  `platform_device`,  
descendientes segmento de _bus_.

Siendo utilizado _DT_, aparecerán problemas en cuanto a `of_platform_populate()` por  
que debe decidirse si registrar cada nodo, como `platform_device` o `amba_device`. Esto  
desafortunadamente complica la creación del modelo, un _poquitín_; sin embargo la  
solución _no será demasiado invasiva_. Si un nodo es compatible con `arm,amba-primcell`  
entonces `of_platform_populate()` será registrada como `amba_device` en lugar de  
`platform_device`.

***************

#### <a name="i9">Referencias y agradecimeintos</a> ####

> [f1]ábol de dispositivo reducido, Flattened Device Tree(FDT)



__Autor__: Grant Likely <grant.likely@secretlab.ca>
__Traductor:__ Heliogabalo S.J. <jonitjuego@gmail.com>


