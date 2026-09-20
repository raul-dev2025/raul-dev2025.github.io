.. SPDX-License-Identifier: GPL-2.0-or-later

=======================================================
Configuración de VLANs en Linux (Estándar IEEE 802.1Q)
=======================================================

El estándar **IEEE 802.1Q** permite la segmentación lógica de redes de área local (*VLANs*) sobre una misma infraestructura física de Ethernet. En Linux, la gestión de etiquetado de tramas (*VLAN tagging*) se realiza a nivel del kernel mediante el módulo de red ``8021q``.

Requisitos de Hardware y Conceptos Previos
===========================================

Para implementar la configuración de una VLAN se requieren dos elementos principales:

1. **Conmutador (Switch)**: Debe soportar el estándar IEEE 802.1Q para etiquetar e inspeccionar las tramas de red.
2. **Interfaz de Red (NIC)**: Tarjeta de red en el host que soporte la transmisión de tramas Ethernet con encabezado 802.1Q.

.. note::
   Los equipos domésticos proporcionados por los proveedores de servicios (ISP) suelen ser equipos locales del cliente (**CPE** - *Customer Premises Equipment*). Estos agrupan módem, enrutador, conmutador y punto de acceso en un único dispositivo híbrido para cubrir las tres capas inferiores del modelo OSI.

Carga del Módulo del Kernel e Instalación de Utilidades
=======================================================

Compruebe si el módulo ``8021q`` está cargado en el kernel del sistema:

.. code-block:: console

   $ lsmod | grep 8021q

Si el módulo no está activo, cárguelo manualmente en el kernel:

.. code-block:: console

   # modprobe 8021q

Instale las utilidades de gestión de VLANs en sistemas basados en Debian/Ubuntu:

.. code-block:: console

   # apt-get install vlan

Para asegurar que el módulo se cargue automáticamente durante el arranque del sistema, añada la línea ``8021q`` al archivo ``/etc/modules``:

.. code-block:: text

   # /etc/modules
   8021q

Gestión Dinámica de VLANs con la Herramienta ``ip``
===================================================

Creación de la Interfaz Virtual
-------------------------------

Cree la interfaz de red virtual vinculada a la interfaz física (ej. ``eth0``) especificando el identificador de VLAN (*VLAN ID*):

.. code-block:: console

   # ip link add link eth0 name eth0.10 type vlan id 10

.. note::
   Por convención, el nombre de las interfaces de VLAN sigue la nomenclatura ``interfaz_física.ID`` (por ejemplo, ``eth0.10`` para la VLAN ID 10).

Asignación de Dirección IP y Activación
---------------------------------------

Configure la dirección IP y la máscara de red en la interfaz virtual recién creada y active el enlace:

.. code-block:: console

   # ip addr add 192.168.1.200/24 dev eth0.10
   # ip link set dev eth0.10 up

Verifique el estado detallado del dispositivo VLAN:

.. code-block:: console

   $ ip -d link show eth0.10

Eliminación de la Interfaz VLAN
-------------------------------

Para eliminar la interfaz virtual, desactívela primero y proceda con su borrado:

.. code-block:: console

   # ip link set dev eth0.10 down
   # ip link delete eth0.10

Configuración Persistente (Debian / Ubuntu)
===========================================

Para mantener la configuración de la VLAN tras el reinicio del sistema en distribuciones que utilicen ``ifupdown``, edite el archivo ``/etc/network/interfaces``:

.. code-block:: text

   # /etc/network/interfaces

   auto eth0.10
   iface eth0.10 inet static
       address 192.168.1.200
       netmask 255.255.255.0
       vlan-raw-device eth0

.. note::
   La directiva ``vlan-raw-device eth0`` se puede omitir si la interfaz virtual utiliza el formato estándar de nombrado ``ethX.YY``, ya que el sistema deduce automáticamente el dispositivo físico subyacente.