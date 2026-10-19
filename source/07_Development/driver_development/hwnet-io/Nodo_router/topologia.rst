=================================
Visión General y Topología de Red
=================================

El nodo denominado ``router-node`` es una máquina virtual basada en Rocky Linux 10 que actúa como enrutador y pasarela (*gateway*) dentro del entorno de desarrollo e integración continua. Su función principal es proporcionar un entorno aislado y controlado para la ejecución de pruebas del módulo de kernel ``hwnet-io`` y la suite de pruebas LTP (Linux Test Project).

Topología de Interfaces
=======================

La máquina virtual está configurada con dos interfaces de red virtuales (virtio) dedicadas a separar el tráfico de administración del tráfico de la red local de pruebas:

.. list-table:: Asignación de Interfaces de Red
   :widths: 20 20 20 40
   :header-rows: 1

   * - Interfaz
     - Perfil NM
     - Zona Firewalld
     - Función / Dirección IP
   * - enp1s0
     - enp1s0
     - external
     - Conexión WAN / Salida a red externa (DHCP)
   * - enp9s0
     - LAN
     - internal
     - Red local de pruebas / Estática: 192.168.100.1/24

Flujo de Tráfico
================

1. **Tráfico de Administración y Despliegue:** Se canaliza a través de la interfaz WAN (``enp1s0``), permitiendo el acceso SSH desde la estación de trabajo y los repositorios remotos.
2. **Tráfico de Pruebas LAN:** Se gestiona en la interfaz ``enp9s0``, que sirve como puerta de enlace predeterminada (``192.168.100.1``) para los segmentos de red de pruebas controlados por el módulo ``hwnet-io``.