============================================================
Despliegue de Réplica FreeIPA y Sincronización de Directorio
============================================================

.. section-author:: Ingeniero de Documentación Técnica
.. date:: 2026-02-15

Objetivo Técnico
================

El objetivo principal de esta intervención ha sido la implementación de una **réplica de alta disponibilidad** del servidor FreeIPA (Identity Management) para la infraestructura de ``raulvilchez.org``. Se busca garantizar la redundancia de los servicios de autenticación Kerberos, el servidor de certificados (CA) y la resolución de nombres (DNS), asegurando que la **Global Password Policy** definida en el nodo maestro se replique correctamente.

Infraestructura de Red
----------------------

- **Maestro (idm):** 192.168.17.39
- **Réplica (idm-replica):** 192.168.17.40
- **Puerto crítico:** 636 (LDAPS)

Procedimiento de Configuración y Resolución
===========================================

1. Preparación del Entorno de Red (Hosts)
-----------------------------------------
Para evitar dependencias circulares del servicio DNS durante la fase crítica de instalación, se forzó la resolución estática en el archivo ``/etc/hosts`` de la réplica.

.. code-block:: bash

    sed -i '/idm/d' /etc/hosts
    echo "192.168.17.39 idm.raulvilchez.org idm" >> /etc/hosts
    echo "192.168.17.40 idm-replica.raulvilchez.org idm-replica" >> /etc/hosts

2. Sincronización de Tiempo (Kerberos)
--------------------------------------
Se verificó que el sesgo de tiempo entre el maestro y la réplica fuera de **0 segundos**, fundamental para la validación de tickets GSSAPI.

.. code-block:: bash

    # Verificación cruzada desde la réplica
    echo "Maestro: $(ssh root@idm.raulvilchez.org date)"; echo "Réplica: $(date)"

3. Limpieza de Topología en el Maestro
--------------------------------------
Para resolver conflictos de "Replication Agreement" existentes, se procedió a la eliminación forzosa de la topología previa en el nodo maestro.

.. code-block:: bash

    kinit admin
    ipa server-del idm-replica.raulvilchez.org --force

4. Ejecución del Instalador de Réplica
--------------------------------------
Se utilizó el comando de instalación con parámetros de fuerza para sobreescribir registros de host y omitir comprobaciones de conectividad DNS externas.

.. code-block:: bash

    read -sp "Contraseña de Admin: " IPA_PASS && echo "" && \
    ipa-replica-install \
      --principal admin \
      -w "$IPA_PASS" \
      --server idm.raulvilchez.org \
      --domain raulvilchez.org \
      --realm RAULVILCHEZ.ORG \
      --setup-ca \
      --setup-dns \
      --forwarder 8.8.8.8 \
      --skip-conncheck \
      --force-join

Justificación Técnica de Parámetros
===================================

- **--server idm.raulvilchez.org**: Se prefiere el FQDN para asegurar la coincidencia con el **Common Name (CN)** de los certificados RSA de 2048 bits validados.
- **--skip-conncheck**: Parámetro crítico para evitar que el instalador aborte si el registro DNS inverso (PTR) aún no está propagado en la zona ``17.168.192.in-addr.arpa``.
- **--force-join**: Necesario para reutilizar el objeto de host en el LDAP tras desinstalaciones incompletas que mantienen el *Keytab* original.
- **Certificados**: Se validó el uso de una cadena de confianza basada en **RSA con SHA-256** y una validez de 2 años (Feb 2026 - Feb 2028).

Verificación de Configuración
=============================

La validez del canal de comunicación se comprobó mediante el cliente OpenSSL, confirmando el protocolo **TLSv1.3** y el cifrado **TLS_AES_128_GCM_SHA256**.

.. code-block:: bash

    openssl s_client -connect idm.raulvilchez.org:636 -showcerts

El resultado exitoso de la prueba fue ``Verify return code: 0 (ok)``, garantizando que el Maestro está listo para la replicación de base de datos.