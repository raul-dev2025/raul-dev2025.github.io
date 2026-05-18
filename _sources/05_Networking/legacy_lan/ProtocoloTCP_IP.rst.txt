Protocolo TCP/IP
================

Historia
--------
En la década de los '70, Vinton Cerf y Robert E. Kahn crearon el protocolo TCP/IP (Transmission Control Protocol/Internet Protocol) con el objetivo de proporcionar una capa de abstracción entre las aplicaciones de usuario y la infraestructura de red subyacente.

Fué el Departamento de defensa de los EEUU, quien encargó el desarrollo de un proyecto ambicioso, que terminaría por convertirse en *el estandard de facto*. 
Su implementación tuvo lugar en la red ARPANET, también conocida por ser la primera red de área ámplia(WAN), a su vez, desarrollada por DARPA(Departamento de Defensa de los Estados Unidos).

Buscaron una manera de comunicar computadoras de diferentes fabricantes, de forma fiable y reproducible. Consiguieron conectar *al mundo*, en una red global y sentaron las base de la comunicación entre máquinas distantes y dispares.


Funcionamiento
--------------

TCP/IP es un protocolo de comunicaciones de red que se utiliza para establecer conexiones de red confiables y seguras entre dispositivos en una red.

1. **Conexión**: Cuando un dispositivo desea establecer una conexión con otro dispositivo, envía un paquete de solicitud (SYN) al dispositivo de destino. Este paquete incluye información sobre la conexión, como el puerto de destino y la dirección IP.

2. **Aceptación**: El dispositivo de destino recibe el paquete de solicitud y, si está dispuesto a establecer la conexión, envía un paquete de aceptación (SYN-ACK) de vuelta al dispositivo original. Este paquete confirma la aceptación de la conexión y proporciona información sobre la conexión, como el puerto de origen y el puerto de destino.

3. **Establecimiento de la conexión**: Después de recibir el paquete de aceptación, el dispositivo original envía un paquete de confirmación (ACK) al dispositivo de destino para confirmar que ha recibido el paquete de aceptación. Esto completa el proceso de establecimiento de la conexión.

4. **Comunicación**: Una vez que la conexión está establecida, los dispositivos pueden enviar datos entre sí a través de la conexión. Los datos se envían en paquetes, que se dividen en segmentos para facilitar su transferencia a través de la red.

5. **Control de errores**: TCP/IP utiliza varios mecanismos para detectar y corregir errores en la transferencia de datos. Por ejemplo, los dispositivos envían paquetes de control, como los paquetes ACK, para confirmar la recepción de datos y los paquetes de retransmisión para reenviar datos perdidos.

6. **Cierre de la conexión**: Cuando un dispositivo desea cerrar la conexión, envía un paquete de cierre (FIN) al otro dispositivo. El otro dispositivo recibe el paquete de cierre y envía un paquete de confirmación (ACK) de vuelta para confirmar que ha recibido el paquete de cierre. Después de recibir el paquete ACK, el dispositivo original cierra la conexión.

En resumen, TCP/IP proporciona una conexión de red confiable y segura a través de la transferencia de datos segmentados y el control de errores. Esto permite una comunicación fiable entre dispositivos en una red.


Versiones
---------

TCP/IP es un conjunto de protocolos de comunicaciones de red que ha evolucionado a lo largo del tiempo. Aquí hay un breve resumen de las principales versiones de TCP/IP:

1. **TCP/IP versión 4 (IPv4)**: Esta es la versión más antigua y ampliamente utilizada de TCP/IP. Utiliza direcciones IP de 32 bits para identificar dispositivos en una red. IPv4 es el estándar actualmente utilizado en la mayoría de las redes.

2. **TCP/IP versión 6 (IPv6)**: Esta versión de TCP/IP fue diseñada para solucionar los problemas de escala y direcciones limitadas de IPv4. Utiliza direcciones IP de 128 bits para proporcionar una mayor cantidad de direcciones únicas. IPv6 también introduce nuevas características, como la capacidad de encapsular tráfico IPv6 dentro de tráfico IPv4.

3. **TCP Selectivo (SCTP)**: SCTP es un protocolo de transporte que proporciona características adicionales a TCP, como la capacidad de establecer múltiples conexiones simultáneas sobre una única conexión de red. SCTP es ampliamente utilizado en aplicaciones de comunicaciones en tiempo real, como la transmisión de video y audio.

4. **TCP con QoS (Quality of Service)**: Este es un conjunto de extensiones de TCP que permite proporcionar diferentes niveles de calidad de servicio a diferentes tipos de tráfico en una red. Esto es especialmente útil en redes donde se requiere garantizar un rendimiento específico para ciertos tipos de tráfico, como la transmisión de video en alta resolución.

5. **TCP con DCCP (DCCP - Datagram Congestion Control Protocol)**: DCCP es un protocolo de transporte que permite la transferencia de datos en forma de datagramas, en lugar de segmentos, como lo hace TCP. DCCP es útil en aplicaciones donde se requiere un control de congestion más preciso, como en la transferencia de datos multimedia.

Estas son solo algunas de las versiones principales de TCP/IP. Cada una de ellas introduce características y mejoras en relación con la transferencia de datos en redes.
