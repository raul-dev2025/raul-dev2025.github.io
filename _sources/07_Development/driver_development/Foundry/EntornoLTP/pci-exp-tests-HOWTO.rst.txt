.. SPDX-License-Identifier: GPL-2.0-or-later

============================================================
Guía de Uso: Scripts de Prueba PCI-Express para el Marco LTP
============================================================

*Autor: Amit Khanna <amit.khanna@intel.com>*  
*Fecha: 20 de agosto de 2004 (Copyright (c) Intel Corporation, 2004)*

1. Acerca de esta Guía
======================

Este documento describe la integración de casos de prueba para dispositivos **PCI-Express** dentro del proyecto Linux Test Project (LTP). Estos scripts y funciones amplían las capacidades de LTP para validar controladores y dispositivos PCI-Express en el kernel.

2. Descripción de los Cambios en el Código
==========================================

Modificaciones en la Capa del Kernel (``tpci.c``)
-------------------------------------------------

Ubicación: ``ltp/testcases/kernel/device-drivers/pci/tpci/tpci.c``

* **Inclusión de ``test_find_pci_exp_cap``**:
  Esta función invoca a ``pci_find_capability`` para determinar si un dispositivo dispone de capacidad PCI-Express. Un dispositivo indica soporte PCI-Express al implementar la estructura correspondiente en su lista de capacidades.

* **Inclusión de ``test_read_pci_exp_config``**:
  Invoca a ``pci_config_read`` para verificar si el espacio de configuración extendido de PCI-Express se puede leer correctamente.
  
  La función lee el registro *Advanced Error Reporting CAP-ID* ubicado en la dirección ``0x100`` del espacio de configuración extendido. El valor de este registro es constante y de solo lectura para todos los dispositivos PCI-Express. Si el valor leído coincide con la macro ``AER_CAP_ID_VALUE`` (definida en ``tpci.h``), se confirma que el controlador accede con éxito al espacio extendido.

Pruebas desde el Espacio de Usuario (``user_tpci.c``)
-----------------------------------------------------

Ubicación: ``ltp/testcases/kernel/device-drivers/pci/user_tpci/user_tpci.c``

* **Función de Control ``ki_generic()``**:
  Función en el espacio de usuario encargada de interactuar con el módulo de kernel ``tpci`` para ejecutar y controlar las distintas pruebas PCI y PCI-Express definidas en ``tpci.c``.

3. Habilitación del Soporte PCI-Express en el Kernel
====================================================

Por defecto, es posible que el soporte para PCI-Express no esté habilitado en la configuración del kernel.

Para activar el soporte PCI-Express, es necesario configurar la opción de acceso a PCI como **"Any"** o **"MMCFG"** dentro del menú de configuración del kernel (*General Setup*).

4. Preguntas Frecuentes (FAQ)
=============================

¿Existen limitaciones al utilizar este parche?
----------------------------------------------

El acceso al espacio extendido de PCI-Express solo es posible si el dispositivo soporta PCI-Express y la opción correspondiente está habilitada en el kernel. En caso de que el dispositivo no sea PCI-Express, el espacio PCI tradicional continuará siendo accesible sin inconvenientes.

¿Qué representa la macro ``AER_CAP_ID_VALUE`` en ``tpci.h``?
------------------------------------------------------------

``AER_CAP_ID_VALUE`` representa el identificador de capacidad de notificación avanzada de errores (*Advanced Error Reporting Capability ID*) en el espacio de configuración PCI-Express. Su valor predeterminado es constante para todos los dispositivos PCI-Express (``0x14011``).

En la función ``test_read_pci_exp_config``, este valor predefinido se compara con el extraído directamente del dispositivo analizado. Si coinciden, se confirma que el controlador del kernel está leyendo correctamente el espacio de configuración extendido.