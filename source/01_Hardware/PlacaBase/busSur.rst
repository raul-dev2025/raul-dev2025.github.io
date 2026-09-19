.. SPDX-License-Identifier: GPL-2.0-or-later

===========
Southbridge
===========

El **Southbridge** (o *puente sur*) es el circuito integrado del conjunto de chips (**chipset**) que gestiona las funciones de entrada y salida (E/S) y los periféricos de menor velocidad en las arquitecturas de placas base tradicionales (como x86). 

También se conoce en las arquitecturas de Intel como **ICH** (*I/O Controller Hub*) o **FCH** (*Fusion Controller Hub*) en plataformas de AMD.

Ubicación y Arquitectura
========================

A diferencia del **Northbridge**, el Southbridge no está directamente conectado a la CPU. Todas las comunicaciones entre el Southbridge y el procesador deben atravesar obligatoriamente el Northbridge a través de un bus de interconexión dedicado de alta velocidad (como *Intel Hub Link*, *Direct Media Interface - DMI*, o *AMD A-Link*).

Físicamente, se ubica en la parte inferior de la placa base, cerca de las ranuras de expansión PCI y los conectores de almacenamiento.

.. code-block:: text

   +-------------------------------------------------+
   |                   CPU                           |
   +-------------------------------------------------+
                            |
                   Bus Frontal (FSB)
                            |
   +-------------------------------------------------+
   |               NORTHBRIDGE                       |
   +-------------------------------------------------+
                            |
           Bus Inter-Chipset (DMI / Hub Link)
                            |
   +-------------------------------------------------+
   |               SOUTHBRIDGE (ICH)                 |
   |  - USB, SATA / IDE, Audio, Red                  |
   |  - LPC / SPI Bus (BIOS, Super I/O)              |
   |  - Reloj RTC / Memoria CMOS                     |
   +-------------------------------------------------+

Funciones Integradas
====================

El Southbridge centraliza el control de la mayoría de periféricos y subsistemas del equipo:

* **Controladores de Almacenamiento**: Interfaces para discos duros y unidades ópticas (**IDE / PATA** y **SATA**), incluyendo soporte para arreglos **RAID** por hardware/firmware.
* **Buses de Periféricos de Alta y Media Velocidad**: Controladores nativos para **USB** (UHCI, OHCI, EHCI y xHCI), tarjetas de red Ethernet (**LAN**) y audio de alta definición (**HD Audio** / AC'97).
* **Buses Legados y de Expansión**: Gestión del bus **PCI** convencional, bus **ISA** (en arquitecturas antiguas) y la interfaz **LPC** (*Low Pin Count*) / **SPI** para comunicar con la memoria Flash de la **BIOS/UEFI** y el chip **Super I/O**.
* **Gestión de Energía y Reloj del Sistema**:
  * Control de estados de energía ACPI (modos de suspensión :math:`S_3, S_4, etc.`).
  * Reloj en tiempo real (**RTC**) y memoria sustentada por batería (**CMOS**).
  * Controlador de interrupciones programable (**APIC** / PIC) y controladores **DMA** tradicionales.

Evolución: El Paso hacia el Platform Controller Hub (PCH)
========================================================

Al integrarse el controlador de memoria (IMC) y las líneas PCIe principales dentro del propio encapsulado de la CPU, la arquitectura de doble chip (Northbridge + Southbridge) quedó obsoleta.

.. list-table:: Evolución de la Arquitectura del Chipset
   :widths: 30 35 35
   :header-rows: 1

   * - Era
     - Arquitectura
     - Distribución de Funciones
   * - **Tradicional**
     - Northbridge + Southbridge
     - Northbridge (Memoria y Gráficos) + Southbridge (E/S lentas).
   * - **Moderna**
     - CPU + **PCH / FCH**
     - CPU (Memoria, PCIe x16) + PCH (Resto de E/S, SATA, USB, Red).

En las plataformas modernas, el Southbridge ha absorbido las pocas funciones restantes del antiguo Northbridge para convertirse en un único chip denominado **PCH** (*Platform Controller Hub*) en Intel o **FCH** en AMD.

Referencias
===========

* `Southbridge en Wikipedia <https://en.wikipedia.org/wiki/Southbridge_(computing)>`_
* Documentación técnica sobre la arquitectura de chipsets I/O Controller Hub (ICH) de Intel.