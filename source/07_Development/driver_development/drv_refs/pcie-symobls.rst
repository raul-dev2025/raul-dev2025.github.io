.. SPDX-License-Identifier: GPL-2.0-or-later

============================================================
Concepto MMCFG (Memory-Mapped Configuration) en PCI Express
============================================================

En el contexto de **PCI Express (PCIe)** y el kernel de Linux, el término **MMCFG** hace referencia a *Memory-Mapped Configuration Space* (Espacio de Configuración Mapeado en Memoria). Se trata del mecanismo definido en la especificación PCIe para acceder al espacio de configuración de los dispositivos del bus.

¿Qué es MMCFG?
==============

* Los dispositivos PCIe disponen de un **espacio de configuración**, compuesto por un conjunto de registros utilizados para configurar y controlar el dispositivo.
* En el bus PCI tradicional, el acceso al espacio de configuración se realiza mediante puertos de E/S (por ejemplo, los puertos ``CONFIG_ADDRESS`` y ``CONFIG_DATA``).
* En PCIe, este acceso se realiza a través de **Entrada/Salida Mapeada en Memoria (MMIO)** mediante el mecanismo **MMCFG**.
* La región MMCFG es una porción del espacio de direccionamiento de la memoria física del sistema reservada exclusivamente para acceder al espacio de configuración PCIe. La dirección base de esta región la define el firmware en las tablas ACPI del sistema (específicamente en la tabla ``MCFG``).

Funcionamiento de MMCFG
=======================

1. El firmware del sistema (BIOS o UEFI) proporciona la dirección base de la región MMCFG dentro de la tabla ACPI ``MCFG``.
2. El sistema operativo (kernel de Linux) utiliza esta dirección base para mapear el espacio de configuración PCIe en su propio espacio de direcciones virtuales.
3. A partir de ese momento, el kernel puede acceder a los registros de configuración de los dispositivos PCIe realizando operaciones directas de lectura y escritura en memoria dentro de la región MMCFG.

MMCFG en el Kernel de Linux
===========================

En el kernel de Linux, el soporte para MMCFG se gestiona mediante la siguiente opción de configuración:

.. code-block:: Kconfig

   CONFIG_PCI_MMCONFIG

* Esta opción habilita el uso del espacio de configuración mapeado en memoria para dispositivos PCIe.
* En los kernels modernos suele estar activada por defecto, dado que la práctica totalidad de los sistemas actuales utilizan PCIe y dependen de MMCFG para gestionar los dispositivos.

Importancia de MMCFG
====================

* **Rendimiento**: Proporciona un método significativamente más rápido y eficiente para acceder al espacio de configuración en comparación con el mecanismo legado de puertos de E/S de PCI.
* **Gestión de Dispositivos**: Es fundamental para la detección, inicialización y administración de dispositivos PCIe durante el proceso de arranque y en tiempo de ejecución.

.. note::
   Durante la fase de depuración o análisis del arranque del kernel, es habitual encontrar referencias a MMCFG en los registros del sistema (``dmesg``). El kernel suele notificar la dirección base asignada a MMCFG y el tamaño de la región detectada a partir de las tablas ACPI.