`Documentation/arm/Booting`

* [Introducción](#i1)
* [Configura e inicializa la _RAM_](#i2)
* [Inicializa un _puerto en serie_](#i3)
* [Detección del tipo de máquina](#i4)
* [Configuración de los datos de arranque](#i5)
* [Carga `initramfs`](#i6)
* [Llamada a la _imagen_ del kernel](#i7)



* [Referencias y agradecimientos](#i99)

#### <a name="i1">Introducción</a> ####

Para arrancar `ARM Linux`, es necesario un gestor de arranque, el cual es una pequeño programa, que _carga_ antes que el _kernel principal_. Del gestor de arranque se espera que inicialice varios dispositivos, pudiendo llamar al kernel de Linux y, pasarle _distinta información_.

En esencia, el gestor de arranque debería proporcionar -como mínimo, lo siguiente: 

1. Configura e inicializa la _RAM_.
2. Inicializa un _puerto en serie_.
3. Detección del tipo de máquina.
4. Configurar la lista de _etiquetas_ del kernel.
5. Carga `initramfs`.
6. Llamada a la _imagen_ del kernel.

> La siguiente documentación atañe a la versión v2.4.18-rmk6 y posteviores

#### <a name="i2">Configura e inicializa la _RAM_</a> ####

- Cargador de arranque _existente_: `MANDATORY`.
- Nuevos cargadores de arranque: `MANDATORY`.

Del gestor de arranque se espera que encuentre e inicialice toda la _RAM_, que utilizará el kernel, para almacenar los _datos volátiles_ del sistema. La tarea se lleva a cabo, de forma _dependiente_ a la máquina. Podrían utilizarse algoritmos internos, para localizar y _dimensionar_, automáticamente la _RAM_, o podrían utilizarse los datos conocidos sobre la RAM de la máquina, e incluso otros métodos designados por el gestor de arranque como _coincidentes_.


#### <a name="i3">Inicializa un _puerto en serie_</a> ####

- Cargador de arranque _existente_: `OPTIONAL, RECOMMENDED`.
- Nuevos cargadores de arranque: `OPTIONAL, RECOMMENDED`.

El cargador de arranque, debería inicializar y activar, un _puerto en serie_. Esto permite al controlador en serie del kernel, detectar automáticamente qué _puerto en serie_ debe utilizarse para la cónsola del kernel. Usado normalmente en operaciones de depuración, o comunicación con la máquina. 

Como alternativa, el _gestor_, podrá pasar al kernel, la opción `console=`, a través de las listas etiquetadas, que especifiquen el _puerto_ y, las opciones de _formato en serie_, descrito en `Documentation/admin-guide/kernel-parameters.rst`.


#### <a name="i4">Detección del tipo de máquina</a> ####

- Cargador de arranque _existente_: `OPTIONAL`.
- Nuevos cargadores de arranque: `MANDATORY`, excepto para algunas plataformas DT.

El cargador de arranque debería detectar el tipo de máquina, por medio de _algún método_. Tanto si es algún tipo de código _provisional_ -_hard coded_, u otro algoritmo que busque el _hardware_ conectado, queda fuera del _tema_ de éste documento.

En último término, el gestor de arranque deberá ser capaz de proporcionar al kernel, un valor tipo `MACH_TYPE_xxx`. ver `linux/arch/arm/tools/mach-types`. Es pasado al kernel en el registro `r1`.

En plataformas `DT-only`, el tipo de máquina será determinada por el árbol de dispositivo. Configura el tipo de máquina para todas ellas `~0`. Esto no es estríctamente necesario, pero asegura que no coincidirá con alguna otra existente.

#### <a name="i4">Configuración de los datos de arranque</a> ####

- Cargador de arranque _existente_: `OPTIONAL, HIGHLY RECOMMENDED`.
- Nuevos cargadores de arranque: `MANDATORY`.

El gestor de arranque debe proporcionar tanto una _lista etiquetada_, como una imagen _dtb_, para _pasar_ los datos de configuración al kernel. La dirección física de los datos de arranque, son pasados al kernel, por el registro `r2`.

__Configurar la lista de _etiquetas_ del kernel__

El gestor de arranque debe crear e inicializar la _lista etiquetada_. Una _lista_ válida empieza por `ATAG_CORE` y termina por `ATAG_NONE`.
La etiqueta `ATAG_CORE` podrá o no, estar vacía. Una etiqueta vacía `ATAG_CORE`, tendrá configurado el tamaño de campo a _2_ `0x00000002`. La etiqueta `ATAG_NONE` deberá definir el tamaño de campo a _cero_.

La _lista_ podrá tener un número indetermindado de etiquetas. Es indefinido dónde una etiqueta repetida, cuelga de la información descrita en la anterior etiqueta. Incluso si reemplaza la información en su totalidad; algunas etiquetas se comportan como la _primera_, otras como la última.

El gestor de arranque deberá pasar -como mínimo, el tamaño y localización de la memoria del sistema y, la localización del _sistema de archivo_ raíz. Por lo tanto, una _lista etiquetada_ mínima, tendrá este aspecto:

			+-----------+
		base ->	| ATAG_CORE |  |
			+-----------+  |
			| ATAG_MEM  |  | increasing address
			+-----------+  |
			| ATAG_NONE |  |
			+-----------+  v

La _lista etiquetada_ deberá ser almacenada en la RAM.

Debe ser situada en una región de la memoria donde ni el _decompresor_ del kernel, ni el programa `inird` _bootp_, la sobreescriban. El lugar aconsejado es en los primeros `16KiB` de la RAM.

__Configuración del árbol de dispositivo__

El gestor de arranque deberá cargar la imagen del árbol de dispositivo(dtb), en la memoria RAM del sistema, en una dirección de `64bit` alineada e inicializada, con los _datos de arranque_. El formato `dtb` está documentado en `Documentation/devicetree/booting-without-of.txt`.
El kernel buscará el valor `0xd00dfeed` -_magic value_, en la dirección física del `dtb`, para determinar si ya ha sido pasado un `dtb`, en lugar de una _lista etiquetada_.

El gestor de arranque debe _pasar_, -como mínimo, el tamaño y localicación de la memoria del lsistema y, la localización del _sistema de archivo_ raíz. El `dtb` deberá ser situado en una región de la memoria donde el _decompresor_ del kernel, no lo sobreescriba, deberá permanecer en la _región_ cubierta por el mapa de memoria del kernel.

Un localización segura es por encima del límite de `128MiB`, desde el comienzo de la RAM.


#### <a name="i6">Carga `initramfs`</a> ####

- Cargador de arranque _existente_: `OPTIONAL`.
- Nuevos cargadores de arranque: `OPTIONAL`.

Estando en uso una `initramfs` junto al `dtb`, deberá ser situada en una región de la memoria, donde el _decompresor_ del kernel, no lo sobreescriba. Tambíen deberá permanecer en la _región_ cubierta por el mapa de memoria del kernel.

Una localización segura, es encima del _pequeño_ DT, el cuál él mismo será cargado encima del límite de `128MiB` desde el comienzo de la RAM -recomendación líneas arriba.


#### <a name="i7">Llamada a la _imagen_ del kernel</a> ####

- Cargador de arranque _existente_: `MANDATORY`.
- Nuevos cargadores de arranque: `MANDATORY`.

Hay dos opciones para llamar a la imagen `zImage` del kernel. Si la imagen `zImage`, está almacenada en un _flash_ y, enlazada correctamente para poder ser lanazda desde el _flash_, el gestor de arranque podrá llamar a `zImage` directamente, desde el dispositivo.

La imagen `zImage`, podría ser situada en el sistema RAM, y llamada desde allí. El kernel debería ser situado en los primeros `128MiB` de la RAM. Es recomendable que _cargue_ encima de `32MiB`, para evitar la necesidad de _realojar_, una decompresión previa, lo que hará significativamente más rápido, el _proceso de arranque_.

Cuando se arranca un kernel en _crudo_(no `zImage`), hay más restricciones. En este caso, el kernel deberá ser situado en un `offset` del sistema, igual a `TEXT_OFFSET - PAGE_OFFSET`.

En cualquier caso, deberán aparecer las siguientes condiciones:

- Situar -lugar fijo, todos los dispositivos capaces de trabajar con el _acceso directo a memoria_(DMA), para que la memoria no sea corrompida por paquetes de red, o datos de disco _falsos_. 

- Configuración de registros de la CPU.
	* `r0 = 0`.
	* `r1 =` número del tipo de máquinam descubierto en <a name="i4">Detección del tipo de máquina</a>.
	* `r2 = ` dirección física de la _lista etiquetada_ en la RAM de sistema, o dirección física del DTB -bloque del árbol de dispositivo, en la RAM de sistema.

- Modo CPU

Todas la formas de interrupción, deberán ser deshabilitadas -IRQs y FIQs.

En las CPUs, que no incluyan las extensiónes de virtualización ARM, la CPU deberá estar en modo SVC. Existe una excepción en `Angel`.

CPUs, que incluyan soporte a la extensión de virtualización, entrarán en modo `HYP`, para que el kernel pueda activar un uso completo de las extensiones. Es este el método recomendado para el arranque, en este tipo de CPUs. A menos que la _virtualización_, se encuentre ya en uso, por el _hipervisor_ preinstalado.

Si por alguna razón, el kernel no ha entrado en modo `HYP`, deberá entrar en modo `SVC`. 

- Cachés, MMUs
El MMU debe estar apagado.
La caché de instrucciones podrá estar apagada.
La caché de datos _debe_ estar apagada..

Si el kernel entra en modo `HYP`, los anteriores requisitos serán aplicados al modo `HYP` de configuración, además de la configuración ordinaria PL1 -modos privilegiados del kernel.
En el _hipervisor_ deben ser deshabilitadas las [f1]trampas(traps). El acceso a `PL1`, garantizado a todos los _periféricos_ y recursos de CPU, en todos aquellos casos que sea posible. Exceptuando al entrar en el modo `HYP`, la configuración de sistema debería ser del _tipo_ que, sino incluye soporte a las extensiones de virtualización, pueda arrancar correctamente sin ayuda extra.

- El gestor de arranque llamará a la imagen del kernel, saltando directamente a la primera instrucción de la imagen.

En CPUs que soporte el conjunto de instrucciones ARM, la _entrada_ debe estar hecha en _estado ARM_, inluso para un kernel _thumb-2_.

En CPUs que soporten únicamente el conjunto de instrucciones _Thumb_, como la clase de CPUs `Cortex-M`, la _entrada_ debe estar hecha en _estado Thumb_.


#### <a name="i99">Referencias y agradecimientos</a> ####

[f1] Traps, conjunto especial de instrucciones, ejecutadas habitualmente sobre la CPU. Ver [CPUID wikipedia](https://en.wikipedia.org/wiki/CPUID)




__Autor__:	Russell King
__Fecha__: 18 May 2002


<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
