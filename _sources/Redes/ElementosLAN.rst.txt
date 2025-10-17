Elementos de una red de área local
==================================

Características y funciones
---------------------------

- Estaciones de trabajo y servidores; se trata de los dispositivos que sirven a la comunicación y determinarán el tipo de información a transmitir.
- Sistemas operativos; Es un conjunto de aplicaciones esenciales que permiten el aprovechamiento de los recursos de hardware, la máquina. A groso modo podría dividirse en dos partes; el Kernel y las aplicaciones de usuario. 
- Canal de comunicacion; medio por el que circula la información.
- Adaptadores de red; convierten las señales eléctricas utilizadas por los terminales, al formato utilizado por las redes de comunicación (señales eléctricas, ondas de radio, etc.).
- Elementos de interconexión; son elementos *intermedios* que interconectan los terminales de la red. Ayudan a determinar el mejor camino en la transmisión de los datos.

Estaciones de trabajo
---------------------
Una estación de trabajo es un ordenador (PC, portátil, etc.) conectado a la red que es utilizado por un usuario final para realizar sus tareas. Actúa como un cliente que solicita y consume recursos y servicios proporcionados por los servidores de la red.

1. **Actua como un terminal**: utilizado por el usuario para iniciar peticiones, como navegar en una *web*, enviar un correo electrónico o recibir datos.
2. **Correr aplicaciones**: ejecuta el software que requiere de conectividad para su kfuncionamiento.
3. **Consume recursos**: accede a los servicios y a los datos proporcionados por otras computadoras en la red; servidores principalmente -como servidores de archivo, de páginas web o servidores de impresión.

Servidores
----------
Un servidor es un ordenador de alto rendimiento que proporciona servicios, datos y recursos a otros dispositivos de la red, conocidos como clientes (que suelen ser las estaciones de trabajo). A diferencia de una estación de trabajo, que es utilizada por un usuario para consumir recursos, un servidor está diseñado para gestionar, almacenar y distribuir información de forma centralizada y responder a las peticiones de múltiples clientes.

Algunos ejemplos de servidores:

- Servidor web, hospeda páginas y aplicaciones web.
- Servidores de archivo; almacena y gestiona archivos y carpetas compartidas.
- Servidores de impresora; gestiona los trabajos de impresión, enviados por las impresoras en red.
- Servidores de base de datos; gestiona y proporciona acceso a una o más basees de datos.
- Servidores DHCP; Asigna automáticamente direcciones IP, a los dispositivos de la red.


Tarjetas de red
---------------
Una tarjeta de red, también conocida como NIC (del inglés *Network Interface Card*) o adaptador de red, es el componente de hardware que conecta un ordenador a una red informática. Actúa como la interfaz física entre el ordenador y el medio de transmisión.

Su función principal es preparar, enviar y controlar los datos en la red. Para ello, convierte los datos digitales del ordenador en señales eléctricas, pulsos de luz u ondas de radio que pueden ser transmitidas por el medio correspondiente.

Cada tarjeta de red tiene una dirección **MAC (Media Access Control)** única, que es un identificador físico de 48 bits asignado por el fabricante. Esta dirección se utiliza para identificar de forma inequívoca a un dispositivo dentro de una red local.


Equipos de conectividad
-----------------------
Son utilizados para conectar los equipos y seleccionar el camino por el que circulará la información. Se trata de dispositivos especializados en tareas específicas. La siguiente es una lista no exahustiva, de dispositivos utilizados en la configuración física de una red.

- **Repetidores (Repeaters)**: Operan en la capa 1 (Física). Su función es regenerar la señal de red para extender la distancia a la que puede viajar. No interpretan los datos, solo amplifican y retransmiten la señal.
- **Concentradores (Hubs)**: También de capa 1. Es un punto central que conecta varios dispositivos. Cuando recibe datos por un puerto, los retransmite a todos los demás puertos, lo que genera tráfico innecesario y reduce el rendimiento. Han sido reemplazados por los switches.
- **Puentes (Bridges)**: Operan en la capa 2 (Enlace de Datos). Conectan dos segmentos de red y filtran el tráfico basándose en las direcciones MAC. Solo reenvían los datos al otro segmento si el destinatario se encuentra allí, reduciendo colisiones. Un switch es, en esencia, un puente con muchos puertos.
- **Conmutadores (Switches)**: Son el pilar de las redes LAN modernas y operan en la capa 2. A diferencia de un hub, un switch aprende la dirección MAC de los dispositivos conectados a cada uno de sus puertos y envía los datos únicamente al puerto del destinatario. Esto mejora drásticamente la eficiencia y la seguridad de la red.
- **Encaminadores (Routers)**: Operan en la capa 3 (Red). Su función principal es interconectar redes distintas (por ejemplo, una LAN con Internet). Toman decisiones de enrutamiento basadas en direcciones IP para determinar el mejor camino que deben seguir los paquetes de datos.
- **Pasarelas (Gateways)**: Es un dispositivo que actúa como punto de entrada y salida entre dos redes, a menudo con protocolos diferentes. Un router es un tipo de gateway, pero el término es más amplio y puede incluir dispositivos que realizan traducción de protocolos a niveles superiores.
- **Dispositivos inalámbricos**: El más común es el **Punto de Acceso Inalámbrico (Access Point o AP)**. Permite que los dispositivos con capacidad Wi-Fi se conecten a una red cableada, actuando como un puente entre el medio inalámbrico y el cableado.


Sistemas operativos de red
--------------------------
En la actualidad, todos los dispositivos, desde ordenadores de sobremesa hasta móviles, utilizan sistemas operativos en red. Estos sistemas operativos permiten la conexión a la red y son fundamentales en la era del Internet de las cosas (IoT), donde la conectividad es esencial.

Los sistemas operativos basados en UNIX, como Linux, han sido concebidos desde un primer momento para trabajar en red. Linux, en particular, se ha consolidado como el sistema operativo más utilizado en entornos de servidor. Esta característica de trabajar en red es clave para garantizar la estabilidad y la fiabilidad de los sistemas.

El trabajo colaborativo es fundamental para el rápido y constante desarrollo del código en el mundo empresarial. El código está siempre disponible y se puede revisar por múltiples grupos de trabajo. Esto contribuye a mejorar la calidad del código y a garantizar su mantenimiento a largo del tiempo.

En resumen, los sistemas operativos de red son esenciales en la actualidad. Los sistemas operativos basados en UNIX, como Linux, se han adaptado a las necesidades del mundo actual, especialmente en cuanto a la conectividad en red y el trabajo colaborativo. Estas características han contribuido a su éxito en entornos de servidor y en el desarrollo de software


Medios de transmisión
---------------------
Los medios de transmisión constituyen el canal físico o inalámbrico a través del cual viajan los datos entre los dispositivos de una red. Son el soporte que permite el envío de bits de un punto a otro. Se dividen principalmente en dos categorías: medios guiados y medios no guiados.

Medios Guiados (Cableados)
~~~~~~~~~~~~~~~~~~~~~~~~~~
- **Cable de Par Trenzado (Twisted Pair):** Es el medio más común en redes LAN (Ethernet). Consiste en pares de hilos de cobre trenzados para reducir la interferencia electromagnética. Existen variantes como UTP (sin apantallar) y STP (apantallado).
- **Cable Coaxial:** Similar al cable de antena de TV, consta de un núcleo de cobre rodeado por un aislante, una malla metálica y una cubierta exterior. Fue muy popular en las primeras redes, pero ha sido mayormente reemplazado por el par trenzado y la fibra óptica.
- **Fibra Óptica:** Utiliza pulsos de luz para transmitir datos a través de hilos de vidrio o plástico. Ofrece velocidades muy altas, gran ancho de banda, mayor distancia y es inmune a las interferencias electromagnéticas. Es el medio preferido para conexiones troncales y de alta velocidad.

Medios no Guiados (Inalámbricos)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- **Ondas de Radio (Wi-Fi):** Utilizan ondas de radiofrecuencia para transmitir datos por el aire. Es la tecnología detrás de las redes WLAN (Wireless Local Area Network), permitiendo la conexión sin necesidad de cables.
- **Infrarrojos:** Utilizan ondas de luz infrarroja para la comunicación a corta distancia y sin obstáculos (requieren línea de visión directa). Su uso en redes es limitado, siendo más común en mandos a distancia.
- **Microondas:** Se utilizan para enlaces de larga distancia, tanto terrestres (entre antenas) como por satélite.


Los números IP
--------------
Los números IP tienen como función principal conectar una máquina a una red. Aunque también cumplen otro propósito; el de identificar un equipo. De manera que en una misma red no puede haber dos equipos con el mismo número IP.

La versión IPv4 configura los números dividiéndolos en cuatro octetos. Siendo cada octeto un número entre 0 y 255. Esto es, 2^8=256. Decimos que son doscientos cincuenta y seis números, pero empezamos a contar desde cero.
De forma que nunca vemos expresado en un octeto el número 256; *su parte literal*. 

Son cuatro octetos, por lo que el número que se utiliza para conectar la máquina a la red es significativamente más grande que 256. Es en realidad 2^32=4.294.967.296. Que son *cuatro mil millones largos* de números. Para hacerlo humanamente legible, se divide en cuatro partes a las que llamamos octetos.

Conversión decimal a binario
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
El sistema decimal utiliza diez cifras para representar un número, (1, 2, 3, 4, 5, 6, 7, 8, 9, 0). por esta razón se le llama sistema decimal. El sistema binario en cambio, utiliza dos cifras el cero y el uno (0, 1).
A continuación se presenta una técnica, para convertir los números decimales en binarios. 

2^32=4294 967 296
2^24=16 777 216
2^16=65 536
2^8=256
2^7=128
2^6=64
2^5=32
2^4=16
2^3=8
2^2=4
2^1=2
2^0=1

Imaginemos que pudiesemos posicionar cada una de las cifras del número binario que constituye un octeto, de manera que fuese posible *encender* o *apagar* el bit.

128 64 32 16 8 4 2 1 
 0  0  0  0  0 0 0 0 <--todos apagados(0).

128 64 32 16 8 4 2 1 
 1  1  1  1  1 1 1 1 <--todos encendidos(255).

De esta forma, encendiendo o apagando convenientemente la cifra asociada a su posicion, podremos configurar cualquier número en el rango del octeto o en sus doscientas cincuenta y seis posibilidades(0-255).

Por ejemplo, se convertirá el número 211 en su formato binario. Para ello empezamos por posicionar los bits del octeto, en una cadena o lista de números decimales separados por espacio.

   128 64 32 16 8 4 2 1

A continuación se sumarán las cifras de la cadena hasta conseguir el número buscado, en este caso el 211. Cada vez que la suma de las cifras decimales se acerquen al número buscado sin pasarse, encenderemos el bit(1) y lo apagaremos, cuando suceda lo contrario(0). 


.. code-block:: bash  
   
   128 64 32 16 8 4 2 1
    1  1
   128+64=192 -> encendemos los dos primeros bits
   
   
   128 64 32 16 8 4 2 1
    1  1  0
   192+32=224 -> apagamos el tercer bit por que se pasa(224 > 211).
   
   
   128 64 32 16 8 4 2 1
    1  1  0  1
   192+16=208 -> encendemos el cuarto bit(208 < 211).
   

   128 64 32 16 8 4 2 1
    1  1  0  1  0
   208+8=216 -> apagamos el quinto bit(216 > 211).
   

   128 64 32 16 8 4 2 1
    1  1  0  1  0 0
   208+4=212 -> apagamos el sexto bit(212 > 211).


   128 64 32 16 8 4 2 1
    1  1  0  1  0 0 1
   208+2=210 -> encendemos el septimo bit(210 < 211).


   128 64 32 16 8 4 2 1
    1  1  0  1  0 0 1 1
   210+1=211 -> encendemos el octavo bit(211 = 211).


Máscara de subred
-----------------
Se refiere a un conjunto de bits en la dirección de una subred que determinan el rango de direcciones IP que pertenecen a esa subred.

La máscara de subred se utiliza para dividir una dirección IP en dos partes: la parte de la subred y la parte de host. La parte de la subred define el rango de direcciones IP que pertenecen a la subred, mientras que la parte de host define las direcciones IP individuales que se pueden utilizar dentro de esa subred.

La máscara de subred se representa como una dirección IP con un número fijo de bits establecidos en 1, seguido por un número fijo de bits establecidos en 0. Por ejemplo, si se utiliza una máscara de subred de /24, significa que los primeros 24 bits de la dirección IP son los bits de la subred, mientras que los siguientes 8 bits son los bits de host.

La máscara de subred se utiliza en la configuración de routers y en la asignación de direcciones IP en redes locales. Permite determinar qué direcciones IP pertenecen a la subred actual y qué direcciones IP están en otras subredes.


.. tip::

   La notación CIDR ``/24`` representa los tres primeros octetos asignados a la red. Lo máximo que podría asignarse sería ``/32`` bits; está claro que entonces no podríamos asignar ningún número IP a ninguna máquina porque todas los números IP estarían destinados a identificar la red.


loopback
--------
El loopback 127.0.0.1 es una dirección IP especial que se utiliza para dirigirse a sí mismo. Es conocida como "dirección IP loopback" o "dirección IP de red local". Esta dirección IP se utiliza para realizar pruebas y comunicaciones locales dentro del mismo equipo o máquina.

Cuando se envía un paquete de red a la dirección IP 127.0.0.1, el software de red del equipo lo captura y lo envía de nuevo a la misma máquina, lo que permite realizar pruebas y comprobar la funcionalidad del software de red.

Es importante tener en cuenta que el loopback 127.0.0.1 no se puede utilizar para comunicarse con otros equipos en una red externa. Es específicamente utilizado para comunicaciones locales dentro del mismo equipo.
