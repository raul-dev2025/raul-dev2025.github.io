1. [Prólogo](#i1)
2. [Contenido](#i2)
3. [Formato de datos básico](#i3)
4. [Conceptos básicos](#i4)
5. [Estructura inicial](#i5)
6. [CPUs](#i6)
7. [Nombre de nodos](#i77)
8. [Dispositivos](#i8)
9. [Comprensión de la propiedad `compatible`](#i9)
10. [Funcionamiento del _enrutado](#i10)
11. [Direccionado de CPU](#i11)
12. [Dispositivo de memoria _mapeada_](#i12)
13. [Dispositivo de memoria _no mapeada_](#i13)
14. [Rangos (_traducción_ de direcciones)](#i14)
15. [Cómo funcionan las interrupciones](#i15)
16.	[Datos específicos de dispositivo](#i16)
17. [Nodos especiales](#i17)
18.	[Nodo _escogido_](#18)
19.	[Temas avanzados](#i19)
20.	[Ejemplo _avanzado_ de máquina](#i20)
21. [PCI host bridge(puente anfitrion PCI)](#i21)
22.	[Enumeración del BUS PCI](#i22)
23. [Traducción del direccionado PCI](#i23)
24. [Interrupción avanzada, mapa(de memoria)](#i24)
99. [Referencias y agradecimientos](#i99)

***************

# Uso del árbol de dispositivo #

#### <a name="i1">Prólogo</a> ####

Página localizada previamente en `htttp://devicetree.org/Device_Tree_Usage`

El documento,   describe _cómo_ escribir un  _árbol de dispositivo_ sobre una    máquina  
nueva.   Está destinada a proporcionar una  _vista previa_, a los conceptos  del  árbol  
de dispositivos y, _coḿo_ son utilizados para describiir la _maquina_.

Para una más detallada descripción del _formato datos_ del árbol de dispositivo -_DT_ en  
adelante,  refiérase a la especificación _ePAPR v1.1_. Dicha especificación, cubre  con  
mucho  más detalle los temas básicos aquí descritos. La _ePAPR v1.1_ está siendo  actua-  
lizada con nueva documentación específica.

#### <a name="i2">Contenido</a> ####

- Formato de datos básico
- Conceptos básicos
 - Ejemplo de máquina
	- Estructura inicial
	- CPUs
	- Nombres de _nodo_
	- Dispositivos
	- Comprensión de la propiedad `compatible`
- Funcionamiento del _enrutado_
	- Direccionado de CPU
	- Dispositivo memoria de _mapeada_
	- Dispositivo memoria de _no mapeada_
	- Rangos (_traducción_ de direcciones)
- Cómo funcionan las interrupciones
- Datos específicos de dispositivo
- Nodos especiales
	- Alias de nodo
	- Nodo _escogido_
- Temas avanzados
	- Ejemplo _avanzado_ de máquina
	- PCI host bridge(puente anfitrion PCI)
	  - Enumeración del BUS PCI
	  - Traducción del direccionado PCI
	  - Interrupción avanzada, mapa(de memoria)
- Notas


#### <a name="i3">Formato de datos básico</a> ####

El _DT_ es una estructura simple con nodos y propiedades. Las _propiedades_ son pares de  
valores  <llave-valor>,  y el nodo,  podrá contener tanto nodos _descendientes_,   como  
_propiedades_. Por ejemplo, el siguiente es una _árbol simple_ en formato `.dts`:  

		/dts-v1/;

		/ {
				node1 {
				    a-string-property = "A string";
				    a-string-list-property = "first string", "second string";
				    // hex is implied in byte arrays. no '0x' prefix is required
				    a-byte-data-property = [01 23 34 56];
				    child-node1 {
				        first-child-property;
				        second-child-property = <1>;
				        a-string-property = "Hello, world";
				    };
				    child-node2 {
				    };
				};
				node2 {
				    an-empty-property;
				    a-cell-property = <1 2 3 4>; /* each number (cell) is a uint32 */
				    child-node1 {
				    };
				};
		};

Ahora mismo, éste _árbol_ es poco útil, por que no describe nada; muestra la estructura  
de __nodos__ y __propiedades__:

- Un único _nodo_ raíz `/`
- Un par de nodos _descendientes_: __nodo1__ y __nodo2__.
- Otro par de nodos _descendientes del nodo_ 1 y 2.
- Un conjunto de propiedades, dispuestas en la extensión del árbol.

Las  propiedades  son simples valores  <llave-valor>,  donde el valor, podrá   aparecer  
vacio o, conteniendo un _torrente de byte_, arbitrario.
Mientras   los _tipos de datos_, sean codificados dentro de la _estructura de   datos_,  
habrá  un conjunto de representaciones  fundamentales, que podrán ser expresadas en  un  
archivo fuente _DT_.

-	_Cadenas de texto_(terminación nula[f1]) serán representadas con doble comilla `"`:
		string-property = "una cadena";
- _Celdas_, _números enteros_ de `32 bit`, delimitados por _ángulos_ `<>`:
		cell-property = <0xbeef 123 0xabcd1234>;
- Datos binarios están delimitados por _corchetes_ `[]`:
		binary-property = [0x01 0x23 0x45 0x67];
- Representaciones de datos distintos, podrán ser concatenados usando la _coma_ `,`:
		mixed-property = "a string", [0x01 0x23 0x45 0x67], <0x12345678>;
- Las comas, serán utilizadas para crear _listas de cadenas_:
		string-list = "red fish", "blue fish";
		

#### <a name="i4">Conceptos básicos</a> ####

Comprender cómo utilizar el _DT_, empieza por utilizar una simple máquina y, construir  
un _árbol_, para describirlo _paso a paso_.  

__Ejemplo de máquina__  

Considerada una máquina imaginaria, _basada en la versátil arquitectura ARM_, manufac-  
turado por _Acme_ y llamada _la venganza-del-Coyote_:  

- Una CPU ARM, de `32bit`  
- Procesador de _bus_ local, acoplado a la _memoria mapeada_ del puerto en serie,  
controlador de _bus spi[f2](f2)_, controlador _i2c_, controlador de interrupción y,  
_bus puente externo(external bus bridge)_.
- 256MB de SDRAM basada en `0`(dirección de memoria). 
- 2 puertos en serie basado en `0x101F1000 and 0x101F2000`
- Controlador GPIO basado en `0x101F3000`
- Controlador SPI basado en `0x10170000`, con los siguientes dispositivos:
	- Zócalo MMC con _pin_ SS acoplado al GPIO `#1`.
- _Bus puente externo_ con los siguientes componentes:
	- Dispositivo _Ethernet_ SMC SMC91111, acoplado al _bus_ basado `0x10100000`
	- Controlador _i2c_ basado en `0x10160000` con los siguientes dispositivos:
  	- Reloj de Tiempo Real(RTC) _Maxim DS1338_. responde a la dirección _esclava_
  	`1101000 (0x58)`.
  - 64MB de una memoria flash, tipo NOR, basada en `0x30000000`.
  
#### <a name="i5">Estructura inicial</a> ####

El   primer paso es desplegar el  _esqueleto_  de la estructura, de la máquina.   Es la  
estructura mínima necesaria, que requiere un _árbol_ válido. En esta etapa, debe iden-  
tificarse, _inequívocamente_, la máquina.

		/dts-v1/;

		/ {
				compatible = "acme,coyotes-revenge";
		};


El   nombre del sistema es especificado por  la  propiedad `compatible`. contiene   una  
cadena en su forma `<fabricante>,<modelo>`. Es importante especificar el nombre exacto  
del   dispositivo, e incluir el nombre del _fabricante_, para evitar _colisión_ en  el  
_espacio de nombres_. Puesto que el sistema operativo, usará el valor `compatible` para  
tomar   decisiones, sobre cómo _correr, funcionar_, en la máquina; es muy   importante  
colocar correctamente los datos, en sus propiedades.

En teoría, `compatible`, son todos los datos que un _OS_, necesitará para identificar  
de forma inequívoca, a la máquina. La presunción de sus detalles, dará lugar a que el  
OS, pueda buscar por `"acme,coyotes-revenge"` específicamente, en el _nivel más alto_,  
de la propiedad `copatible`.


#### <a name="i6">CPUs</a> ####

El   siguiente paso, es describir cada una  de las CPUs. Un nodo contenedor,   llamado  
`"cpus"`, será añadido junto a un _nodo descendiente_, para cada CPU.  En éste caso el  
sistema es de _doble núcleo_, `Cortex A9` en ARM.

		/dts-v1/;

		/ {
				compatible = "acme,coyotes-revenge";

				cpus {
				    cpu@0 {
				        compatible = "arm,cortex-a9";
				    };
				    cpu@1 {
				        compatible = "arm,cortex-a9";
				    };
				};
		};


La   propiedad compatible e cada _nodo CPU_, es  una cadena, especificando  
el modelo exacto de CPU, formato `<fabricante>,<modelo>`.  
Igual que para la propiedad `compatible` en el nivel superior.  

Serán añadidas otras propiedades a la CPU, más tarde. Primero hablaremos de conceptos  
más específicos.  


#### <a name="i7">Nombre de nodos</a> ####

Vale la pena, tomarse un momento, para hablar sobre _convenciones en el nombrado_. Cada  
nodo, deberá tener un _nombre_ en formato `<name>[@<unit-address>]`.

`<name>`   es una cadena ASCII, simple. Podrá contener hasta 31 carácteres -tamaño.  En  
general,  los nodos son nombrados de acuerdo al tipo de dispositivo representado.  El  
nodo de un adpatador _Ethernet 3com_, utilizaría el nombre `ethernet` no _3com509_.

`[@<unit-address>]` es incluida si el nodo describe al dispositivo con una dirección.  
Habitualmente,  la _dirección de unidad_, es  la  dirección principal, utilizada  para  
acceder  al dispositibo, y es listado en la propiedad `reg` del nodo. Dicha  propiedad  
será cubierta posteriormente, en éste documento.

Nodos _afín_, deben ser llamados de forma unequívoca, aunque es habitual que más de un  
nodo utilize el mismo nombre genérico, siempre que la dirección sea distinta.  

Ver sección _2.2.1_ de EPAPR, para una descripción detallada.  


#### <a name="i8">Dispositivos</a> ####


Cada dispositivo en el sistema, está representado por un nodo _DT_. El siguiente paso,  
será poblar el _árbol_ con un nodo por cada dispositivo. Por ahora, _los nuevos_, per-  
manecerán vacíos, hasta hablar acerca de cómo los rangos de direcciones e IRQs son  
gestionadas.


		/dts-v1/;

		/ {
				compatible = "acme,coyotes-revenge";

				cpus {
				    cpu@0 {
				        compatible = "arm,cortex-a9";
				    };
				    cpu@1 {
				        compatible = "arm,cortex-a9";
				    };
				};

				serial@101F0000 {
				    compatible = "arm,pl011";
				};

				serial@101F2000 {
				    compatible = "arm,pl011";
				};

				gpio@101F3000 {
				    compatible = "arm,pl061";
				};

				interrupt-controller@10140000 {
				    compatible = "arm,pl190";
				};

				spi@10115000 {
				    compatible = "arm,pl022";
				};

				external-bus {
				    ethernet@0,0 {
				        compatible = "smc,smc91c111";
				    };

				    i2c@1,0 {
				        compatible = "acme,a1234-i2c-bus";
				        rtc@58 {
				            compatible = "maxim,ds1338";
				        };
				    };

				    flash@2,0 {
				        compatible = "samsung,k8f1315ebm", "cfi-flash";
				    };
				};
		};


En este árbol, ha sido añadido un nodo, poor cada dispositivo en el sistema. La jerar-  
quía refleja cómo los dispositivos están conectados al mismo. Ejemplo, los dispositivos  
conectados al _bus_ externo, son sus descencientes. Los dipositivos del nodo `i2c`, son  
descendientes  del controlador de bus `i2c`. La jerarquía representa el _ámbito_   del  
sistema, desde la perspectiva de la CPU.

El  _árbol_ tratado, aún no es válido. Ha sido omitida, la información relacionada con  
las conexiones entre dispositivos. Los datos serán añadidos mas tarde.

Algunos datos importantes son:

* Cada dispositivo consta de la propiedad `compatible`.
* El nodo _flash_, posée dos cadenas en la propiedad `compatible`. Leer la siguiente  
sección, para entender por qué.
* Como fué mencionado anteriormente, los nombres de nodo reflejan el tipo de dispo-  
sitivo, no el modelo particular. Ver sección _2.2.2_ de la specificación ePAPR, para  
una lista genérica de nombre de nodo que deberían utilizarse habitualmente.


#### <a name="i9">Comprensión de la propiedad `compatible`</a> ####

Cada  nodo,  representando en el árbol, a un dispositivo; requerirá tener la  propiedad  
`compatible`.   `compatible` es la _llave_,  que  utiliza  el _OS_, para decidir   qué  
controlador bincular a _cual_ dispositivo.

`compatible`   es una lista de cadenas. La primera  cadena en la lista,  especifica  el  
dispositivo  exacto,  que representa al nodo con la forma `<fabricante>,<modelo>`. Las  
siguientes cadenas representan otros dispositivos _compatibles_.

Por ejemplo,   el sistema(SoC) `Freescale MPC8349`, posee un dispositivo en serie,  el 	
cual   implementa la interfasee  de  registro  _National Semiconductor  ns16550_.   La  
propiedad `compatible` para el _dispositivo en serie_ MPC8349, debería ser:  
`compatible = "fsl,mpc8349-uart, ns16550`. En este caso, _fsl,mpc8349-uart_ especifica  
el dispositivo exacto, y _ns16550_ determina su compatibilidad, a nivel de registro,  
con un _National Semiconductor 16550 UART_.  

__nota__: _ns16550_ no tiene prefijo de fabricante -sólo por razones históricas. Todos  
los valores `compatible` deberían utilizarse con el _prefijo de fabricante_.  

Esta   práctica,  permite  a _controladores_ existentes,  ser vinculados  a   nuevos  
dispositivos y, a la vez que identifica de forma única, el _hardware_ exacto.  

Advertencia:     no utilizar símbolos  "comodín",  en valores `compatible`    como  
`fsl,mpc83xx-uart` o similares. Vendedores de _chips de silicio_, invariablemente,  
quebrarán esta _asunción_ de reglas, en el peor momento. En su lugar, especificar el  
_hardware_, y compatibilizar el resto de _chips_ con él.  

#### <a name="i10">Funcionamiento del _enrutado</a> ####


Dispositivos   direccionables, utilizan las siguientes propiedades para  codificar  la  
información de dirección dentro del _DT_:  
		
		reg
		#address-cells
		#size-cells

Cada dispositivo direccionable, consigue un `reg`, el cual es una lista de _tuplas_ en  
forma   `<reg = <address1length1 [address2 length2] [address3 length3] ... >`.   Cada  
tupla  representa un rango, utilizado por el dispositivo. Cada valor, es una lista  de  
uno   o mas _enteros_ de `32bit` llamados celdas.  El tamaño del valor, podría   ser  
una lista de celdas, o estar vacío.  

Los campos _dirección_ y _longitud_, son variables en tamaño, las propiedades  
`#address-cells` y `#size-cells` en el nodo ascendente, son utilizadas para establecer  
cuantas   celdas tiene cada campo. En otras palabras, interpretar la propiedad   `reg`  
corectamente,   requiere el  valor de los nodos  ascendentes  `#address-cells`   y  
`#size-cells`.  Para ver como funciona  todo esto,  será añadida la propiedad _direc-_  
_cionado_, en el ejemplo DT.  

#### <a name="i11">Direccionado de CPU</a> ####

Los  nodos CPU. representan un caso simple cuando se habla acerca  del _direccionado_.  
Cada CPU es identificada con un úncio _ID_ -no hay tamaño asociado al mismo.


    cpus {
        #address-cells = <1>;
        #size-cells = <0>;
        cpu@0 {
            compatible = "arm,cortex-a9";
            reg = <0>;
        };
        cpu@1 {
            compatible = "arm,cortex-a9";
            reg = <1>;
        };
    };

En   los nodos CPUs, `#address-cells` es asignado a `1` y, `#size-cells` a `0`.  Esto  
significa  que los valores `reg` _descendientes_, son un único `32bit`, que  repre-  
senta la dirección de, sin el campos _tamaño_.
En éste caso, las dos CPUs, son asignadas a la dirección `0` y `1`. `#size-cells` es  
`0` para los nodos CPU, por que en amabas CPUs, sólo hay asignada una dirección.

El valor de `reg`, coincide con el valor del _nombre de nodo_. Por convención, si un  
nodo, tiene la propiedad `reg`, el nombre de nodo debe incluir `unit-addres`, el cual  
es el primer valor de dirección en la propiedad `reg`


#### <a name="i12">Dispositivo memoria de _mapeada_</a> ####


En lugar de una sóla dirección, tal y como se encuentra en los nodos CPU, la _memoria_  
_mapeada de un dispositivo_,   asigna un rango de direcciones, a las que  responderá.  
`#size-cells` es utilizado para establecer _cuánto de largo_, es el campo, en la tupla  
de la variable `reg`. En el siguiente ejemplo, cada valor para la dirección de celda  
`#address-cells` es `1`(32bit) y, cada valor de _longitud_, es también _una celda_.  
En sistemas de _32bit_, es esto lo habitual . Para máquinas de _64bit_, podría usarse  
el valor `2`, en los campos `#address-cells` y `#size-cells`, para conseguir _64bit_ en  
el direccionado del DT.

		/dts-v1/;

		/ {
				#address-cells = <1>;
				#size-cells = <1>;

				...

				serial@101f0000 {
				    compatible = "arm,pl011";
				    reg = <0x101f0000 0x1000 >;
				};

				serial@101f2000 {
				    compatible = "arm,pl011";
				    reg = <0x101f2000 0x1000 >;
				};

				gpio@101f3000 {
				    compatible = "arm,pl061";
				    reg = <0x101f3000 0x1000
				           0x101f4000 0x0010>;
				};

				interrupt-controller@10140000 {
				    compatible = "arm,pl190";
				    reg = <0x10140000 0x1000 >;
				};
				spi@10115000 {
				    compatible = "arm,pl022";
				    reg = <0x10115000 0x1000 >;
				};

				...

		};

Para   cada dispositivo, es asignada una _base_ de direccción y, un _tamaño_,  de  la  
región,   a la qque es asignada. la dirección de dispositivo GPIO en este ejemplo, es  
asignada a dos rangos; `0x101f3000...0x101f3fff` y `0x101f4000..0x101f400f`.

Algunos   dispositivos, se encuentran en un _bus_, con un esquema de  _direccionado_  
distinto.   Ejemplo, un dispositivo podría ser acoplado a un bus externo con _líneas_  
_discretas de selección de chips(discrete chip select lines)_.   Puesto que cada nodo  
ascendente, define el _nombre de dominio_ para su descendiente, el _mapeado_ de direc-  
ción,   podrá ser seleccionado, como mejor desccriba al sistema.  El código de abajo,  
muestra la asignación de dirección, para los dispositivos acoplados a un bus externo,  
codificando el número de chip(ID) seleccionado, dentro de la dirección.

		external-bus {
        #address-cells = <2>;
        #size-cells = <1>;

        ethernet@0,0 {
            compatible = "smc,smc91c111";
            reg = <0 0 0x1000>;
        };

        i2c@1,0 {
            compatible = "acme,a1234-i2c-bus";
            reg = <1 0 0x1000>;
            rtc@58 {
                compatible = "maxim,ds1338";
            };
        };

        flash@2,0 {
            compatible = "samsung,k8f1315ebm", "cfi-flash";
            reg = <2 0 0x4000000>;
        };
		};


El  bus externo, utiliza 2 celdas para el valor de dirección; una para seleccionar  el  
número   de chip y, otra par el `offset`, desde la base del _chip_ seleccionado.   La  
longitud   del campo, permanece como una sóla celda, ya que únicamente  la  parte  del  
`offset`   de la dirección, necesita tener un rango. Por lo que en este ejemplo, cada  
entrada `reg`, contiene tres celdas; _el número de chip_, _el offset_ y, _la longitud_.  

Como el  dominio de la dirección, en un nodo y su descendiente, los nodos ascendentes,  
son libres para definir cualquier _esquema de direccionado_, que tenga sentido para el  
bus. Los nodos que estén fuera del _ascendente_ y _descendente_ inmediato, no tendrán  
que preocuparse por el direccionado _local_, del dominio y, las direcciones deberán ser  
_mapeadas_, para ser obtenenidas de un nodo a otro.

#### <a name="i13">Dispositivo de memoria _no mapeada_</a> ####

Otros dispositivos no tienen un _mapa de memoria_ dentro del bus del procesador. Podrán  
tener   rangos  de direcciones, pero no son directamente accesibles por la CPU.   Los  
controladores   _ascendentes_, de dispositivo, deberían llevar a cabo _accesos  _indi-_  
_rectos_, en nombre de la CPU.

Para   seguir el ejemplo de dispositivos `i2c`, cada uno de ellos es asignado  a   una  
dirección, pero no hay un rango de direcciones asociadas a ellos. Se parece mucho más  
a la asignación de direcciones de la CPU.

        i2c@1,0 {
            compatible = "acme,a1234-i2c-bus";
            #address-cells = <1>;
            #size-cells = <0>;
            reg = <1 0 0x1000>;
            rtc@58 {
                compatible = "maxim,ds1338";
                reg = <58>;
                compatible = "maxim,ds1338";
                reg = <58>;
            };
        };


#### <a name="i14">Rangos (_traducción_ de direcciones)</a> ####

Hemos hablado sobre cómo asignar direcciones a un dispositivo, pero en este punto, esas  
direcciones son _locales_ al nodo de dispositivo. Aún no describen como _mapear_ desde  
esas direcciones a una dirección que pueda utilizar la CPU.

El nodo raíz, siempre describe el _punto de vista_ -o ámbito,  del espacio de dirección  
de la CPU. Nodos _descendientes_ de la _raíz_, ya usan la _dirección de dominio_ de las  
CPUs. No necesitan un mapeado explícito. Ejem. `serial@101f0000` es asignado a la  
dirección `0x101f0000`.

Los nodos que no son descendientes directos de la _raíz_, no utilizarán la _dirección_  
_de dominio_ de las CPUs. A fín de obtener _el direccionado del mapa de memoria_, el  
DT,   debe especificar cómo traducir estas direcciones, desde un dominio a otro.  La  
propiedad `ranges`(rangos), es utilizada con éste propósito.

		/dts-v1/;

		/ {
				compatible = "acme,coyotes-revenge";
				#address-cells = <1>;
				#size-cells = <1>;
				...
				external-bus {
				    #address-cells = <2>
				    #size-cells = <1>;
				    ranges = <0 0  0x10100000   0x10000     // Chipselect 1, Ethernet
				              1 0  0x10160000   0x10000     // Chipselect 2, i2c controller
				              2 0  0x30000000   0x1000000>; // Chipselect 3, NOR Flash

				    ethernet@0,0 {
				        compatible = "smc,smc91c111";
				        reg = <0 0 0x1000>;
				    };

				    i2c@1,0 {
				        compatible = "acme,a1234-i2c-bus";
				        #address-cells = <1>;
				        #size-cells = <0>;
				        reg = <1 0 0x1000>;
				        rtc@58 {
				            compatible = "maxim,ds1338";
				            reg = <58>;
				        };
				    };

				    flash@2,0 {
				        compatible = "samsung,k8f1315ebm", "cfi-flash";
				        reg = <2 0 0x4000000>;
				    };
				};
		};

`ranges` es una lista de traducciones de dirección. Cada entrada en la tabla de rangos  
es  una tupla, conteniendo la dirección _descendente_, _ascendente_ y, el tamaño de la  
región,   en el espacio de dirección _descendente_. El tamaño de cada campo, es deter-  
minado tomando los valores de las celdas `#address-cells` descendentes, ascendentes y,  
el   valor de la celda `#size-cells` descendente.  En el emplo del _bus externo_,   la  
dirección  descendente es de `2` celdas, y la dirección ascendente es `1` celda y, el  
tamaño es también `1` celda. Son traducidos tres rangos, -`range`:

		Offset 0 from chip select 0 is mapped to address range 0x10100000..0x1010ffff
		Offset 0 from chip select 1 is mapped to address range 0x10160000..0x1016ffff
		Offset 0 from chip select 2 is mapped to address range 0x30000000..0x30ffffff

De forma alternativa, si el espacio de dirección ascendente y descendente son identicos  
en su lugar,   el nodo podrá añadir la propiedad `ranges` vacía. La presencia  de  la  
propiedad  `ranges` vacia, significa que las direcciones, en el espacio de  dirección  
descendente, están _mapeados_ `1:1` dentro del espacio de dirección ascendente.

Podría   preguntarse, por qué la  traducción de direcciones, es utilizada para   todo,  
cuando _todo_ podría estar escrito con un _mapa_ `1:1`(uno a uno). Algunos buses -como  
PCI,  tienen un espacio de direcciones completamente distinto, cuyos detalles deberán   
ser expuestos _al SO_.   Otros, constan de _motor_ DMA, el cual necesita conocer  la   
dirección _real_ en el bus.  En ocasiones, los dispositivos necesitan estar agrupados,  
por que comparten el mismo _mapa físico de dirección_, para el _software_ programable.
Donde   el uso de _mapas_ `1:1` -o no, depende  estrechamente de la información   que  
necesite el OS, y del diswño del _hardware_.

Nótese también,  que no hay propiedad `ranges` en el nodo `i2c@1,0`. La razón,  que a  
diferencia del bus externo, dispositivos en el bus `i2c` no tienen un _mapa de memoria_  
en  la  dirección de dominio de la CPU.  En su lugar, la CPU accede indirectamente  al  
dispositivo  `rtc@58` a través de `i2c@1,0`. 
La   ausencia de  la propiedad `ranges`, significa que un  dispositivo no puede   ser  
accedido directamente por ninǵún otro dispositivo mas que por su ascendente.

#### <a name="i15">Cómo funcionan las interrupciones</a> ####

A diferencia de la traducción -memoria, de `range`, la cual sigue la estructura natural  
del árbol,   las señales de interrupción, podrán originarse y, finalizar, en cualquier  
dispositivo.  Contrariamente al direccionado de dispositivo,  -expesado naturamente  
en el DT; las señales de interrupción son enlaces entre nodos independientes del DT.  
Cuatro propiedades son utilizadas para describirlas:

* `interrupt-controller` Propiedad vacía, declarando un nodo como dispositivo que   
recive señales de linterrupción.
* `#interrupt-cells`  Propiedad del nodo contralador de interrupciones. Establece   
cuantas celdas hay, en el _especificador de interrupción_ del controlador. Similar a  
`#address-cells` y ` #size-cells`.
* `interrupt-parent` propiedad conteniendo un `phandle`[f99], al controlador de inte-  
rrupción,   al que está acoplado.  Nodos sin propiedad `interrupt-parent`,  prodrán  
heredarla desde el nodo ascendente.
* `interrupts`   Propiedad del nodo,  conteniendo  una  lista  de  especificadores  
interrupción, con una señal de salida, para cada uno.

Un   enumerador de interrupción, es una o  más  celdas de datos, definida   por  
`#interrupt-cells`  especificando a qué interrupción de entrada está acoplado  el  
dispositivo. La mayoría, sólo tienen una interrupción de salida, tal y como se muestra  
en el ejemplo de abajo. Es posible que hayan múltiples interrupciones de ssalida. El  
significado,  de un _especificador de interrupción_, depende énteramente del  enlace  
del  controlador de interrupción del dispositivo. Cada controlador de  interrupción,  
podrá decidir cuantas celdas necesita, inequívocamente una inetrrupción de entradda.

El siguiente código, añade conexiones de interrupción a nuestra máquina de ejemplo  
_Coyote's Revenge_:

		/dts-v1/;

		/ {
				compatible = "acme,coyotes-revenge";
				#address-cells = <1>;
				#size-cells = <1>;
				interrupt-parent = <&intc>;

				cpus {
				    #address-cells = <1>;
				    #size-cells = <0>;
				    cpu@0 {
				        compatible = "arm,cortex-a9";
				        reg = <0>;
				    };
				    cpu@1 {
				        compatible = "arm,cortex-a9";
				        reg = <1>;
				    };
				};

				serial@101f0000 {
				    compatible = "arm,pl011";
				    reg = <0x101f0000 0x1000 >;
				    interrupts = < 1 0 >;
				};

				serial@101f2000 {
				    compatible = "arm,pl011";
				    reg = <0x101f2000 0x1000 >;
				    interrupts = < 2 0 >;
				};

				gpio@101f3000 {
				    compatible = "arm,pl061";
				    reg = <0x101f3000 0x1000
				           0x101f4000 0x0010>;
				    interrupts = < 3 0 >;
				};

				intc: interrupt-controller@10140000 {
				    compatible = "arm,pl190";
				    reg = <0x10140000 0x1000 >;
				    interrupt-controller;
				    #interrupt-cells = <2>;
				};

				spi@10115000 {
				    compatible = "arm,pl022";
				    reg = <0x10115000 0x1000 >;
				    interrupts = < 4 0 >;
				};

				external-bus {
				    #address-cells = <2>
				    #size-cells = <1>;
				    ranges = <0 0  0x10100000   0x10000     // Chipselect 1, Ethernet
				              1 0  0x10160000   0x10000     // Chipselect 2, i2c controller
				              2 0  0x30000000   0x1000000>; // Chipselect 3, NOR Flash

				    ethernet@0,0 {
				        compatible = "smc,smc91c111";
				        reg = <0 0 0x1000>;
				        interrupts = < 5 2 >;
				    };

				    i2c@1,0 {
				        compatible = "acme,a1234-i2c-bus";
				        #address-cells = <1>;
				        #size-cells = <0>;
				        reg = <1 0 0x1000>;
				        interrupts = < 6 2 >;
				        rtc@58 {
				            compatible = "maxim,ds1338";
				            reg = <58>;
				            interrupts = < 7 3 >;
				        };
				    };

				    flash@2,0 {
				        compatible = "samsung,k8f1315ebm", "cfi-flash";
				        reg = <2 0 0x4000000>;
				    };
				};
		};


Señalar lo siguiente:
 
La máquina tiene un único controlador de interrupción, `interrupt-controller@10140000`.  
La etiqueta `intc:` ha sido añadida al nodo controlador de interrupción, y la etiqueta  
fué   utilizada para asignar un `phandle` a la propiedad `interrupt-parent` en el nodo  
raíz. El valor de `interrupt-parent` se tomará _por defecto_ en el sistema, puesto que  
los   nodos descendentes _heredarán_ su valor, a menos que explícitamente esté  sobre-  
escrito.
Cada  dispositivo utiliza una propiedad _interrpción_, para especificar una _línea de_  
_interrupción_ distinta. `#interrupt-cells` es `2`, por lo que cada _enumerador_ tendrá  
2 celdas. Este ejemplo, usa un patrón común; usar la primera celda, para codificar el  
número  de línea de interrupción y, la segunda celda, para codificar opciones  -flag,  
_sensibles_, como `active high` vs. `active low` o `edge` vs. `level`.
Para un controlador de interrupción dado, referir la documentación de _enlaces_, para  
aprender cómo dodificar los _enumeradores_.


#### <a name="i16">Datos específicos de dispositivo</a> ####

Tras   la propiedades comunes, otras _arbitrarias_ y, nodos descendentes, podrán   ser  
añadidas  a los nodos. Cualquier dato requerido por el OS, podrá ser añadido,  siempre  
que sigamos _determinadas regla_.

Primero,    los nombres de propiedades, para nuevos `device-specific`  -dispositivos  
específicos,   deberán usar un prefijo de fabricante, de esta mforma no entrarán  en  
conflicto, con nombres de propiedades estandar, ya existentes.

Segundo,   _la intención_ de la propiedad y los nodos descendentes,  deberá estar  
documentada en un enlace, así, el __autor__ de un controlador de dispositivo, sabrá  
como  interpretar los datos. Un enlace documenta qué significa un valor compatible en  
particular, qué propiedad debería tener, qué nodos descendentes podría enumerar y, a  
qué dispositivo representa. Cada valor `compatible` único, debería tener sus própias  
vinculaciones -o reclamar compatibilidad, con otro valor `compatible`. 
Vinculaciones para nuevos dispositivos serán documentados, proxímamente, en ésta _Web_.  
<www.territoriolinux.net> ][__fuente__](#f3).
Ver la página principal de la citada _fuente_, para una descripción del formato de  
documentación y proceso de revisión.

Tercero, publicar nuevas vinculaciones, para ser revisada en la lista de correo:
<devicetree-discuss@lists.ozlabs.org>. La revisión de nuevas vinculaciones, capturan  
muchos errores comunes, que causarán posteriores problemas.


#### <a name="i17">Nodos especiales</a> ####

__Nodo__ `aliases`

Un nodo específico es normalmente referido con la _ruta absoluta_, como:  
`/external-bus/ethernet@0,0,`,  pero resulta incómodo, cuando un usuario lo que quiere,  
es   saber _qué dispositivo es `eth0`_. Los nodos _alias_, pueden ser utilizados  para  
asignar un _nombre corto_, a la ruta de un dispositivo. Por ejemplo:  

    aliases {
        ethernet0 = &eth0;
        serial0 = &serial0;
    };

El  OS  es  _instado_ a utilizar estos _alias_, cuando es asignado un identificados  al  
dispositivo.  

Aparece  aquí, una nueva _sintaxis_. La propiedad `property = &label;` asigna la  ruta  
del nodo, referenciado por la _etiqueta_, como una propiedad de tipo `string` -cadena.  
Resulta distinto al formato _phandle_ `phandle = < &label >;` usado anteriormente.  
_Phandle_ inserta un valor dentro de la celda.


#### <a name="i18">Nodo _escogido_</a> ####

El  nodo _excogido_ -o seleccionado, representa un dispositivo real. Es utilizado como  
_lugar_,  para pasar datos entre el _firmware_ y el sistema operativo;   tales  como  
argumentos en el arranque. Los datos en el _nodo escogido_ no representa al _hardware_.  
Los   archivos fuente son guardados con formato `dts` y, suele estar vacío. Es poblado  
durante el arranque del sistema.

En el ejemplo de _sistema_, el _firmware_ podría añadir el siguiente código al nodo:

		chosen {
				bootargs = "root=/dev/nfs rw nfsroot=192.168.1.1 console=ttyS0,115200";
		};

#### <a name="i19">Temas avanzados</a> ####

__<a name="i20">Ejemplo _avanzado_ de máquina</a>__

Ha sido definido lo básico, es el momento de añadir "algo" de _hardware_ al ejemplo de  
máquina, y así discutir cuestiones más complicadas.

El _ejemplo avanzado_, añade un PCI _host bridge(puente anfitrión)_ el cuál controla  
los   registro de _memoria mapeada_ en `0x10180000`, y _barras programadas?(BARs)_ al  
principio de la dirección `0x80000000`.

Los siguentes datos aparecen en el DT, describiendose el nodo _PCI host bridge_ tal y  
como se sucede:


        pci@10180000 {
            compatible = "arm,versatile-pci-hostbridge", "pci";
            reg = <0x10180000 0x1000>;
            interrupts = <8 0>;
        };
        

#### <a name="i21">PCI host bridge(puente anfitrion PCI)</a> ####

Cierto conocimiento previo, sobre PCI, es necesario. Esto NO es un tutorial sobre PCI,  
de necesitar información sobre el mismo, son de recomendada lectura [f3]. Igualmente  
referirse a sPAPR v1.1[f4] or _vinculaciones al Bus PCI en Open Firmware_.  
Desde _Freescale_ `MPC5200` se muestra un ejemplo completamente funcional.


<a name="i22">__Enumeración del BUS PCI__</a>

Cada  segmente del bus PCI es enumerado de forma única y, expuesto el mismo en el nodo  
PCI. Por medio de la propiedad `bus-ranges`,  la cual contiene dos celdas. La primera  
celda, proporciona el número de bus, asignado al nodo. La segunda, delimita el número  
máximo de bus, de cualquier bus PCI subordinado.  

El ejemplo de máquina, contiene un único bus PCI, por lo que hay `0` celdas.  

        pci@0x10180000 {
            compatible = "arm,versatile-pci-hostbridge", "pci";
            reg = <0x10180000 0x1000>;
            interrupts = <8 0>;
            bus-ranges = <0 0>;
        };

#### <a name="i23">Traducción del direccionado PCI</a> ####

De forma similar, al bus local descrito con anterioridad, el espacio de dirección PCI,  
aparece completamente separado del espacio de dirección de la CPU. La _traducción_ de  
direcciones, es necesaria para obtener una dirección desde PCI a la CPU. Esto siempre  
se lleva a cabo utilizando un rango, en la propiedades `#address-cells` y `#size-cells`  

        pci@0x10180000 {
            compatible = "arm,versatile-pci-hostbridge", "pci";
            reg = <0x10180000 0x1000>;
            interrupts = <8 0>;
            bus-ranges = <0 0>;

            #address-cells = <3>
            #size-cells = <2>;
            ranges = <0x42000000 0 0x80000000 0x80000000 0 0x20000000
                      0x02000000 0 0xa0000000 0xa0000000 0 0x10000000
                      0x01000000 0 0x00000000 0xb0000000 0 0x01000000>;
        };
        
        
Tal y como se aprecia, la dirección _descendente_(PCI) usa 3 celdas y, los rangos PCI  
están codificados en dos celdas. La primera questión podría ser, ¿ por qué necesitamos  
tres celdas de `32bit` para especificar _una_ dirección PCI?  
Hay _tres etiquetas_ de celda; `phys.hi, phys.mid` y ` phys.low` [f3]  

    phys.hi cell: npt000ss bbbbbbbb dddddfff rrrrrrrr
    phys.mid cell: hhhhhhhh hhhhhhhh hhhhhhhh hhhhhhhh
    phys.low cell: llllllll llllllll llllllll llllllll

Las   direcciones PCI, son `64bit` de _ancho_ y, están codificadas en  `phys.mid`  y  
`phys.low`. Aunque lo realmente interesante aparece en el campo `phys.hi`, siendo un  
_campo de bit_.


* `n`: opción de región reasignable. Aquí no juega ningun papel.
* `p`: prefetchable(predecible?) cacheable. Opción de región.
* `t`: alias. Opción de región. Aquí no juega ningun papel.
* `ss`: espacio de código.
* `00`: espacio de configuración
* `01`: espacio I/O
* `10`: espacio de memoria de 32 bit
* `11`: espacio de memoria de 64 bit
* `bbbbbbbb`: el número de bus PCI. Podría estar estructurado jerárquicamente. Así que  
podría ser un PCI/PCI bridge, el cual definiría buses subordinados.
* `fff`: el número de la función. Usado en dispositivos PCI multifunción.
* `rrrrrrrr`: número de registro; utilizado en la configuración de _ciclos_.

En   la propuesta _traducción de direcciones PCI_, los campos importantes son `ss`.  El  
valor  de `p` y `ss` en `phys.hi`, determina qué espacio de dirección PCI, está  siendo  
accedida. Mirando en la propiedad `ranges`, son encontradas tres regiones:

* una memoria predecible(chacheable) de 32bit. Empezando en la dirección `0x80000000`  
PCI, de `512 Mbyte` de tamaño, la cuál está mapeada en la dirección `0x80000000` dentro  
de la CPU _anfitrion_.
* una memoria no predecible de 32bit. Empezando en la dirección `0xa0000000` PCI, de  
`256 MByte` de tamaño, la cuál está mapeada en la dirección `0xa0000000` dentro  
de la CPU _anfitrion_.
* una región `I/O` Empezando en la dirección `0x00000000` PCI, de `16 MByte` de tamaño, la cuál está mapeada en la dirección `0xb0000000` dentro de la CPU _anfitrion_.

De  alguna manera, la presencia del _campo de bit_ `phys.hi`, significa que un sistema  
operativo, necesita saber qué nodo representa al _puente pci_, por lo que se ignorarán  
los campos irrelevantes, en favor de la _traducción de dirección_. El OS, deberá mirar  
el la _cadena_ `pci` dentro del nodo de bus PCI, para determinar dónde _enmascarar_ los  
campos extra.

#### <a name="i24">Interrupción avanzada, mapa(de memoria)</a> ####

_Ahora viene la parte interesante_...
 Mapeado    de interrupción PCI.  Un dispositivo  PCI, podrá activar   interrupciones,  
utilizando  _conexiones(wire)_ `#INTA, #INTB, #INTC` e `#INTD`.   Una _función única_  
de    dispositivo(single-function),  es obligada   a   utilizar  `#INTA`  para   las  
interrupciones.
Una _multi función_ de dispositivo, debe utilizar `#INTA` si utiliza un sólo _pin_ de  
interrupción, `#INTA` y `#INTB` si utiliza dos _pins_ de interrupción, etc.

Debido   a estas reglas, `#INTA` es usado  con mayor frecuencia que `#INTB, #INTC`   e  
`#INTD`.  Para distribuir la _carga_, sobre la cuatro líneas de interrupción `#INTA` a  
`#INTD`,   cada zócalo de dispositivo PCI,   es habitualmente conectado a   distintas  
_entradas_ del controlador de linterrupciones, de forma rotatoria, para así, evitar que  
todos los   _clientes_-ejem. SO.  tengan que   estar  conectados a la misma línea   de  
interrupción -_entrada_. A este procedimiento lo llaman _swizzling_ las interrupciones.

El DT, necesitará una forma de _mapear_ cada señal de interrupción PCI, en las entradas  
del controlador. Las propiedades `#interrupt-cells`, `interrupt-map` y `interrupt-map-mask`  
son utilizadas para describir el _mapeado_ de interrupción.

Actualmente   el _mapeado_ de interrupción, descrito aquí, no se limita únicamente   al  
bus PCI, cualquier nodo, podría especificar complejos mapas de interrupción, pero en el  
caso del PCI, es por mucho, el más habitual.

        pci@0x10180000 {
            compatible = "arm,versatile-pci-hostbridge", "pci";
            reg = <0x10180000 0x1000>;
            interrupts = <8 0>;
            bus-ranges = <0 0>;

            #address-cells = <3>
            #size-cells = <2>;
            ranges = <0x42000000 0 0x80000000  0x80000000  0 0x20000000
                      0x02000000 0 0xa0000000  0xa0000000  0 0x10000000
                      0x01000000 0 0x00000000  0xb0000000  0 0x01000000>;

            #interrupt-cells = <1>;
            interrupt-map-mask = <0xf800 0 0 7>;
            interrupt-map = <0xc000 0 0 1 &intc  9 3 // 1st slot
                             0xc000 0 0 2 &intc 10 3
                             0xc000 0 0 3 &intc 11 3
                             0xc000 0 0 4 &intc 12 3

                             0xc800 0 0 1 &intc 10 3 // 2nd slot
                             0xc800 0 0 2 &intc 11 3
                             0xc800 0 0 3 &intc 12 3
                             0xc800 0 0 4 &intc  9 3>;
        };


En   primer lugar, debe ser notado, que los números de interrupción PCI, utilizan  una  
única celda, a pesar de que el sistema controlador de interrupciones use 2 celdas; una  
para el número IRQ, otra para las opciones(flags). PCI sólo necesita una celda, para  
las interrupciones, por que son _especificadas_, para ser siempre sensibles a _bajo_  
_nivel_.

En la placa de ejemplo, aparecen 2 zócalos PCI, con 4 líneas de interrupción, respec-  
tivamente.     Habrá que _mapear_ 8 líneas de   interrupción, en el controlador   de  
interrupciones. LLevado a cabo, por medio de la propiedad `interrupt-map`. El proce-  
dimiento exacto en el mapeado de interrupción, es descrito en [f5]

Puesto que el número de interrupción -`#INTA` etc, no es suficiente para distinguir  
entre   diversos dispositivos PCI, sobre un   bus PCI, es necesario observar,   qué  
dispositivo PCI, activó la línea de interrupción. Afortunádamente, cada dispositivo  
PCI, tiene un _número único_, de dispositivo, utilizado para dicho propósito.  
Para   distinguir, entre varios dispositivos PCI,  es necesaria una tupla,   la cual  
consta  de _número de dispositivo PCI_ y, _número de interrupción PCI_.   En general,  
construiremos una _unidad enumeradora de interrupción_, con cuatro celdas:

		tres #address-cells constituidad por phys.hi, phys.mid, phys.low, y
		una #interrupt-cell (#INTA, #INTB, #INTC, #INTD).

Puesto que sólo es necesaria la parte del número de dispositivo, de la dirección PCI,  
la propiedad `interrupt-map-mask`, _entra en juego_. `interrupt-map-mask` es también  
una tupla _4-tupla_, como la unidad enumeradora de interrupción. La 1, es la máscara  
cuya parte unidad enumeradora de interrupción, deberá mmtomarse en consideración. En  
el ejemplo, puede verse que sólo la parte del número de dispositivo de `phys.hi`, es  
requerido   y, se necesitarán 3 _bits_, para  distiguir   entre las cuatro líneas   de  
interrupión. Empiezan a contar desde `1` no desde `0`.

Ahora es construida la propiedad `interrupt-map`. Esta propiedad, es una tabla y, cada  
entrada en la misma, consiste en una unidad enumeradora de interrupción descendente  
-bus PCI, un controlador ascendente (el controlador de interrupción, es representado  
para servir, presentar, las interrupciónes). También el ascendente.
Así que,   en la primera línea, pueda leerse que la linterrupción PCI `#INTA`, está  
mapeado en _IRQ 9_ -bajo nivel sensitivo del controlador de interrupción[f6] 

La única parte que falta hasta el momento, es los extraños números de la unidad enu-  
meradora de interrupción. La parte importante, es el número de dispositivo en el campo  
`phys.hi`. El número de dispositivo es específico de la placa y, depende de, _cómo_  
el   controlador anfitrión PCI, activa el pin IDSEL, en cada dispositivo.   En este  
ejemplo, el zócalo PCI 1, es asignado al ID de dispositivo `24 (0x18)` y, el zócalo  
PCI 2, es asignado al ID de dispositivo `25 (0x19)`. El valor de `phys.hi` para cada  
zócalo, es determinado por el número dispositio coincidente -hasta 11 bits, encontrado  
en la sección `ddddd` del _campo bit_:

		phys.hi for slot 1 is 0xC000, y
		phys.hi for slot 2 is 0xC800.

Colocándolos todos juntos, la propiedad `interrupt-map` muestra:

		#INTA of slot 1 is IRQ9, level low sensitive on the primary interrupt controller
		#INTB of slot 1 is IRQ10, level low sensitive on the primary interrupt controller
		#INTC of slot 1 is IRQ11, level low sensitive on the primary interrupt controller
		#INTD of slot 1 is IRQ12, level low sensitive on the primary interrupt controller

y

		#INTA of slot 2 is IRQ10, level low sensitive on the primary interrupt controller
		#INTB of slot 2 is IRQ11, level low sensitive on the primary interrupt controller
		#INTC of slot 2 is IRQ12, level low sensitive on the primary interrupt controller
		#INTD of slot 2 is IRQ9, level low sensitive on the primary interrupt controller

Las propiedades de interrupción = <8 0>; describen la interrupciones del controlador  
_host/PCI-bridge_, que él mismo activa. No mezclar estas interrupciones con disposi-  
tivos de interrupción PCI, que pudieran activar (using INTA, INTB, ...).

Nota final. igual que en la propiedad `interrupt-parent`, la presencia de la propiedad  
`interrupt-map`,   en un nodo, cambiará el _controlador por defecto_ , para todos  los  
descendentes y nodos _afínes_. En éste ejemplo PCI, significa que el _host/PCI-bridge_  
pasa   a ser el controlador de interrupción _por defecto_. Si un dispositivo acoplado  
vía   el  bus PCI, tubiese una conexión  directa,  a otro controlador,   necesitaría  
especificar su propiedad `interrupt-parent`.


***************

#### <a name="i99">Referencias y agradecimientos</a> ####

<a name="f3"> :</a>[wiki-elinux.org](https://elinux.org/Device_Tree_Usage)

[f1]enlace al artículo sobre símbolos de ruby?-- comprobar  
<a name="f2">[f2]</a> 
ver <a name="http://territoriolinux.net/TerritorioLinux/siglas.html">siglas</a>.  

[f2] enlace a phandle

[f3] https://www.mindshare.com/

[f4] ePAPR

[f5]  Open Firmware Recommended Practice: Interrupt Mapping

[f6] PCI interrupts are always level low sensitive

nota d.t. _torrente de byte_, byte stream:  

nota d.t. sibling, hermano. En Territorio Linux, optamos por alejarnos de connotaciones  
negativas. A nuestro juicio, la traducción al castellano, de las palabras _sibling,  
parent_ o _child_, tiene la __peor__, de las connotaciones posibles. Hemos decidido  
traducirlas por:  
		_ascendente, descendente y afín_.  

nota d.t. muchas de las abreviaturas y definiciones o tecnicísmos, son descritas en  
otros documentos, por lo que se ha evitado su reiteración. Utilícese los mecanísmos  
habituales -ejem. [siglas](http://www.territoriolinux.net/TerritorioLinux/siglas.html  
[indice](http://www.territoriolinux.net/TerritorioLinux/porTema.html)  
para referirse a éstos.




<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>

afín, semejante, parejo, rayano, equivalente

