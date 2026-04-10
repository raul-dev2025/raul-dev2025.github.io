1. `Arquitectura <#i1>`__

   - `Controlador de dispositivo <#i1i1>`__
   - `Controlador de eventos <#i1i2>`__

2. `Uso simple <#i2>`__
3. `Descripción detallada <#i3>`__

   - `evdev <#i3i1>`__
   - `Teclado <#i3i2>`__
   - `mousedev <#i3i3>`__
   - `joydev <#i3i4>`__
   - `Controladores de dispositivo <#i3i5>`__
   - `Interfase genérica de eventos de entrada - HID <#i3i6>`__
   - `usbmouse <#i3i7>`__
   - `usbkbd <#i3i8>`__
   - `psmouse <#i3i9>`__
   - `atkkbd <#i3i10>`__
   - `iforce <#i3i11>`__

4. `Verificando que funciona <#i4>`__
5. `Interfase de eventos <#i5>`__
6. `Referencias y agradecimientos <#i6>`__

--------------

#### Arquitectura

| Los subsistemas de entrada, son una colección de controladores
  disñados para
| dar soporte a todos los dispositivos de entrada, bajo el *SO Linux*.
  Muchos de los
| controladores se encuentran en ``drivers/input``, también podrían
  encontrarse bajo
| los directorios ``drivers/hid`` y ``drivers/platform``.

| El centro del *subsistema de entrada*, es el modulo ``input`` , el
  cuál debe ser
| cargado antes que cualquier otro módulo -hace las veces de *camino de
  entrada*,
| para las comunicaciones *entre dos grupos* de módulos.

\ **Controladores de dispositivo**\ 

| Éstos módulos *hablan* con el *hardware* -por ejemplo vía USB, y
  proporciona los
| eventos -pulsación de teclas, eventos de ratón; al módulo *input*.

\ **Controlador de eventos**\ 

| Éstos módulos toman los *eventos* desde el *centro de entrada “input
  core”* y
| los pasa al kernel, cundo es necesario, por medio de distintas
  *interfases*
| -pulsación de teclas , eventos de ratón, una interfase PS/2 simulada
  al
| *GPM* y *“X”* etc.

Uso simple
^^^^^^^^^^

| Para las configuraciones más habituales, con un ratón USB y, un
  teclado USB, se
| tendrán que cargar los siguientes módulos(o contruirlos como parte del
  kernel).

::

       input  
       mousedev  
       usbcore  
       uhci_hcd or ohci_hcd or ehci_hcd  
       usbhid  
       hid_generic  

| Después de esto, el teclado USB, funcionará *como debe* y, el ratón,
  estará
| disponible como dispositivo de carácteres: *mayor 13 y, menor 63*.

::

       crw-r--r--   1 root     root      13,  63 Mar 28 22:45 mice
       

| Éste dispositivo es normalmente creado automáticamente por el sistema.
  Los
| comandos para crearlos:

::

       cd /dev
       mkdir input
       mknod input/mice c 13 63

| Después de esto, se debe apuntar *GPM* y, *XFree* al dispositivo
  -arriba creado,
| para poder hacer uso de él.

::

       gpm -t ps2 -m /dev/input/mice
       

… para las *Xs:*

::

       Section "Pointer"
             Protocol    "ImPS/2"
             Device      "/dev/input/mice"
             ZAxisMapping 4 5
       EndSection

Cuando se haga lo descrito arriba podrá utilizarse ratón y teclado USB.

      GPM: herramienta modo de texto del ratón,\ *copiar y pegar*.

Descripción detallada
^^^^^^^^^^^^^^^^^^^^^

**controlador de eventos**

| Los controladores de eventos distribuyen los eventos desde los
  dispositivos al espacio
| de usuario y, a los *usuarios del kernel*, cuando sea necesario.

\ **evdev**\ 

| ``evdev`` es una interfase genérica para eventos de entrada. Se
  encarga de *traspasar*
| los eventos generados en el *kernel* directamente a los programas,
  junto a sus marcas
| de tiempo.
| Los códigos de eventos, son los mismos en todas las plataformas
  independiente de
| hardware.

| Ésta es la interfase preferida para el *espacio de usuario* para
  consumar las entradas
| de usuario, y a todos los clientes, se anima que hagan uso de ésta.
| Ver ``event-interface``.

Los dispositivos están en ``/dev/input``:

::

       crw-r--r--   1 root     root      13,  64 Apr  1 10:49 event0
       crw-r--r--   1 root     root      13,  65 Apr  1 10:50 event1
       crw-r--r--   1 root     root      13,  66 Apr  1 10:50 event2
       crw-r--r--   1 root     root      13,  67 Apr  1 10:50 event3

| Hay dos rangos de *menores*: *64 hasta 95* es el *rango estático*
  legado. Si hubiesen
| más de 32 dispositivos de entrada en un sistema, ``evdev`` crearía
  nodos adicionales,
| cuyos *menores* empezariam desde 256.

\ **Teclado**\ 

| El controlador de entrada de teclado es parte del *kernel* y del
  código VT. Interpreta
| las pulsaciones de tecla y controla las entradas de usuario para
  *cónsolas VT*.

      **VT:** virtual terminal

\ **mousedev**\ 

| Es una *trampa(hack)* hecha para que los programas legados, que hacen
  uso de las
| entradas de ratón, puedan funcionar. Toman eventos tanto del ratón
  como de
| *digitadores/tablets* y, permiten que dispositivos del tipo PS/2,
  estén disponibles
| en el espacio de usuario.

Los dispositibos tipo *Mousedev* en ``/dev/input`` son:

::

       crw-r--r--   1 root     root      13,  32 Mar 28 22:45 mouse0  
       crw-r--r--   1 root     root      13,  33 Mar 29 00:41 mouse1  
       crw-r--r--   1 root     root      13,  34 Mar 29 00:41 mouse2  
       crw-r--r--   1 root     root      13,  35 Apr  1 10:50 mouse3  
       ...
       ...
       crw-r--r--   1 root     root      13,  62 Apr  1 10:50 mouse30  
       crw-r--r--   1 root     root      13,  63 Apr  1 10:50 mice  

| Cada dispositivo ``mouse`` es asignado a un único ratón o *digitador*,
  excepto el último,
| ``mice``. Éste único dispositivo *literal* es compartido por todos los
  ratones y
| digitadores, e incluso si no hay ninguno conectado, es presentado el
  dispositivo.
| Ésto es útil para conectar en *caliente* dispositivos USB. Así,
  antiguos programas
| que no soportan conexión en *caliente*, puedan abrir el dispositivo
  incluso cuando no
| hay ratón presente.

| ``CONFIG_INPUT_MOUSEDEV_SCREEN_[XY]`` en la configuración del
  *kernel*, represesnta el
| tamaño de la pantalla(en pixels) en XFree86. Esto es necesario si se
  quiere hacer uso
| de un digitador en *X*, por que su movimiento es enviado a *X* por
  medio de un ratón
| PS/2, necesitando ser *escalado* adecuadamente.

| *Mousedev* generará protocolos, tanto PS/2, ImPS/2 (Microsoft
  IntelliMouse) como
| ExplorerPS/2 (IntelliMouse Explorer), dependiendo de lo que necesite
  leer el programa.
| Puede configurarse GPM y X, a cualquiera de ellos. Es necesario
  configurar ImPS/2, si
| va a hacerse uso de la rueda del ratón y, ExplorerPS/2, para usar (más
  de 5) botones
| extra.

   | **digitador** se utiliza un término genérico, para referirse a
     dispositivo donde
   | la pantalla, es en ambos casos, dispositivo de entrada y salida
     -teclado o ratón y
   | monitor, respectivamente.
   | **Las Xs:** Referido al servidor gráfico de Linux *Xorg.org*.
   | **X:** en un eje de coordenadas, la variable horizontal.

\ **joydev**

| ``joydev`` implementa las versiones *v0.x* y *v1.x* de la API de Linux
  para joystic. Ver
| ``joystic.api`` para más detalles.

Tan pronto como es conectado el *joystic*, podrá ser accedido desde
``/dev/input``:

::

       crw-r--r--   1 root     root      13,   0 Apr  1 10:50 js0  
       crw-r--r--   1 root     root      13,   1 Apr  1 10:50 js1  
       crw-r--r--   1 root     root      13,   2 Apr  1 10:50 js2  
       crw-r--r--   1 root     root      13,   3 Apr  1 10:50 js3  
       ...  

| … así, hasta ``js31``, en un rango legado y, *menores* adicionales por
  encima de ``256``
| si fuesen necesarios más dispositivos.

   **menores:** ver input-misNotas.md

\ **Controladores de dispositivo**\ 

Son módulos que generan eventos.

\ **Interfase genérica, de eventos de entrada - HID**\ 

| La *interfase* ``hid-generic``, es una de las más grandes y complejas
  de todo el *paquete*.
| Controla todos los dispositivos *HID*, y puesto que hay una gran
  variedad de ellas y,
| la *especificación HID USB*, no es nada simple, necesita ser, así de
  grande.

| En estos momentos, controla, el ratón, los *joystics*, *gamepads,
  steering wheels*
| *kbd*, *trackballs, y digitadores*.

| Aunque el USB también usa el HID, para el control de monitores,
  altavoces, UPS, LCD y,
| muchos otros.

| Los controles del monitor y altavoces, deberían ser fáciles de añadir
  a la interfase
| de entrada HID. Sin embargo, no tiene mucho sentido, por ésto, fué
  diseñada la
| interfase ``hiddev``. Ver documentaciónm
  ``Documentation/hid/hiddev.txt``, para más *info*.

| El *uso* del módulo ``usbhid`` es muy sencillo, no toma parámetros,
  detecta cualquier
| cosa automáticamente y, cuando un dispositivo HID, es insertado, lo
  detecta de forma
| apropiada.

| Dado que los dispositivos varían *inténsamente(wildly)*, se podría
  esperar tener un
| dispositivo que no funcionase. En ese caso, podría definirse
  ``#define DEBUG``, al
| principio de ``hid-core.c``, y mandar el resultado a *Vojtech Pavlik*
  vojtech@ucw.cz
| quien se presta, amigablemente a recoger las *trazas de log*.

      | **joystic:** es quizás una de esas excepciones, a palabras que
        no haya que
      | traducir…
      | ``joy``–juego/juguete, ``stick``–palo: *palo de juego*.

..

      | **HID:** Human Interface Device, toma eventos de entrada(INPUTS)
        y devuelve
      | salidas(OUTPUTS) .[hardware/hid]:[hid.md].

\ **usbmouse**\ 

| Para sistemas embebidos, para ratones con descriptores *HID* rotos, y
  paraqualquier
| otro uso, cuando el enorme ``usbhid``, no seería una buena opción. Es
  entonces, el
| controlador ``usbmouse`` una buena opción.
| Únicamente controla los ratones USB. Usa un protocolo simple, *HIDBP*.
  Significa esto
| también, que debe soportar dicho protocolo. No todos -los
  controladores, lo hacen.
| Pero si no se tiene una “poderosa” razón para usarlo, ``usbhid``, es
  mejor alternativa.

\ **usbkbd**\ 

| Con éste controlador, ocurre algo similar a ``usbmouse``, el módulo,
  se comunica con el
| teclado, por medio de un protocolo simplificado; *HIDBP*. Es más
  pequeño, y no soporta
| *teclas especiales*. usbhid\`, es mejor alternativa.

\ **psmouse**\ 

| Éste controlador es para aquellos dispositivos que apuntan al uso del
  protocolo PS/2,
| incluidos *Synaptics* y *ALPS touchpads, Intellimouse*, *dispositivos
  Explorer*,
| *ratones Logitech PS/2* , etc.

\ **atkbd**\ 

Es un controlador para teclados PS/2(AT).

\ **iforce**\ 

| Controlador para *volantes y joystics I-Force*, ambos sobre USB Y
  RS232.
| Ahora esto incluye *Force Feedback* e incluso Immersion Corp;
  considérese un “secreto”
| y espere oir hablar de él.

Verificando que funciona
^^^^^^^^^^^^^^^^^^^^^^^^

| Pulsar un par de teclas en el teclado, debería considerarse suficiente
  para comprobar
| que funciona y, que está correctamente conectado al controlador de
  teclado del kernel.

| Hacer un ``cat /dev/input/mouse0`` verificará que el ratón está
  funcionando; aparecerán
| *carácteres* si se mueve.

| Puede provarse la emulación del joystick con la utilidad ``jstest``,
  disponible el
| paquete de *joystick*. Ver ``joystick-doc``.

Los eventos utilizan la aplicación ``evtest`` para ser probados.

Interfase de eventos
^^^^^^^^^^^^^^^^^^^^

| Podrán usarse lecturas bloqueantes y no bloqueantes y, la función
  ``select()`` en
| dispositivos ``/dev/input/eventX``, y siempre se tendrá *el completo*
  de eventos de
| entrada sobre lectura. La plantilla es la siguiente:

::

       struct input_event {
           struct timeval time;
           unsigned short type;
           unsigned short code;
           unsigned int value;
       };

| ``time`` es la marca de tiempo, devuelve el tiempo en el que sucedió
  el evento.
| ``type`` es -por ejemplo, ``EV_REL``, para el momento relativo,
  ``EV_KEY`` para pulsaciones
| de teclas o *soltar tecla(to release)*. Hay más tipos definidos en
| ``include/uapi/linux/input-event-codes.h``.

| ``code`` es el código de evento. Por ejemplo, *REL_X o KEY_BACKSPACE*,
  de nuevo, la lista
| completa en ``include/uapi/linux/input-event-codes.h``.

| ``value`` es el valor que acarrea evento. Tanto el *cambio relativo*
  para ``EV_REL`` como
| el *absolumto* ``EV_KEY`` al soltar, 1 para pulsaciones y 2 para
  autorepetir.

Ver ``input-event-codes``, para más información sobre distintos códigos.

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Documentación del sistema operativo Linux.
| Referencia al documento ``input.rst``.
