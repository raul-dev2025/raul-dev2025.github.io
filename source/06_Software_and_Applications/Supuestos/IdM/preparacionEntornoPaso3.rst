================================
Preparación del Entorno (Paso 3)
================================

:Fecha: 2026-02-24
:Servidor: ipa02.raulvilchez.org (Réplica)
:Maestro: ipa.raulvilchez.org
:Estado: Completado y Verificado

Descripción
-----------
Configuración de la identidad de red local y sincronización horaria persistente. Esta fase asegura que la réplica tenga una referencia de tiempo idéntica al maestro, requisito sine qua non para el funcionamiento de los tickets de Kerberos.

Acciones Realizadas
-------------------
1. **Identidad Local**: Configuración manual de resolución de nombres en ``/etc/hosts`` para garantizar la visibilidad mutua sin dependencia de DNS externos.
2. **Sincronización NTP**: Configuración de ``chronyd`` para actuar como cliente exclusivo del servidor maestro.
3. **Autorización de Red**: Apertura de puertos en el firewall para servicios de replicación y sincronización.
4. **Validación de Latido**: Verificación de conectividad UDP (puerto 123) y estado de sincronización (Reachability).

Comandos Utilizados
-------------------
.. code-block:: bash

    # Configuración de Identidad (Réplica)
    echo "192.168.17.39   ipa.raulvilchez.org ipa" >> /etc/hosts
    echo "192.168.17.40   ipa02.raulvilchez.org ipa02" >> /etc/hosts

    # Configuración de Tiempo (Réplica)
    # Editado /etc/chrony.conf: server ipa.raulvilchez.org iburst
    systemctl restart chronyd
    chronyc sources -v

    # Autorización en el Cortafuegos (Réplica)
    firewall-cmd --permanent --add-service={ntp,freeipa-replication,dns,http,https}
    firewall-cmd --reload

    # Verificación de conectividad (Bash-native)
    timeout 1 bash -c 'cat < /dev/null > /dev/udp/ipa.raulvilchez.org/123' && echo "Open"

Estado Final
------------
* **Chrony Status**: Sincronizado (^* ipa.raulvilchez.org).
* **Firewall Services**: cockpit, dhcpv6-client, dns, freeipa-replication, http, https, ntp, ssh.