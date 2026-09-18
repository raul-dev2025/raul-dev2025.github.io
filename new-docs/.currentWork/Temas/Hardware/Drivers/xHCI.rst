1. Extensible Host Controller Interface
2. Objetivos.
3. Detalles

   - Soporte para todas las velocidades
   - Eficiencia energética
   - Soporte para la virtualización
   - Driver simplificado
   - Soporte para torrente(stream) de datos
   - Escalabilidad

4. Referencias y agradecimientos

Extensible Host Controller Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Es una especificación de interfase de computadora, que define un nivel
  de registros de
| descripción del controdalor para el *Universal Serial Bus(USB)*, el
  cuál es compatible con
| dispositivos USB, para las versiones v1.x, v2.0 y v3.x de la misma
  interfase(USB).

La especificación también es referida como *USB 3.0 host controller
specification*.

Objetivos.\_
^^^^^^^^^^^^

| El xHCI es una ruptura radical con respecto a previas generaciones del
  *USB host controller*
| En esencia, Open Host Controller Interface(OHCI), Universal Host
  Controller Interface(UHCI) y
| Enhanced Host Controller Interface(EHCI) en muchos casos.
| Los objetivos prinicipales de *xHCI*, son los siguientes:

- Operación eficiente: mejor *desarrollo* y *tiempo de espera o reposo*,
  que el controlador de
  host USB, de anteriores versiones.
- Un modelo de programación a nivel de dispositivo, consistente con el
  modelo de software para
  USB.
- Aunar la interfase presentada para el *controlador de host*, para los
  distintos protocolos
  USB, ya existentes.
- Minimizar el acceso a memoria del *host*; eliminándolos completamente,
  cuando el USB está
  en reposo(idle).
- Eliminar la escritura de registros y, minimizar la lectura de los
  mismos, para la
  transferencia normal de datos.
- Eliminar el modelo “*controlador compañero*\ (Companion Controller)”.
- Activar los modos *fail-over*, en situaciones de recursos de sistema
  *constringido?*, para
  que los dispositivos aún puedan ser accesibles, quzás con un
  comportamiento en cuanto a eficiencia y energía, reducido.
- Proporcionar la habilidad de distinguir las distintas capacidades del
  *hardware*, a
  diferentes mercados, ejem: coste/eficiencia en distintos mercados.
- Definición de una arquitectura extensible, capaz de proveer una ruta
  sencilla, para las
  nuevas tecnologías y especificaciones USB; tales como un mayor ancho
  de banda, medio óptico
  de transmisión, etc., sin necesidad de definir otra *interfase* para
  el *controlador* *de host USB*.

Detalles
^^^^^^^^

| **Soporte para todas las velocidades** Los controladores OHCI y UHCI,
  soportan únicamente la velocidad del dispositivo *USB v1*.
| EHCI la velocidad del dispositivo *USB v2*. Velocidades (1.5 Mbit/s y
  12 Mbit/s) y
| (480 Mbit/s) respectivamente.

| La arquitectura xHCI, fué diseñada para soportar todas las velocidades
  USB, incluída
| *“SuperSpeed”* (5 Gbit/s) y futuras mejoras, bajo la misma
  *pila(stack)* del controlador.

| **Eficiencia energética** Originalmente, el USB fue desarrollado en
  1995, con el propósito de trabajar en ordenadores
| de *sobre mesa*, dando lugar, a la proliferación de los distintos
  conectores, que aparecerían
| para *PCs* ejem. PS/2, puerto en serie, puerto en paralelo, Puerto
  juegos(GamePad), etc.

| En un principio, el consumo de energía del *controlador host*, no era
  una consideración
| importante. desde entonces, los móbiles se han convertido en la
  plataforma predilecta, y sus
| baterías, han hecho del consumo de energía, la consideración más
  importante.

| La infraestructura de los *controladores de host(OHCI, UHCI y EHCI)*
  fueron muy similares
| en cuanto al esquema, de la transaccaiones que debían lleverse a cabo
  en el USB, donde se
| construyen por software, en la memoria del host.

| El controlador de hardware, tenía que leer constantemente los
  esquemas, para determinar si
| las transacciones, debían ser conducidas, a través del USB, incluso
  sin tener que mover
| datos. Adicionalmente en el caso de lecturas desde el dispositivo, era
  consultado, incluso
| sin haber datos que leer.

- El *xHCI* elimina de la memoria del host, las transacciones del USB
  basadas en esquemas,
  evitando la actividad, en la memoria de host, cuando no hay movimiento
  de datos.
- El *xHCI* reduce la necedidad de consultar periódicamente al
  dispositivo, permitiendo
  notificar al *controlador host*, cuándo tiene datos disponibles para
  su lectura, y
  mueve la gestión de consultas en dispositivos USB v2.0 y v1.1, que
  usan interrupcion de
  transacciones, desde la CPU al *controlador USB host*.

| Los *controladores de host* EHCI, OHCI y UHCI, serían controlados
  automáticamente por la
| CPU, si no hay cambios que necesiten hacerse y, si ningún dispositivo
  tiene alguna
| interrupción que enviar. Pero todos ellos subyacen, en que la cpu,
  configure los esquemas
| de los controladores.

| Si algún dispositivo USB, haciendo uso de *transacción de
  interrupciones*, tiene datos que
| enviar, entonces el *controlador xHCI*, enviará una interrupción, para
  notificar a la CPU, que hay una *transacción de interrupción*, que
  necesita ser gestionada.

| Como la CPU, ya no tiene que gestionar la consulta del *bus USB*,
  podrá gastar más tiempo
| en *estados de baja energía*.

- El *xHCI* no necesita que las implementaciones, proporcionen soporte
  para *todas* las
  características avanzadas de gestión de energía en *USB v1 y v2*,
  incluidas *los estados*
  *USB 2 LPM, USB 3 U1 y U2*, HERD, LTM, *Function Wake(función
  levantar)*, etc. Pero estas características son necesarias par
  conseguir todas las ventajas de *xHCI*.

**Soporte para la virtualización**

| Anteriores USB HCI, exibieron algunas de las características que más
  tarde serían
| incorporadas a implementaciones posteriores. Éstas “primicias”, fueron
  aplicadas a entornos virtualizados. USB HCI legados, definen una
  relatívamente *simple* canalización
| de datos por *hardware*; donde el estado crítico relacionado al
  *sobrecoste* -en cuanto
| a la gestión del *bus*\ (acomodo del ancho de banda, asignación de
  direccionamiento, etc.),
| reside en el *software* del *HCD*.

| Intentar aplicar la técnica de virtualización por *hardware* (el
  estandar de entrada/salida),
| replicando la intefase de registros *I/O*, a USB HCI, es problemático
  por que los
| *estados críticos* que deben ser gestionados entre las máquinas
  virtuales(VMs) **no están**
| *disponible por hardware*

| El *xHCI* mueve el control de estos estados críticos dentro del
  *hardware*, activando
| la gestión de recursos *USB*, entre las *VMs*. La virtualización
  *xHCI* proporciona las
| características:

- Asignación directa de dispositivos USB individuales(con independencia
  de su localización
  respecto a la topología marcada en el BUS) a cualquier *VM*.
- Minimización del tiempo necesario, para la comunicación entre *VMs*.
- Soporte de dispositivos compartidos para *USB nativo*.
- soporte para *PCIe* *SR-IOV*.

..

   SR-IOV – raíz simple para la virtualización de I/O(single root I/O
   virtualization) HCI – Host Controller Infraestructure HCD – Host
   Controller Driver VM – Maquina Virtual(Virtual Machine)

**Driver simplificado**

| El *EHCI* utiliza los controladores *OHCI* o *UHCI* como “controlador
  compañero”, donde
| los dispositivos *USB v2* son controlados a través de la pila *EHCI*,
  y el puerto lógico
| de *EHCI* permite que la velocidad *baja/completa* en un dispositivo
  *USB*, pueda ser
| dirigida hacia un controlador de puerto -el *“compañero”*, tipo *OHCI*
  o *UHCI*.

| Por ejemplo, un *controlador de host ``de tarjeta`` PCIe*, para un
  *USB v2*, el cuál presenta
| 4 conectores *USB(estandar tipo A)*, es presentado ante el *software
  de sistema* como
| **un** *controlador de software de sistema* con 4 puertos tipos EHCI y
  **dos**, con 2 puertos
| tipo OHCI.

| Cuando un dispositivo USB de *alta velocidad*, es acoplado a cualquier
  de los 4 conectores,
| el dispositivo es gestionado por uno de los 4 puertos *hub* raíz, del
  controlador *EHCI*. Si un *dispositivo USB* de *baja/completa*
  velocidad, es acoplado al conector 1 o 2,
| será dirigido al puerto *hub* raíz, de uno de los controladores *OHCI*
  para su gestión y,
| un *dispositivo USB* de *baja/completa* velocidad acoplado al conector
  3 o 4, será dirigido
| al puerto *hub* raíz, del otro conector *OHCI*.

| La dependencia *EHCI*, sobre *controladores de host* separados, para
  *dispositivo USB*
| de velocidad *baja/completa*, resulta en complejas *dependencias e
  interacciones*, entre
| los controladores EHCI y OHCI/UHCI.

::

                        |--puerto-1 usb
       USB EHCI |--puerto-2 usb
                        |--puerto-3 usb
                        |--puerto-4 usb

       |------|
            HUB

                                       |--puerto-1 usb
                           crt-1   |--puerto-2 usb
       USB OHCI 
                           crt-2   |--puerto-3 usb
                                       |--puerto-4 usb

                       |-----|
                       HUB
                               

- El xHCI, elimina la necesisdad de *controladores compañeros* y su
  controlador de
  *pila* separado.
- La incorporación del *“esquema”*, la gestión del ancho de banda y, las
  funciones
  asignación de direccionamiento, que fueron antes realizadas por el
  controlador. Con
  el *hardware xHCI* se establece una *pila simple*, por software de
  baja latencia
  para el xHCI.

..

   **hub:** es una especie de interfase; referido a un nodo con gran
   cantidad de enlaces. **CRT:** Tubo de Rayos Catódicos, aquí
   abreviatura de *conector*.

**Soporte para torrente(stream) de datos**

| El soporte para los *streams*, fue añadido en la especificación
  “SuperSpeed”
| versión *USB v3.0(5 Gbit/s)*. Primeramente para permitir una mejor
  eficiencia en las
| operaciones de almacenamiento sobre USB.

| Históricamente, ha habido una relación de *uno a uno(1:1)* entre la
  *terminación(endpoint)*
| de un USB y su *almacén(buffer)* en memoria de sistema; el
  *controlador de host* únicamente
| es responsable de direccionar la transferencia de datos.

| Los *Streams* cambiaron éste *paradigma*, porporcionando una
  asociación *terminación*
| hacia el *almacén*\ (endpoint to buffer), y permitiendo al
  *controlador de host* de un
| dispositivo, a qué -o cuál, *almacén* dirigirse.

| La transferencia de datos de un USB, asociada a una terminación USB,
  de torrente de
| datos(USB stream point) y, presentado por el xCHI, de la misma forma
  que cualquier otra
| terminación es, en cualquier caso, los datos asociados del almacén,
  con una transferencia
| es determinados por el dispositvo.

- El soporte del *xHCI USB Stream*, permite almacenes de hasta 64K, ser
  asociados con
  una sóla terminación.
- El protocolo *xHCI USB Stream*, permite a un dispositivo USB,
  seleccionar el almacén, al que hacer la transferencia, cuando es
  presentada la terminación.

**Escalabilidad**

| El xHCI, fué diseñado para ser sólidamente adaptable, capaz de
  soportar de 1 a 255 dispositivos
| USB y, de 1 a 255 *puertos hub raíz*. Como a cada dispositivo USB, le
  es permitido definir
| hasta 31 terminaciones, un xHCI que soporte 255 dispositivos, tendrá
  que dar soporte a
| a un total de 7906 terminaciones, por separado.

| Consecuentemente, cada almacén de memoria, asociado a una terminación,
  es descrito por una
| *lista(cola, queue en inglés)* de bloques de memoria, donde cada
  *lista* requiere un punto
| de cabecera(head pointer), una longitud de cola de puntos(el extremo,
  the queue, the tail…)
| y otros registros que definan su estado.

| Hay muchas formas de definir el *estado de lista*\ (queue state),
  aunque si uno tuviese que
| asumir 32 bytes de espacio de registros, para cada lista, entonces
  casi 256KB de espacio
| de registro, sería necesario par dar soporte a las 7906 listas.

| Únicamente un pequeño numero de dispositivos USB, serán acoplados al
  mismo tiempo. Como
| media, un dispositivo USB, da soporte a 3-4 terminaciones, de las
  cuáles, sólo un
| subconjunto de ellas, estarán activas a la vez.

| El xHCI, mantiene el *estado de lista*, en la memoria del sistema como
  *contexto para la*
| *extructura de datos de terminaciones*. El contexto, está diseñado,
  para mantener una *caché*
| a ser accedida por el xHCI y, *paginado* como función de entrada y
  salida, para la actividad
| de la terminación.

| De esta forma, un *fabricate/desarrollador*, podrá escalar su própio
  *contexto de caché xHCI*
| y hacer coincidir su uso práctico, en todos sus productos; en lugar de
  limirlo(xHCI) a la *arquitectura* del própio producto. Es decir, el
  fabricante, en lugar de desarrollar
| nuevo *software* para cada producto, utilizará el mismo; y lo adaptará
  a distintos
| dispositivos, con una “maquinaria” similar.

| Idealmente, el *espacio interno de caché*, es seleccionado de tal
  forma, que bajo
| circunstancias de uso normales, no hay *contexto de paginación* en el
  xCHI. Iguamlente, la actividad de una *terminación USB*, tiende a ser
  reactiva -o a reaccionar.

| Esto significa, que en cualquier momento, un gran número de
  terminaciones, podrán estar
| preparadas, para mover datos; aunque únicamente un subconjunto de
  ellos, mueva datos de manera activa.

| Como ejemplo, la interrupción ``IN``, de la terminación de un ratón,
  podría transferir datos
| durante horas, si el usuario está lejos de su escritorio. Los
  algoritmos xHCI, específicos
| del fabricante, podrán detectar ésta situación y, hacer que la
  terminación candidata
| *deje de paginar*, si otra terminación está ocupada.

- | El xHCI, permite grandes *valores máximos*, para el número de
    dispositivos soportados;
  | puertos interrupciones, vectores, etc. Aunque una implementación,
    únicamente necesita
  | definir, aquellos que satisfagan los requisitos de *marketing*. Por
    ejemplo, un fabricante
  | podrá limitar el número de dispositivos USB, que soporta la
    implementación xHCI de una
  | *tablet*, a 16 dispositivos.

- | Un fabricante aún puede sacar más ventaja de las características
    xHCI, y escalar sus
  | recursos internos, para hacerlo coincidir, con un *modelo* de uso.
    Por ejemplo, si a través de pruebas de usabilidad, el fabricante
    determina que el 95% de los usuarios
  | de *tablets*, nunca conectan más de *cuatro (4)* dispositivos USB y,
    cada dispositivo
  | define 4 terminaciones -o menos, entonces el cacheado interno para
    16 contextos de
  | terminación, asegura que bajo circunstancias normales, no habrá
    actividad en la memoria
  | de sistema, debido al contexto de paginación.

..

   | **paradigma:** abstracción de una situación o modelo real -en la
     vida cotidiana, a un
   | entorno de programación.

   **Escalabilidad** que puede ser adaptado, para que funcione en
   distintas plataformas.

..

   \__caché:\__almacén oculto de cosas.

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[xHCI][https://en.wikipedia.org/wiki/Extensible_Host_Controller_Interface]
