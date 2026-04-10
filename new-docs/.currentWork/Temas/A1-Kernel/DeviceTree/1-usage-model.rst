- `El modelo Linux de uso, para el árbol de dispositivo <#i1>`__
- `Historia <#i2>`__
- `Modelo de datos <#i3>`__
- `Vista de alto nivel <#i4>`__
- `Identificación de plataforma <#i5>`__
- `Configuración del tiempo de ejecución <#i6>`__
- `Lista de dispositivos <#i7>`__
- `Apéncice A: dispositivos AMBA <#i8>`__
- `Referencias y agradfecimientos <#i9>`__

--------------

Linux y el árbol de dispositivo
-------------------------------

El modelo Linux de uso, para el árbol de dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| El siguiente artículo, describe como *Linux*, utiliza el árbol de
  dispositivo. Otra
| visión maś general sobre el tema, podrá encontrarse en la página usdo
  del *árbol de*
| *dispositivos*, en
  [f2][devicetree.org](http://devicetree.org/Device_Tree_Usage).

| El “Open Firmware Device Tree”, o símplemente árbol de dispositivo
  (DT), es una
| estructura de datos y un lenguaje descriptivo de *hardware*. Más
  específicamente, es
| una descripción de *hardware* comprensible para un sistema operativo,
  de tal forma, que
| éste último, no necesite *reescribir* detalles de la máquina.

| Estructuralmente, el *DT*, es un árbol o, un gráfico acíclico con
  nombre de nodos,
| los cuáles podrían tener un número arbitrario de propiedades
  *enumeradas*, encapsulando
| datos de manera arbitraria. Existe un mecanismo, para crear enlaces
  desde un nodo a otro, fuera de la *estructura*
| *de árbol*, natural.

| Conceptualmente, es un conjunto de *convenciones* comunes, llamadas
| vinculaciones(bindings). Definidas para determinar cómo los datos,
  deberían aparecer
| en el árbol, para decribir características típicas de *hardware*,
  incluyendo *buses* de
| datos, líneas de interrupción, conexiones GPIO y dispositivos
  periféricos.

| El *hardware* es descrito -tanto como es posible, utilizando
  vinculaciones existentes,
| para maximizar, el uso de código ya existente. Puesto que las
  propiedades y los nombres
| de nodo, son símplemente cadenas de texto, es *fácil* extender
  vinculaciones ya exis-
| tentes o, crear nuevas, definiendo nuevos *nodos* y *propiedades*. Se
  deberá ser
| cauteloso a la hora de crear nuevas vinculaciones, comprobando antes
  si ya existen. Actualmente hay dos tipos de incompatibilidades
  diferentes. Vinculaciones para buses
| ``i2c``, que aparecen, por haber creado otras nuevas, sin primero
  investigar, cómo los
| dispositivos ``i2c`` fueron enumerados, en sistemas existentes.

Historia
^^^^^^^^

| El *DT* fué originalmente creado, como *código abierto de
  fabricante(Open Firmware)*,
| parte del método de comunicación, con el que pasar datos entre *Open
  Firmaware* y el
| programa cliente -ejem. un sistema operativo. Un sistema operativo usó
  el *árbol de* *dispositivo*, para descubrir la topología de *hardware*
  en *tiempo de carrera* y, de este modo, dar soporte a la mayoría de
  hardware disponible, sin tener que *reecribir*
| información -asumiendo que los controladores, estuviesen disponibles
  para todos los dispositivos.

| Puesto que *Open firmware*, es habitualmente utilizado en plataformas
  *PowerPc* y
| *SPARC*, el soporte *Linux* para tales arquitecturas, ha usado el
  *árbol de dispositivo*
| durante un largo príodo de tiempo.

| En 2005, cuando *PowerPc Linux*, comenzó “las obras” para hacer
  confluir el soporte en
| plataformas 32-bit y 64-bit, se tomó la decisión de *requerir* el
  soporte *DT*, en todas
| ellas, independientemente de si usaban ó no, *Open Firmware*. Para
  ésto, una representación *DT*, llamada *ábol de dispositivo
  reducido*\ [f1], fue
| creado para posder pasar al *kernel*, como *pequeño* binario, sin
  tener que requerir
| una implementación *real* del *Open Firmware*. ``U-boot``, ``kexec`` y
  otros gestores de
| arranque, fueron modificados para soportar éste *árbol de dispositivo
  binario(dtb)* y,
| para modificar un *dtb* durante el arranque del sistema. También fué
  añadido el *DT*
| al arranque de *PowerPc*\ ( arch/powerpc/boot/\* ) así, el *dtb*
  pudiera ser *envuelto*,
| junto a la imagen del *núcleo*, y dar soporte a máquinas ya
  existentes, con *firmware*
| *no DT(sis esta característica)*.

| Tiempo después, la infraestructura *FDT* se usó de forma generalizada,
  en todo tipo de
| arquitecturas. Al momento de éste escrito, 6 *líneas de arquitectura*
  principales,
| (arm, microblaze, mips, powerpc, sparc y x86), también otra fuera de
  la *línea*
| principal(nios), tienen *cierto* nivel de soporte a *DT*.

Modelo de datos
^^^^^^^^^^^^^^^

| Si aún no has leído la página *uso del aŕbol de dispositivo[f2]*,
  entonces hazlo, es
| correcto, yo esperaré aquí…

Vista de *alto nivel*\ 
^^^^^^^^^^^^^^^^^^^^^^^

| Entender lo siguiente, como lo más importante; el árbol de
  dispositivo, es una
| estructura que describe el *hardware*. Nada mágico se esconde detrás,
  tampoco hace
| que problemas con el *hardware* desaparezcan por *arte de mágia*.
  Aunque sí porporciona
| un lenguaje, para “desmenuzar” la configuarción soportada por el
  *hardware*, de la
| *placa* y del *controlador de dispositivo*, en el *núcleo* de Linux -o
  cualquier otro
| *sistema operativo* a éste respecto. Al utilizarlo, permite al soporte
  de placas y
| dispositivos, el *poder ser conducidos*; esto es, tomar decisiones de
  configuración
| basadas en los datos expuestos en el *kernel*, en lugar de ``codigos``
  específicos, para
| *máquinas* concretas.

| Es preferible, una configuración de datos *por plataforma*, que pueda
  resultar en menos
| código duplicado y, hacer más fácil, el dar soporte, a un ámplio rango
  de *hardware*
| con sólamente una imagen del núcleo.

Linux utiliza los datos *DT*, en tres propuestas principales:

1. Identificación de plataforma.
2. Configuración en *tiempo de carrera* y,
3. población de dispositivo.

Identificación de plataforma
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Primero y ante todo , el *kernel* usará los datos en el *DT*, para
  identificar la
| máquina específica. En un mundo perfecto, la plataforma concreta, no
  debería importar
| al *núcleo*, por que todos los detalles de *plataforma*, deberían
  estar perfectamente
| dscritos, de forma segura y consistente, por el árbol de dispositivo.
  Aunque el *hardware* no es perfecto, el *kernel* deberá identificar la
  máquina durante
| el *arranque*, así, tendrá la oportunidad de realizar ajustes
  específicos.

| En la mayoría de casos, la *identidad* de la máquina es irrelevante,
  en su lugar el
| *núcleo*, seleccionará una configuración de código, basada en la *CPU*
  ó *SoC*, de
| la máquina. En *ARM*, por ejemplo, ``setup_arch()`` en
  ``arch/arm/kernel/setup.c`` llamará
| a ``setup_machine_fdt()``, en ``arch/arm/kernel/devtree.c`` el cuál
  busca a través de
| la tabla ``machine_desc`` y, selecciona ``machine_desc`` que mejor
  coincida con los datos
| del árbol de dispositivo. Determina la mejor coincidencia mirando en
  la propiedad
| ``compatible`` en el nodo de la ráiz, del árbol de dispositivo y,
  comparándolo con la
| lista ``dt_compat`` en la estructura ``machine_desc`` -la cuál está
  definida en
| ``arch/arm/include/asm/mach/arch.h`` -por si alguien es curioso.

| La propiedad ``compatible``, mcontiene una lista ordenada de
  *cadenas*, empezando por el
| nombre exacto de la máquina, seguido por una lista opcional de
  *placas* compatibles,
| ordenadas de más, a menos compatible. Por ejemplo, las propiedades
  compatibles con la
| raíz, para la placa *TI BeagleBoard* y sus secesoras *BeagleBoard xM*,
  podría parecerse
| a esto, respectivamente:

::

       compatible = "ti,omap3-beagleboard", "ti,omap3450", "ti,omap3";
       compatible = "ti,omap3-beagleboard-xm", "ti,omap3450", "ti,omap3";

| Donde “ti,omap3-beagleboard” especifíca el modelo exacto, además de
  establecer, que es
| compatible con el *SoC* ``OMAP 3450``, y la familia de *SoC* ``omap3``
  en general. Notará,
| que la lista, está ordenada desde la más específica (placa exacta) a
  menos (familia
| *Soc*).

| Lectores astutos, podrán imaginar que *Beagle xM* podría reclamar
  compatibilidad, con
| la *placa* original *Beagle*. Aunque *uno* debe ser cauto haciendo
  ésto, ya que a
| nivel de placa, es verdad que exista un alto grado de compatibilidad
  entre ellas, pero
| será difícil, averiguar exactamente, qué signifíca exactamente que una
  placa sea
| *compatible* con otra. Será preferible pecar de cáuto, en lugar de dar
  por sentado la
| *compatibilidad entre ellas* . Una excepción podría ser si una *placa*
  es portadora de
| otra, como en el caso de un módulo CPU, acoplado a una plac portadora.

| Una nota más sobre *valores compatibles*. Cualquier
  ``string``\ (cadena), en una propiedad
| ``compatible``, deberá estar documentada, tal y como se indica. Ver la
  documentación para
| *cadenas* compatibles en *Documentation/devicetree/bindings*.

| De nuevo, en *ARM*, para cada ``machine_desc``, el *kernel* buscará
  cualquier entrada de
| lista en ``dt_compat``, para ver si aparece la propiedad
  ``compatible``. Si aparece,
| entonces ``machine_desc`` será un *candidato* para la máquina. Después
  de bustac en toda
| la tabla, de ``machine_desc``\ s, ``setup_machine_fdt()``, retornará
  la ``machine_desc`` más
| compatible, basándose en qué entrada coincide con la propiedad
  *compatible*. Si no hay
| ninguna coincidencia, retornará ``NULL``.

| El razonamiento detrás de éste esquema, es mediante la observación; en
  la mayoría de
| casos, *una sóla* ``machine_desc``, podrá soportar una gran cantidad
  de placas, si todas
| ellas utilizan el mismo ``SoC``, o la misma famila de ``Soc``\ s.
  Aunque invariablemente,
| habrá algunas excepciones, dónde una placa específica, necesitará de
  una configuraci´on
| especial de código, poco útil en casos más genéricos. Los casos
  especiales son *controlados*, comprobando explícitamente el incomodo
  código
| genérico de configuración, sin embargo no es la mejor de las
  soluciones, si hay más de
| *un par* de casos.

| En su lugar, la lista ``compatile``, permite a una ``machine_desc``
  genérica, proporcionar
| soporte a un ámplio rango de placas, especificando valores
  ``less compatible``\ (menos
| compatibles), en la lista ``dt_compat``. En el ejemplo de arriba, el
  soporte de la placa
| genérica, podrá exponer la compatibilidad con ``ti,omap3`` ó
  ``ti,omap3450``. Si fué
| descubierto un error(bug) en la placa original *beagleboard*,
  necesitando una solución
| alternativa *de código*, durante el arranque, podría ser añadido una
  nueva
| ``machine_desc``, implementando dicha *alternativa* para que sólo
  coincidiese sobre
| ``ti,omap3-beagleboard``.

| PowerPc usa un esquema ligéramente distinto, cuando llama al enlace
  ``.probe()`` desde
| ``machine_desc``; será utilizado el primero en retornar ``TRUE``.
  Aunque esta aproximación
| no se toma en cuenta la propiedad de la lista *compatible*, y
  probablemente debería ser
| evitada en el soporte a nuevas arquitecturas.

Configuración del *tiempo de ejecución*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

####

| En la mayoría de casos, *DT* será el único método de comunicación
  entre el *firmware*
| y el núcleo, así pués, también será usado para pasar datos de
  configuración durante el
| *tiempo de ejecución*. Tales como parámetros o la localización de la
  imagen ``initrd``.

| Muchos de estos datos, están contenidos en el nodo ``/chosen`` y,
  cuando Linux es
| *arrancado*, buscará algo parecido a esto:

::

       chosen {
           bootargs = "console=ttyS0,115200 loglevel=8";
           initrd-start = <0xc8000000>;
           initrd-end = <0xc8200000>;
       };

| Los *argumentos de arranque*, conmtienen los argumentos del *kernel*
  y, las propiedades
| de ``initrd`` define las direcciones y tamaño de un *pequeño*
  ``initrd``. Nótese que
| ``initrd-end`` es la primera dirección después de la imagen
  ``initrd``, por lo que no
| coincide con la semántica habitual del ``struct``
  ``resource``\ (*recurso*). El nodo escogido
| puede contener opcionalmente, un número arbitrario de propiedades
  adicionales. Para la
| configuración de datos específica a la plataforma.

| Durante el *arranque temprano*, las llamadas de código de
  configuración de la
| arquitectura ``of_scan_flat_dt()``, tendrán jlugar en distintos
  momentos, mediante el
| *ayudante de llamadas* para analizar los datos del arból de
  dispositivo antes de que la
| *paginación* sea configurada.

| El código ``of_scan_flat_dt()`` escanea a través del árbol de
  dispositivo, y utilizará
| los *ayudantes*, para extraer, durante el qrranque, la información
  necesaria. El
| ayudante ``early_init_dt_scan_chosen()`` es utilizado para analizar el
  nodo escogido,
| incluyendo parámetros del núcleo.
| ``early_init_dt_scan_root()`` para inicializar el model de spacio de
  direcciones *DT* y,
| ``early_init_dt_scan_memory()`` para determinar el tamaño y
  localización de la *RAM*
| utilizable.

| En *ARM*, la función ``setup_machine_fdt()``, es responsable del
  *pronto escaneado*, del
| árbol de dispositivo, después de seleccionar la ``machine_desc`` que
  soporte la placa.

\ *Lista* de dispositivos
^^^^^^^^^^^^^^^^^^^^^^^^^

| Una vez identificada la *placa*, tras haber traspasado los datos de
  configuración, la
| inicialización del núcleo procederá con normalidad. En *algún* punto
  de este proceso
| se llamará a ``unflatten_device_tree()``, para convertir los datos en
  una representación
| más eficiente del *tiempo de ejecución*. Igualmente sucederá cuando la
  configuración de los enlaces *específicos de máquina*,
| sean llamados, como ``machine_desc``, ``.init_early()``,
  ``.init_irq()``, ``.init_machine(),`` -son enlaces para la plataforma
  *ARM*. El resto de la sección, utilizará ejemplos de la implementación
  *ARM*, pero todas las
| arquitecturas, llevarán a cabo algo muy similar, en cuanto a la
  utilizaación el *DT*.

| Tal y como se intuye por los nombres, ``.init_early()`` es utilizado
  para la
| configuración \_ específica de máquina \_, que necesite ser
  *ejecutada* en un pronto
| arranque del sistema, ``.init_irq()`` es utilizado para gestionar las
  *interrupciones*.
| El uso de *DT*, no cambia el comportamiento de ninguna de éstas
  funciones. Al proporcionar un *DT*, tanto ``.init_early()`` como
  ``.init_irq()``, serán capaces de
| *llamar* a cualquier función de *DT* -``of_*`` in
  ``include/linux/of*.h`` para obtener
| datos adicionales sobre la plataforma.

| El enlace más interesante, en el contexto *DT* es ``.init_machine()``
  el cuál es el prin-
| cipal responsable de *poblar* el *modelo de dispositivo* Linux, con
  los datos sobre la
| plataforma. Históricamente, ésto ha sido implementado en plataformas
  embebidas,
| definiendo un conjunto de *estructuras de reloj estáticas*,
  ``platform_devices`` y otros
| datos para el soporte de *placa* en archivos ``.c``. Registrándolos
  *en masa*, en
| ``.init_machine()``, al utilizar *DT* y, colocando estructuras
  dinámicas de dispositivo.

| El caso más simple, es cuando ``.init_machine()`` sólo es responsable
  de registar un
| bloque de ``platform_devices``. Un ``platform_devices`` es un concepto
  usado por la memoria
| de Linux o por dispositivos *mapeados* en memoria *I/O*, los cuáles no
  pueden ser
| detectados por el *hardware*, o por dispositivos “compuestos” o
  “virtuales” -ver más
| adelante. Mientras que no existe la términología “dispositivo de
  plataforma” para el *DT*, los
| dispositivos de plataforma, corresponde de forma aproximada, a nodos
  de dispositivo,
| en la *ráiz del árbol* y, al *nodo bus hijo*, simplemente asignado a
  memoria.

| Es un buen momento para poner un ejemplo. Aquí se representa *parte*
  de un árbol de
| dispositivo para la *placa* de ``NVIDIA Tegra``.

::

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

| Durante ``.init_machine()``, la placa *Tegra*, soporta el código
  necesario, para buscar
| en *DT* y y decidir en que nodos crear el ``platform_devices``. En
  cualquier caso, mirando en el árbol, no es inmediatamente obvio qué
  clase de
| dispositivo representa a cada nodo, e incluso si un dispositivo
  representa al nodo. Los
| nodos ``/chosen``, ``/aliases``, y ``/mmemory`` son nodos
  informativos, que no describen
| dispositivos -aunque podría decirse, que la memoria es considerada un
  dispositivo.
| El *hijo* del nodo ``/soc``, es un dispositivo de memoria *mapeado*,
  pero el ``code@1a``
| es un dispositivo ``12c``, y el nodo de sonido, no representa a un
  dispositivo. En su
| lugar es creado el *subsistema* de audio. Es posible conocer cada
  dispositivo si *uno*
| está familiarizado con el diseño de la placa, pero ¿cómo sabe el
  núcleo qué hacer en
| cada nodo?

| El *truco* radica en que el *kernel* empieza en la *raíz del árbol* y,
  busca los nodos
| con la propiedad ``compatible``. Primero, es asumido que cualquier
  nodocon la propiedad
| ``compatible``, represente a un dispositivo; segundo, es asumido
  igualmente, que un nodo
| en la *raíz del árbol* está directamente acoplado al *bus* del
  procesador, o a un
| sistema *misceláneo* de dispositivo, que no puede ser descrito de otra
  manera.

| ¿ Por qué un ``platform_device`` utiliza una *asumción fiable*, para
  el nodo? Bien, en la medida en que *el modelo de dispositivo* Linux,
  asume , que sus dispositivos son descendientes(children) de un
  controlador bus, en casi todos los ``bus_types``\ (tipos
| de buses). Por ejemplo, cada ``i2c_client`` es *hijo* de un
  ``i2c_master``. Cada
| ``spi_device`` es *hijo* de un *bus SPI*. De forma similar, en *USB,
  PCI, MDIO,* etc. La
| misma jerarquía es encontrada en el *DT*, donde nodos de dispositivos
  ``i2c`` únicamente
| aparecerán como *hijos* del bus nodo ``I2C``; idem. para \_USB, PCI,
  MDIO, etc. El único
| dispositivo que no requiere este tipo de parentesco, son los
  ``platforme_devices`` -y
| los ``amba_devices``, se hablará de ello más adelante; los cuáles
  residen *alegremente*
| en la *base del árbol* de Linux ``/sys/devices``. Por lo tanto, si un
  nodo *DT* está en
| la *raíz del árbol*, probáblemente entonces, será más adecuado
  registrarlo como una
| ``platforme_device``.

| El código para el soporte de placa Linux, *llama* a
  ``of_platform_populate(NULL, NULL,``
| ``NULL, NULL)``, para tratar de descubrir los dispositivos en *la raíz
  del árbol*. Los
| parámetros son todos ``NULL``, por que cuando se empiza desde el
  ``struct`` *base del*
| *árbol*, no es necesario proporcionar un nodo desde el que comenzar
  -el primero es
| ``NULL``, otro ``struct`` relacionado, el último, también es ``NULL``
  y, aún no se está
| utilizando una tabla de *coincidencia*. Para una placa que sólo
  necesita registrar
| dispositivos, ``.init_machine()`` podrá estar completamente vacío,
  excepto la llamada
| ``of_platform_populate()``.

| Con el ejemplo de *Tegra*, es aplicable a los nodos\ ``/soc`` y
  ``/sound``, pero ¿qué pasa
| con el nodo descendiente ``SoC``? ¿ Debería ser registrado también
  como dispositivo de
| plataforma ? Para el soporte *DT* de Linux, el comportamiento
  genérico, es que los
| dispositivos relacionados, sean registrados por el controlador del
  dispositivo ascen-
| dente, durante ``.probe()``\ (las pruebas del controlador). Así que,
  un controlador de
| dispositivo de bus ``i2c``, registrará un ``i2c_client`` para cada
  nodo relacionado. Un
| controlador de bus ``SPI``, registrará su ``spi_device`` relacionado
  y, de mforma similar
| para otros tipos de *buses*. De acuerdo con el modelo, un controlador
  podrá ser escrito, como vínculo al nodo ``SoC``
| y registrar la ``platform_devices``, para cada uno de sus
  *descendientes*. El código de
| soporte de placa, colocará y registrará un dispositivo ``SoC``, un
  controlador de dispo-
| sitivo ``SoC`` -teóricamente, podría vincular el diapositivo ``SoC``
  y, registrar
| ``platform_devices`` para ``/soc/iterrupt-mcontroller``,
  ``/soc/serial, /soc/i2s`` y
| ``/soc/i2c`` en su enlace .probe()\` ¿Verdad que és fácil?

| De hecho, registrar descendientes de alguna ``platform_device``, es un
  patrón común, y el
| código de soporte al *árbol de dispositivo*, refeja ésto y, que el
  ejemplo -líneas
| arriba, sea más simple. El segundo argumento en
  ``of_platform_populate()`` es una tabla
| ``of_device_id`` y, cualquier nodo que coincida con una *entrada* en
  la tabla, también
| registrará sus nodos descendientes. En el caso de *Tegra*, podría
  parecerse a lo
| siguiente:

::

       static void __init harmony_init_machine(void)
       {
           /* ... */
           of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
       }

| En la especificación ``Devicetree`` el ``simple'bus`` es definido como
  una propiedad,
| significando esto, *un mapa de memoria simple, para el bus*, de esta
  forma, el código
| de ``of_platform_populate()`` podrá ser escrito asumiendo que un nodo
  *simple-bus*
| compatible, siempre será *transversal*. En cualquier caso, ha sido
  pasado como
| argumento, por lo que el código de soporte a la placa, podrá ser
  sobreescribir el
| comportamiento normalizado.

[necesaria nota sobre descendientes ``i2c/spi/etc``]

Apéndice A: dispoditivos AMBA
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Las principales céldas -o células, ARM, constan de cierto dispositivo
  acoplado al bus
| *ARM AMBA*, el cuál incluye *algo* de soporte a la detección de
  *harwdware* y gestión
| de energía. En Linux, el ``struct`` ``amba_device`` y
  ``amba_bus_type``, es usado para
| representar dispositivos de céldas principales. Para el sistema
  operativo Linux, esto
| es habitual en ambos casos, en instancias ``amba_devicce`` y
  ``platform_device``,
| descendientes segmento de *bus*.

| Siendo utilizado *DT*, aparecerán problemas en cuanto a
  ``of_platform_populate()`` por
| que debe decidirse si registrar cada nodo, como ``platform_device`` o
  ``amba_device``. Esto
| desafortunadamente complica la creación del modelo, un *poquitín*; sin
  embargo la
| solución *no será demasiado invasiva*. Si un nodo es compatible con
  ``arm,amba-primcell``
| entonces ``of_platform_populate()`` será registrada como
  ``amba_device`` en lugar de
| ``platform_device``.

--------------

Referencias y agradecimeintos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   [f1]ábol de dispositivo reducido, Flattened Device Tree(FDT)

**Autor**: Grant Likely grant.likely@secretlab.ca **Traductor:**
Heliogabalo S.J. jonitjuego@gmail.com
