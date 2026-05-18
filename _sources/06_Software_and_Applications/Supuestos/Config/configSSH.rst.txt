===========================================
Configuración de Acceso Remoto Seguro (SSH)
===========================================

:Fecha: 2026-02-24
:Proyecto: Réplica FreeIPA en Synology DS218+
:Host: ipa02.raulvilchez.org (192.168.17.40)

Descripción
-----------
Este paso describe el procedimiento para habilitar el acceso administrativo remoto mediante el intercambio de llaves SSH, eliminando la dependencia de contraseñas y facilitando la gestión desde la Workstation (WS).

Configuración del Servidor (Réplica)
------------------------------------
Para permitir el acceso inicial de la cuenta ``root``, se realizaron modificaciones en la configuración del servicio SSH en el nodo ``ipa02``.

1. Editar el archivo de configuración:

   ``vi /etc/ssh/sshd_config``

2. Asegurar los siguientes parámetros:

   * ``PermitRootLogin yes``
   * ``PasswordAuthentication yes``

3. Reiniciar el servicio para aplicar cambios:

   ``systemctl restart sshd``

Gestión de Identidad en la Workstation
--------------------------------------
Debido a la existencia de múltiples identidades en la WS, se detectó un error de tipo "Too many authentication failures" al intentar el copiado estándar.

**Resolución del conflicto de huella digital (Fingerprint)**
Antes de la transferencia, se limpió el registro previo del host para evitar conflictos de identificación:

.. code-block:: bash

   ssh-keygen -R 192.168.17.40

**Transferencia de la llave pública**
Se utilizó la opción ``IdentitiesOnly=yes`` para forzar al cliente SSH a ignorar otras llaves cargadas en el agente y utilizar exclusivamente la identidad ``ipa02.pub``:

.. code-block:: bash

   ssh-copy-id -o "IdentitiesOnly=yes" -i ~/.ssh/ipa02.pub root@192.168.17.40

Verificación
------------
El paso se considera completado cuando es posible iniciar sesión de forma transparente:

.. code-block:: bash

   ssh -i ~/.ssh/ipa02 root@192.168.17.40

Notas de Seguridad
------------------
* Se ha utilizado una llave de tipo ED25519/RSA específica para este nodo.
* Una vez finalizada la instalación de la réplica, se recomienda revisar la directiva ``PermitRootLogin`` según la política global definida.