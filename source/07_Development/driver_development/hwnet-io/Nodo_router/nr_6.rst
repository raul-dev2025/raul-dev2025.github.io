=============================================================
``dnsmasq`` convierte al router-node en un Router Físico Real
=============================================================

.. admonition:: Rflexión   

   Como la idea es dedicar el nodo-router a eso; un router, la opción de instalar el paquete ``dnsmasq``, nos permitirá configurar ampliamente, los requisitos que necesitemos cumplir. Pero dnsmasq *es un servidor dns/dhcp local...*. 
   
   El nodo-router debe operar como si fuese un router de verdad, solo que al tener un sisteema operativo, debería ser aún más capaz que cualquier router convencional. A todos los efectos la vm "nodo-router" debe comportarse como un router físico.
   
   Lo que nos lleva a preguntarnos, es eso lo que necesitamos?


Que ``dnsmasq`` sea ligero no significa que sea un servicio "solo para VMs"; de hecho, **la inmensa mayoría de los routers físicos del mercado** (desde routers domésticos TP-Link, ASUS o Netgear con firmware propietario, hasta sistemas profesionales integrados como OpenWrt, DD-WRT o PfSense) utilizan ``dnsmasq`` internamente como su motor de DHCP y DNS local.

-----

Por qué lo convierte en un Router Físico Real
=============================================

1. **Arquitectura Estándar de la Industria:**
En un router comercial, la CPU interna ejecuta un kernel de Linux y utiliza ``dnsmasq`` para escuchar en las interfaces LAN, repartir direcciones por DHCP y ofrecer resolución DNS hacia la WAN. Al usar ``dnsmasq`` en el ``router-node``, estamos replicando exactamente la pila de software de un router real.
2. **Capacidades de un Router Profesional Avanzado:**
Al operar sobre un sistema operativo completo (Rocky Linux en el ``router-node``), tenemos la potencia de ``dnsmasq`` unida a la flexibilidad del Kernel de Linux:
* **Servidor DHCP dinámico multi-clase:** Configuración de rangos para Clases A, B, C, D, E bajo demanda.
* **Control de leases y tiempos:** Tiempos de asignación extremadamente cortos (ej. 10m) para probar la re-negociación del driver ``hwnet-io`` cuando la IP expira o rotan los paquetes.
* **Opciones DHCP personalizadas (RFC 2132):** Inyección de parámetros de red específicos (Option 3 para Default Gateway, Option 6 para DNS, Option 121 para rutas estáticas) que un router físico real enviaría al cliente Sandbox.
* **Servidor DNS Local / Transitivo:** ``dnsmasq`` puede actuar como DNS caché/forwarder enviando las peticiones DNS del Sandbox hacia el exterior (a través de ``enp1s0`` ⟶ ``192.168.17.1``), resolviendo la falta de DNS que observamos en los logs previos.


Configuración Base Objetivo para ``dnsmasq`` (Clase C)
======================================================

Para que el ``router-node`` empiece a actuar inmediatamente como el router del usuario sobre la interfaz de pruebas ``enp9s0``:

1. **Interfaz de escucha:** Vincular ``dnsmasq`` exclusivamente a ``enp9s0`` (aislando por completo la red de control ``enp1s0``).
2. **Pool de Direcciones Clase C:** Rango ``192.168.100.10`` a ``192.168.100.200`` con máscara ``/24`` y tiempo de concesión de 10 minutos.
3. **Anuncio de Gateway y DNS:** Declarar ``192.168.100.1`` (``router-node``) como la puerta de enlace predeterminada y el servidor DNS para la LAN de pruebas.