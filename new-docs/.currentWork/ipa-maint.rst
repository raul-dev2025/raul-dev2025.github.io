=====================================================
Informe de Estado: Recuperación y Sincronización IdM
=====================================================

:Fecha: 2026-04-06
:Responsable: Raul Vilchez(Administrador de Sistemas)
:Infraestructura: Nodo NAS (DSM) & IdM Integration
:Estado Final: **OPERACIONAL / SINCRONIZADO**

Resumen Ejecutivo
================

Tras la restauración de un backup en el servidor maestro (``ipa.raulvilchez.org``), se detectó una desincronización crítica en la base de datos LDAP y en el vector de actualización de réplicas (RUV). El sistema presentaba inconsistencia de credenciales para el usuario ``Directory Manager`` y pérdida de visibilidad de la topología de certificados en el nodo principal.

Procedimiento de Recuperación
=============================

1. Restauración de Acceso Administrativo
----------------------------------------
Se procedió al cambio manual del hash de la contraseña de ``Directory Manager`` directamente en el archivo ``dse.ldif``. Se aplicaron las siguientes correcciones de seguridad:

* **Sintaxis:** Ajuste estricto del espaciado en la directiva ``nsslapd-rootpw``.
* **Persistencia:** Edición realizada con servicios detenidos para evitar sobrescritura por el proceso de cierre.
* **SELinux:** Restauración del contexto de seguridad mediante ``restorecon -v`` para asegurar el arranque del servicio ``dirsrv``.


  .. nota:: antes de recrear la cadena de texto encriptada o hash, es conveniente asegurarse de que el servicio systemd correspondiente esta parado. Una vez incrustado en el archivo; reactivar el mismo.


  .. block_code::

    systemctl stop dirsrv@RAULVILCHEZ-ORG.service


2. Sincronización de Topología y Datos (RUV)
--------------------------------------------
Se identificó una "amnesia" de replicación en el Maestro. El procedimiento de alineación consistió en:

* **Identificación de Vectores:** Análisis mediante ``ipa-replica-manage list-ruv``, detectando la falta de los IDs de réplica (3 y 5) en el Maestro.
* **Re-inicialización:** Ejecución de ``re-initialize --from`` desde el Maestro apuntando a la Réplica (``ipa02``), asumiendo que la Réplica poseía el estado más completo de la base de datos post-backup.
* **Alineación de CA:** Sincronización específica del subsistema de certificados mediante la herramienta de gestión de réplicas de CA.

3. Verificación de Continuidad
------------------------------
* **NTP:** Sincronización horaria validada con ``chrony`` (offsets < 100us).
* **Backups:** Ejecución manual exitosa del script personalizado ``/usr/sbin/ipa_backup``.
* **NAS:** Verificación de transferencia de archivos ``full`` y ``data`` al almacenamiento externo.

Estado de la Infraestructura
============================

Sincronización de Réplicas
--------------------------

.. list-table:: Estado de Vectores de Actualización (RUV)
   :widths: 30 35 35
   :header-rows: 1

   * - Subsistema
     - ipa.raulvilchez.org (ID)
     - ipa02.raulvilchez.org (ID)
   * - LDAP (Domain)
     - 4, 3 (OK)
     - 3, 4 (OK)
   * - CA (Certificates)
     - 6, 5 (OK)
     - 5, 6 (OK)

Métricas de Salud
-----------------

* **Servicio Directory Server:** Activo y respondiendo.
* **Web UI:** Topología visual coherente con flechas de replicación bidireccionales activas.
* **Backup NAS:** Ultima copia exitosa el 2026-04-06 19:43.

Conclusión
==========
El clúster FreeIPA se encuentra en estado estable. La comunicación multi-maestro ha sido restaurada sin pérdida de integridad de datos. Se recomienda mantener la monitorización de los logs de replicación durante las próximas 24 horas.