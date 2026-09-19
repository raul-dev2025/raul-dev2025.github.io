.. SPDX-License-Identifier: GPL-2.0-or-later

========================================
Controladores de Dispositivos (Drivers)
========================================

En esta sección se documenta la arquitectura de controladores de dispositivos (*device drivers*) en el sistema operativo, enfocándose en la interfaz de controladores USB de alta velocidad y en la capa de abstracción para dispositivos de interfaz humana.

Contenidos
==========

.. toctree::
   :maxdepth: 2
   :caption: Subsección Drivers

   xHCI
   hid

Resumen de Módulos
==================

* **Arquitectura del Controlador xHCI**: Especificación de la interfaz de controlador host extensible (*eXtensible Host Controller Interface*) para buses USB 3.x/2.0/1.1 en :doc:`xHCI`.
* **Dispositivos de Interfaz Humana (HID)**: Subsistema e infraestructura para teclados, ratones y dispositivos de entrada (*Human Interface Devices*) en :doc:`hid`.