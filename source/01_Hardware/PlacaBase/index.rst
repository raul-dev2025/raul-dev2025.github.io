.. SPDX-License-Identifier: GPL-2.0-or-later

===================================
Arquitectura de la Placa Base
===================================

En esta sección se detallan la estructura, los componentes electrónicos, los chipsets, los buses de expansión y los subsistemas de soporte que integran la placa base de un sistema informático.

Contenidos
==========

.. toctree::
   :maxdepth: 2
   :caption: Arquitectura de la Placa Base

   busNorte
   busSur
   pciBusBridges
   busPCI
   busPCIexpress
   busISA
   vrm-sio
   fwr-boot
   drive-mod
   clk-signal

Resumen de Módulos
==================

* **Arquitectura de Chipsets**: Cobertura del :doc:`busNorte` (*Northbridge*) y el :doc:`busSur` (*Southbridge / PCH*).
* **Interconexión y Buses**: Evolución desde el histórico :doc:`busISA` y el :doc:`busPCI` hasta la topología por capas en serie de :doc:`busPCIexpress` y la jerarquía de :doc:`pciBusBridges`.
* **Subsistemas de Control y Alimentación**: Regulación de energía en :doc:`vrm-sio` (*VRM y Super I/O*) y la generación del reloj base del sistema en :doc:`clk-signal`.
* **Firmware, Almacenamiento y Seguridad**: Procesos de inicialización en :doc:`fwr-boot` (*SPI Flash, RTC y POST*) junto con las interfaces de almacenamiento de alta velocidad, red y seguridad en :doc:`drive-mod` (*M.2, NVMe, Ethernet y TPM*).