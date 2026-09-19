.. SPDX-License-Identifier: GPL-2.0-or-later

====================================
Puentes de Bus PCI - PCI Bus Bridges
====================================

La especificación PCI contempla la interconexión de múltiples buses independientes dentro de un mismo sistema mediante el uso de **puentes de bus** (*PCI Bus Bridges*). Un puente de bus es un dispositivo de hardware (o una función dentro de un circuito integrado) que actúa como interfaz entre dos buses locales distintos, aislando sus dominios eléctricos y gestionando la transmisión selectiva de transacciones.

Conceptos Fundamentales y Propósito
===================================

En las arquitecturas PCI tradicionales, un único segmento de bus paralelo presenta restricciones físicas estrictas en cuanto a la impedancia eléctrica, la capacitancia de la señal y el número máximo de carga por zócalos (*slots*).

Los puentes de bus resuelven estas limitaciones permitiendo:

1. **Jerarquización del Bus**: Permiten organizar la topología en forma de árbol, donde un bus principal o primario se subdivide en uno o varios buses secundarios.
2. **Aislamiento Eléctrico y Muestreo**: Filtran el tráfico para que las señales eléctricas de un segmento no saturen las líneas de otros segmentos, extendiendo la cantidad total de periféricos instalables.
3. **Conversión de Protocolos y Frecuencias**: Un puente puede interconectar segmentos que operan a diferentes velocidades o voltajes (por ejemplo, adaptar un bus PCI de 33 MHz a uno de 66 MHz, o traducir señales entre PCI y otros buses como CardBus o PCIe).

Tipos de Puentes de Bus PCI
===========================

Puentes PCI-a-PCI (*PCI-to-PCI Bridges - P2P*)
----------------------------------------------

Son los puentes estándar definidos bajo la cabecera de configuración tipo 1 (*Header Type 1*). Un puente P2P conecta un bus primario (hacia la CPU) con un bus secundario (hacia los dispositivos o hacia otros puentes).

* **Filtrado de Direcciones**: El puente examina cada transacción en el bus primario. Si la dirección de destino pertenece al rango configurado para su bus secundario (o subárbol descendiente), el puente captura la transacción y la retransmite (*forwarding*). De lo contrario, la ignora.
* **Transacciones Posteadas y No Posteadas**: Implementa buffers internos para almacenar operaciones de escritura sin bloquear el bus de origen (*posted writes*), optimizando el flujo de trabajo.

Puentes Host-a-PCI (*Host-to-PCI / Root Complex*)
-------------------------------------------------

Ubicados en la cúspide de la jerarquía (históricamente dentro del **Northbridge** o en el **Root Complex** de PCIe), conectan el bus nativo del procesador y la memoria del sistema con el bus PCI primario (denominado *Bus 0*).

Diferencias del Uso de Puentes entre PCI Convencional y PCI Express
===================================================================

Aunque la teoría de puentes aplica a ambas tecnologías, la práctica difiere de forma radical según el diseño del bus:

.. list-table:: Comparativa de la Topología de Puentes entre PCI y PCIe
   :widths: 30 35 35
   :header-rows: 1

   * - Parámetro
     - PCI Convencional
     - PCI Express (PCIe)
   * - **Estructura Física**
     - Bus multipunto paralelo compartido.
     - Enlaces punto a punto en serie.
   * - **Uso de Puentes**
     - Infrecuente (normalmente 1 a 2 segmentos).
     - Masivo e intensivo.
   * - **Representación Lógica**
     - Múltiples dispositivos en un único bus.
     - Cada enlace :math:`x1, x4, x16` representa un bus independiente.
   * - **Mecanismo de Conmutación**
     - Puentes P2P físicos discretos.
     - Conmutadores virtuales internos (*PCIe Switches / Virtual P2P Bridges*).

En **PCI Express**, la topología lógica se representa ante el sistema operativo exactamente igual que un árbol de puentes PCI tradicionales para preservar la compatibilidad con el software de enumeración. Sin embargo, en el plano físico, los *PCIe Switches* integran múltiples puentes virtuales P2P conectados internamente a un bus virtual secundario (*Virtual PCI Bus*), permitiendo la conmutación de paquetes a alta velocidad entre puertos sin las colisiones del bus paralelo.

Proceso de Enumeración y Asignación de Números de Bus
=====================================================

Durante el arranque (*bootstrapping*), el firmware (BIOS/UEFI) explora la topología mediante un algoritmo de búsqueda en profundidad (*Depth-First Search*), asignando tres registros clave en la cabecera de cada puente:

* **Primary Bus Number**: El número del bus ubicado aguas arriba (*upstream*), más cercano a la CPU.
* **Secondary Bus Number**: El número asignado directamente al segmento de bus aguas abajo (*downstream*) gestionado por este puente.
* **Subordinate Bus Number**: El número de bus con el valor más alto ubicado en cualquier punto del subárbol descendiente de este puente.

Este mecanismo de direccionamiento permite que los mensajes de E/S y las transacciones *MMIO* se enruten de forma transparente a través de múltiples niveles de puentes sin modificar las aplicaciones ni los controladores de los dispositivos finales.

Referencias
===========

* `PCI-to-PCI Bridge Architecture Specification <https://pcisig.com/>`_ (PCI-SIG).
* Tom Shanley / Don Anderson: *PCI System Architecture*, MindShare Inc.