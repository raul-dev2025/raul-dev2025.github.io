1.  `Prólogo <#i1>`__
2.  `Contenido <#i2>`__
3.  `Formato de datos básico <#i3>`__
4.  `Conceptos básicos <#i4>`__
5.  `Estructura inicial <#i5>`__
6.  `CPUs <#i6>`__
7.  `Nombre de nodos <#i77>`__
8.  `Dispositivos <#i8>`__
9.  `Comprensión de la propiedad ``compatible`` <#i9>`__
10. `Funcionamiento del \_enrutado <#i10>`__
11. `Direccionado de CPU <#i11>`__
12. `Dispositivo de memoria mapeada <#i12>`__
13. `Dispositivo de memoria no mapeada <#i13>`__
14. `Rangos (traducción de direcciones) <#i14>`__
15. `Cómo funcionan las interrupciones <#i15>`__
16. `Datos específicos de dispositivo <#i16>`__
17. `Nodos especiales <#i17>`__
18. `Nodo escogido <#18>`__
19. `Temas avanzados <#i19>`__
20. `Ejemplo avanzado de máquina <#i20>`__
21. `PCI host bridge(puente anfitrion PCI) <#i21>`__
22. `Enumeración del BUS PCI <#i22>`__
23. `Traducción del direccionado PCI <#i23>`__
24. `Interrupción avanzada, mapa(de memoria) <#i24>`__
25. `Referencias y agradecimientos <#i99>`__

--------------

Uso del árbol de dispositivo
============================

Prólogo
^^^^^^^

Página localizada previamente en
``htttp://devicetree.org/Device_Tree_Usage``

| El documento, describe *cómo* escribir un *árbol de dispositivo* sobre
  una máquina
| nueva. Está destinada a proporcionar una *vista previa*, a los
  conceptos del árbol
| de dispositivos y, *coḿo* son utilizados para describiir la *maquina*.

| Para una más detallada descripción del *formato datos* del árbol de
  dispositivo -*DT* en
| adelante, refiérase a la especificación *ePAPR v1.1*. Dicha
  especificación, cubre con
| mucho más detalle los temas básicos aquí descritos. La *ePAPR v1.1*
  está siendo actua-
| lizada con nueva documentación específica.

Contenido
^^^^^^^^^

- Formato de datos básico
- Conceptos básicos
- Ejemplo de máquina

  - Estructura inicial
  - CPUs
  - Nombres de *nodo*
  - Dispositivos
  - Comprensión de la propiedad ``compatible``

- Funcionamiento del *enrutado*

  - Direccionado de CPU
  - Dispositivo memoria de *mapeada*
  - Dispositivo memoria de *no mapeada*
  - Rangos (*traducción* de direcciones)

- Cómo funcionan las interrupciones
- Datos específicos de dispositivo
- Nodos especiales

  - Alias de nodo
  - Nodo *escogido*

- Temas avanzados

  - Ejemplo *avanzado* de máquina
  - PCI host bridge(puente anfitrion PCI)

    - Enumeración del BUS PCI
    - Traducción del direccionado PCI
    - Interrupción avanzada, mapa(de memoria)

- Notas

Formato de datos básico
^^^^^^^^^^^^^^^^^^^^^^^

| El *DT* es una estructura simple con nodos y propiedades. Las
  *propiedades* son pares de
| valores , y el nodo, podrá contener tanto nodos *descendientes*, como
| *propiedades*. Por ejemplo, el siguiente es una *árbol simple* en
  formato ``.dts``:

::

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

| Ahora mismo, éste *árbol* es poco útil, por que no describe nada;
  muestra la estructura
| de **nodos** y **propiedades**:

- Un único *nodo* raíz ``/``
- Un par de nodos *descendientes*: **nodo1** y **nodo2**.
- Otro par de nodos *descendientes del nodo* 1 y 2.
- Un conjunto de propiedades, dispuestas en la extensión del árbol.

| Las propiedades son simples valores , donde el valor, podrá aparecer
| vacio o, conteniendo un *torrente de byte*, arbitrario. Mientras los
  *tipos de datos*, sean codificados dentro de la *estructura de datos*,
| habrá un conjunto de representaciones fundamentales, que podrán ser
  expresadas en un
| archivo fuente *DT*.

- *Cadenas de texto*\ (terminación nula[f1]) serán representadas con
  doble comilla ``"``: string-property = “una cadena”;
- *Celdas*, *números enteros* de ``32 bit``, delimitados por *ángulos*
  ``<>``: cell-property = <0xbeef 123 0xabcd1234>;
- Datos binarios están delimitados por *corchetes* ``[]``:
  binary-property = [0x01 0x23 0x45 0x67];
- Representaciones de datos distintos, podrán ser concatenados usando la
  *coma* ``,``: mixed-property = “a string”, [0x01 0x23 0x45 0x67],
  <0x12345678>;
- Las comas, serán utilizadas para crear *listas de cadenas*:
  string-list = “red fish”, “blue fish”;

Conceptos básicos
^^^^^^^^^^^^^^^^^

| Comprender cómo utilizar el *DT*, empieza por utilizar una simple
  máquina y, construir
| un *árbol*, para describirlo *paso a paso*.

**Ejemplo de máquina**

| Considerada una máquina imaginaria, *basada en la versátil
  arquitectura ARM*, manufac-
| turado por *Acme* y llamada *la venganza-del-Coyote*:

- Una CPU ARM, de ``32bit``
- Procesador de *bus* local, acoplado a la *memoria mapeada* del puerto
  en serie,
  controlador de *bus spi\ *\ `f2 <f2>`__, controlador *i2c*,
  controlador de interrupción y,
  *bus puente externo(external bus bridge)*.
- 256MB de SDRAM basada en ``0``\ (dirección de memoria).
- 2 puertos en serie basado en ``0x101F1000 and 0x101F2000``
- Controlador GPIO basado en ``0x101F3000``
- Controlador SPI basado en ``0x10170000``, con los siguientes
  dispositivos:

  - Zócalo MMC con *pin* SS acoplado al GPIO ``#1``.

- *Bus puente externo* con los siguientes componentes:

  - Dispositivo *Ethernet* SMC SMC91111, acoplado al *bus* basado
    ``0x10100000``
  - Controlador *i2c* basado en ``0x10160000`` con los siguientes
    dispositivos:
  - Reloj de Tiempo Real(RTC) *Maxim DS1338*. responde a la dirección
    *esclava* ``1101000 (0x58)``.
  - 64MB de una memoria flash, tipo NOR, basada en ``0x30000000``.

Estructura inicial
^^^^^^^^^^^^^^^^^^

| El primer paso es desplegar el *esqueleto* de la estructura, de la
  máquina. Es la
| estructura mínima necesaria, que requiere un *árbol* válido. En esta
  etapa, debe iden-
| tificarse, *inequívocamente*, la máquina.

::

       /dts-v1/;

       / {
               compatible = "acme,coyotes-revenge";
       };

| El nombre del sistema es especificado por la propiedad ``compatible``.
  contiene una
| cadena en su forma ``<fabricante>,<modelo>``. Es importante
  especificar el nombre exacto
| del dispositivo, e incluir el nombre del *fabricante*, para evitar
  *colisión* en el
| *espacio de nombres*. Puesto que el sistema operativo, usará el valor
  ``compatible`` para
| tomar decisiones, sobre cómo *correr, funcionar*, en la máquina; es
  muy importante
| colocar correctamente los datos, en sus propiedades.

| En teoría, ``compatible``, son todos los datos que un *OS*, necesitará
  para identificar
| de forma inequívoca, a la máquina. La presunción de sus detalles, dará
  lugar a que el
| OS, pueda buscar por ``"acme,coyotes-revenge"`` específicamente, en el
  *nivel más alto*,
| de la propiedad ``copatible``.

CPUs
^^^^

| El siguiente paso, es describir cada una de las CPUs. Un nodo
  contenedor, llamado
| ``"cpus"``, será añadido junto a un *nodo descendiente*, para cada
  CPU. En éste caso el
| sistema es de *doble núcleo*, ``Cortex A9`` en ARM.

::

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

| La propiedad compatible e cada *nodo CPU*, es una cadena,
  especificando
| el modelo exacto de CPU, formato ``<fabricante>,<modelo>``.
| Igual que para la propiedad ``compatible`` en el nivel superior.

| Serán añadidas otras propiedades a la CPU, más tarde. Primero
  hablaremos de conceptos
| más específicos.

Nombre de nodos
^^^^^^^^^^^^^^^

| Vale la pena, tomarse un momento, para hablar sobre *convenciones en
  el nombrado*. Cada
| nodo, deberá tener un *nombre* en formato ``<name>[@<unit-address>]``.

| ``<name>`` es una cadena ASCII, simple. Podrá contener hasta 31
  carácteres -tamaño. En
| general, los nodos son nombrados de acuerdo al tipo de dispositivo
  representado. El
| nodo de un adpatador *Ethernet 3com*, utilizaría el nombre
  ``ethernet`` no *3com509*.

| ``[@<unit-address>]`` es incluida si el nodo describe al dispositivo
  con una dirección.
| Habitualmente, la *dirección de unidad*, es la dirección principal,
  utilizada para
| acceder al dispositibo, y es listado en la propiedad ``reg`` del nodo.
  Dicha propiedad
| será cubierta posteriormente, en éste documento.

| Nodos *afín*, deben ser llamados de forma unequívoca, aunque es
  habitual que más de un
| nodo utilize el mismo nombre genérico, siempre que la dirección sea
  distinta.

Ver sección *2.2.1* de EPAPR, para una descripción detallada.

Dispositivos
^^^^^^^^^^^^

| Cada dispositivo en el sistema, está representado por un nodo *DT*. El
  siguiente paso,
| será poblar el *árbol* con un nodo por cada dispositivo. Por ahora,
  *los nuevos*, per-
| manecerán vacíos, hasta hablar acerca de cómo los rangos de
  direcciones e IRQs son
| gestionadas.

::

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

| En este árbol, ha sido añadido un nodo, poor cada dispositivo en el
  sistema. La jerar-
| quía refleja cómo los dispositivos están conectados al mismo. Ejemplo,
  los dispositivos
| conectados al *bus* externo, son sus descencientes. Los dipositivos
  del nodo ``i2c``, son
| descendientes del controlador de bus ``i2c``. La jerarquía representa
  el *ámbito* del
| sistema, desde la perspectiva de la CPU.

| El *árbol* tratado, aún no es válido. Ha sido omitida, la información
  relacionada con
| las conexiones entre dispositivos. Los datos serán añadidos mas tarde.

Algunos datos importantes son:

- Cada dispositivo consta de la propiedad ``compatible``.
- El nodo *flash*, posée dos cadenas en la propiedad ``compatible``.
  Leer la siguiente
  sección, para entender por qué.
- Como fué mencionado anteriormente, los nombres de nodo reflejan el
  tipo de dispo-
  sitivo, no el modelo particular. Ver sección *2.2.2* de la
  specificación ePAPR, para
  una lista genérica de nombre de nodo que deberían utilizarse
  habitualmente.

Comprensión de la propiedad ``compatible``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Cada nodo, representando en el árbol, a un dispositivo; requerirá
  tener la propiedad
| ``compatible``. ``compatible`` es la *llave*, que utiliza el *OS*,
  para decidir qué
| controlador bincular a *cual* dispositivo.

| ``compatible`` es una lista de cadenas. La primera cadena en la lista,
  especifica el
| dispositivo exacto, que representa al nodo con la forma
  ``<fabricante>,<modelo>``. Las
| siguientes cadenas representan otros dispositivos *compatibles*.

| Por ejemplo, el sistema(SoC) ``Freescale MPC8349``, posee un
  dispositivo en serie, el
| cual implementa la interfasee de registro *National Semiconductor
  ns16550*. La
| propiedad ``compatible`` para el *dispositivo en serie* MPC8349,
  debería ser:
| ``compatible = "fsl,mpc8349-uart, ns16550``. En este caso,
  *fsl,mpc8349-uart* especifica
| el dispositivo exacto, y *ns16550* determina su compatibilidad, a
  nivel de registro,
| con un *National Semiconductor 16550 UART*.

| **nota**: *ns16550* no tiene prefijo de fabricante -sólo por razones
  históricas. Todos
| los valores ``compatible`` deberían utilizarse con el *prefijo de
  fabricante*.

| Esta práctica, permite a *controladores* existentes, ser vinculados a
  nuevos
| dispositivos y, a la vez que identifica de forma única, el *hardware*
  exacto.

| Advertencia: no utilizar símbolos “comodín”, en valores ``compatible``
  como
| ``fsl,mpc83xx-uart`` o similares. Vendedores de *chips de silicio*,
  invariablemente,
| quebrarán esta *asunción* de reglas, en el peor momento. En su lugar,
  especificar el
| *hardware*, y compatibilizar el resto de *chips* con él.

Funcionamiento del \_enrutado ####
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Dispositivos direccionables, utilizan las siguientes propiedades para
  codificar la
| información de dirección dentro del *DT*:

::

       reg
       #address-cells
       #size-cells

| Cada dispositivo direccionable, consigue un ``reg``, el cual es una
  lista de *tuplas* en
| forma
  ``<reg = <address1length1 [address2 length2] [address3 length3] ... >``.
  Cada
| tupla representa un rango, utilizado por el dispositivo. Cada valor,
  es una lista de
| uno o mas *enteros* de ``32bit`` llamados celdas. El tamaño del valor,
  podría ser
| una lista de celdas, o estar vacío.

| Los campos *dirección* y *longitud*, son variables en tamaño, las
  propiedades
| ``#address-cells`` y ``#size-cells`` en el nodo ascendente, son
  utilizadas para establecer
| cuantas celdas tiene cada campo. En otras palabras, interpretar la
  propiedad ``reg``
| corectamente, requiere el valor de los nodos ascendentes
  ``#address-cells`` y
| ``#size-cells``. Para ver como funciona todo esto, será añadida la
  propiedad *direc-*
| *cionado*, en el ejemplo DT.

Direccionado de CPU
^^^^^^^^^^^^^^^^^^^

| Los nodos CPU. representan un caso simple cuando se habla acerca del
  *direccionado*.
| Cada CPU es identificada con un úncio *ID* -no hay tamaño asociado al
  mismo.

::

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

| En los nodos CPUs, ``#address-cells`` es asignado a ``1`` y,
  ``#size-cells`` a ``0``. Esto
| significa que los valores ``reg`` *descendientes*, son un único
  ``32bit``, que repre-
| senta la dirección de, sin el campos *tamaño*. En éste caso, las dos
  CPUs, son asignadas a la dirección ``0`` y ``1``. ``#size-cells`` es
| ``0`` para los nodos CPU, por que en amabas CPUs, sólo hay asignada
  una dirección.

| El valor de ``reg``, coincide con el valor del *nombre de nodo*. Por
  convención, si un
| nodo, tiene la propiedad ``reg``, el nombre de nodo debe incluir
  ``unit-addres``, el cual
| es el primer valor de dirección en la propiedad ``reg``

Dispositivo memoria de *mapeada*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| En lugar de una sóla dirección, tal y como se encuentra en los nodos
  CPU, la *memoria*
| *mapeada de un dispositivo*, asigna un rango de direcciones, a las que
  responderá.
| ``#size-cells`` es utilizado para establecer *cuánto de largo*, es el
  campo, en la tupla
| de la variable ``reg``. En el siguiente ejemplo, cada valor para la
  dirección de celda
| ``#address-cells`` es ``1``\ (32bit) y, cada valor de *longitud*, es
  también *una celda*.
| En sistemas de *32bit*, es esto lo habitual . Para máquinas de
  *64bit*, podría usarse
| el valor ``2``, en los campos ``#address-cells`` y ``#size-cells``,
  para conseguir *64bit* en
| el direccionado del DT.

::

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

| Para cada dispositivo, es asignada una *base* de direccción y, un
  *tamaño*, de la
| región, a la qque es asignada. la dirección de dispositivo GPIO en
  este ejemplo, es
| asignada a dos rangos; ``0x101f3000...0x101f3fff`` y
  ``0x101f4000..0x101f400f``.

| Algunos dispositivos, se encuentran en un *bus*, con un esquema de
  *direccionado*
| distinto. Ejemplo, un dispositivo podría ser acoplado a un bus externo
  con *líneas*
| *discretas de selección de chips(discrete chip select lines)*. Puesto
  que cada nodo
| ascendente, define el *nombre de dominio* para su descendiente, el
  *mapeado* de direc-
| ción, podrá ser seleccionado, como mejor desccriba al sistema. El
  código de abajo,
| muestra la asignación de dirección, para los dispositivos acoplados a
  un bus externo,
| codificando el número de chip(ID) seleccionado, dentro de la
  dirección.

::

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

| El bus externo, utiliza 2 celdas para el valor de dirección; una para
  seleccionar el
| número de chip y, otra par el ``offset``, desde la base del *chip*
  seleccionado. La
| longitud del campo, permanece como una sóla celda, ya que únicamente
  la parte del
| ``offset`` de la dirección, necesita tener un rango. Por lo que en
  este ejemplo, cada
| entrada ``reg``, contiene tres celdas; *el número de chip*, *el
  offset* y, *la longitud*.

| Como el dominio de la dirección, en un nodo y su descendiente, los
  nodos ascendentes,
| son libres para definir cualquier *esquema de direccionado*, que tenga
  sentido para el
| bus. Los nodos que estén fuera del *ascendente* y *descendente*
  inmediato, no tendrán
| que preocuparse por el direccionado *local*, del dominio y, las
  direcciones deberán ser
| *mapeadas*, para ser obtenenidas de un nodo a otro.

Dispositivo de memoria *no mapeada*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Otros dispositivos no tienen un *mapa de memoria* dentro del bus del
  procesador. Podrán
| tener rangos de direcciones, pero no son directamente accesibles por
  la CPU. Los
| controladores *ascendentes*, de dispositivo, deberían llevar a cabo
  \_accesos *indi-*
| *rectos*, en nombre de la CPU.

| Para seguir el ejemplo de dispositivos ``i2c``, cada uno de ellos es
  asignado a una
| dirección, pero no hay un rango de direcciones asociadas a ellos. Se
  parece mucho más
| a la asignación de direcciones de la CPU.

::

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

Rangos (*traducción* de direcciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Hemos hablado sobre cómo asignar direcciones a un dispositivo, pero en
  este punto, esas
| direcciones son *locales* al nodo de dispositivo. Aún no describen
  como *mapear* desde
| esas direcciones a una dirección que pueda utilizar la CPU.

| El nodo raíz, siempre describe el *punto de vista* -o ámbito, del
  espacio de dirección
| de la CPU. Nodos *descendientes* de la *raíz*, ya usan la *dirección
  de dominio* de las
| CPUs. No necesitan un mapeado explícito. Ejem. ``serial@101f0000`` es
  asignado a la
| dirección ``0x101f0000``.

| Los nodos que no son descendientes directos de la *raíz*, no
  utilizarán la *dirección*
| *de dominio* de las CPUs. A fín de obtener *el direccionado del mapa
  de memoria*, el
| DT, debe especificar cómo traducir estas direcciones, desde un dominio
  a otro. La
| propiedad ``ranges``\ (rangos), es utilizada con éste propósito.

::

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

| ``ranges`` es una lista de traducciones de dirección. Cada entrada en
  la tabla de rangos
| es una tupla, conteniendo la dirección *descendente*, *ascendente* y,
  el tamaño de la
| región, en el espacio de dirección *descendente*. El tamaño de cada
  campo, es deter-
| minado tomando los valores de las celdas ``#address-cells``
  descendentes, ascendentes y,
| el valor de la celda ``#size-cells`` descendente. En el emplo del *bus
  externo*, la
| dirección descendente es de ``2`` celdas, y la dirección ascendente es
  ``1`` celda y, el
| tamaño es también ``1`` celda. Son traducidos tres rangos, -``range``:

::

       Offset 0 from chip select 0 is mapped to address range 0x10100000..0x1010ffff
       Offset 0 from chip select 1 is mapped to address range 0x10160000..0x1016ffff
       Offset 0 from chip select 2 is mapped to address range 0x30000000..0x30ffffff

| De forma alternativa, si el espacio de dirección ascendente y
  descendente son identicos
| en su lugar, el nodo podrá añadir la propiedad ``ranges`` vacía. La
  presencia de la
| propiedad ``ranges`` vacia, significa que las direcciones, en el
  espacio de dirección
| descendente, están *mapeados* ``1:1`` dentro del espacio de dirección
  ascendente.

| Podría preguntarse, por qué la traducción de direcciones, es utilizada
  para todo,
| cuando *todo* podría estar escrito con un *mapa* ``1:1``\ (uno a uno).
  Algunos buses -como
| PCI, tienen un espacio de direcciones completamente distinto, cuyos
  detalles deberán
| ser expuestos *al SO*. Otros, constan de *motor* DMA, el cual necesita
  conocer la
| dirección *real* en el bus. En ocasiones, los dispositivos necesitan
  estar agrupados,
| por que comparten el mismo *mapa físico de dirección*, para el
  *software* programable. Donde el uso de *mapas* ``1:1`` -o no, depende
  estrechamente de la información que
| necesite el OS, y del diswño del *hardware*.

| Nótese también, que no hay propiedad ``ranges`` en el nodo
  ``i2c@1,0``. La razón, que a
| diferencia del bus externo, dispositivos en el bus ``i2c`` no tienen
  un *mapa de memoria*
| en la dirección de dominio de la CPU. En su lugar, la CPU accede
  indirectamente al
| dispositivo ``rtc@58`` a través de ``i2c@1,0``. La ausencia de la
  propiedad ``ranges``, significa que un dispositivo no puede ser
| accedido directamente por ninǵún otro dispositivo mas que por su
  ascendente.

Cómo funcionan las interrupciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| A diferencia de la traducción -memoria, de ``range``, la cual sigue la
  estructura natural
| del árbol, las señales de interrupción, podrán originarse y,
  finalizar, en cualquier
| dispositivo. Contrariamente al direccionado de dispositivo, -expesado
  naturamente
| en el DT; las señales de interrupción son enlaces entre nodos
  independientes del DT.
| Cuatro propiedades son utilizadas para describirlas:

- ``interrupt-controller`` Propiedad vacía, declarando un nodo como
  dispositivo que
  recive señales de linterrupción.
- ``#interrupt-cells`` Propiedad del nodo contralador de interrupciones.
  Establece
  cuantas celdas hay, en el *especificador de interrupción* del
  controlador. Similar a
  ``#address-cells`` y ``#size-cells``.
- ``interrupt-parent`` propiedad conteniendo un ``phandle``\ [f99], al
  controlador de inte-
  rrupción, al que está acoplado. Nodos sin propiedad
  ``interrupt-parent``, prodrán
  heredarla desde el nodo ascendente.
- ``interrupts`` Propiedad del nodo, conteniendo una lista de
  especificadores
  interrupción, con una señal de salida, para cada uno.

| Un enumerador de interrupción, es una o más celdas de datos, definida
  por
| ``#interrupt-cells`` especificando a qué interrupción de entrada está
  acoplado el
| dispositivo. La mayoría, sólo tienen una interrupción de salida, tal y
  como se muestra
| en el ejemplo de abajo. Es posible que hayan múltiples interrupciones
  de ssalida. El
| significado, de un *especificador de interrupción*, depende
  énteramente del enlace
| del controlador de interrupción del dispositivo. Cada controlador de
  interrupción,
| podrá decidir cuantas celdas necesita, inequívocamente una
  inetrrupción de entradda.

| El siguiente código, añade conexiones de interrupción a nuestra
  máquina de ejemplo
| *Coyote’s Revenge*:

::

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

| La máquina tiene un único controlador de interrupción,
  ``interrupt-controller@10140000``.
| La etiqueta ``intc:`` ha sido añadida al nodo controlador de
  interrupción, y la etiqueta
| fué utilizada para asignar un ``phandle`` a la propiedad
  ``interrupt-parent`` en el nodo
| raíz. El valor de ``interrupt-parent`` se tomará *por defecto* en el
  sistema, puesto que
| los nodos descendentes *heredarán* su valor, a menos que
  explícitamente esté sobre-
| escrito. Cada dispositivo utiliza una propiedad *interrpción*, para
  especificar una *línea de*
| *interrupción* distinta. ``#interrupt-cells`` es ``2``, por lo que
  cada *enumerador* tendrá
| 2 celdas. Este ejemplo, usa un patrón común; usar la primera celda,
  para codificar el
| número de línea de interrupción y, la segunda celda, para codificar
  opciones -flag,
| *sensibles*, como ``active high`` vs. ``active low`` o ``edge``
  vs. ``level``. Para un controlador de interrupción dado, referir la
  documentación de *enlaces*, para
| aprender cómo dodificar los *enumeradores*.

Datos específicos de dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Tras la propiedades comunes, otras *arbitrarias* y, nodos
  descendentes, podrán ser
| añadidas a los nodos. Cualquier dato requerido por el OS, podrá ser
  añadido, siempre
| que sigamos *determinadas regla*.

| Primero, los nombres de propiedades, para nuevos ``device-specific``
  -dispositivos
| específicos, deberán usar un prefijo de fabricante, de esta mforma no
  entrarán en
| conflicto, con nombres de propiedades estandar, ya existentes.

| Segundo, *la intención* de la propiedad y los nodos descendentes,
  deberá estar
| documentada en un enlace, así, el **autor** de un controlador de
  dispositivo, sabrá
| como interpretar los datos. Un enlace documenta qué significa un valor
  compatible en
| particular, qué propiedad debería tener, qué nodos descendentes podría
  enumerar y, a
| qué dispositivo representa. Cada valor ``compatible`` único, debería
  tener sus própias
| vinculaciones -o reclamar compatibilidad, con otro valor
  ``compatible``. Vinculaciones para nuevos dispositivos serán
  documentados, proxímamente, en ésta *Web*.
| <www.territoriolinux.net> ]\ `fuente <#f3>`__. Ver la página principal
  de la citada *fuente*, para una descripción del formato de
| documentación y proceso de revisión.

| Tercero, publicar nuevas vinculaciones, para ser revisada en la lista
  de correo: devicetree-discuss@lists.ozlabs.org. La revisión de nuevas
  vinculaciones, capturan
| muchos errores comunes, que causarán posteriores problemas.

Nodos especiales
^^^^^^^^^^^^^^^^

**Nodo** ``aliases``

| Un nodo específico es normalmente referido con la *ruta absoluta*,
  como:
| ``/external-bus/ethernet@0,0,``, pero resulta incómodo, cuando un
  usuario lo que quiere,
| es saber *qué dispositivo es ``eth0``*. Los nodos *alias*, pueden ser
  utilizados para
| asignar un *nombre corto*, a la ruta de un dispositivo. Por ejemplo:

::

   aliases {
       ethernet0 = &eth0;
       serial0 = &serial0;
   };

| El OS es *instado* a utilizar estos *alias*, cuando es asignado un
  identificados al
| dispositivo.

| Aparece aquí, una nueva *sintaxis*. La propiedad
  ``property = &label;`` asigna la ruta
| del nodo, referenciado por la *etiqueta*, como una propiedad de tipo
  ``string`` -cadena.
| Resulta distinto al formato *phandle* ``phandle = < &label >;`` usado
  anteriormente.
| *Phandle* inserta un valor dentro de la celda.

Nodo *escogido*\ 
^^^^^^^^^^^^^^^^^

| El nodo *excogido* -o seleccionado, representa un dispositivo real. Es
  utilizado como
| *lugar*, para pasar datos entre el *firmware* y el sistema operativo;
  tales como
| argumentos en el arranque. Los datos en el *nodo escogido* no
  representa al *hardware*.
| Los archivos fuente son guardados con formato ``dts`` y, suele estar
  vacío. Es poblado
| durante el arranque del sistema.

En el ejemplo de *sistema*, el *firmware* podría añadir el siguiente
código al nodo:

::

       chosen {
               bootargs = "root=/dev/nfs rw nfsroot=192.168.1.1 console=ttyS0,115200";
       };

Temas avanzados
^^^^^^^^^^^^^^^

**Ejemplo avanzado de máquina**

| Ha sido definido lo básico, es el momento de añadir “algo” de
  *hardware* al ejemplo de
| máquina, y así discutir cuestiones más complicadas.

| El *ejemplo avanzado*, añade un PCI *host bridge(puente anfitrión)* el
  cuál controla
| los registro de *memoria mapeada* en ``0x10180000``, y *barras
  programadas?(BARs)* al
| principio de la dirección ``0x80000000``.

| Los siguentes datos aparecen en el DT, describiendose el nodo *PCI
  host bridge* tal y
| como se sucede:

::

       pci@10180000 {
           compatible = "arm,versatile-pci-hostbridge", "pci";
           reg = <0x10180000 0x1000>;
           interrupts = <8 0>;
       };
       

PCI host bridge(puente anfitrion PCI)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Cierto conocimiento previo, sobre PCI, es necesario. Esto NO es un
  tutorial sobre PCI,
| de necesitar información sobre el mismo, son de recomendada lectura
  [f3]. Igualmente
| referirse a sPAPR v1.1[f4] or *vinculaciones al Bus PCI en Open
  Firmware*.
| Desde *Freescale* ``MPC5200`` se muestra un ejemplo completamente
  funcional.

\ **Enumeración del BUS PCI**\ 

| Cada segmente del bus PCI es enumerado de forma única y, expuesto el
  mismo en el nodo
| PCI. Por medio de la propiedad ``bus-ranges``, la cual contiene dos
  celdas. La primera
| celda, proporciona el número de bus, asignado al nodo. La segunda,
  delimita el número
| máximo de bus, de cualquier bus PCI subordinado.

El ejemplo de máquina, contiene un único bus PCI, por lo que hay ``0``
celdas.

::

       pci@0x10180000 {
           compatible = "arm,versatile-pci-hostbridge", "pci";
           reg = <0x10180000 0x1000>;
           interrupts = <8 0>;
           bus-ranges = <0 0>;
       };

Traducción del direccionado PCI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| De forma similar, al bus local descrito con anterioridad, el espacio
  de dirección PCI,
| aparece completamente separado del espacio de dirección de la CPU. La
  *traducción* de
| direcciones, es necesaria para obtener una dirección desde PCI a la
  CPU. Esto siempre
| se lleva a cabo utilizando un rango, en la propiedades
  ``#address-cells`` y ``#size-cells``

::

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
       
       

| Tal y como se aprecia, la dirección *descendente*\ (PCI) usa 3 celdas
  y, los rangos PCI
| están codificados en dos celdas. La primera questión podría ser, ¿ por
  qué necesitamos
| tres celdas de ``32bit`` para especificar *una* dirección PCI?
| Hay *tres etiquetas* de celda; ``phys.hi, phys.mid`` y ``phys.low``
  [f3]

::

   phys.hi cell: npt000ss bbbbbbbb dddddfff rrrrrrrr
   phys.mid cell: hhhhhhhh hhhhhhhh hhhhhhhh hhhhhhhh
   phys.low cell: llllllll llllllll llllllll llllllll

| Las direcciones PCI, son ``64bit`` de *ancho* y, están codificadas en
  ``phys.mid`` y
| ``phys.low``. Aunque lo realmente interesante aparece en el campo
  ``phys.hi``, siendo un
| *campo de bit*.

- ``n``: opción de región reasignable. Aquí no juega ningun papel.
- ``p``: prefetchable(predecible?) cacheable. Opción de región.
- ``t``: alias. Opción de región. Aquí no juega ningun papel.
- ``ss``: espacio de código.
- ``00``: espacio de configuración
- ``01``: espacio I/O
- ``10``: espacio de memoria de 32 bit
- ``11``: espacio de memoria de 64 bit
- ``bbbbbbbb``: el número de bus PCI. Podría estar estructurado
  jerárquicamente. Así que
  podría ser un PCI/PCI bridge, el cual definiría buses subordinados.
- ``fff``: el número de la función. Usado en dispositivos PCI
  multifunción.
- ``rrrrrrrr``: número de registro; utilizado en la configuración de
  *ciclos*.

| En la propuesta *traducción de direcciones PCI*, los campos
  importantes son ``ss``. El
| valor de ``p`` y ``ss`` en ``phys.hi``, determina qué espacio de
  dirección PCI, está siendo
| accedida. Mirando en la propiedad ``ranges``, son encontradas tres
  regiones:

- una memoria predecible(chacheable) de 32bit. Empezando en la dirección
  ``0x80000000``
  PCI, de ``512 Mbyte`` de tamaño, la cuál está mapeada en la dirección
  ``0x80000000`` dentro
  de la CPU *anfitrion*.
- una memoria no predecible de 32bit. Empezando en la dirección
  ``0xa0000000`` PCI, de
  ``256 MByte`` de tamaño, la cuál está mapeada en la dirección
  ``0xa0000000`` dentro
  de la CPU *anfitrion*.
- una región ``I/O`` Empezando en la dirección ``0x00000000`` PCI, de
  ``16 MByte`` de tamaño, la cuál está mapeada en la dirección
  ``0xb0000000`` dentro de la CPU *anfitrion*.

| De alguna manera, la presencia del *campo de bit* ``phys.hi``,
  significa que un sistema
| operativo, necesita saber qué nodo representa al *puente pci*, por lo
  que se ignorarán
| los campos irrelevantes, en favor de la *traducción de dirección*. El
  OS, deberá mirar
| el la *cadena* ``pci`` dentro del nodo de bus PCI, para determinar
  dónde *enmascarar* los
| campos extra.

Interrupción avanzada, mapa(de memoria)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| *Ahora viene la parte interesante*\ … Mapeado de interrupción PCI. Un
  dispositivo PCI, podrá activar interrupciones,
| utilizando *conexiones(wire)* ``#INTA, #INTB, #INTC`` e ``#INTD``. Una
  *función única*
| de dispositivo(single-function), es obligada a utilizar ``#INTA`` para
  las
| interrupciones. Una *multi función* de dispositivo, debe utilizar
  ``#INTA`` si utiliza un sólo *pin* de
| interrupción, ``#INTA`` y ``#INTB`` si utiliza dos *pins* de
  interrupción, etc.

| Debido a estas reglas, ``#INTA`` es usado con mayor frecuencia que
  ``#INTB, #INTC`` e
| ``#INTD``. Para distribuir la *carga*, sobre la cuatro líneas de
  interrupción ``#INTA`` a
| ``#INTD``, cada zócalo de dispositivo PCI, es habitualmente conectado
  a distintas
| *entradas* del controlador de linterrupciones, de forma rotatoria,
  para así, evitar que
| todos los *clientes*-ejem. SO. tengan que estar conectados a la misma
  línea de
| interrupción -*entrada*. A este procedimiento lo llaman *swizzling*
  las interrupciones.

| El DT, necesitará una forma de *mapear* cada señal de interrupción
  PCI, en las entradas
| del controlador. Las propiedades ``#interrupt-cells``,
  ``interrupt-map`` y ``interrupt-map-mask``
| son utilizadas para describir el *mapeado* de interrupción.

| Actualmente el *mapeado* de interrupción, descrito aquí, no se limita
  únicamente al
| bus PCI, cualquier nodo, podría especificar complejos mapas de
  interrupción, pero en el
| caso del PCI, es por mucho, el más habitual.

::

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

| En primer lugar, debe ser notado, que los números de interrupción PCI,
  utilizan una
| única celda, a pesar de que el sistema controlador de interrupciones
  use 2 celdas; una
| para el número IRQ, otra para las opciones(flags). PCI sólo necesita
  una celda, para
| las interrupciones, por que son *especificadas*, para ser siempre
  sensibles a *bajo*
| *nivel*.

| En la placa de ejemplo, aparecen 2 zócalos PCI, con 4 líneas de
  interrupción, respec-
| tivamente. Habrá que *mapear* 8 líneas de interrupción, en el
  controlador de
| interrupciones. LLevado a cabo, por medio de la propiedad
  ``interrupt-map``. El proce-
| dimiento exacto en el mapeado de interrupción, es descrito en [f5]

| Puesto que el número de interrupción -``#INTA`` etc, no es suficiente
  para distinguir
| entre diversos dispositivos PCI, sobre un bus PCI, es necesario
  observar, qué
| dispositivo PCI, activó la línea de interrupción. Afortunádamente,
  cada dispositivo
| PCI, tiene un *número único*, de dispositivo, utilizado para dicho
  propósito.
| Para distinguir, entre varios dispositivos PCI, es necesaria una
  tupla, la cual
| consta de *número de dispositivo PCI* y, *número de interrupción PCI*.
  En general,
| construiremos una *unidad enumeradora de interrupción*, con cuatro
  celdas:

::

       tres #address-cells constituidad por phys.hi, phys.mid, phys.low, y
       una #interrupt-cell (#INTA, #INTB, #INTC, #INTD).

| Puesto que sólo es necesaria la parte del número de dispositivo, de la
  dirección PCI,
| la propiedad ``interrupt-map-mask``, *entra en juego*.
  ``interrupt-map-mask`` es también
| una tupla *4-tupla*, como la unidad enumeradora de interrupción. La 1,
  es la máscara
| cuya parte unidad enumeradora de interrupción, deberá mmtomarse en
  consideración. En
| el ejemplo, puede verse que sólo la parte del número de dispositivo de
  ``phys.hi``, es
| requerido y, se necesitarán 3 *bits*, para distiguir entre las cuatro
  líneas de
| interrupión. Empiezan a contar desde ``1`` no desde ``0``.

| Ahora es construida la propiedad ``interrupt-map``. Esta propiedad, es
  una tabla y, cada
| entrada en la misma, consiste en una unidad enumeradora de
  interrupción descendente
| -bus PCI, un controlador ascendente (el controlador de interrupción,
  es representado
| para servir, presentar, las interrupciónes). También el ascendente.
  Así que, en la primera línea, pueda leerse que la linterrupción PCI
  ``#INTA``, está
| mapeado en *IRQ 9* -bajo nivel sensitivo del controlador de
  interrupción[f6]

| La única parte que falta hasta el momento, es los extraños números de
  la unidad enu-
| meradora de interrupción. La parte importante, es el número de
  dispositivo en el campo
| ``phys.hi``. El número de dispositivo es específico de la placa y,
  depende de, *cómo*
| el controlador anfitrión PCI, activa el pin IDSEL, en cada
  dispositivo. En este
| ejemplo, el zócalo PCI 1, es asignado al ID de dispositivo
  ``24 (0x18)`` y, el zócalo
| PCI 2, es asignado al ID de dispositivo ``25 (0x19)``. El valor de
  ``phys.hi`` para cada
| zócalo, es determinado por el número dispositio coincidente -hasta 11
  bits, encontrado
| en la sección ``ddddd`` del *campo bit*:

::

       phys.hi for slot 1 is 0xC000, y
       phys.hi for slot 2 is 0xC800.

Colocándolos todos juntos, la propiedad ``interrupt-map`` muestra:

::

       #INTA of slot 1 is IRQ9, level low sensitive on the primary interrupt controller
       #INTB of slot 1 is IRQ10, level low sensitive on the primary interrupt controller
       #INTC of slot 1 is IRQ11, level low sensitive on the primary interrupt controller
       #INTD of slot 1 is IRQ12, level low sensitive on the primary interrupt controller

y

::

       #INTA of slot 2 is IRQ10, level low sensitive on the primary interrupt controller
       #INTB of slot 2 is IRQ11, level low sensitive on the primary interrupt controller
       #INTC of slot 2 is IRQ12, level low sensitive on the primary interrupt controller
       #INTD of slot 2 is IRQ9, level low sensitive on the primary interrupt controller

| Las propiedades de interrupción = <8 0>; describen la interrupciones
  del controlador
| *host/PCI-bridge*, que él mismo activa. No mezclar estas
  interrupciones con disposi-
| tivos de interrupción PCI, que pudieran activar (using INTA, INTB, …).

| Nota final. igual que en la propiedad ``interrupt-parent``, la
  presencia de la propiedad
| ``interrupt-map``, en un nodo, cambiará el *controlador por defecto* ,
  para todos los
| descendentes y nodos *afínes*. En éste ejemplo PCI, significa que el
  *host/PCI-bridge*
| pasa a ser el controlador de interrupción *por defecto*. Si un
  dispositivo acoplado
| vía el bus PCI, tubiese una conexión directa, a otro controlador,
  necesitaría
| especificar su propiedad ``interrupt-parent``.

--------------

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:\ `wiki-elinux.org <https://elinux.org/Device_Tree_Usage>`__

| [f1]enlace al artículo sobre símbolos de ruby?– comprobar
| [f2] ver siglas.

[f2] enlace a phandle

[f3] https://www.mindshare.com/

[f4] ePAPR

[f5] Open Firmware Recommended Practice: Interrupt Mapping

[f6] PCI interrupts are always level low sensitive

nota d.t. *torrente de byte*, byte stream:

| nota d.t. sibling, hermano. En Territorio Linux, optamos por alejarnos
  de connotaciones
| negativas. A nuestro juicio, la traducción al castellano, de las
  palabras *sibling,
  parent* o *child*, tiene la **peor**, de las connotaciones posibles.
  Hemos decidido
| traducirlas por:
| *ascendente, descendente y afín*.

| nota d.t. muchas de las abreviaturas y definiciones o tecnicísmos, son
  descritas en
| otros documentos, por lo que se ha evitado su reiteración. Utilícese
  los mecanísmos
| habituales -ejem.
  [siglas](http://www.territoriolinux.net/TerritorioLinux/siglas.html
| `indice <http://www.territoriolinux.net/TerritorioLinux/porTema.html>`__
| para referirse a éstos.

.. raw:: html

   <ul id="firma">

.. raw:: html

   <li>

Traducción: Heliogabalo S.J.

.. raw:: html

   </li>

.. raw:: html

   <li>

www.territoriolinux.net

.. raw:: html

   </li>

.. raw:: html

   </ul>

afín, semejante, parejo, rayano, equivalente
