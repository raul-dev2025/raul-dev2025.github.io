1. [_Sobreposición_ del árbol de dispositivo, notas](#i1)
2. [Cómo funciona la _obreposición_](#i2s)
3. [Sobreposición, en la _API_ del núcleo](#i3)
4. [Formato de sobreposición _DTS_](#i4)
99. [Referencias y agradecimientos](#i99)

#### <a name="i1">_Sobreposición_ del árbol de dispositivo, notas</a> ####

Éste documento describe la implementación -_en el lado del kernel_, de la funcionalidad  
de la _sobreposición_ del árbol de dispositivo.
__Localización:__ `drivers/of/overlay.c`.
__lectura:__ `Documentation/devicetree/dynamic-resolution-notes.txt`.


#### <a name="#i2">Cómo funciona la _obreposición_</a>  ####

El principal objetivo del _Árbol de Dispositivo_, es modificar el _árbol del kernel_ en  
_activo(live)_ y, proporcionar una _manera_ de que tales cambios, sean reflejados el el  
núcleo.
Puesto que el núcleo, principalmente _trabaja_ con dispositivos, cualquier nuevo _nodo_  
de dispositivo, resultará en que un dispositivo _activo_, debería ser creado, incluso  
si el _nodo de dispositivo_ es desactivado, retirado o, ambos. El dispositivo afectado  
debería ser _desregistrado -esto es, quitado de la lista en el registro_.

Tómese el siguiente ejemplo, dónde aparece la _placa_ foo _-base del árbol_: 

		---- foo.dts -----------------------------------------------------------------
			/* FOO platform */
			/ {
				compatible = "corp,foo";

				/* shared resources */
				res: res {
				};

				/* On chip peripherals */
				ocp: ocp {
					/* peripherals that are always instantiated */
					peripheral1 { ... };
				}
			};
		---- foo.dts -----------------------------------------------------------------

El sobrepuesto `bar.dts`, cuando sea cargado -y resuelto tal y como se describe en
[ResolucionDinamica-Notes.html](DeviceTree/dynamicResolutionNotes.html#f1),
debería:

		---- bar.dts -----------------------------------------------------------------
		/plugin/;	/* allow undefined label references and record them */
		/ {
			....	/* various properties for loader use; i.e. part id etc. */
			fragment@0 {
				target = <&ocp>;
				__overlay__ {
					/* bar peripheral */
					bar {
						compatible = "corp,bar";
						... /* various properties and child nodes */
					}
				};
			};
		};
		---- bar.dts -----------------------------------------------------------------

Resultando en `foo+bar.dts`

		---- foo+bar.dts -------------------------------------------------------------
			/* FOO platform + bar peripheral */
			/ {
				compatible = "corp,foo";

				/* shared resources */
				res: res {
				};

				/* On chip peripherals */
				ocp: ocp {
					/* peripherals that are always instantiated */
					peripheral1 { ... };

					/* bar peripheral */
					bar {
						compatible = "corp,bar";
						... /* various properties and child nodes */
					}
				}
			};
		---- foo+bar.dts -------------------------------------------------------------

Como resultado de la sobreposición, el nuevo nodo de dispositivo (bar), ha sido creado  
así un dispositivo de plataforma _bar_, será registrado y si un controlador de dispo-  
sitivo coincidente, es cargado, el dispositivo será creado tal y como se espera.

#### <a name="i3">Sobreposición, en la _API_ del núcleo</a> ####

La _API_, es bastante fácil de usar:

1. Llamada a `of_overlay_create()`, para crear y aplicar la _sobreposición_. El valor  
retornado es una galletita(cookie) identificando la _sobreposición_.
2. Llamada a `of_overlay_destroy()` para retirar y limpiar, la sobreposición previa-  
mente creada, por medio de `of_overlay_create()`. La retirada de una _sobreposición_  
_apilada_ por otra, no será permitida. 
3. Finalmente, si es necesario retirar la _sobreposición_, de _una sóla vez_, llamar  
únicamente a `of_overlay_destroy_all()` para retirar cada una de ellas, en el orden  
correcto.


#### <a name="i4">Formato de sobreposición _DTS_</a> ####

El _DTS_ de una sobreposición, debería tener el siguient formato:

		{
			/* ignored properties by the overlay */

			fragment@0 {	/* first child node */

				target=<phandle>;	/* phandle target of the overlay */
			or
				target-path="/path";	/* target path of the overlay */

				__overlay__ {
					property-a;	/* add property-a to the target */
					node-a {	/* add to an existing, or create a node-a */
						...
					};
				};
			}
			fragment@1 {	/* second child node */
				...
			};
			/* more fragments follow */
		}

Utilizar un método no basado en _phandle_, permite el uso de un _DT_ de base, no
conteniendo ningún nodo `__symbols__`. Por ejemplo, si no fue compilado con la 
opción `-@`. El nodo `__symbols__`, es sólo un requisito para el método:
`target=<phandle>`, ya que contiene la información para _mapear_ un _phandle_ a una
localización del árbol.
7

***************

#### <a name="i1">Referencias y agradecimientos</a> ####

__[f1]:__ phandle, ver [dynamicResolutionNotes.html](dynamicResolutionNotes.html#f1)

