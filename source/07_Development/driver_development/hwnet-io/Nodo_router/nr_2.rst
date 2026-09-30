========================================
Configuración de Red y Enrutamiento Base
========================================

La transformación de la máquina virtual en un enrutador funcional con traducción de direcciones de red (NAT/Masquerade) se implementa exclusivamente mediante los servicios y herramientas nativos proporcionados por el sistema operativo Rocky Linux 10. La pila de red se apoya en el subsistema del kernel, ``NetworkManager``, ``firewalld`` y el motor de filtrado de paquetes ``nftables``.

Inhabilitación de Dependencias Externas
=======================================

Una premisa de diseño fundamental en esta arquitectura es el uso eficiente de los componentes preinstalados en la distribución base. El enrutamiento de paquetes IP y la traducción de direcciones no requieren la instalación de paquetes adicionales o daemon de terceros (como ``dnsmasq`` o ``frr``) para sus funciones esenciales.

.. list-table:: Herramental Nativo de la Pila de Red
   :widths: 25 35 40
   :header-rows: 1

   * - Herramienta / Componente
     - Utilidad en el Nodo Router
     - Estado en la Distribución Base
   * - ``iproute2`` (``ip``)
     - Gestión del direccionamiento y tablas de rutas
     - Preinstalado / Nativo
   * - ``NetworkManager`` (``nmcli``)
     - Gestión persistente de enlaces y zonas
     - Servicio activo por defecto
   * - ``firewalld`` / ``nftables``
     - Abstracción y ejecución de enmascaramiento NAT
     - Servicio activo por defecto
   * - Kernel Linux (Parámetro sysctl)
     - Reenvío de paquetes IPv4 entre interfaces
     - Habilitado (``net.ipv4.ip_forward = 1``)

Activación del Reenvío de Paquetes (IP Forwarding)
=================================================

El reenvío de paquetes en el nivel de red (Capas 3/4) está controlado por la variable del subsistema sysctl. Para asegurar que los paquetes entrantes por la interfaz LAN (``enp9s0``) sean conmutados hacia la interfaz WAN (``enp1s0``), el valor del parámetro en tiempo de ejecución debe ser unitario:

.. code-block:: text

   net.ipv4.ip_forward = 1

La persistencia de esta configuración se asegura mediante la inclusión explícita del parámetro dentro del directorio de configuración del sistema en ``/etc/sysctl.d/99-ipforward.conf``.

Mapeo de Zonas en NetworkManager y Firewalld
============================================

La segmentación de seguridad y el comportamiento del enrutador se delegan en la integración entre ``NetworkManager`` y ``firewalld``. Cada interfaz física/virtual se vincula a una zona con reglas de filtrado específicas:

1. **Configuración de Zonas en NetworkManager:**

   .. code-block:: bash

      nmcli connection modify enp1s0 connection.zone external
      nmcli connection modify LAN connection.zone internal
      nmcli connection up enp1s0
      nmcli connection up LAN

2. **Habilitación de Masquerade (NAT) en la Zona Externa:**

   La zona ``external`` de ``firewalld`` está diseñada para actuar como interfaz de salida a redes no confiables o externas. Al activar la propiedad de enmascaramiento (``masquerade``), el sistema traduce automáticamente la dirección IP de origen de todos los paquetes salientes provenientes del segmento LAN.

   .. code-block:: bash

      firewall-cmd --zone=external --add-masquerade --permanent
      firewall-cmd --reload

Verificación en la Pila Subyacente (nftables)
=============================================

Aunque el control de las reglas de cortafuegos se gestiona a alto nivel con ``firewall-cmd``, las reglas se traducen directamente en el motor de tablas del kernel ``nftables``. La presencia de la regla de enmascaramiento se verifica mediante la inspección directa del conjunto de reglas del sistema:

.. code-block:: bash

   nft list ruleset | grep -i masquerade

La salida esperada confirma que cualquier tráfico con protocolo IPv4 cuya interfaz de salida no sea la interfaz de bucle local (``lo``) será enmascarado mediante la siguiente regla::

   meta nfproto ipv4 oifname != "lo" masquerade