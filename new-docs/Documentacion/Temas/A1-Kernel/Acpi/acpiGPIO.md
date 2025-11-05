* [Propuesta General de I/O(GPIO)](#i1)
* [Controlador de dispositivo GPIO](#i2)
* [Controladores GPIO e interrupciones SendoActiva (ActiveBoth).](#i3)
* [Espacio de nombres de objeto GPIO](#i4)
* [Identificación de dispositivos y configuración de objetos](#i5)
* [Descriptor de recursos de conexión GPIO](#i6)
* [Eventos ACPI, Señalizados como GPIO.](#i7)
* [Objeto de Evento de Información ACPI](#i8)

***************


## <a name="i1">Propuesta General de I/O(GPIO)</a> ##


Chip en sistema (SoC) son circuitos integrados, que hacen uso ampliado de la propuesta  
general de I/O _GPIO_(entrada/salida standar). En plataformas basadas en _SoC_, Windows  
define una abstracción general desde el _A-en_, espacio de nombres ACPI_, para la  
Interfase de Configuración avanzada de Energía.  

La abstracción GPIO, es soportada por la definición de ACPI 5.0, que es listada en este  
artículo.  

Para verificar que sus controladores GPIO, aceptan los requisitos de la plataforma  
Windows, ver [GPIO lista de comprobación de requisitos del Controlador][link].  

#### <a name="i2">Controlador de dispositivo GPIO</a> ####


Windows soporta controladores GPIO. Los controladores GPIO proporcionan variedad de  
funciones para dispositivos periféricos, incluidas interrupciones, señal de entrada y  
señal de salida. Las capacidades GPIO, son modeladas como control de dispositivo en  
_A-en_. La extensión _GpioClx_ para marco de trabajo GPIO (GPIO framework), moldea el  
controlador de dispositivo para ser particionados dentro de algunos _bancos de enlance_.  
Cada _banco de enlace_ tiene tiene 64 _enlaces_ configurables, o menos.  
Los _bancos_ en un controlador GPIO están ordenados por la posición relativa de sus  
enlaces, dentro del espacio de enlaces, relativo al controlador GPIO. Por ejemplo, el  
banco 0(_o bufer/almacén_), contiene _0-31_ enlaces en el controlador(de 0 a 31), el  
banco 1 contiene 32-63 enlaces, y así sucesivamente. Todos los bancos tienen el mismo  
número de enlaces, excepto para el último banco, el cuál podría tener menos. Estos  
bancos son importantes para firmware de ACPI, por que debe relacionar el mapeado de  
interrupciones de sistema a los bancos; tal y como se describe en [A-en para objetos  
GPIO][link].  

Cada enlace al _banco_, contiene un conjunto de parámetros -por ejemplo, salida, nivel  
de sensibilidad de la interrupción, desvinculación de entrada, etc. Esto, describe como  
el enlace será configurado.  


> n.d.t: pin significa algo así como _alfiler_, podría haberlo traducido como  
_conector_ pero pienso que resulta confuso, puesto que un conector podría tener  
multitud de _alfileres!!_.  

#### <a name="i3">Controladores GPIO e interrupciones SendoActiva (ActiveBoth).</a> ####


Una característica de un determinado controlador GPIO, es la habilidad de generar  
interrupciones en ambos extremos de una señal(rising, ActiveHigh edges, and falling, o  
ActiveLow edges). Esto resulta útil en multitud de aplicaciones, incluida la interfase  
de botón, donde ambos eventos son controlados; _pulsar de botón_ y, _dejar de pulsar  
botón_ -en el extremo opuesto. Esta característica es denominada _ActiveBoth_.  

Lógicamente, ambas señales _ActiveBoth_ definen un estado de asertación o no, donde  
están momentáneamente activas -por ejemplo, las pulsacioes de botón. O indefinidamente  
definidas como asertación larga -por ejemplo, la inserción del conector de unos  
auriculares. La detección de extremo de interrupción para _ActiveBoth, podría ser   
implementada en el controlador de pieza(hardware ActiveBoth)_, o emulada en el  
controlador de software GPIO (ActiveBoth emulado). Windows requiere que los  
controladores GPIO que implementan _ActiveBoth_, deban usar _ActiveBoth emulado_. Esto  
es requerido para asegurar la robustez en el manejo de las interrupciones de doble  
extremo, en cualquier _escenario_. Como soporte a la _emulación ActiveBoth_, son  
aplicados los siguientes requisitos de hardware:  

1.- Los controladores GPIO, que soportan interrupciones _ActiveBoth_ deben soportar  
_modo nivel_ de interrupciones y, deben soportar la reprogramación de polaridad de  
interrupción dinámica en _tiempo de ejecución_.  

2.- Para minimizar el riesgo de errores _I/O_, Windows prefiere el uso de controladores  
GPIO de _memoria mapeada_, en lugar de controladores GPIO tipo _SPB-connected_. De hecho  
para el arreglo de _dispositivo Botón(PNP0C40)_, es requerido que las interrupciones,  
para este dispositivo, _ActiveBoth_ de GPIO, se conecten a un controlador de  
_memoria mapeada_, en lugar de contectarse a otro tipo _SPB-connected_.  
Para dterminar que interrupciones de botón, deben ser _ActiveBoth_,  
ver [Dispositivo de Boton][link].  

3.- Para establecer un estado inicial determinista para las interrupciones de señal de  
_ActiveBoth_, la pila del dispositivo GPIO de Windows, garantiza que la primera  
interrupción generada después de la conexión de interupción por el controlador, será  
siempre para la señal de estado de aserción. La pila asume completamente que el estado  
de aserción de todas las líneas deinterrupción, de _ActiveBoth_, son de bájo nivel  
lógico (el extremo ActiveLow) por defecto. Si en su plataforma este no es el caso,  
puede sobreescribirse por defecto, incluyendo un método de controlador GPIO de  
dispositivo específico, ver [método de controlador GPIO específico(_DSM)][link].  

__Nota:__ El tercer requisito en la lista precedente, implica que el controlador del  
dispositivo usado por _ActiveBoth_, pueda recivir una interrupción inmediatamente  
después de inicializar (conectar a) la interrupción, si la señal en el enlace GPIO  
se encuentra en estado de aserción en ese momento. Esto es posible, e incluso posible,  
para algunos dispositivos(por ejemplo, auriculares), y debe ser soportado por el  
controlador.  

Par el soporte _ActiveBoth_ emulado, el controlador GPIO debe activar `opt-in to`  
emulación ActiveBoth, implementando una llamada a la funcion  
 `CLIENT_ReconfigureInterrupt` (reconfiguracion de interrupción de cliente) y,  
configurar la bandera(flag) `EmulateActiveBoth` en la estructura de información  
básica que la llamada a la función `CLIENT_QueryControllerBasicInformation` del  
controlador, suministra a `GpioClx`.  
Para mas información, ver [Controladores de I/O de propósito general _GPIO_][link].  

#### <a name="i4">Espacio de nombres de objeto GPIO</a> ####


Los controladores GPIO, y los periféricos que conectan a él, son enumerados por ACPI.  
La conexión entre ellos es descrita por medio de _Descriptor de conexción de recursos  
GPIO_. Para más información, ver sección [Descriptores de conexión][link] de la  
especificación ACPI 5.0.  


#### <a name="i5">Identificación de dispositivos y configuración de objetos</a> ####


Un espacio de nombres para el controlador GPIO de dispositivo ACPI, incluye lo siguiente:  

- Un objeto asignado por el fabricante de hardware compatible con ACPI.  
- Un conjunto de recursos objeto `_CSR`.  
- Un objeto ID único `_UID`, si hay mas de una instancia para el controlador GPIO en el  
espacio de nombres -esto es, dos o más nodos de espaciios de nombres que tienen la  
misma identificación de objeto de dispositivo.  

Los controladores GPIO de `_CRS`, contienen todos los recursos (espacio de dirección  
para los registros, sistemas de interrupción, y demás) ocupados por todos los _bancos_  
en el controlador. El mapeado de interrupción de _recurso a banco_, es representado en  
el orden en el cuál la interrupción de recursos es listada en el `_CSR`; la primera  
interrupción listada es asignada al _banco_ 0, la siguiente en la lista, es asignada al  
_banco_ 1, y así sucesivamente. Los bancos pueden compartir recursos de interrupcion,  
en cuyo caso la interrupción es listada una vez, por cada banco a esta, en orden de  
_banco_ y, configuración compartida.  

#### <a name="i6">Descriptor de recursos de conexión GPIO</a> ####


La relación entre los periféricos y los _enlaces_ GPIO al cuál están conectados es  
descrita al sistema operativo, por el _Descriptor de recursos de conexión GPIO_. Estos  
descriptores de recurso, pueden definir dos tipos de Conexiones GPIO: conexiones GPIO y  
conexiones I/O GPIO. Los periféricos incluyen descriptores de conexión en sus `_CSR`,  
para todas las interrupciones I/O de enlace de conexión. Si una interrupción de  
conexión, es _wake-capable_ -capaz de despertar al sistema, desde un estado en espera  
de baja energía, entonces debe ser configurado como `ExclusiveAndWake` o  
`SharedAndWake`; para más información ver [Dispositivo de administración de energía][link]  

Los descripores son definidos en la sección [Descriptor de conexión GPIO][link], de la  
especificación ACPI 5.0. Los recursos de plantillas de macros ASL para estos  
descriptores, en la seción [`GpioInt` recursos de Descriptor de interrupción de conexión]  
[link], en la especificación ACPI 5.0 igualmente.  


#### <a name="i7">Eventos ACPI, Señalizados como GPIO.</a> ####


ACPI define un modelo de plataforma de eventos, que activa eventos de hardware, en la  
plataforma a ser señalizada y comunicada con el controlador ACPI. Windows proporciona  
un servicio de notificación  para comunicarse con la plataforma de eventos del  
controlador de dispositivos. Un número de controladores _dentro de la caja_, recae  
sobre este servicio, para proporcionar soporte a los dispositivos ACPI definidos; como  
el _Metodo de control del Botón de Encendido_, el _dispositivo LID_, _Método de control  
de Batería_, _Zona Termal_, y otros. Para más información sobre notificaciones, ver  
sección [Eventos ACPI de señal GPIO][link], de la especificación ACPI.  

En plataformas _SoC_, las interrupciones GPIO, son usadas para señalizar eventos de  
plataforma. Cualquier dispositivo de espacio de nombres (dispositivo ACPI de fuente  
de eventos, _ACPI Event Source_) que señalice eventos a sus controladores, usando  
el operador de notificación ASL, requiere lo siguiente:  

- El nodo de espacio de nombres del controlador GPIO, al cuál el evento de señal ACPI  
está conectado, debe incluir un recurso `GpioInt` para el enlace, en su objeto de  
Evento de Informacion `_AEI`. Ver sección [Objeto de evento de información ACPI `_AEI`]  
[link], más abajo. El recurso `GpioInt` debe ser configurado como _no compartido_  
(Exclusivamente).  
- El nodo del controlador debe también contener un método de control _Extremo_ `_Exx`  
_Nivel_ `_Lxx` o _Evento_ `EVT`, para cada enlace en el objeto `_AEI`.  

El controlador ACPI, gestiona la lista de interrupciones GPIO y, evalua el _Extremo_,  
el _Nivel_, o el método de control de _Evento_ para él. El método de control desactiva  
el evento de hardware, si es necesario y, ejecuta el operador de notificación requerido  
en la fuente de evento del nodo en el espacio de nombres.  
Después, Windows envía la notificación al controlador de dispositivo. Pueden ser  
señalizados múltiples eventos, sobre el mismo recurso `GpioInt`,  si el método de  
control de evento puede consultar el hardware, para determinar el evento ocurrido.  
El método, debe entonces notificas al dispositivo correcto con el código de notificación  
apropiado.  

#### <a name="i8">Objeto de Evento de Información ACPI</a> ####


Tal y como se ha mencionado previamente, el espacio de nompres para el controlador GPIO  
debe contener el objeto `_AEI` para poder soportar los eventos ACPI. El objeto `_AEI`  
ver sección 5.6.5.2 en la especificación ACPI 5.0,  
