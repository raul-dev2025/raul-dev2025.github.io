* [Tabla de contenido](#i0)
* [Introducción](#i1)
* [Terminología](#i2)
* [Secuencia](#i3)
* [Zona FPGA](#i4)
* [Modelos de uso soportados](#i5)
* [Ejemplo de _árbol de dispositivo_](#i6)
* [Restricciones](#i7)
* [Referencias y agradecimientos](#i99)

# FPGA Enlaces de _zona_ para el DT #
__(Region Device Tree Bindings)__


#### <a name="i0">Tabla de contenido</a> ####

1. Tabla de contenido
2. Terminología
3. Secuencia
4. Zona FPGA
5. Modelos de uso soportados
6. Ejemplo de _árbol de dispositivo_
7. Restricciones
8. Referencias y agradecimientos

#### <a name="i1">Introducción</a> ####

Las _regiones_ FPGA, representan a FPGAs y a zonas de reconfiguración parcial del FPGA, en el árbol de dispositivo. Las regiones FPGA, proporcionan una manera de programar FPGAs _bajo el control del DT_.

Este documento de _vinculaciones_ al _DT_, señala algunos de los puntos más importantes sobre el uso del FPGA y, trata de incluir la terminología utilizada por los fabricantes de tales dispositivos FPGA. No es un reemplazo a las especificaciones de fabricante, en cuanto al uso del FPGA.

#### <a name="i2">Terminología</a> ####

__Reconfiguración completa__
- Es programado el fpga, énteramente.

__Remconfiguración parcial `PR`__
- Es reprogramada una sección FPGA, mientra el resto, no se ve afectada.
- No todas las FPGAs soportan `PR`.

__Región de Reconfiguración Parcial `PRR`__
* También llamada "partición reconfigurable".
* Un `PRR`es una sección específica de una FPGA, reservada para ser reconfigurada.
* Una _imagen_ base -o estática, podrá crear un conjunto de `PRR`, para más tarde poder ser, independientemente reprogramados muchas veces.
* El tamaño y, localización específica de cada `PRR` es _fija_.
* Las _conexiones_ y _extremos_, de cada `PRR` son fijos. La imagen que es cargada en un `PRR`, __debe__ ajustar y utilizar, un subconjunto de conexiones de la región.
* Los _buses_ dentro del FPGA, son separados de tal forma que, cada región obtiene su propia rama, donde poder crear más tarde una puerta, de forma independiente.

__Persona__
* También llamada: _torrente de bit parcial_.
* Una imagen FPGA designada para ser cargada en el `PRR`. Puede haber cualquier número de _personas_ designadas para ajustarse al `PRR`, Pero sólo una a la vez, poodrá ser cargada.
* Una _persona_ podrá crear _otras_ regiones.

__Puente FPGA__
* Puentes FPGA para señales de _buses de puerta_, entre el _host_ y el FPGA.
* Los Puentes FPGA, deberían ser desabilitados mientras el FPGA es programado, para prevenir señales espúrias sobre el _bus_ de la CPU y, el _soft logic[f1]_.
* Los puentes FPGA, podran ser _hardware_ en activo, o _soft logic_ en un FPGA.
* Durante la reconfiguración completa, los puentes de _hardware_, entre el _host_ y el FPGA, serán desactivados.
* Durante la reconfiguración parcial de una región específica, el _puente_ de la misma, será utilizado como _puerta_ a los _buses_. El tráfico a otras regiones no se verá afectado. 
* En algunas implementaciones, el gestor FPGA controla el _enrutado(gating)_ a los buses de manera transparente, evitando la necesidad de mostrar los puentes FPGA de _hardware_, en el árbol de dispositivo.
* Una imagen FPGA, podrá crear un conjunto de regiones reprogramables, cada una, con su própio puente y separación de buses en el FPGA.

__Gestor FPGA__
* Un gestor FPGA es un bloque de _hardware_ que programa un FPGA, bajo el control de un procesador anfitrión.

__Imagen base__
* También llamada "imagen estática".
* Una imagen FPGA, diseñada para reconfigurar al completo el FPGA.
* Una imagen base, podría configurar un conjunto parcial de _regiones de reconfiguración_, para más tarde ser reprogramadas.

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

> __figura 1__: una configuración FPGA, con una imagen _base_ creando tres regiones. Cada región `PRR0-2`, con buses separados, que son enrutados de forma independiente, por un _puente lógico(soft logic bridge)_ en el FPGA. El contenido de cada `PRR`, podrá ser reprogramado independientemente, mientra el resto del sistema continúa funcionando.

#### <a name="i3">Secuencia</a> ####

Cuando es aplicada una _sobrecarga_ que apunta a una región FPGA, la _región FPGA_, hará lo siguiente:

1. Desactivar los puentes FPGA apropiados.
2. Programar el FPGA utilizando el gestor FPGA.
3. Activar los puentes FPGA.
4. La sobrecarga es aceptada dentro del árbol de dispositivo.
5. Los dispositivos descendentes son definidos.

Al ritirar al sobreposición -o sobregarga, los nodos descendentes seerán retirados y la región FPGA desactivará los puentes.


#### <a name="i4">Zona FPGA</a> ####

La _región FPGA_ represeenta al fpga -matriz de puertas reconfigurble, y a regiones FPGA PR en el DT. Una _región FPGA_ une a los elementos necesarios de un programa, en un sistema en carrera y, añade los dispositivos descendentes.

* Gestor FPGA. 
* Puentes FPGA.
* Información específica de la imagen, necesaria para la programación.
* Nodos descendentes.

El objetivo del _DTO_ es ser utilizado para reprogramar un FPGA, mientras el sistema operativo está en funcionamiento.

Una _Región FPGA_ existente en un _DT_ en activo, refleja su estado. Si el árbol activo, muestra una propiedada `firmware-name`, o nodos descendentes bajo la _Región FPGA_, indicará que el FPGA ya está programado. Un _DTO_ que apunte a una _Región FPGA_, y añada la propiedad `firmware-name`, será tomada como petición para reprogramar el FPGA. Después de la reprogramación tenga éxito, la _sobrecarga_, será aceptada en el _DT_.

La _Región FPGA base_ dentro del DT, representa al FPGA y soportará una reconfiguración completa. Debe incluir un `phandle` a un gestor FPGA. La _Región FPGA base_, será el descendente de uno de los puentes de _hardware_ -el puente que permite el acceso a registros, entre la CPU y el FPGA. Si hubiese más de un puente que controlar, durante la programación del FPGA, la _región_ también contendría una lista de `phandles` a los puentes de _hardware_ FPGA, adicionales.

Para la reconfiguración parcial _PR_, cada _Región PR_, constará con una _Región FPGA_. Estas _Regiónes FPGA_, son descendentes de puentes FPGA, los cuales son descendentes de la _Región FPGA base_. La "reconfiguración completa" de los ejmeplos _PRR_ mostrados más abajo, explica esto.

Si una _región FPGA_ no especifica un gestor FPGAm, _asumirá_ la región fpga, del gestor especificado por su predecesor. Ésto soporta ambos casos; allí donde el mismo gestor FPGA es utlizado para todo, así como _diferentes_ gestores para cada región.

Las regiónes FPGA no heredan los _puentes(bridges)_ de región FPGA, de sus predecesores. Previene el apagado de un puente "aguas arriba"[f2] mientras una _región_ está siendo reconfigurada -ver __figura 1__. Durante un _PR_, los puentes FPGA permanecen activos.
Los puentes de _región PR_ serán puentes FPGA dentro de la imagen estática del FPGA.

Propiedades requeridas:
* `compatible`: podría contener una _región FPGA_.
* `fpga-mgr`: podría contener un `phandle` al gestor FPGA. Regiones FPGA descendentes reciben esta propiedad desde regiones _ascendentes_. Una propiedad `fpga'mgr` en una región, _sobreescribirá_ cualquier gestor FPGA heredado.
* `#address'cell`, `#size'cells`, `ranges`: deberá estar presente para comandar los espacios de dirección mapeados en nodos descendentes.

Propiedades opcionales:
* `firmaware-name`: debería contener el nombre de un archivo imagen FPGA, localizado en la ruta de búsqueda del _firmware_. Si esta propiedad es mostrada en un _DT_ en activo, indicará que el FPGA ya ha sido programado con esta imagen.
Si la propiedad está en un objetivo de región FPGA _sobrepuesto(overlay)_, será necesario programar el FPGA con dicha imagen.
* `fpga'bridges`: debería contener una lista de _phandles a puentes FPGA, que deberá ser controlados durante la programación FPGA, junto al puente FPGA ascendente.
Es una propiedad opcional si el gestor FPGA controla los puentes.
Si la `fpga'region` es descendente de `fpga'bridge`, la lista no debería contener el puente ascendente.
* `partial-fpga-config`: boleano, establecido si la reconfiguración parcial tomase efecto, o reconficguración completa, en cualquier otro caso.
* `external-fpga-config`: boleano, establecido si el FPGA ha sido configurado, con anterioridad al arranque del OS.
* `encrypted-fpga-config`: boleano, establecido si el _bitstream_ está encriptado.
* `region-unfreeze-timeout-us`: tiempo máximo en microsegundos, a la espera de que sean activados satisfactoriamente los puentes, tras la programación de región.
* `region-freeze-timeout-us`: tiempo máximo en microsegundos, a la espera de que sean desactivados satisfactoriamente los puentes, antes de ser programada la región.
* `config-complete-timeout-us`: tiempo máximo en microsegundos, para que el FPGA, cambie al _modo operación_, tras haber sido programada la región.
* _nodos descendentes(child nodes)_: dispositivos fpga, tras la programación.

En el ejemplo de abajo, cuando es aplicada una _sobreposición_ apuntando a `fpga'region0`, `fpga'mgr` será utilizado para programar el FPGA. Son controlados dos puentes durante la programación: el `fpga_bridge0` ascendente y `fpga_bridge1`. Puesto que la _región_ es descendente de `fpga_bridge0`, sólo `fpga_bridge1` necesitará ser especificado en la propiedad `fpga-bridges`. Durante la programación estos puentes son desactivados, el firmware especificado en la _sobreposición_, es cargado en el FPGA, por medio del gestor FPGA especificado en la _región_. Si tiene éxito la programación del FPGA, los mpuentes serán reactivados y, la sobreposición tomará efecto en el árbol activo. Los dispositivos descendentes, serán entonces _completados_. 
Si la programación FPGA fallase, los puentes permanecerán desactivados y la sobreposición será rechazada. La propiedad `ranges`(rangos) de la sobreposición, _sitúa en el mapa_ la región del puente `lwhps`(`0xff200000`) y, la regón `hps`(`0xc0000000`), para ser utilizados por los dos dispositivos descendentes.

Ejemplo, la base del árbol contiene:

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

La _sobreposición_ contiene:

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


#### <a name="i5">Modelos de uso soportados</a> ####

En cualquier caso, un DT activo, deberá tener un _gestor FPGA_, un puente FPGA -si lo hubiese y, una región FPGA. El objetivo de la sobreposición del árbol de dispositivo, es la región FPGA. Algunos _usos_ son específicos del dispositivo FPGA.

* __Sin puentes FPGA__
  En este caso, el _gestor FPGA_, que programa el FPGA, también direige los puentes _tras la escena_. No es necesario ningún dispositivo de puente FPGA, para una reconfiguración completa.
* _Reconfiguración completa con puentes _hardware_._
  Hay puentes de _hardware_, entre el procesador y el FPGA, que necesitan ser controlados durante la _reconfiguración completa_. Antes de ser aplicada la sobreposición, el DT activo debe incluir el gestor FPGA, los puentes FPGA y, una región FPGA. La _región FPGA_ es descendente del puente que permite acceso al registro del FPGA. Puentes adicionales, podrán ser listados en una propiedad `fpga-bridges`, de la región FPGA, o en una sobreposición del árbol de dispositivo.
* __Reconfiguración parcial con puentes, en el FPGA__.
  El FPGA tendrá uno o más `PRR`s, que podrán ser programados por separado, mientras el resto del FPGA permanece activo. Para manejar esto, es necesario que existan los puentes en el FPGA, los cuales dirigen los buses hacia cada región FPGA, al mismo tiempo que los buses son activados para otras secciones. Antes de realizar cualquier _reconfiguración parcial_, una imagen FPGA base, deberá ser cargada, incluyendo `PRR` con puentes FPGA. El DT debería tener una región FPGA para cada `PRR`.

#### <a name="URL">Ejemplo de _árbol de dispositivo_</a> ####

El objetivo de esta sección, es proporcionar ejemplos simples, centrados en la localización de los elementos detallados arriba, especificamente:

 * Gestor FPGA
 * Puentes FPGA
 * Regiones FPGA
 * `ranges` Rangos
 * Ruta objetivo u objetivo.

En lo que respecta a esta sección, será dividido el árbol de dispositivo en dos partes, cada una de ellas, con sus própios requisitos. Las dos partes son:
* El DT en activo, antes de ser añadida la sobreposición.
* La sobreposición DT.

El árbol activo deberá contener una región FPGA, un gestor FPGA y, cualquier puente FPGA. La propiedad `fpga-mgr` de las regiones FPGA, especifican el gestor por _phandle_, para controlar la programación del FPGA. Si la región FPGA, es descendente de otra región FPGA, será utilizado el gestor ascendente FPGA. Si está involucrado el puente FPGA, serán especificados en la región FPGA por la propiedad `fpga-bridges`. Durante la programación FPGA, la región FPGA desactivará los puentes incluidos en la lista  `fpga-bridges` y, reactivados después de tener éxito la programación del FPGA.

La sobreposición del DT contendrá:
* `target-path` o `target`
  El punto de inserción donde el contenido de la sobreposición es situado dentro del árbol activo. `target-path` es una ruta completa, mientras que `target` es un `phandle`.
* `ranges`
  El espacio de dirección, _mapeado_ desde el procesador al bus/es FPGA.
* `firmware-name`
  Especifica el nombre del archivo de la imagen FPGA, en la ruta de búsqueda del _firmware_. La ruta de búsqueda, es descrita por la _clase_ `documentation` en el _firmware_.
* `partial-fpga-config`
  Esta vinculación es un boleano y debería estar presente de tomar efecto una reconfiguración parcial.
* Nodos descendentes, ligados al _hardware_, que cargarán en esta región del FPGA.

__Reconfiguración completa sin puentes__

El árbol activo contiene:

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

__Reconfiguiración completa para añadir `PRR`s__

La región base FPGA, es especificada de manera similar al primer ejemplo.

Este ejemplo, programa el FPGA para con dos regiones que, podrán ser configuradas más tarde. Cada una de ellas, tiene su própio puente en su estructura FPGA.

La sobreposición DT contiene:

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


__Reconfiguración parcial__

Este ejemplo reprograma una de las `PRR`s, configurada en previos ejemplos.

La secuencia sucedida cuando es _sobrepuesta_, es similar a lo anterior; las únicas diferencias residen en que el FPGA, es parcialmente reconfigurado debido al boleano `partial-fpga-config` y, el único puente que es controlado durante la programación, es el puente FPGA basado en `fpga_region1`.

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


#### <a name="i7">Restricciones</a> ####

Queda fuera del ámbito de éste documente, la descripción completa de todas las restricciones en el diseño FPGA, reqqueridas para llevar a cabo reconfiguraciones parciales; referencias _1, 2 y 3_. Aunue merece la pena, una rápida mención.

Una `persona`, deberá tener un "límite de conexiones", alineado con tales _particiones_ o regiones para las que fueron diseñados.

Durante la programación, la transmisión a través de dichas conexiones, deberán cesar y, las conexiones retenidas en un nivel lógico fijo. Consiguiéndose esto, con los puentes FPGA que existen en la estructura FPGA, anterior, a la reconfiguración parcial.


#### <a name="i99">Referencias y agradecimientos</a> ####

[f1] soft logic

[f2] aguas arriba, upstream. Ejemplo, en electricidad esto es la corriente energizadora que parte desde un _elemento_ situado _antes_ del dispositivo en cuestión; el _telerruptor no funciona_ porque al "magneto" no le llega tensión...

__[1]__: www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_partrecon.pdf
__[2]__: tspace.library.utoronto.ca/bitstream/1807/67932/1/Byma_Stuart_A_201411_MAS_thesis.pdf
__[3]__: http://www.xilinx.com/support/documentation/sw_manuals/xilinx14_1/ug702.pdf


__Autor__: Allan Tull 2016

***************

<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
