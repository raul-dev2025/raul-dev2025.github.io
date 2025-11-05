1. Extensible Host Controller Interface
2. Objetivos.
3. Detalles
	 - Soporte para todas las velocidades
	 - Eficiencia energética 
	 - Soporte para la virtualización
	 - Driver simplificado
	 - Soporte para torrente(stream) de datos
	 - Escalabilidad
99. Referencias y agradecimientos

#### Extensible Host Controller Interface

Es una especificación de interfase de computadora, que define un nivel de registros de  
descripción del controdalor para el _Universal Serial Bus(USB)_, el cuál es compatible con  
dispositivos USB, para las versiones  v1.x, v2.0 y v3.x de la misma interfase(USB).  

La especificación también es referida como _USB 3.0 host controller specification_.  

#### Objetivos._

El xHCI es una ruptura radical con respecto a previas generaciones del _USB host controller_  
En esencia, Open Host Controller Interface(OHCI), Universal Host Controller Interface(UHCI) y  
Enhanced Host Controller Interface(EHCI) en muchos casos.  
Los objetivos prinicipales de _xHCI_, son los siguientes:  

- Operación eficiente: mejor _desarrollo_ y _tiempo de espera o reposo_, que el controlador de  
host USB, de anteriores versiones.  
- Un modelo de programación a nivel de dispositivo, consistente con el modelo de software para  
USB.  
- Aunar la interfase presentada para el _controlador de host_, para los distintos protocolos  
USB, ya existentes.
- Minimizar el acceso a memoria del _host_; eliminándolos completamente, cuando el USB está  
en reposo(idle).
- Eliminar la escritura de registros y, minimizar la lectura de los mismos, para la  
transferencia normal de datos.
- Eliminar el modelo "_controlador compañero_(Companion Controller)".
- Activar los modos _fail-over_, en situaciones de recursos de sistema _constringido?_, para  
que los dispositivos aún puedan ser accesibles, quzás con un comportamiento en cuanto a 
eficiencia y energía, reducido.
- Proporcionar la habilidad de distinguir las distintas capacidades del _hardware_, a  
diferentes mercados, ejem: coste/eficiencia en distintos mercados.
- Definición de una arquitectura extensible, capaz de proveer una ruta sencilla, para las  
nuevas tecnologías y especificaciones USB; tales como un mayor ancho de banda, medio óptico  
de transmisión, etc., sin necesidad de definir otra _interfase_ para el _controlador_ 
_de host USB_.


#### Detalles

__Soporte para todas las velocidades__
Los controladores OHCI y UHCI, soportan únicamente la velocidad del dispositivo _USB v1_.   
EHCI la velocidad del dispositivo _USB v2_. Velocidades (1.5 Mbit/s y 12 Mbit/s) y  
(480 Mbit/s) respectivamente.

La arquitectura xHCI, fué diseñada para soportar todas las velocidades USB, incluída  
_"SuperSpeed"_ (5 Gbit/s) y futuras mejoras, bajo la misma _pila(stack)_ del controlador.

__Eficiencia energética__
Originalmente, el USB fue desarrollado en 1995, con el propósito de trabajar en ordenadores  
de _sobre mesa_, dando lugar, a la proliferación de los distintos conectores, que aparecerían  
para _PCs_ ejem. PS/2, puerto en serie, puerto en paralelo, Puerto juegos(GamePad), etc.

En un principio, el consumo de energía del _controlador host_, no era una consideración  
importante. desde entonces, los móbiles se han convertido en la plataforma predilecta, y sus  
baterías, han hecho del consumo de energía, la consideración más importante.

La infraestructura de los _controladores de host(OHCI, UHCI y EHCI)_ fueron muy similares  
en cuanto al esquema, de la transaccaiones que debían lleverse a cabo en el USB, donde se  
construyen por software, en la memoria del host.

El controlador de hardware, tenía que leer constantemente los esquemas, para determinar si  
las transacciones, debían ser conducidas, a través del USB, incluso sin tener que mover  
datos. Adicionalmente en el caso de lecturas desde el dispositivo, era consultado, incluso  
sin haber datos que leer.

 * El _xHCI_ elimina de la memoria del host, las transacciones del USB basadas en esquemas,  
 evitando la actividad, en la memoria de host, cuando no hay movimiento de datos.
 * El _xHCI_ reduce la necedidad de consultar periódicamente al dispositivo, permitiendo  
 notificar al _controlador host_, cuándo tiene datos disponibles para su lectura, y  
 mueve la gestión de consultas en dispositivos USB v2.0 y v1.1, que usan interrupcion de  
 transacciones, desde la CPU al _controlador USB host_.  
 
 Los _controladores de host_ EHCI, OHCI y UHCI, serían controlados automáticamente por la  
 CPU, si no hay cambios que necesiten hacerse y, si ningún dispositivo tiene alguna  
 interrupción que enviar. Pero todos ellos subyacen, en que la cpu, configure los esquemas  
 de los controladores.
 
 Si algún dispositivo USB, haciendo uso de _transacción de interrupciones_, tiene datos que  
 enviar, entonces el _controlador xHCI_, enviará una interrupción, para notificar a la CPU,
 que hay una _transacción de interrupción_, que necesita ser gestionada.
 
 Como la CPU, ya no tiene que gestionar la consulta del _bus USB_, podrá gastar más tiempo  
 en _estados de baja energía_.

 * El _xHCI_ no necesita que las implementaciones, proporcionen soporte para _todas_ las  
 características avanzadas de gestión de energía en _USB v1 y v2_, incluidas _los estados_  
 _USB 2 LPM, USB 3 U1 y U2_, HERD, LTM, _Function Wake(función levantar)_, etc.
 Pero estas características son necesarias par conseguir todas las ventajas de _xHCI_.
 
 
__Soporte para la virtualización__

Anteriores USB HCI, exibieron algunas de las características que más tarde serían  
incorporadas a implementaciones posteriores. Éstas "primicias", fueron aplicadas a 
entornos virtualizados. USB HCI legados, definen una relatívamente _simple_ canalización  
de datos por _hardware_; donde el estado crítico relacionado al _sobrecoste_ -en cuanto  
a la gestión del _bus_(acomodo del ancho de banda, asignación de direccionamiento, etc.),  
reside en el _software_ del _HCD_.

Intentar aplicar la técnica de virtualización por _hardware_ (el estandar de entrada/salida),  
replicando la intefase de registros _I/O_, a USB HCI, es problemático por que los  
_estados críticos_ que deben ser gestionados entre las máquinas virtuales(VMs) __no están__  
_disponible por hardware_

El _xHCI_ mueve el control de estos estados críticos dentro del _hardware_, activando  
la gestión de recursos _USB_, entre las _VMs_. La virtualización _xHCI_ proporciona las  
características: 

 - Asignación directa de dispositivos USB individuales(con independencia de su localización  
 respecto a la topología marcada en el BUS) a cualquier _VM_.  
 - Minimización del tiempo necesario, para la comunicación entre _VMs_.  
 - Soporte de dispositivos compartidos para _USB nativo_.  
 - soporte para _PCIe_ _SR-IOV_.
 
> SR-IOV -- raíz simple para la virtualización de I/O(single root I/O virtualization)
> HCI -- Host Controller Infraestructure 
> HCD -- Host Controller Driver
> VM -- Maquina Virtual(Virtual Machine)

__Driver simplificado__

El _EHCI_ utiliza los controladores _OHCI_ o _UHCI_ como "controlador compañero", donde  
los dispositivos _USB v2_ son controlados a través de la pila _EHCI_, y el puerto lógico  
de _EHCI_ permite que la velocidad _baja/completa_ en un dispositivo _USB_, pueda ser  
dirigida hacia un controlador de puerto -el _"compañero"_, tipo _OHCI_ o _UHCI_.  

Por ejemplo, un _controlador de host `de tarjeta` PCIe_, para un _USB v2_, el cuál presenta  
4 conectores _USB(estandar tipo A)_, es presentado ante el _software de sistema_ como  
__un__ _controlador de software de sistema_ con 4 puertos tipos EHCI y __dos__, con 2 puertos  
tipo OHCI.

Cuando un dispositivo USB de _alta velocidad_, es acoplado a cualquier de los 4 conectores,  
el dispositivo es gestionado por uno de los 4 puertos _hub_ raíz, del controlador _EHCI_.
Si un _dispositivo USB_ de _baja/completa_ velocidad, es acoplado al conector 1 o 2,  
será dirigido al puerto _hub_ raíz, de uno de los controladores _OHCI_ para su gestión y,  
un _dispositivo USB_ de _baja/completa_ velocidad acoplado al conector 3 o 4, será dirigido  
al puerto _hub_ raíz, del otro conector _OHCI_.

La dependencia _EHCI_, sobre _controladores de host_ separados, para _dispositivo USB_  
de velocidad _baja/completa_, resulta en complejas _dependencias e interacciones_, entre  
los controladores EHCI y OHCI/UHCI.



						 |--puerto-1 usb
		USB EHCI |--puerto-2 usb
						 |--puerto-3 usb
						 |--puerto-4 usb

		|------|
			 HUB

										|--puerto-1 usb
							crt-1	|--puerto-2 usb
		USB OHCI 
							crt-2	|--puerto-3 usb
										|--puerto-4 usb

						|-----|
  						HUB
								


 * El xHCI, elimina la necesisdad de _controladores compañeros_ y su controlador de  
 _pila_ separado.
 * La incorporación del _"esquema"_, la gestión del ancho de banda y, las funciones  
 asignación de direccionamiento, que fueron antes realizadas por el controlador. Con  
 el _hardware xHCI_ se establece una _pila simple_, por software de baja latencia  
 para el xHCI.


> __hub:__ es una especie de interfase; referido a un nodo con gran cantidad de enlaces.
> __CRT:__ Tubo de Rayos Catódicos, aquí abreviatura de _conector_.


__Soporte para torrente(stream) de datos__

El soporte para los _streams_, fue añadido en la especificación "SuperSpeed"  
versión _USB v3.0(5 Gbit/s)_. Primeramente para permitir una mejor eficiencia en las  
operaciones de almacenamiento sobre USB. 

Históricamente, ha habido una relación de _uno a uno(1:1)_ entre la _terminación(endpoint)_  
de un USB y su _almacén(buffer)_ en memoria de sistema; el _controlador de host_ únicamente  
es responsable de direccionar la transferencia de datos. 

Los _Streams_ cambiaron éste _paradigma_, porporcionando una asociación _terminación_  
hacia el _almacén_(endpoint to buffer), y permitiendo al _controlador de host_ de un  
dispositivo, a qué -o cuál, _almacén_ dirigirse.

La transferencia de datos de un USB, asociada a una terminación USB, de torrente de  
datos(USB stream point) y, presentado por el xCHI, de la misma forma que cualquier otra  
terminación es, en cualquier caso, los datos asociados del almacén, con una transferencia  
es determinados por el dispositvo.

 * El soporte del _xHCI USB Stream_, permite almacenes de hasta 64K, ser asociados con  
 una sóla terminación.
 * El protocolo _xHCI USB Stream_, permite a un dispositivo USB, seleccionar el almacén,
 al que hacer la transferencia, cuando es presentada la terminación.


__Escalabilidad__

El xHCI, fué diseñado para ser sólidamente adaptable, capaz de soportar de 1 a 255 dispositivos  
USB y, de 1 a 255 _puertos hub raíz_. Como a cada dispositivo USB, le es permitido definir  
hasta 31 terminaciones, un xHCI que soporte 255 dispositivos, tendrá que dar soporte a  
a un total de 7906 terminaciones, por separado.

Consecuentemente, cada almacén de memoria, asociado a una terminación, es descrito por una  
_lista(cola, queue en inglés)_ de bloques de memoria, donde cada _lista_ requiere un punto  
de cabecera(head pointer), una longitud de cola de puntos(el extremo, the queue, the tail...)  
y otros registros que definan su estado.

Hay muchas formas de definir el _estado de lista_(queue state), aunque si uno tuviese que  
asumir 32 bytes de espacio de registros, para cada lista, entonces casi 256KB de espacio  
de registro, sería necesario par dar soporte a las 7906 listas. 

Únicamente un pequeño numero de dispositivos USB, serán acoplados al mismo tiempo. Como  
media, un dispositivo USB, da soporte a 3-4 terminaciones, de las cuáles, sólo un  
subconjunto de ellas, estarán activas a la vez.

El xHCI, mantiene el _estado de lista_, en la memoria del sistema como _contexto para la_  
_extructura de datos de terminaciones_. El contexto, está diseñado, para mantener una _caché_  
a ser accedida por el xHCI y, _paginado_ como función de entrada y salida, para la actividad  
de la terminación.

De esta forma, un _fabricate/desarrollador_, podrá escalar su própio _contexto de caché xHCI_  
y hacer coincidir su uso práctico, en todos sus productos; en lugar de limirlo(xHCI) a la
_arquitectura_ del própio producto. Es decir, el fabricante, en lugar de desarrollar  
nuevo _software_ para cada producto, utilizará el mismo; y lo adaptará a distintos  
dispositivos, con una "maquinaria" similar.

Idealmente, el _espacio interno de caché_, es seleccionado de tal forma, que bajo  
circunstancias de uso normales, no hay _contexto de paginación_ en el xCHI.
Iguamlente, la actividad de una _terminación USB_, tiende a ser reactiva -o a reaccionar.

Esto significa, que en cualquier momento, un gran número de terminaciones, podrán estar  
preparadas, para mover datos; aunque únicamente un subconjunto de ellos, mueva datos de 
manera activa.

Como ejemplo, la interrupción `IN`, de la terminación de un ratón, podría transferir datos  
durante horas, si el usuario está lejos de su escritorio. Los algoritmos xHCI, específicos  
del fabricante, podrán detectar ésta situación y, hacer que la terminación candidata  
_deje de paginar_, si otra terminación está ocupada.

 * El xHCI, permite grandes _valores máximos_, para el número de dispositivos soportados;  
 puertos interrupciones, vectores, etc. Aunque una implementación, únicamente necesita  
 definir, aquellos que satisfagan los requisitos de _marketing_. Por ejemplo, un fabricante  
 podrá limitar el número de dispositivos USB, que soporta la implementación xHCI de una  
 _tablet_, a 16 dispositivos.
 
 * Un fabricante aún puede sacar más ventaja de las características xHCI, y escalar sus  
 recursos internos, para hacerlo coincidir, con un _modelo_ de uso. Por ejemplo, si 
 a través de pruebas de usabilidad, el fabricante determina que el 95% de los usuarios  
 de _tablets_, nunca conectan más de _cuatro (4)_ dispositivos USB y, cada dispositivo  
 define 4 terminaciones -o menos, entonces el cacheado interno para 16 contextos de  
 terminación, asegura que bajo circunstancias normales, no habrá actividad en la memoria  
 de sistema, debido al contexto de paginación.
 

> __paradigma:__ abstracción de una situación o modelo real -en la vida cotidiana, a un  
> entorno de programación.  

> __Escalabilidad__ que puede ser adaptado, para que funcione en distintas plataformas.  
  
> __caché:__almacén oculto de cosas.  


#### Referencias y agradecimientos

[xHCI][https://en.wikipedia.org/wiki/Extensible_Host_Controller_Interface]


