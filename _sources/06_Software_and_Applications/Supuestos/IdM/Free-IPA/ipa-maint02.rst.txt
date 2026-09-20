============================================================
Informe de Estado: Restauración y Optimización IdM (FreeIPA)
============================================================

:Fecha: 7 de abril de 2026
:Responsable: Administración de Sistemas
:Nodos: ipa.raulvilchez.org (Maestro), ipa02.raulvilchez.org (Réplica)

Resumen Ejecutivo
-----------------
Tras un incidente de pérdida de sincronización y fallo en el nodo maestro, se ha completado con éxito la restauración del servicio **FreeIPA**. Se han corregido las discrepancias de DNS, optimizado la resolución en clientes y blindado el sistema de sincronización horaria para permitir el autoarranque fiable de la réplica en el entorno NAS.

Tareas Realizadas
-----------------

1. Restauración y Sincronización
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* **Maestro (WS):** Restauración completa a partir del backup del 2026-03-03.
* **Réplica (NAS):** Re-inicialización total de la réplica desde el maestro para asegurar la integridad de la base de datos LDAP y Kerberos.

2. Corrección y Consolidación DNS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Se han validado y corregido los registros A para garantizar la coherencia de red:

* **ipa.raulvilchez.org**: 192.168.17.39 (Alojado en Workstation).
* **ipa02.raulvilchez.org**: 192.168.17.40 (Alojado en NAS).

En la estación de trabajo (WS), se ha configurado ``NetworkManager`` para priorizar la réplica del NAS, eliminando la opción ``rotate`` para asegurar una resolución predecible:

* Orden: ``192.168.17.40`` > ``192.168.17.39`` > ``1.1.1.1``.

3. Blindaje de Sincronización Horaria (NTP/Chrony)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Para mitigar el fallo de la pila CMOS del NAS (que provoca arranques en fechas erróneas), se ha modificado la configuración de ``chronyd`` en la réplica (``ipa02``):

* **IPs Directas:** Se han añadido servidores Stratum 1/2 por dirección IP (RedIRIS, ROA) para saltar la dependencia del DNS durante el arranque en frío.
* **Directiva Makestep:** Configurada como ``makestep 0.1 -1`` para forzar saltos temporales masivos (superiores a un año) de forma instantánea.
* **Persistencia:** Activación de ``rtcsync`` para mantener el reloj de hardware virtual actualizado.

Estado Actual del Sistema
-------------------------

* **Servicio IdM:** Operativo y estable.
* **Tickets Kerberos:** Validación exitosa (probado con ``kinit admin``).
* **Resolución de Nombres:** Correcta y jerarquizada.
* **Autoarranque:** Validado y seguro frente a desfases temporales.
