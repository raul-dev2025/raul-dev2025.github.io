============================================================
Informe de Incidencia: Fallo de Autenticación Kerberos (KDC)
============================================================

:Fecha: 2026-04-16
:Estado: Resuelto
:Responsable: Raul  Vilchez
:Infraestructura: IdM Integration (ipa.raulvilchez.org / ipa02.raulvilchez.org)

Resumen de la Incidencia
========================
El cliente no puede obtener tickets iniciales de Kerberos (TGT) mediante el comando ``kinit``. El error reportado es: 
``kinit: Cannot contact any KDC for realm 'RAULVILCHEZ.ORG'``.

Análisis y Diagnóstico
======================
Tras la depuración, se identificaron tres factores críticos que impedían la comunicación:

1. **Estado del Maestro:** El servidor maestro (``ipa``) se encontraba apagado para preservar recursos.
2. **Configuración del Cliente:** El archivo local ``/etc/krb5.conf`` del cliente solo contenía la referencia al servidor maestro, ignorando la existencia de la réplica (``ipa02``).
3. **Servicio KDC en la Réplica:** Aunque la réplica ``ipa02`` estaba activa, el proceso ``krb5kdc`` se encontraba en un estado inconsistente: figuraba como *RUNNING* pero no tenía sockets abiertos en los puertos de red (88 UDP/TCP).

Acciones Realizadas
===================

Configuración de Redundancia en el Cliente
------------------------------------------
Se actualizó la sección ``[realms]`` en el cliente para incluir explícitamente la réplica en el NAS. También se ajustó el límite de preferencia UDP para asegurar compatibilidad.

.. code-block:: ini

   [realms]
   RAULVILCHEZ.ORG = {
       kdc = ipa02.raulvilchez.org:88
       kdc = ipa.raulvilchez.org:88
       ...
   }



Saneamiento del Servicio en ipa02
---------------------------------
Se realizó un reinicio forzado del servicio Kerberos en la réplica y se habilitó su inicio automático para garantizar la disponibilidad tras reinicios del NAS.

* Comandos ejecutados en ``ipa02``:
    * ``systemctl restart krb5kdc``
    * ``systemctl enable krb5kdc``

Verificación
------------
Se validó la escucha de puertos mediante ``ss -tunlp | grep :88``, confirmando la apertura de sockets en UDP y TCP.

Resolución
==========
La incidencia se resolvió satisfactoriamente. El cliente ahora es capaz de obtener tickets contactando directamente con la réplica (``ipa02``) de forma transparente cuando el maestro está fuera de línea.

.. note::
   Se recomienda que cualquier nueva réplica añadida al dominio sea incluida en el registro DNS SRV o, en su defecto, en la configuración estática de los clientes críticos.

Cronología de Comandos de Verificación
======================================
* ``dig -t SRV _kerberos._udp.RAULVILCHEZ.ORG`` (Validación DNS)
* ``kinit raul-ipa`` (Prueba de obtención de ticket)
* ``klist`` (Confirmación de caché de credenciales)