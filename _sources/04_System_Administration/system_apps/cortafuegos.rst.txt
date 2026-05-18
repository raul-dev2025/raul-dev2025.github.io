¿Qué es un cortafuegos?
=======================

Un cortafuegos (también conocido como firewall) es un sistema de seguridad de red que monitorea y controla el tráfico de red entre redes, permitiendo o bloqueando el acceso a ciertos protocolos, puertos y direcciones IP.

Funciones principales
---------------------

* **Filtrado de tráfico**: El cortafuegos analiza el tráfico de red y decide qué paquetes de datos se permiten pasar y cuáles se bloquean.
* **Control de acceso**: El cortafuegos regula el acceso a la red, permitiendo o denegando el acceso a ciertos dispositivos o direcciones IP.
* **Protección contra amenazas**: El cortafuegos ayuda a proteger la red contra amenazas como ataques de denegación de servicio (DoS), ataques de inyección de código y malware.

Tipos de cortafuegos
--------------------


* **Cortafuegos de red**: Protege la red entera, filtrando el tráfico entre la red y el exterior.
* **Cortafuegos de host**: Protege un solo dispositivo o host, filtrando el tráfico entre el dispositivo y la red.
* **Cortafuegos de aplicación**: Protege una aplicación específica, filtrando el tráfico relacionado con esa aplicación.

**Beneficios**:

* **Mejora la seguridad**: El cortafuegos ayuda a prevenir ataques y vulnerabilidades en la red.
* **Controla el acceso**: El cortafuegos regula quién puede acceder a la red y qué recursos pueden utilizar.
* **Reduce el riesgo**: El cortafuegos reduce el riesgo de pérdida de datos y daños a la red.


Conceptos importantes para configurar reglas del cortafuegos en Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A continuación, se presentan algunos conceptos clave que es importante entender para configurar reglas del cortafuegos en Windows:

1. **Protocolos**: Los protocolos son los lenguajes que utilizan los dispositivos para comunicarse entre sí. Los protocolos más comunes son TCP (Transmission Control Protocol), UDP (User Datagram Protocol) y ICMP (Internet Control Message Protocol).
2. **Puertos**: Los puertos son números que identifican un proceso o servicio específico en un dispositivo. Los puertos se utilizan para dirigir el tráfico de red a la aplicación o servicio correcto.
3. **Direcciones IP**: Las direcciones IP son números únicos que identifican un dispositivo en una red. Las direcciones IP se pueden utilizar para permitir o bloquear el acceso a ciertos dispositivos.
4. **Máscaras de subred**: Las máscaras de subred se utilizan para definir la parte de la dirección IP que se utiliza para identificar la subred.
5. **Reglas de tráfico**: Las reglas de tráfico definen cómo se maneja el tráfico de red. Las reglas pueden ser de permitir o bloquear el acceso a ciertos protocolos, puertos o direcciones IP.
6. **Prioridad**: La prioridad se utiliza para determinar el orden en que se aplican las reglas del cortafuegos.
7. **Estado**: El estado se refiere al estado actual de la regla del cortafuegos. Las reglas pueden estar habilitadas o deshabilitadas.
8. **Acción**: La acción se refiere a lo que se hace con el tráfico de red que coincide con la regla. Las acciones comunes son permitir, bloquear o rechazar.
9. **Perfil**: El perfil se refiere al tipo de red en la que se aplica la regla del cortafuegos. Los perfiles comunes son dominio, privado y público.

Tipos de reglas del cortafuegos
-------------------------------

* **Reglas de entrada**: Reglas que controlan el tráfico de red que ingresa a la red.
* **Reglas de salida**: Reglas que controlan el tráfico de red que sale de la red.
* **Reglas de entrada y salida**: Reglas que controlan el tráfico de red en ambos sentidos.

Consideraciones importantes
~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **Seguridad**: Las reglas del cortafuegos deben ser configuradas de manera que se permita el acceso necesario a los recursos de la red, mientras se bloquea el acceso no autorizado.
* **Compatibilidad**: Las reglas del cortafuegos deben ser configuradas de manera que no interfieran con las aplicaciones y servicios que se ejecutan en la red.
* **Documentación**: Es importante documentar las reglas del cortafuegos para que se puedan entender y mantener fácilmente.

.. note

    Los conceptos descritos anteriormente, son perfectamente aplicables a cualquier sistema que utilice un cortafuegos. Ver página ``iptables, ufw y firewalld ``, para ver un resumen de las herramientas de cortafuego utilizadas en Linux. 
    Sería bueno enlazar aquí los manuales de RedHat...
