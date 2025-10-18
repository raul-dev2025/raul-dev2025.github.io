Redes
=====

Podría definirse como un conjunto de dispositivos interconectados entre sí; un mecanismo que permite la comunicación entre dos o más computadoras.

Clasificación
-------------

- LAN (Local Area Network)
- MAN (Metropolitan Area Network)
- WAN (Wide Area Network)
- IN (Internet)

Características
---------------

- **Terminales**: son los equipos que se comunican entre si; ordenadores, teléfonos, etc.
- **Dispositivos**: son el conjunto de elementos físicos que facilitan la comunicación entre el dispositivo emisor y receptor.

    - *Canal de comunicación*: medio por el que circula la información.
    - *Elementos de interconexión*: interconectan los terminales de la red. Se encargan también de determinar la mejor ruta por la que circulará la información.
    - *Adaptadores de red*: su función principal es convertir el formato de los datos utilizado por los terminales, en el formato que utilizará la red de comunicación; habitualmente señales eléctricas u ondas de radio.
    - *Programas de red*: son un conjunto de aplicaciones destinadas a facilitar la gestión de la red.

Arquitectura de Red
-------------------

La arquitectura de red se refiere al diseño de una red de comunicaciones. Es un marco que define cómo se organizan los componentes físicos y lógicos de la red, sus principios operativos y los servicios que ofrece.

Existen dos modelos principales de arquitectura de red:

- **Cliente-Servidor**: En este modelo, un equipo central (el servidor) proporciona recursos y servicios a otros equipos (los clientes). Es el modelo más común en redes empresariales, ya que permite una gestión centralizada de la seguridad y los datos.
- **Peer-to-Peer (P2P)**: En este modelo, todos los equipos tienen el mismo estatus y pueden actuar tanto como cliente como servidor, compartiendo recursos directamente entre ellos. Es común en redes pequeñas o para compartir archivos.

Podrían ser definidas tres características esenciales:
   - Topología: se encarga de organizar el cableado y define la configuración básica de las conexiones entre equipos o dispositivos.
   - Método de acceso a la red: cuando el medio de comunicación es compartido, los dispositivos deben ponerse de acuerdo para transmitir, ya que no pueden hacerlo al mismo tiempo. Este método define las reglas para compartir el medio. Los más comunes son:

      - **CSMA/CD (Acceso Múltiple con Detección de Portadora y Detección de Colisiones)**: Usado en redes Ethernet cableadas. Un equipo "escucha" el medio antes de transmitir. Si está libre, envía los datos. Si dos equipos envían a la vez, se produce una colisión. Ambos se detienen, esperan un tiempo aleatorio y vuelven a intentarlo.
      - **CSMA/CA (Acceso Múltiple con Detección de Portadora y Prevención de Colisiones)**: Usado en redes inalámbricas (Wi-Fi). Es similar al anterior, pero intenta *evitar* las colisiones en lugar de detectarlas, ya que en el aire es más complejo. Antes de transmitir, el equipo puede enviar una señal para "reservar" el canal.
      - **Paso de testigo (Token Passing)**: Usado en redes como Token Ring. Un paquete especial llamado "testigo" (token) circula por la red. Solo el dispositivo que posee el testigo tiene permiso para transmitir. Una vez que termina, pasa el testigo al siguiente dispositivo.

   - Protocolos de comunicaciones: es el conjunto de reglas y procedimientos utilizados con el objeto de llevar a cabo la comunicación.


Topologías básicas
~~~~~~~~~~~~~~~~~~

   - **Malla (Mesh)**: Cada dispositivo está conectado a todos los demás. Ofrece alta redundancia y fiabilidad, pero es costosa y compleja de instalar y gestionar.
   - **Estrella (Star)**: Todos los dispositivos se conectan a un nodo central (como un switch o hub). Es fácil de administrar y añadir nuevos equipos. Su principal desventaja es que si el nodo central falla, toda la red se cae. Es la topología más común en redes LAN.
   - **Árbol (Tree)**: Es una combinación de la topología de bus y estrella. Los nodos están conectados en forma de árbol, con un nodo raíz y ramas. Permite un crecimiento escalonado de la red.
   - **Anillo (Ring)**: Los dispositivos se conectan en una configuración circular. Los datos viajan en una sola dirección a través del anillo, pasando por cada dispositivo hasta llegar a su destino. Si un dispositivo o cable falla, puede interrumpir toda la red (a menos que sea un doble anillo).
   - **Intersección de anillo**: Se refiere a la conexión de dos o más topologías de anillo a través de un dispositivo común, creando una red más grande y compleja.
   - **Bus**: Todos los dispositivos comparten un único canal de comunicación (el "bus"). Es una topología simple y económica, pero si el cable principal falla, toda la red deja de funcionar. Además, el rendimiento disminuye a medida que se añaden más dispositivos.
   - **Irregular o Híbrida**: Combina dos o más topologías diferentes para formar una red más grande y compleja. Por ejemplo, conectar varias redes en estrella a una troncal de bus.

Protocolos
----------
Son un conjunto de normas o reglas, utilizadas para coordinar el funcionamiento de los distintos componentes que conforman la red.

- **Encaminamiento**: se encarga de determinar la mejor ruta por la que circulará la información.
- **Direccionamiento**: se encarga de identificar los dispositivos de la red y asignarles un identificador único.
- **Acceso al medio**: se encarga de transmitir la información por el medio de comunicación.
- **Saturación del receptor**: se encarga de detectar y evitar la saturación del receptor.
- **Mantenimiento del orden**: consiste en un mecanismo que permite ordenar los mensajes en el destino; por ejemplo al numerar los fragmentos.
- **control de flujo**: se encarga de controlar el flujo de datos entre los dispositivos de la red.
- **control de errores**: se encarga de detectar y corregir errores en la información transmitida.
- **Multiplexación**: se encarga de compartir el medio de comunicación entre varios dispositivos.

- TCP (Transmission Control Protocol).
- UDP (User Datagram Protocol).
- ICMP (Internet Control Message Protocol).


Números de IPs
--------------

Las IPs se identifican en octetos, cada octeto contiene 8 bits.

.. code:: bash
   
   :linenos:

   2^8 = 256
   x.x.x.x
   2^32 = 4,294,967,296


Máscara de subred
-----------------

La máscara de subred es un conjunto de bits que se utiliza para identificar la porción de red y la porción de host en una dirección IP, permitiendo la creación de subredes dentro de una red más grande.

255.255.255.0

El número de cuatro octetos se organiza de la siguiente manera:
El primer octeto (255) se utiliza para la parte de red.
El segundo octeto (255) se utiliza para la parte de subred.
Los dos  ú ltimos octetos (255.0) se utilizan para la parte de host.

Para limitar el número de máquinas configurables en una red, puedes ajustar la máscara de subred. La máscara determina cuántas direcciones IP están disponibles para los hosts.

Por ejemplo, la máscara 255.255.128.0 (o /17 en notación CIDR) permite 32,766 direcciones de host (2¹⁵ - 2, restando la dirección de red y broadcast).

**¿Cómo funciona?**

Cuantos más bits pongas en 255 (o en 1 en binario), menos hosts podrás tener.
Ejemplo:
255.255.255.0 (/24) → 254 hosts
255.255.255.128 (/25) → 126 hosts
255.255.255.192 (/26) → 62 hosts
¿Cómo elegir la máscara?

Calcula cuántas máquinas necesitas.
Elige una máscara que permita ese número de hosts (usa la fórmula: 2ⁿ - 2, donde n = bits para hosts).
Ejemplo:
Si quieres máximo 30 máquinas:

2⁵ = 32 → 32-2 = 30 hosts
Máscara: 255.255.255.224 (/27)
Resumen:
Ajusta la máscara de subred para limitar el número de máquinas configurables en la red.


notación CIDR y notación de máscara de subred
---------------------------------------------

La notación de máscara de subred y la notación CIDR son dos formas diferentes de representar la cantidad de direcciones de host disponibles en una subred. 

La notación de máscara de subred es una forma más tradicional de representar una subred. En esta notación, la máscara de subred se expresa como un número de cuatro octetos en formato de punto decimal (por ejemplo, 255.255.255.0). Los bits de la máscara que son '1' representan la porción de la red, y los bits que son '0' representan la porción del host.

Por ejemplo, la máscara de subred 255.255.255.0 indica que los primeros tres octetos de la dirección IP son parte de la subred, mientras que el último octeto representa las direcciones de host. Esto significa que hay 256 direcciones de host disponibles en esta subred (2⁸ - 2, restando la dirección de red y broadcast).

La notación CIDR, por otro lado, es una forma más concisa de representar una subred. En esta notación, la máscara de subred se expresa como una combinación de un número y una barra ("/"). El número indica cuántos bits de la dirección IP son parte de la subred, mientras que la barra separa el número de la dirección IP. 

Por ejemplo, la máscara CIDR /17 indica que los primeros 17 bits de la dirección IP son parte de la subred. Esto significa que hay 32,766 direcciones de host disponibles en esta subred (2¹⁵ - 2, restando la dirección de red y broadcast). 

En resumen, tanto la notación de máscara de subred como la notación CIDR se utilizan para representar la cantidad de direcciones de host disponibles en una subred. La notación de máscara de subred es más tradicional y utiliza un número de cuatro octetos en formato de punto decimal, mientras que la notación CIDR es más concisa y utiliza un número y una barra para representar la cantidad de bits de la dirección IP que son parte de la subred.


Netbios
-------
NETBIOS (Network Basic Input/Output System) es un protocolo de red utilizado en sistemas Windows para facilitar la comunicación entre dispositivos en una red local. Proporciona una forma de identificar y comunicarse con otros dispositivos en la red, como computadoras, impresoras, servidores y dispositivos de red.

NETBIOS se utiliza principalmente para proporcionar servicios básicos de red, como el nombre de host, el nombre de usuario y la contraseña, la autenticación, el registro de nombres y la comunicación de datos. Permite a los usuarios acceder a recursos en la red, como archivos, impresoras y servicios de red, utilizando nombres de host y nombres de red.

Aunque NETBIOS es ampliamente utilizado en redes locales, también se utiliza en redes virtuales y en la comunicación entre dispositivos remotos a través de Internet. Sin embargo, en la actualidad, se recomienda el uso de protocolos más seguros y eficientes, como SMB (Server Message Block), que es una evolución de NETBIOS.

Samba
-----
Samba es un software de código abierto que implementa el protocolo SMB (Server Message Block), que es una evolución de NETBIOS. SMB es un protocolo de red utilizado para proporcionar servicios básicos de red, como el acceso a archivos, impresoras y servicios de red.

Samba permite a los sistemas operativos basados en Unix, como Linux y macOS, compartir recursos con sistemas operativos Windows. Proporciona una forma de compartir archivos y impresoras entre diferentes sistemas operativos y facilita la integración de equipos de diferentes plataformas en una red.

Con Samba, los usuarios pueden acceder a recursos compartidos en una red, como directorios, archivos y impresoras, utilizando nombres de host y nombres de red. También permite la autenticación de usuarios y la gestión de permisos para controlar el acceso a los recursos compartidos.

En resumen, Samba es una herramienta fundamental para la interoperabilidad entre sistemas operativos Windows y Unix, permitiendo compartir recursos y servicios de red de manera segura y eficiente.

Appeltalk
---------
AppleTalk es un protocolo de red desarrollado por Apple para su sistema operativo Macintosh. Proporciona una forma de comunicación entre dispositivos de Apple en una red local.

AppleTalk permite a los dispositivos Macintosh compartir recursos, como archivos, impresoras y servicios de red, utilizando nombres de host y nombres de red. También proporciona funcionalidades adicionales, como la capacidad de enviar mensajes entre usuarios de la red y la gestión de direcciones IP.

Además de ser utilizado en redes locales, AppleTalk también puede ser utilizado para la comunicación entre dispositivos de Apple a través de Internet utilizando el protocolo AppleTalk over IP (ATPIP).

Aunque AppleTalk es ampliamente utilizado en redes de Apple, también se puede utilizar en entornos heterogéneos, donde se integra con otros protocolos de red, como TCP/IP. Sin embargo, en la actualidad, se recomienda el uso de protocolos más ampliamente utilizados y compatibles con múltiples plataformas, como TCP/IP y DNS.

En resumen, AppleTalk es un protocolo de red específico de Apple utilizado para compartir recursos y servicios en redes locales de Macintosh, y también puede ser utilizado para la comunicación entre dispositivos de Apple a través de Internet.


Comités de estandardización
---------------------------

ITU
~~~
La Unión Internacional de Telecomunicaciones (ITU) es una organización intergubernamental que se encarga de establecer estándares para la comunicación y la información en el mundo.

ISO
~~~
La Organización Internacional para la Estandarización (ISO) es una organización no gubernamental que se encarga de establecer estándares para una amplia gama de temas, incluyendo la comunicación y la información.

ANSI
~~~~
El Instituto Nacional Estadounidense (ANSI) es una organización no gubernamental de los Estados Unidos que se encarga de promover la creación de estándares para la comunicación y la información en el país.

IEEE
~~~~
El Instituto de Ingenieros Eléctricos y Electrónicos (IEEE) es una organización profesional no gubernamental que se encarga de promover la creación de estándares para la comunicación y la información en el mundo.

IETF
~~~~
La Internet Engineering Task Force (IETF) es una organización no gubernamental que se encarga de promover la creación de estándares para la comunicación y la información en la Internet.

ISC
~~~
El Comité de los Sistemas de Nombres de Dominio (ISC) es una organización no gubernamental que se encarga de administrar el sistema de nombres de dominio en la Internet.

ICANN
~~~~~
La Corporación para la Asignación de Nombres y Números en la Internet (ICANN) es una organización no gubernamental que se encarga de administrar el sistema de nombres de dominio en la Internet.

W3C
~~~
El Consorcio Mundial de la Web (W3C) es una organización no gubernamental que se encarga de promover la creación de estándares para la comunicación y la información en la Web.

Open Group
~~~~~~~~~~
El Grupo Abierto es una organización no gubernamental que se encarga de promover la creación de estándares para la comunicación y la información en el mundo.

-----

Ethernet
--------
Ethernet es un protocolo de red de área local (LAN) ampliamente utilizado para conectar dispositivos en una red local. Fue desarrollado por Xerox y Digital Equipment Corporation (DEC) y se basa en el estándar IEEE 802.3.

Ethernet proporciona una forma de conectar dispositivos en una red utilizando cables de cobre y conectores RJ-45. Permite la transmisión de datos en forma de paquetes a través de una red local, utilizando una arquitectura de capas y protocolos específicos.

Ethernet utiliza el protocolo de enrutamiento Ethernet para enviar paquetes de datos a través de la red. Los dispositivos en una red Ethernet se conectan a un switch o a un conmutador, que actúa como intermediario para enrutar los paquetes de datos entre los dispositivos.

Ethernet también soporta diferentes velocidades de transmisión, como 10 Mbps, 100 Mbps y 1 Gbps, lo que permite adaptarse a las necesidades de velocidad de la red.

En resumen, Ethernet es un protocolo de red de área local ampliamente utilizado para conectar dispositivos en una red local, permitiendo la transmisión de datos a través de cables de cobre. Proporciona una forma eficiente y confiable de conectar dispositivos en una red local, con velocidades de transmisión variadas.

802.3
~~~~~
El estándar 802.3 es un estándar de la IEEE (Instituto de Ingenieros Eléctricos y Electrónicos) que define las especificaciones técnicas para la implementación de redes de área local (LAN) utilizando tecnología Ethernet.

El estándar 802.3 se divide en varias versiones, cada una con sus propias especificaciones y capacidades de transmisión. Algunas de las versiones más comunes del estándar 802.3 son:

- 802.3-1985: Esta es la primera versión del estándar 802.3 y define la especificación para redes Ethernet de 10 Mbps utilizando cableado de pare de pares (twisted pair) de tipo A y B.
- 802.3u-1998: Esta versión del estándar define la especificación para redes Ethernet de 100 Mbps utilizando cableado de pare de pares (twisted pair) de tipo A, B y C, así como fibra óptica.
- 802.3ab-1999: Esta versión del estándar define la especificación para redes Ethernet de 1000 Mbps utilizando cableado de pare de pares (twisted pair) de tipo A, B y C, así como fibra óptica.
- 802.3ae-2002: Esta versión del estándar define la especificación para redes Ethernet de 10 Gbps utilizando fibra óptica.
- 802.3an-2006: Esta versión del estándar define la especificación para redes Ethernet de 1000 Mbps utilizando cableado de pare de pares (twisted pair) de tipo A, B y C, así como fibra óptica, con una distancia máxima de 100 metros.
El estándar 802.3 también define las especificaciones para los dispositivos de red, como switches, hubs, y adaptadores de red. Además, define las especificaciones para los cables y conectores utilizados en las redes Ethernet.

En resumen, el estándar 802.3 define las especificaciones técnicas para la implementación de redes de área local (LAN) utilizando tecnología Ethernet, con capacidades de transmisión que van desde 10 Mbps hasta 10 Gbps, utilizando diferentes tipos de cableado y dispositivos de red.


FDDI
----
FDDI (Fiber Distributed Data Interface) es un protocolo de red de área local (LAN) que utiliza cables de fibra óptica para la transmisión de datos. Fue desarrollado en la década de 1980 y se utilizó principalmente en redes de alta velocidad.

FDDI utiliza cables de fibra óptica para conectar dispositivos en una red, lo que permite una transmisión de datos más rápida y segura que la transmisión a través de cables de cobre. FDDI puede alcanzar velocidades de transmisión de hasta 100 Mbps, lo que lo convierte en una opción adecuada para redes de gran tamaño y alto tráfico.

FDDI utiliza un enfoque de anillo de transmisión, donde los datos se envían en un bucle continuo a través de la red. Los dispositivos en una red FDDI se conectan a un conmutador o a un switch FDDI, que actúa como intermediario para enrutar los datos a través de la red.

Aunque FDDI fue ampliamente utilizado en la década de 1990, en la actualidad ha sido desplazado por otros protocolos de red de alta velocidad, como Gigabit Ethernet y Fibra Óptica. Sin embargo, FDDI sigue siendo utilizado en algunas redes antiguas o en situaciones específicas donde se requieren velocidades de transmisión más altas.

En resumen, FDDI es un protocolo de red de área local que utiliza cables de fibra óptica para la transmisión de datos en redes de alta velocidad. Fue ampliamente utilizado en la década de 1990, pero ha sido desplazado por otros protocolos de red más modernos.

Trama Ethernet
--------------
La trama Ethernet es el formato de datos utilizado en la capa de enlace de datos del modelo OSI para la transmisión de datos a través de una red Ethernet. La trama Ethernet, también conocida como frame, está compuesta por varios campos que proporcionan información adicional para la transmisión y recepción de datos.


La trama Ethernet es el formato de datos utilizado en la capa de enlace de datos del modelo OSI para la transmisión de datos a través de una red Ethernet. La trama Ethernet, también conocida como frame, está compuesta por varios campos que proporcionan información adicional para la transmisión y recepción de datos.

La trama Ethernet (específicamente Ethernet II) está compuesta por los siguientes campos:

1. Preambulo: Un conjunto de bits predefinidos que se utilizan para sincronizar los relojes de las máquinas transmisoras y receptoras.
2. Destino: Un campo que contiene la dirección MAC (dirección física) de destino del paquete.
3. Fuente: Un campo que contiene la dirección MAC de origen del paquete.
4. Tipo: Un campo que indica el tipo de datos que se están transmitiendo (por ejemplo, datos, control, etc.).
5. Longitud del cuerpo: Un campo que indica la longitud en bytes del cuerpo de datos.
6. Cuerpo: Un campo que contiene los datos que se están transmitiendo.
7. CRC: Un campo que contiene un código de redundancia cíclica (CRC) que se utiliza para detectar errores en la transmisión.
8. Fin del frame: Un campo que indica el final del paquete.

La trama Ethernet es utilizada en redes Ethernet y en la capa de enlace de datos del modelo OSI.

En esencia, la trama Ethernet está compuesta por cuatro campos fundamentales; las direcciones MAC de los equipos de origen y destino, un relleno que asegura una longitud fija, y un código de redundancia cíclica (CRC) que se utiliza para detectar errores en la transmisión.


modelo OSI
----------
