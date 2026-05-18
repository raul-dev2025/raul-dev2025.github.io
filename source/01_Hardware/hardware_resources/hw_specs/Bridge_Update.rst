==============================================================
Informe de Reconfiguración de Red Virtual: Bridge br_lab
==============================================================

:Fecha: 24 de marzo de 2026
:Proyecto: Infraestructura Virtual (IV) - Migración de NIC
:Host: Servidor de Virtualización B550
:Estado: Operacional


Contexto de la Intervención
===========================
Tras la sustitución física de la tarjeta de red TX201 por la **QNAP QXG-2G2T-1225**, el bridge virtual ``br_lab`` perdió su conectividad con el mundo exterior. El perfil de conexión previo (denominado *Slave-TX201*) quedó huérfano al no detectar el hardware original, lo que aisló el tráfico de las máquinas virtuales (VMs) como el ``ipa-server``.


Lógica de Reconfiguración
=========================
El objetivo no era asignar una IP al host en este bridge, sino restaurar el **Switch Virtual de Capa 2**. Se procedió a:

1.  Eliminar los perfiles de red individuales que NetworkManager crea automáticamente para las nuevas NICs (para evitar conflictos de control).
2.  Vincular el puerto físico ``enp6s0`` de la QNAP como un "esclavo" (port) del bridge existente.


Comandos Utilizados y Justificación
===================================

* ``nmcli connection delete Slave-TX201``: Elimina la conexion esclava, ligada al dispositivo de la anterior NIC, ahora desconectada.
* ``nmcli connection delete QXG1``: Elimina la configuración por defecto para liberar el dispositivo físico.
* ``nmcli connection add type ethernet slave-type bridge con-name QXG-Slave1 ifname enp6s0 master br_lab``: Crea el enlace lógico que "pincha" el cable físico al switch virtual.
* ``nmcli connection modify Slave-QXG ifname enp6s0``: asocia el dispositivo físico al esclavo creado.
* ``nmcli connection up Slave-QXG``: Levanta la conexion si aun no lo ha hecho.


Análisis de la Salida de Datos
==============================
La ejecución de ``bridge fdb show brport enp6s0`` arrojó resultados positivos inmediatos:

.. code-block:: text

    70:4d:7b:8e:f5:70 master br_lab  (MAC externa aprendida)
    24:5e:be:94:3a:94 master br_lab permanent (MAC local de la QNAP)
    10:ff:e0:7a:54:0b master br_lab 
    24:5e:be:94:3a:93 master br_lab 
    24:5e:be:94:3a:94 vlan 1 master br_lab permanent
    24:5e:be:94:3a:94 master br_lab permanent
    01:00:5e:00:00:01 self permanent
    33:33:00:00:00:01 self permanent


* ``bridge fdb show brport enp6s0``: Muestra la tabla de reenvío (Forwarding Database). Es vital para confirmar que el bridge está "aprendiendo" direcciones MAC a través del puerto.

* ``ip addr show br_lab``: esto debera confirmar que el bridge dispone de conectividad.

    5: br_lab: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 24:5e:be:94:3a:94 brd ff:ff:ff:ff:ff:ff 


**Interpretación:** El bridge no solo está activo, sino que está detectando tráfico de otros dispositivos en la red física. Esto confirma que el "tubo" de datos está abierto para las VMs.


Incidencia: brctl not found
===========================
Se detectó la ausencia de la herramienta clásica ``brctl``. En la infraestructura actual, esta se considera obsoleta. La verificación de la arquitectura se realiza ahora mediante el stack de iproute2:

* **Comando sustituto recomendado:** ``ip -d link show br_lab`` o ``bridge link show``.


Conclusión
==========
La infraestructura virtual vuelve a tener salida a la red física. El servidor IdM (``ipa-server``) debería ser accesible sin cambios adicionales en su configuración interna, manteniendo la integridad del reino ``RAULVILCHEZ.ORG``.