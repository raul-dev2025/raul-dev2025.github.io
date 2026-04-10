- `Tabla de contenido <#i0>`__
- `Introducción <#i1>`__
- `Terminología <#i2>`__
- `Secuencia <#i3>`__
- `Zona FPGA <#i4>`__
- `Modelos de uso soportados <#i5>`__
- `Ejemplo de árbol de dispositivo <#i6>`__
- `Restricciones <#i7>`__
- `Referencias y agradecimientos <#i99>`__

FPGA Enlaces de *zona* para el DT
=================================

**(Region Device Tree Bindings)**

Tabla de contenido
^^^^^^^^^^^^^^^^^^

1. Tabla de contenido
2. Terminología
3. Secuencia
4. Zona FPGA
5. Modelos de uso soportados
6. Ejemplo de *árbol de dispositivo*
7. Restricciones
8. Referencias y agradecimientos

Introducción
^^^^^^^^^^^^

Las *regiones* FPGA, representan a FPGAs y a zonas de reconfiguración
parcial del FPGA, en el árbol de dispositivo. Las regiones FPGA,
proporcionan una manera de programar FPGAs *bajo el control del DT*.

Este documento de *vinculaciones* al *DT*, señala algunos de los puntos
más importantes sobre el uso del FPGA y, trata de incluir la
terminología utilizada por los fabricantes de tales dispositivos FPGA.
No es un reemplazo a las especificaciones de fabricante, en cuanto al
uso del FPGA.

Terminología
^^^^^^^^^^^^

**Reconfiguración completa** - Es programado el fpga, énteramente.

**Remconfiguración parcial ``PR``** - Es reprogramada una sección FPGA,
mientra el resto, no se ve afectada. - No todas las FPGAs soportan
``PR``.

**Región de Reconfiguración Parcial ``PRR``** - También llamada
“partición reconfigurable”. - Un ``PRR``\ es una sección específica de
una FPGA, reservada para ser reconfigurada. - Una *imagen* base -o
estática, podrá crear un conjunto de ``PRR``, para más tarde poder ser,
independientemente reprogramados muchas veces. - El tamaño y,
localización específica de cada ``PRR`` es *fija*. - Las *conexiones* y
*extremos*, de cada ``PRR`` son fijos. La imagen que es cargada en un
``PRR``, **debe** ajustar y utilizar, un subconjunto de conexiones de la
región. - Los *buses* dentro del FPGA, son separados de tal forma que,
cada región obtiene su propia rama, donde poder crear más tarde una
puerta, de forma independiente.

**Persona** - También llamada: *torrente de bit parcial*. - Una imagen
FPGA designada para ser cargada en el ``PRR``. Puede haber cualquier
número de *personas* designadas para ajustarse al ``PRR``, Pero sólo una
a la vez, podrá ser cargada. - Una *persona* podrá crear *otras*
regiones.

**Puente FPGA** - Puentes FPGA para señales de *buses de puerta*, entre
el *host* y el FPGA. - Los Puentes FPGA, deberían ser desabilitados
mientras el FPGA es programado, para prevenir señales espúrias sobre el
*bus* de la CPU y, el *soft logic[f1]*. - Los puentes FPGA, podrán ser
*hardware* en activo, o *soft logic* en un FPGA. - Durante la
reconfiguración completa, los puentes de *hardware*, entre el *host* y
el FPGA, serán desactivados. - Durante la reconfiguración parcial de una
región específica, el *puente* de la misma, será utilizado como *puerta*
a los *buses*. El tráfico a otras regiones no se verá afectado. - En
algunas implementaciones, el gestor FPGA controla el *enrutado(gating)*
a los buses de manera transparente, evitando la necesidad de mostrar los
puentes FPGA de *hardware*, en el árbol de dispositivo. - Una imagen
FPGA, podrá crear un conjunto de regiones reprogramables, cada una, con
su própio puente y separación de buses en el FPGA.

**Gestor FPGA** - Un gestor FPGA es un bloque de *hardware* que programa
un FPGA, bajo el control de un procesador anfitrión.

**Imagen base** - También llamada “imagen estática”. - Una imagen FPGA,
diseñada para reconfigurar al completo el FPGA. - Una imagen base,
podría configurar un conjunto parcial de *regiones de reconfiguración*,
para más tarde ser reprogramadas.

::

   ----------------       ----------------------------------
   |  Host CPU    |       |             FPGA               |
   |              |       |                                |
   |          ----|       |       -----------    --------  |
   |          | H |       |   |==>| Bridge0 |<==>| PRR0 |  |
   |          | W |       |   |   -----------    --------  |
   |          |   |       |   |                            |
   |          | B |<=====>|<==|   -----------    --------  |
   |          | R |       |   |==>| Bridge1 |<==>| PRR1 |  |
   |          | I |       |   |   -----------    --------  |
   |          | D |       |   |                            |
   |          | G |       |   |   -----------    --------  |
   |          | E |       |   |==>| Bridge2 |<==>| PRR2 |  |
   |          ----|       |       -----------    --------  |
   |              |       |                                |
   ----------------       ----------------------------------

..

   **figura 1**: una configuración FPGA, con una imagen *base* creando
   tres regiones. Cada región ``PRR0-2``, con buses separados, que son
   enrutados de forma independiente, por un *puente lógico(soft logic
   bridge)* en el FPGA. El contenido de cada ``PRR``, podrá ser
   reprogramado independientemente, mientra el resto del sistema
   continúa funcionando.

Secuencia
^^^^^^^^^

Cuando es aplicada una *sobrecarga* que apunta a una región FPGA, la
*región FPGA*, hará lo siguiente:

1. Desactivar los puentes FPGA apropiados.
2. Programar el FPGA utilizando el gestor FPGA.
3. Activar los puentes FPGA.
4. La sobrecarga es aceptada dentro del árbol de dispositivo.
5. Los dispositivos descendentes son definidos.

Al ritirar la sobreposición -o sobregarga, los nodos descendentes serán
retirados y la región FPGA desactivará los puentes.

Zona FPGA
^^^^^^^^^

La *región FPGA* representa al fpga -matríz de puertas reconfigurble, y
a regiones FPGA PR en el DT. Una *región FPGA* une los elementos
necesarios de un programa, en un sistema en carrera y, añade los
dispositivos descendentes.

- Gestor FPGA.
- Puentes FPGA.
- Información específica de la imagen, necesaria para la programación.
- Nodos descendentes.

El objetivo del *DTO* es ser utilizado para reprogramar un FPGA,
mientras el sistema operativo está en funcionamiento.

Una *Región FPGA* existente en un *DT* en activo, refleja su estado. Si
el árbol activo, muestra una propiedada ``firmware-name``, o nodos
descendentes bajo la *Región FPGA*, indicará que el FPGA ya está
programado. Un *DTO* que apunte a una *Región FPGA*, y añada la
propiedad ``firmware-name``, será tomada como petición para reprogramar
el FPGA. Después de la reprogramación tenga éxito, la *sobrecarga*, será
aceptada en el *DT*.

La *Región FPGA base* dentro del DT, representa al FPGA y soportará una
reconfiguración completa. Debe incluir un ``phandle`` a un gestor FPGA.
La *Región FPGA base*, será el descendente de uno de los puentes de
*hardware* -el puente que permite el acceso a registros, entre la CPU y
el FPGA. Si hubiese más de un puente que controlar, durante la
programación del FPGA, la *región* también contendría una lista de
``phandles`` a los puentes de *hardware* FPGA, adicionales.

Para la reconfiguración parcial *PR*, cada *Región PR*, constará con una
*Región FPGA*. Estas *Regiónes FPGA*, son descendentes de puentes FPGA,
los cuales son descendentes de la *Región FPGA base*. La
“reconfiguración completa” de los ejmeplos *PRR* mostrados más abajo,
explica esto.

Si una *región FPGA* no especifica un gestor FPGA, *asumirá* la región
FPGA, del gestor especificado por su predecesor. Ésto soporta ambos
casos; allí donde el mismo gestor FPGA es utlizado para todo, así como
*diferentes* gestores para cada región.

Las regiónes FPGA no heredan los *puentes(bridges)* de región FPGA, de
sus predecesores. Previene el apagado de un puente “aguas arriba”[f2]
mientras una *región* está siendo reconfigurada -ver **figura 1**.
Durante un *PR*, los puentes FPGA permanecen activos. Los puentes de
*región PR* serán puentes FPGA dentro de la imagen estática del FPGA.

Propiedades requeridas: - ``compatible``: podría contener una *región
FPGA*. - ``fpga-mgr``: podría contener un ``phandle`` al gestor FPGA.
Regiones FPGA descendentes reciben esta propiedad desde regiones
*ascendentes*. Una propiedad ``fpga'mgr`` en una región,
*sobreescribirá* cualquier gestor FPGA heredado. - ``#address'cell``,
``#size'cells``, ``ranges``: deberá estar presente para comandar los
espacios de dirección mapeados en nodos descendentes.

Propiedades opcionales: - ``firmaware-name``: debería contener el nombre
de un archivo imagen FPGA, localizado en la ruta de búsqueda del
*firmware*. Si esta propiedad es mostrada en un *DT* en activo, indicará
que el FPGA ya ha sido programado con esta imagen. Si la propiedad está
en un objetivo de región FPGA *sobrepuesto(overlay)*, será necesario
programar el FPGA con dicha imagen. - ``fpga'bridges``: debería contener
una lista de \_phandles a puentes FPGA, que deberán ser controlados
durante la programación FPGA, junto al puente FPGA ascendente. Es una
propiedad opcional si el gestor FPGA controla los puentes. Si la
``fpga'region`` es descendente de ``fpga'bridge``, la lista no debería
contener el puente ascendente. - ``partial-fpga-config``: boleano,
establecido si la reconfiguración parcial tomase efecto, o
reconfiguración completa, en cualquier otro caso. -
``external-fpga-config``: boleano, establecido si el FPGA ha sido
configurado, con anterioridad al arranque del *OS*. -
``encrypted-fpga-config``: boleano, establecido si el *bitstream* está
encriptado. - ``region-unfreeze-timeout-us``: tiempo máximo en
microsegundos, a la espera de que sean activados satisfactoriamente los
puentes, tras la programación de región. - ``region-freeze-timeout-us``:
tiempo máximo en microsegundos, a la espera de que sean desactivados
satisfactoriamente los puentes, antes de ser programada la región. -
``config-complete-timeout-us``: tiempo máximo en microsegundos, para que
el FPGA, cambie al *modo operación*, tras haber sido programada la
región. - *nodos descendentes(child nodes)*: dispositivos fpga, tras la
programación.

En el ejemplo de abajo, cuando es aplicada una *sobreposición* apuntando
a ``fpga'region0``, ``fpga'mgr`` será utilizado para programar el FPGA.
Son controlados dos puentes durante la programación: el ``fpga_bridge0``
ascendente y ``fpga_bridge1``. Puesto que la *región* es descendente de
``fpga_bridge0``, sólo ``fpga_bridge1`` necesitará ser especificado en
la propiedad ``fpga-bridges``. Durante la programación estos puentes son
desactivados, el firmware especificado en la *sobreposición*, es cargado
en el FPGA, por medio del gestor FPGA especificado en la *región*. Si
tiene éxito la programación del FPGA, los puentes serán reactivados y,
la sobreposición tomará efecto en el árbol activo. Los dispositivos
descendentes, serán entonces *completados*. Si la programación FPGA
fallase, los puentes permanecerán desactivados y la sobreposición será
rechazada. La propiedad ``ranges``\ (rangos) de la sobreposición, *sitúa
en el mapa* la región del puente ``lwhps``\ (``0xff200000``) y, la regón
``hps``\ (``0xc0000000``), para ser utilizados por los dos dispositivos
descendentes.

Ejemplo, la base del árbol contiene:

::

       fpga_mgr: fpga-mgr@ff706000 {
           compatible = "altr,socfpga-fpga-mgr";
           reg = <0xff706000 0x1000
                    0xffb90000 0x20>;
           interrupts = <0 175 4>;
       };

       fpga_bridge0: fpga-bridge@ff400000 {
           compatible = "altr,socfpga-lwhps2fpga-bridge";
           reg = <0xff400000 0x100000>;
           resets = <&rst LWHPS2FPGA_RESET>;
           clocks = <&l4_main_clk>;

           #address-cells = <1>;
           #size-cells = <1>;
           ranges;

           fpga_region0: fpga-region0 {
               compatible = "fpga-region";
               fpga-mgr = <&fpga_mgr>;
           };
       };

       fpga_bridge1: fpga-bridge@ff500000 {
           compatible = "altr,socfpga-hps2fpga-bridge";
           reg = <0xff500000 0x10000>;
           resets = <&rst HPS2FPGA_RESET>;
           clocks = <&l4_main_clk>;
       };

La *sobreposición* contiene:

::

       /dts-v1/ /plugin/;
       / {
           fragment@0 {
               target = <&fpga_region0>;
               #address-cells = <1>;
               #size-cells = <1>;
               __overlay__ {
                   #address-cells = <1>;
                   #size-cells = <1>;

                   firmware-name = "soc_system.rbf";
                   fpga-bridges = <&fpga_bridge1>;
                   ranges = <0x20000 0xff200000 0x100000>,
                        <0x0 0xc0000000 0x20000000>;

                   gpio@10040 {
                       compatible = "altr,pio-1.0";
                       reg = <0x10040 0x20>;
                       altr,gpio-bank-width = <4>;
                       #gpio-cells = <2>;
                       clocks = <2>;
                       gpio-controller;
                   };

                   onchip-memory {
                       device_type = "memory";
                       compatible = "altr,onchipmem-15.1";
                       reg = <0x0 0x10000>;
                   };
               };
           };
       };

Modelos de uso soportados
^^^^^^^^^^^^^^^^^^^^^^^^^

En cualquier caso, un DT activo, deberá tener un *gestor FPGA*, un
puente FPGA -si lo hubiese y, una región FPGA. El objetivo de la
sobreposición del árbol de dispositivo, es la región FPGA. Algunos
*usos* son específicos del dispositivo FPGA.

- **Sin puentes FPGA** En este caso, el *gestor FPGA*, que programa el
  FPGA, también dirige los puentes *tras la escena*. No es necesario
  ningún dispositivo de puente FPGA, para una reconfiguración completa.
- \__Reconfiguración completa con puentes \_hardware\_\_ Hay puentes de
  *hardware*, entre el procesador y el FPGA, que necesitan ser
  controlados durante la *reconfiguración completa*. Antes de ser
  aplicada la sobreposición, el DT activo debe incluir el gestor FPGA,
  los puentes FPGA y, una región FPGA. La *región FPGA* es descendente
  del puente que permite acceso al registro del FPGA. Puentes
  adicionales, podrán ser listados en una propiedad ``fpga-bridges``, de
  la región FPGA, o en una sobreposición del árbol de dispositivo.
- **Reconfiguración parcial con puentes, en el FPGA**. El FPGA tendrá
  uno o más ``PRR``\ s, que podrán ser programados por separado,
  mientras el resto del FPGA permanece activo. Para manejar esto, es
  necesario que existan los puentes en el FPGA, los cuales dirigen los
  buses hacia cada región FPGA, al mismo tiempo que los buses son
  activados para otras secciones. Antes de realizar cualquier
  *reconfiguración parcial*, una imagen FPGA base, deberá ser cargada,
  incluyendo ``PRR`` con puentes FPGA. El DT debería tener una región
  FPGA para cada ``PRR``.

Ejemplo de *árbol de dispositivo*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El objetivo de esta sección, es proporcionar ejemplos simples, centrados
en la localización de los elementos detallados arriba, especificamente:

- Gestor FPGA
- Puentes FPGA
- Regiones FPGA
- ``ranges`` Rangos
- Ruta objetivo u objetivo.

En lo que respecta a esta sección, será dividido el árbol de dispositivo
en dos partes, cada una de ellas, con sus própios requisitos. Las dos
partes son: - El DT en activo, antes de ser añadida la sobreposición. -
La sobreposición DT.

El árbol activo deberá contener una región FPGA, un gestor FPGA y,
cualquier puente FPGA. La propiedad ``fpga-mgr`` de las regiones FPGA,
especifican el gestor por *phandle*, para controlar la programación del
FPGA. Si la región FPGA, es descendente de otra región FPGA, será
utilizado el gestor ascendente FPGA. Si está involucrado el puente FPGA,
serán especificados en la región FPGA por la propiedad ``fpga-bridges``.
Durante la programación FPGA, la región FPGA desactivará los puentes
incluidos en la lista ``fpga-bridges`` y, reactivados después de tener
éxito la programación del FPGA.

La sobreposición del DT contendrá: - ``target-path`` o ``target`` El
punto de inserción donde el contenido de la sobreposición es situado
dentro del árbol activo. ``target-path`` es una ruta completa, mientras
que ``target`` es un ``phandle``. - ``ranges`` El espacio de dirección,
*mapeado* desde el procesador al bus/es FPGA. - ``firmware-name``
Especifica el nombre del archivo de la imagen FPGA, en la ruta de
búsqueda del *firmware*. La ruta de búsqueda, es descrita por la *clase*
``documentation`` en el *firmware*. - ``partial-fpga-config`` Esta
vinculación es un boleano y debería estar presente de tomar efecto una
reconfiguración parcial. - Nodos descendentes, ligados al *hardware*,
que cargarán en esta región del FPGA.

**Reconfiguración completa sin puentes**

El árbol activo contiene:

::

           fpga_mgr0: fpga-mgr@f8007000 {
               compatible = "xlnx,zynq-devcfg-1.0";
               reg = <0xf8007000 0x100>;
               interrupt-parent = <&intc>;
               interrupts = <0 8 4>;
               clocks = <&clkc 12>;
               clock-names = "ref_clk";
               syscon = <&slcr>;
           };

           fpga_region0: fpga-region0 {
               compatible = "fpga-region";
               fpga-mgr = <&fpga_mgr0>;
               #address-cells = <0x1>;
               #size-cells = <0x1>;
               ranges;
           };

       DT Overlay contains:
       /dts-v1/ /plugin/;
       / {
       fragment@0 {
           target = <&fpga_region0>;
           #address-cells = <1>;
           #size-cells = <1>;
           __overlay__ {
               #address-cells = <1>;
               #size-cells = <1>;

               firmware-name = "zynq-gpio.bin";

               gpio1: gpio@40000000 {
                   compatible = "xlnx,xps-gpio-1.00.a";
                   reg = <0x40000000 0x10000>;
                   gpio-controller;
                   #gpio-cells = <0x2>;
                   xlnx,gpio-width= <0x6>;
               };
           };
       };

**Reconfiguiración completa para añadir ``PRR``\ s**

La región base FPGA, es especificada de manera similar al primer
ejemplo.

Este ejemplo, programa el FPGA para con dos regiones que, podrán ser
configuradas más tarde. Cada una de ellas, tiene su própio puente en su
estructura FPGA.

La sobreposición DT contiene:

::

       /dts-v1/ /plugin/;
       / {
           fragment@0 {
               target = <&fpga_region0>;
               #address-cells = <1>;
               #size-cells = <1>;
               __overlay__ {
                   #address-cells = <1>;
                   #size-cells = <1>;

                   firmware-name = "base.rbf";

                   fpga-bridge@4400 {
                       compatible = "altr,freeze-bridge";
                       reg = <0x4400 0x10>;

                       fpga_region1: fpga-region1 {
                           compatible = "fpga-region";
                           #address-cells = <0x1>;
                           #size-cells = <0x1>;
                           ranges;
                       };
                   };

                   fpga-bridge@4420 {
                       compatible = "altr,freeze-bridge";
                       reg = <0x4420 0x10>;

                       fpga_region2: fpga-region2 {
                           compatible = "fpga-region";
                           #address-cells = <0x1>;
                           #size-cells = <0x1>;
                           ranges;
                       };
                   };
               };
           };
       };

**Reconfiguración parcial**

Este ejemplo reprograma una de las ``PRR``\ s, configurada en previos
ejemplos.

La secuencia sucedida cuando es *sobrepuesta*, es similar a lo anterior;
las únicas diferencias residen en que el FPGA, es parcialmente
reconfigurado debido al boleano ``partial-fpga-config`` y, el único
puente que es controlado durante la programación, es el puente FPGA
basado en ``fpga_region1``.

::

       /dts-v1/ /plugin/;
       / {
           fragment@0 {
               target = <&fpga_region1>;
               #address-cells = <1>;
               #size-cells = <1>;
               __overlay__ {
                   #address-cells = <1>;
                   #size-cells = <1>;

                   firmware-name = "soc_image2.rbf";
                   partial-fpga-config;

                   gpio@10040 {
                       compatible = "altr,pio-1.0";
                       reg = <0x10040 0x20>;
                       clocks = <0x2>;
                       altr,gpio-bank-width = <0x4>;
                       resetvalue = <0x0>;
                       #gpio-cells = <0x2>;
                       gpio-controller;
                   };
               };
           };
       };

Restricciones
^^^^^^^^^^^^^

Queda fuera del ámbito de éste documento, la descripción completa de
todas las restricciones en el diseño FPGA, requeridas para llevar a cabo
reconfiguraciones parciales; referencias *1, 2 y 3*. Aunque merece la
pena, una rápida mención.

Una ``persona``, deberá tener un “límite de conexiones”, alineado con
tales *particiones* o regiones para las que fueron diseñadas.

Durante la programación, la transmisión a través de dichas conexiones,
deberán cesar y, las conexiones retenidas en un nivel lógico fijo.
Consiguiéndose esto, con los puentes FPGA que existen en la estructura
FPGA, anterior, a la reconfiguración parcial.

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[f1] soft logic

[f2] aguas arriba, upstream. Ejemplo, en electricidad esto es la
corriente energizadora que parte desde un *elemento* situado *antes* del
dispositivo en cuestión; el *telerruptor no funciona* porque al
“magneto” no le llega tensión…

**[1]**:
www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_partrecon.pdf
**[2]**:
tspace.library.utoronto.ca/bitstream/1807/67932/1/Byma_Stuart_A_201411_MAS_thesis.pdf
**[3]**:
http://www.xilinx.com/support/documentation/sw_manuals/xilinx14_1/ug702.pdf

**Autor**: Allan Tull 2016

--------------

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
