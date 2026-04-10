1. Arquitectura
	 - Controlador de dispositivo
	 - Controlador de eventos
2. Uso simple
25. Significado de Mayor y Menor
3. Descripción detallada
	 - evdev
	 - Teclado
	 - mousedev
	 - joydev
	 - Controladores de dispositivo
	 - Interfase genérica de eventos de entrada - HID
	 - usbmouse
	 - usbkbd
	 - psmouse
	 - atkkbd
	 - iforce
4. Verificando que funciona
5. Interfase de eventos

99. Referencias y agradecimientos
---

#### Arquitectura

Los subsistemas de entrada, son una colección de controladores disñados para dar soporte  
a todos los dispositivos de entrada bajo _Linux_. Muchos de los controladores in  
`drivers/input`, también podrían encontrarse baja los directorios `drivers/hid` y  
`drivers/platform`.

El centro del _subsistema de entrada_, es el modulo `input` , el cuál debe ser cargado  
antes que cualquir otro módulo -hace las veces de _camino de entrada_, para las   
comunicaciones _entre dos grupos_ de módulos.


__Controlador de dispositivo__

Éstos módulos _hablan_ con el _hardware_ -por ejemplo vía USB, y proporciona los  
eventos -pulsación de teclas, eventos de ratón; al módulo _input_.


__Controlador de eventos__

Éstos módulos toman los _eventos_ desde desde el _centro de entrada(`input`)_ y se les  
pasan vía distintas _interfases_ -pulsación de teclas al _kernel_, eventos de ratón vía   
una interfase PS/2 simulada al _GPM_ y _"X"_ etc.  


#### Uso simple

Para las configuraciones más habituales, con un ratón USB y, un teclado USB, se tendrán  
que cargar los siguientes módulos(o contruirlos como parte del kernel).  


		input  
		mousedev  
		usbcore  
		uhci_hcd or ohci_hcd or ehci_hcd  
		usbhid  
		hid_generic  

Después de esto, el teclado USB, funcionará _como debe_ y, el ratón, estará disponible  
con -visible en `/dev/...`, el carácter de dispositivo:  _mayor 13 y, menor 63_.

		crw-r--r--   1 root     root      13,  63 Mar 28 22:45 mice
		
Éste dispositivo es normalmente creado automáticamente por el sistema. Los comandos para  
crearlos:

		cd /dev
		mkdir input
		mknod input/mice c 13 63

Después de esto, se debe apuntar _GPM_ y, _XFree_ al dispositivo -arriba creado, para poder  
hacer uso de él.

		gpm -t ps2 -m /dev/input/mice
		
... para las _Xs:_

		Section "Pointer"
			  Protocol    "ImPS/2"
			  Device      "/dev/input/mice"
			  ZAxisMapping 4 5
		EndSection

Cuando hagas lo descrito arriba podrás utiliza ratón y teclado USB.


#### Descripción detallada

__controlador de eventos__

Los controladores de eventos distribuyen los eventos desde los dispositivos al espacio de  
usuario y, a los _usuarios del kernel_, cuando sea necesario.


__evdev__

`evdev` es una interfase genérica para eventos de entrada. Se encarga de _traspasar_ los  
eventos generados en el _kernel_ directamente a los programas, junto a sus marcas de tiempo.  
Los códigos de eventos, son los mismos en todas las plataformas y el hardware, de forma  
independiente.

Ésta es la interfase preferida para el _espacio de usuario_ para consumar las entradas de  
usuario, y a todos los clientes, se anima a que hagan uso de ésta. Ver `event-interface`.

Los dispositivos están en _/dev/input_

		crw-r--r--   1 root     root      13,  64 Apr  1 10:49 event0
		crw-r--r--   1 root     root      13,  65 Apr  1 10:50 event1
		crw-r--r--   1 root     root      13,  66 Apr  1 10:50 event2
		crw-r--r--   1 root     root      13,  67 Apr  1 10:50 event3

Hay dos rangos de _menores_: _64 hasta 95_ es el legado _rango estático_. Si hubiesen más de  
32 dispositivos de entrada en un sistema, `evdev` crearía nodos adicionales, cuyos _menores_  
empezariam desde 256.


__Teclado__

El controlador de entrada de teclado es parte del _kernel_ y del código VT. Interpreta las
pulsaciones de tecla y controla las entradas de usuario para cónsolas VT.


> __VT:__ virtual terminal

__mousedev__

Es una _trampa(hack)_ hecha para que los programas legados, que hacen uso de las entradas de 
ratón, puedan funcionar. Toman eventos tanto del ratón como de _digitales/tablets_ y, 
permitiendo que dispositivos del tipo PS/2, estén disponibles en el espacio de usuario.  

Los dispositibos tipo _Mousedev_ en `/dev/input` son:  

		crw-r--r--   1 root     root      13,  32 Mar 28 22:45 mouse0  
		crw-r--r--   1 root     root      13,  33 Mar 29 00:41 mouse1  
		crw-r--r--   1 root     root      13,  34 Mar 29 00:41 mouse2  
		crw-r--r--   1 root     root      13,  35 Apr  1 10:50 mouse3  
		...
		...
		crw-r--r--   1 root     root      13,  62 Apr  1 10:50 mouse30  
		crw-r--r--   1 root     root      13,  63 Apr  1 10:50 mice  

Cada dispositivo `mouse` es asignado a un único ratón o _digitador_, excepto el último,  
`mice`. Éste único dispositivo _literal_ es compartido por todos los ratones y digitadores,  
e incluso si no hay ninguno conectado, es presentado el dispositivo. Ésto es útil para  
conectar en _caliente_ dispositivos USB. Así, antiguos programas que no soportan conexión en  
_caliente_, puedan abrir el dispositivo incluso cuando no hay ratón presente.

`CONFIG_INPUT_MOUSEDEV_SCREEN_[XY]` en la configuración del _kernel_, represesnta el  
tamaño de la pantalla(en pixels) en XFree86. Esto es necesario si se quiere hacer uso  
de un digitador en _X_, por que su movimiento es enviado a _X_ por medio de un ratón  
PS/2, necesitando ser _escalado_ adecuadamente.

_Mousedev_ generará protocolos, tanto PS/2, ImPS/2 (Microsoft IntelliMouse) como  
ExplorerPS/2 (IntelliMouse Explorer), dependiendo de lo que necesite leer el programa.
Puede configurarse GPM y X, a cualquiera de ellos. Es necesario configurar ImPS/2, si
va a hacerse uso de la rueda del ratón y, ExplorerPS/2, para usar (más de 5) botones  
extra.


> __digitador__ se utiliza un término genérico, para referirse a dispositivo donde la pantalla,  
> es en ambos casos, dispositivo de entrada y salida -teclado o ratón y monitor,  
> respectivamente.  
> __Las _Xs_:__ Referido al servidor gráfico de Linux _Xorg.org_.
> __X:__ en un eje de coordenadas, la variable horizontal.


__joydev__

`joydev` implementa las versiones _v0.x_ y _v1.x_ de la API de Linux para joystic. Ver  
`joystic.api` para más detalles.  

Tan pronto como es conectado el _joystic_, podrá ser accedido desde `/dev/input`:  

		crw-r--r--   1 root     root      13,   0 Apr  1 10:50 js0  
		crw-r--r--   1 root     root      13,   1 Apr  1 10:50 js1  
		crw-r--r--   1 root     root      13,   2 Apr  1 10:50 js2  
		crw-r--r--   1 root     root      13,   3 Apr  1 10:50 js3  
		...  

... así, hasta `js31`, en un rango legado y, _menores_ adicionales por encima de `256` si  
fuesen necesarios más dispositivos.



> __menores:__ ver input-misNotas.md


__Controladores de dispositivo__

Son módulos que generan eventos.


__Interfase genérica, de eventos de entrada - HID__

La _interfase_ `hid-generic`, es una de las más grandes y complejas de todo el _paquete_.
Controla todos los dispositivos _HID_, y puesto que hay una gran variedad de ellas y, la  
_especificación HID USB_, no es nada simple, necesita ser, así de grande.

 
En estos momentos, controla, el ratón, los _joystics_, gamepads, steering wheels kbd,  
trackballs, y digitadores.

Aunque el USB también usa el HID, para el control de monitores, altavoces, UPS, LCD y,  
muchos otros.

Los controles del monitor y altavoces, deberían ser fáciles de añadir a la interfase  
de entrada HID. Sin embargo, no tiene mucho sentido, por ésto, fué diseñada la  
interfase `hiddev`. Ver documentaciónm `Documentation/hid/hiddev.txt`, para más _info_.

El _uso_ del módulo `usbhid` es muy sencillo, no toma parámetros, detecta cualquier  
cosa automáticamente y, cuando un dispositivo HID, es insertado, lo detecta de forma  
apropiada.

Dado que los dispositivos varían _a lo bestia(wildly)_, se podría esperar tener un  
dispositivo que no funcionase. En ese caso, podría definirse `#define DEBUG`, al  
principio de `hid-core.c`, y mandar el resultado a _Vojtech Pavlik <vojtech@ucw.cz>_
quien se presta, amigablemente a recoger las _trazas de log_.



> __joystic:__ es quizás una de esas excepciones, a palabras que no haya que traducir...  
> `joy`--juego/juguete, `stick`--palo: _palo de juego_... No tiene mucho sentido que la
> _NASA_ apalée a sus juguetes!

> __HID:__ Human Interface Device, toma eventos de entrada(INPUTS) y devuelve   
> salidas(OUTPUTS) .[hardware/hid]:[hid.md].


__usbmouse__  

Para sistemas embebidos, para ratones con descriptores _HID_ rotos, y paraqualquier otro
uso, cuando el enorme `usbhid`, no seería una buena opción. Es entonces, el controlador  
`usbmouse` una buena opción.
Únicamente controla los ratones USB. Usa un protocolo simple, _HIDBP_. Significa esto  
también, que debe soportar dicho protocolo. No todos -los controladores, lo hacen.
Pero si no se tiene una "poderosa" razón para usarlo, `usbhid`, es mejor alternativa.


__usbkbd__

Con éste controlador, ocurre algo similar a `usbmouse`, el módulo, se comunica con el  
teclado, por medio de un protocolo simplificado; _HIDBP_. Es más pequeño, y no soporta  
_teclas especiales_. usbhid`, es mejor alternativa.


__psmouse__

Éste controlador es para aquellos dispositivos que apuntan al uso del protocolo PS/2,  
incluidos _Synaptics_ y _ALPS touchpads, Intellimouse_, _dispositivos Explorer_,  
_ratones Logitech PS/2_ , etc.


__atkkbd__

Es un controlador para teclados PS/2(AT).


__iforce__

Controlador para _volantes y joystics I-Force_, ambos sobre USB Y RS232.
Ahora esto incluye _Force Feedback_ e incluso Immersion Corp; considérese un "secreto"
y espere oir hablar de él.


#### Verificando que funciona

Pulsar un par de teclas en el teclado, debería considerarse suficiente para comprobar  
que funciona y, que está correctamente conectado al controlador de teclado del kernel.

Hacer un `cat /dev/input/mouse0` verificará que el ratón está funcionando; aparecerán 
_carácteres_ si se mueve.

Puede provarse la emulación del joystick con la utilidad `jstest`, disponible el paquete  
de _joystick_. Ver `joystick-doc`.

Los eventos utilizan la aplicación `evtest` para ser probados.


#### Interfase de eventos

Podrán usarse lecturas bloqueantes y no bloqueantes y, la función `select()` en  
dispositivos `/dev/input/eventX`, y siempre se tendrá _el completo_ de eventos de  
entrada sobre lectura. La plantilla es la siguiente:


		struct input_event {
			struct timeval time;
			unsigned short type;
			unsigned short code;
			unsigned int value;
		};

`time` es la marca de tiempo, devuelve el tiempo en el que sucedió el evento.
`type` es -por ejemplo, `EV_REL`, para el momento relativo, `EV_KEY` para pulsaciones  
de teclas o _soltar tecla(to release)_. Hay más tipos definidos en  
`include/uapi/linux/input-event-codes.h`.

`code` es el código de evento. Por ejemplo, _REL_X o KEY_BACKSPACE_, de nuevo, la lista  
completa en `include/uapi/linux/input-event-codes.h`.

`value` es el valor que acarrea evento. Tanto el _cambio relativo_ para `EV_REL` como el  
_absolumto_ `EV_KEY` al soltar, 1 para pulsaciones y 2 para autorepetir.

Ver `input-event-codes`, para más información sobre distintos códigos.


#### Referencias y agradecimientos
Documentación del sistema operativo Linux.
Referencia al documento `input.rst`
