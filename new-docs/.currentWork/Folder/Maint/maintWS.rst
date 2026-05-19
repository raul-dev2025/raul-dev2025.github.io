==============================================================
Informe de Persistencia de Tiempo y Redundancia DNS en la WS
==============================================================

:Fecha: 04 de abril de 2026
:Host: dev.raulvilchez.org (WS)
:Sistema Operativo: Rocky Linux 9 (Basado en RHEL)
:Estado: Implementado y Verificado

Objetivo
========
Garantizar la operatividad del sistema ante un posible fallo de la pila física (CMOS). En entornos basados en **FreeIPA/Kerberos**, un desfase temporal mayor a 5 minutos impide la autenticación. Este cambio asegura que la WS sincronice su reloj antes de que los servicios críticos fallen.

Implementación del Servicio "Pila-Persist"
=========================================

Estrategia de Almacenamiento Declarativo
---------------------------------------
Siguiendo la política de administración centralizada, los archivos se mantienen en el disco de datos y se integran mediante enlaces simbólicos:

* **Script:** ``/usr/local/bin/force-time-sync``
  (Origen: ``/mnt/datos_raul/scripts/usr-local-bin/force-time-sync``)
* **Unidad Systemd:** ``/etc/systemd/system/pila-persist.service``
  (Origen: ``/mnt/datos_raul/system-backup/etc-systemd-system/pila-persist.service``)

Lógica del Script
-----------------
El script ejecuta ``ntpdate -u -b pool.ntp.org``. El flag ``-u`` permite evadir conflictos con el puerto NTP si ya está en uso, y ``-b`` fuerza un salto inmediato del reloj en lugar de un ajuste gradual (slew), algo crítico tras un fallo de CMOS.

Configuración de SELinux
========================
Debido a que los archivos residen en una partición de datos, se aplicaron contextos de seguridad específicos para permitir la ejecución por parte de systemd:

1. **Para la unidad de servicio:**
   ``chcon -t systemd_unit_file_t [RUTA_ORIGEN]``
2. **Para el script ejecutable:**
   ``chcon -t bin_t [RUTA_ORIGEN]``

Redundancia de Red (DNS)
========================
Se ha modificado la configuración de red mediante ``nmcli`` para incluir un recurso externo de resolución. Esto garantiza que el script pueda resolver el nombre de los servidores NTP incluso si los controladores de dominio locales están inaccesibles.

**Jerarquía de DNS configurada:**
1.  ``192.168.17.39`` (Maestro IdM)
2.  ``192.168.17.40`` (Réplica IdM)
3.  ``1.1.1.1`` (Cloudflare - **Rescate Externo**)
4.  ``192.168.17.1`` (Gateway)



Verificación de Operatividad
===========================
El servicio se ha habilitado correctamente (``enabled``) para el arranque del sistema. La prueba de ejecución manual arrojó los siguientes resultados:

* **Comando:** ``systemctl start pila-persist.service``
* **Resultado:** ``status=0/SUCCESS``
* **Estado:** ``active (exited)``

.. note::
   Al ser un servicio de tipo ``oneshot``, es normal que aparezca como *exited* tras cumplir su función de sincronización inicial durante el arranque.