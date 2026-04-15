Vamos a empezar un proyecto para poner en marcha un IdM. Ahora mismo el servidor maestro, esta en funcionamiento en una VM con rocy10, antes de hacer nada deberemos ver si podemos aprovecar de este servidor los datos:


Estos son los datos del proyecto:



Diseño de Infraestructura IdM: raulvilchez.org (Sincronización Rocky 9)
=======================================================================


:Autor: Raul Vilchez
:Fecha: 2026-02-21
:Estado: Borrador Final
:Entorno: Virtualización Híbrida (KVM y Synology VMM)

Resumen General
---------------

Este documento describe las especificaciones técnicas para un entorno sincronizado de FreeIPA (IdM). Para garantizar la estabilidad de la replicación y la paridad criptográfica, tanto el nodo Maestro como la Réplica se ejecutarán sobre Rocky Linux 9.

Entidades de Red y Mapeo de IPs
-------------------------------

La siguiente tabla define los servicios principales y su ubicación en la red.

+------------------+-----------------------------+-----------------+---------------------------------+
| Servicio / Host  |            FQDN             |  Dirección IP   |      Infraestructura / SO       |
+==================+=============================+=================+=================================+
| Maestro IPA      | idm.raulvilchez.org         | 192.168.17.39   | VM (KVM/QEMU) en Host Rocky 10  |
+------------------+-----------------------------+-----------------+---------------------------------+
| Réplica IPA      | idm-replica.raulvilchez.org | Por determinar  | VM (Synology VMM) en NAS        |
+------------------+-----------------------------+-----------------+---------------------------------+
| Almacenamiento   | nas.raulvilchez.org         | 192.168.17.38   | Physical Synology NAS           |
+------------------+-----------------------------+-----------------+---------------------------------+
| Web Externa      | raulvilchez.org             | GitHub Pages    | Namecheap (DNS Público)         |
+------------------+-----------------------------+-----------------+---------------------------------+
| Documentación    | docs.raulvilchez.org        | GitHub Pages    | CNAME (DNS Público)             |
+------------------+-----------------------------+-----------------+---------------------------------+

Núcleo de Dominio y Autenticación
---------------------------------

    **Dominio**: raulvilchez.org

    **Reino Kerberos**: RAULVILCHEZ.ORG

    **Usuario Administrador**: admin

    **Política de Seguridad**: Directiva de contraseñas global (ya definida en ``global_policy``).

    **Gestión de Credenciales**: Recuperación automatizada mediante ``/tmp/pwdRoom`` para despliegues desatendidos.

Estrategia de Arquitectura
--------------------------

1. Simetría de SO (La "Regla Rocky 9")
Ambas máquinas virtuales serán provistas con **Rocky Linux 9**. Esto evita las diferencias estrictas de OpenSSL 3.x y las sub-políticas criptográficas que suelen romper la replicación entre versiones mayores de la familia RHEL (por ejemplo, intentar sincronizar la versión 10 con la 9).


2. Capa de Virtualización
~~~~~~~~~~~~~~~~~~~~~~~~~

* **Nodo Maestro:** Se ejecuta en una Workstation usando QEMU/KVM. Aunque el *host* es Rocky 10, el *guest* será Rocky 9.
* **Nodo Réplica:** Se ejecuta en Synology Virtual Machine Manager (VMM). El invitado también será Rocky 9.


3. Interoperabilidad de DNS
~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **Público:** Namecheap gestiona el dominio raíz y el CNAME ``docs`` para GitHub Pages.
* **Interno:** El Maestro IPA (192.168.17.39) actuará como DNS autoritativo para la LAN, gestionando los registros SRV requeridos para el descubrimiento de Kerberos y LDAP.


Modelo de Script de Implementación
----------------------------------

El despliegue de la réplica seguirá el modelo de inyección segura establecido:

.. code-block:: bash

   read -sp "Contraseña de Admin: " IPA_PASS && echo ""
   # O automatizado: IPA_PASS=$(cat /tmp/pwdRoom)

   ipa-replica-install \
     --server idm.raulvilchez.org \
     --domain raulvilchez.org \
     --realm RAULVILCHEZ.ORG \
     --hostname idm-replica.raulvilchez.org \
     --password "$IPA_PASS" \
     --setup-ca \
     --setup-dns \
     --mkhomedir \
     --no-ntp \
     --unattended