========================================================
Informe de Auditoría: Preparación de Réplica FreeIPA
========================================================

:Fecha: 2026-02-27
:Proyecto: Despliegue de Réplica ipa02.raulvilchez.org
:Estado: Listo para Instalación

Descripción
-----------
Este documento detalla las acciones correctivas aplicadas para resolver el fallo de autenticación SASL (Invalid Credentials) durante la promoción del servidor maestro ``ipa.raulvilchez.org`` hacia la réplica ``ipa02.raulvilchez.org``.

Hitos de Resolución
-------------------

1. Sincronización Temporal (Clock Skew)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Se detectó un desfase crítico que impedía la validación de tickets Kerberos.

* **Acción:** Sincronización forzada contra el maestro.
* **Comando:** ``chronyd -q 'server ipa.raulvilchez.org iburst'``
* **Estado:** OK (Verificado con ``chronyc sources``).

2. Consistencia DNS Inversa (PTR)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
El Maestro no podía resolver la IP de la réplica, invalidando el contexto GSSAPI.

* **Acción:** Creación del registro PTR en la zona inversa.
* **Comando:** ``ipa dnsrecord-add 17.168.192.in-addr.arpa. 40 --ptr-rec ipa02.raulvilchez.org.``
* **Estado:** OK (Verificado con ``host 192.168.17.40``).

3. Seguridad de Red (Firewall)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Los puertos críticos (389, 636, 88, 443) estaban cerrados en el Maestro.

* **Acción:** Apertura manual de puertos por protocolo.
* **Comando:** ``firewall-cmd --permanent --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,88/udp,464/tcp,464/udp}``
* **Estado:** OK (Verificado mediante túneles TCP desde la réplica).

4. Saneamiento de Identidad (Atomicidad)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Eliminación de residuos de instalaciones fallidas y desbloqueo de cuenta.

* **Comandos en Maestro:**
    - ``kinit admin``
    - ``ipa host-del ipa02.raulvilchez.org --updatedns``
    - ``ipa user-unlock admin``
* **Comandos en Réplica:**
    - ``./ipa-clean.sh``

Conclusión de Auditoría
-----------------------
Los cuatro pilares de FreeIPA (Red, Tiempo, DNS e Identidad) están validados. 
Se procede con el paso final de ejecución del script de réplica.