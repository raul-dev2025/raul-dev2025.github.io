============================================
MAPA DE INFRAESTRUCTURA DE RED (BRIDGE L2)
============================================

--------------------------------------------
HOST: Workstation (Capa de Virtualización)
--------------------------------------------

1. Switch Virtual (Capa Lógica)
===============================
* **Elemento:** Bridge de Linux (br_lab)
* **Gestor NM:** ``Bridge-TX201``
* **Función:** Actúa como el chasis del switch virtual. Es el nodo central
  donde se "enchufan" todos los cables, tanto físicos como virtuales.

2. Puerto de Enlace Físico (Uplink)
===================================
* **Elemento:** Interfaz PCIe (enp4s0)
* **Gestor NM:** ``Slave-TX201``
* **Función:** Es el cable físico que sale de la tarjeta TX201 hacia
  el switch/router real de la casa. Permite que el tráfico del Bridge
  llegue al mundo exterior.

3. Puertos de Máquinas Virtuales (Taps)
=======================================
* **Elementos:** vnet0, vnet1, ..., vnetN
* **Gestor:** Libvirt (Marcados como ``unmanaged`` en NetworkManager)
* **Esquema propuesto:** ``TX201-01``, ``TX201-02``...
* **Función:** Cables virtuales que conectan cada VM al switch virtual (br_lab).

--------------------------------------------
DIAGRAMA DE FLUJO DE DATOS
--------------------------------------------

[ MÁQUINA VIRTUAL (IdM) ]
          |
          | (Puerto Virtual: vnetN / TX201-N)
          v
[ SWITCH VIRTUAL (br_lab) ] <--- Gestionado por Bridge-TX201
          |
          | (Puerto Físico: enp4s0) <--- Gestionado por Slave-TX201
          v
[ SWITCH/ROUTER FÍSICO ]
          |
          v
    [ INTERNET ]

--------------------------------------------
NOTAS DE CONFIGURACIÓN
--------------------------------------------

* **Independencia de Gestión:** NetworkManager controla el Bridge y el Uplink,
  mientras que Libvirt controla los puertos de las VMs.
* **Trazabilidad:** Al nombrar los puertos como TX201-N, se asocia
  empíricamente cada VM con la tarjeta de red física que le da salida.