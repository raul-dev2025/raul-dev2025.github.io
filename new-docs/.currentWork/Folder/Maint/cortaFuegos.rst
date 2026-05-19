==========================================================
Informe de Configuración de Firewall: Topología FreeIPA
==========================================================

:Proyecto: Replicación de Identity Management (IdM)
:Entorno: raulvilchez.org
:Maestro: idm.raulvilchez.org (192.168.17.38)
:Réplica: ipa-replica.raulvilchez.org (192.168.17.39)

Introducción
------------

Este documento detalla las medidas de seguridad y apertura de puertos aplicadas en los firewalls de ambos nodos para permitir la correcta sincronización de LDAP, Kerberos y la Autoridad de Certificación (CA).

Estado de los Servicios
-----------------------

Ambos nodos deben permitir el tráfico bidireccional en los puertos estándar de FreeIPA. Se ha verificado que la comunicación no solo es cliente-servidor, sino de peer-to-peer para la replicación.

Configuración del Maestro (idm.raulvilchez.org)
----------------------------------------------

En el servidor principal (Rocky 9), se ha validado que el servicio ``firewalld`` tenga habilitado el perfil de FreeIPA.

**Comandos aplicados:**

.. code-block:: bash

   # Apertura de puertos mediante servicio predefinido
   sudo firewall-cmd --permanent --add-service=freeipa-ldap
   sudo firewall-cmd --permanent --add-service=freeipa-ldaps
   sudo firewall-cmd --permanent --add-service=freeipa-replication
   
   # Recarga de configuración
   sudo firewall-cmd --reload

Configuración de la Réplica (ipa-replica.raulvilchez.org)
--------------------------------------------------------

Para la imagen de Rocky 9 que se desplegará en el Synology VMM, es crítico asegurar que el cortafuegos permita la entrada desde el Maestro para las actualizaciones de la base de datos LDAP.

**Puertos Críticos Requeridos:**

+-----------+----------+-----------------------+---------------------------------------+
| Puerto    | Protocolo| Servicio              | Función                               |
+===========+==========+=======================+=======================================+
| 389, 636  | TCP      | LDAP / LDAPS          | Sincronización de base de datos       |
+-----------+----------+-----------------------+---------------------------------------+
| 88, 464   | TCP/UDP  | Kerberos / KPASSWD    | Autenticación y cambio de contraseñas |
+-----------+----------+-----------------------+---------------------------------------+
| 80, 443   | TCP      | HTTP / HTTPS          | Gestión Web y API de certificados     |
+-----------+----------+-----------------------+---------------------------------------+
| 53        | TCP/UDP  | DNS                   | Resolución de registros SRV           |
+-----------+----------+-----------------------+---------------------------------------+
| 123       | UDP      | NTP                   | Sincronización horaria (Crítico)      |
+-----------+----------+-----------------------+---------------------------------------+

Medidas de Red Complementarias
------------------------------

1. **Resolución DNS Local**:
   Se ha configurado la réplica para apuntar al Maestro como DNS primario. Sin esto, el firewall podría estar abierto pero el servicio fallará al no encontrar los punteros de Kerberos.

2. **MTU y Fragmentación**:
   Dado que la comunicación viaja a través de un vSwitch en el NAS (vSwitch-TX201), se ha verificado que no haya bloqueos de paquetes ICMP que impidan la negociación de MTU.

Consideraciones de Seguridad
----------------------------

* Se recomienda mantener el servicio ``firewalld`` activo y no optar por deshabilitarlo, utilizando siempre las zonas específicas de confianza para la red ``192.168.17.0/24``.
* El uso de SELinux debe permanecer en modo ``Enforcing``, ya que FreeIPA define sus propias políticas de puertos.

.. note::
   Cualquier cambio en la topología de red en el Synology VMM (vSwitch) debe replicar estas aperturas para evitar el error "Master is not reachable".

==========================================================
Informe Actualizado de Firewall: Topología FreeIPA
==========================================================

:Estado: Revisado y Ampliado
:Nodos: Maestro (192.168.17.38) y Réplica (192.168.17.39)

Introducción
------------

Tras revisar la configuración, se ha determinado que para garantizar la replicación entre el Maestro y la Réplica en el Synology VMM, es necesario aplicar una política de apertura explícita tanto por **servicios** como por **puertos específicos**. Esto previene fallos de resolución en el tráfico UDP y en la negociación de tickets Kerberos.

Configuración de Seguridad Reforzada
------------------------------------

Se ha aplicado (o se aplicará en la nueva instancia) el siguiente bloque de comandos para asegurar la conectividad total. Esta medida es crítica debido a que el instalador de la réplica realiza validaciones de red extremadamente estrictas antes de iniciar la copia del esquema LDAP.

**Comandos de Apertura Total:**

.. code-block:: bash

   # 1. Apertura por servicios integrales
   sudo firewall-cmd --permanent --add-service={dns,freeipa-ldap,freeipa-ldaps,http,https,kerberos,kpasswd,ntp,freeipa-replication}

   # 2. Apertura explícita de puertos (Redundancia de seguridad)
   # Incluye TCP/UDP para Kerberos (88), Kpasswd (464) y DNS (53)
   sudo firewall-cmd --permanent --add-port={88/tcp,88/udp,464/tcp,464/udp,389/tcp,636/tcp,53/tcp,53/udp,443/tcp}

   # 3. Aplicación de cambios
   sudo firewall-cmd --reload

Análisis de Relevancia
----------------------

* **Puertos 88 y 464 (UDP):** Cruciales para la velocidad de autenticación. Sin la apertura explícita UDP, el proceso de replicación puede sufrir "timeouts" en el Celeron.
* **Puerto 53 (TCP/UDP):** La réplica actúa como servidor DNS secundario; la transferencia de zona (AXFR) requiere TCP, mientras que las consultas estándar usan UDP.
* **Puerto 443:** Necesario para la comunicación con la API de la Autoridad de Certificación (Dogtag PKI).

.. warning::
   La omisión de la apertura explícita de puertos UDP suele ser la causa principal del error "Pre-check failed" durante la ejecución de ``ipa-replica-install``.

Conclusión de Medidas
---------------------

La configuración ahora es redundante y robusta. Se garantiza que el flujo de datos entre el Maestro en Rocky 9 y la futura Réplica no encontrará obstáculos en la capa de transporte, independientemente de si el servicio predefinido de firewalld está actualizado o no.