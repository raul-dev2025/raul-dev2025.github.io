==================================================
Comandos de Inspección Manual para /sys/.../config
==================================================

1. Inspección visual completa (Hexdump clásico)
-----------------------------------------------
Muestra la cabecera PCI de 256 bytes en formato hexadecimal:

.. code-block:: bash

   hexdump -C -n 256 /sys/bus/pci/devices/<device>/config

2. Inspección mediante lspci
----------------------------
Visualiza el volcado oficial interpretado por la herramienta del sistema:

.. code-block:: bash

   lspci -s <device> -xxxx

3. Lectura de offsets específicos con dd
----------------------------------------
Permite extraer bytes en offsets exactos aplicando posicionamiento manual:

* **Vendor ID (2 bytes en offset 0x00):**

  .. code-block:: bash

     dd if=/sys/bus/pci/devices/<device>/config bs=1 skip=0 count=2 status=none | xxd -e

* **Command Register (2 bytes en offset 0x04):**

  .. code-block:: bash

     dd if=/sys/bus/pci/devices/<device>/config bs=1 skip=4 count=2 status=none | xxd -p

* **Revision ID (1 byte en offset 0x08):**

  .. code-block:: bash

     dd if=/sys/bus/pci/devices/<device>/config bs=1 skip=8 count=1 status=none | xxd -p

Traducción a Cadena Hexadecimal (256 bytes)
===========================================


1. Cadena Hexadecimal Continua (vía xxd)
----------------------------------------
Muestra los 256 bytes como una única secuencia hexadecimal limpia:

.. code-block:: bash

   xxd -p -l 256 /sys/bus/pci/devices/0000:02:00.0/config | tr -d '\n'

2. Formato Hexadecimal Byte a Byte (vía hexdump)
------------------------------------------------
Imprime los bytes separados por espacios sin direcciones ni texto ASCII:

.. code-block:: bash

   hexdump -v -e '1/1 "%02x "' -n 256 /sys/bus/pci/devices/0000:02:00.0/config


Verificación Manual sobre el Volcado en /tmp
============================================

Suponiendo que el archivo guardado es ``/tmp/pci_config.bin``:

1. Leer Vendor ID (2 bytes, Offset 0x00)
----------------------------------------

.. code-block:: bash

   xxd -p -s 0x00 -l 2 /tmp/pci_config.bin

2. Leer Command Register (2 bytes, Offset 0x04)
-----------------------------------------------

.. code-block:: bash

   xxd -p -s 0x04 -l 2 /tmp/pci_config.bin

3. Leer BAR0 (4 bytes, Offset 0x10)
-----------------------------------

.. code-block:: bash

   xxd -p -s 0x10 -l 4 /tmp/pci_config.bin