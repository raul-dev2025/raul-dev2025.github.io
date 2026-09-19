.. SPDX-License-Identifier: GPL-2.0-or-later

========================================
Jerarquía para el Espacio de Nombres ACPI
========================================

El espacio de nombres ACPI (**acpiNS**) debe ofrecer una representación precisa de la topología del hardware, comenzando desde el Bus de sistema del procesador (``\_SB``). En general, todo dispositivo conectado a un bus o controlador aparecerá como nodo hijo de dicho bus o controlador dentro del espacio de nombres.

Reglas para Plataformas Basadas en SoC
======================================

En plataformas de tipo System on Chip (SoC), se aplican las siguientes directrices:

* Los bloques funcionales de memoria mapeada (incluidos los procesadores) aparecen directamente bajo el nodo raíz ``\_SB``.
* Los dispositivos periféricos que se conectan a controladores de bus simple de periféricos (SPB) o a controladores `GPIO <https://learn.microsoft.com/es-es/windows-hardware/drivers/gpio/general-purpose-i-o--gpio--driver-support>`_ (Entrada/Salida de Propósito General) describen su conectividad mediante recursos de conexión. Para más información, consulte la documentación de `Bus simple de periféricos (SPB) <https://learn.microsoft.com/es-es/windows-hardware/drivers/spb/simple-peripheral-bus--spb--driver-support>`_.

Periféricos conectados de esta forma pueden situarse directamente bajo el nodo ``\_SB`` o bajo el nodo de su controlador correspondiente (``SPB`` o ``GPIO``). Esta última opción es preferible, ya que refleja explícitamente la relación de jerarquía dentro del espacio de nombres ACPI sin requerir la decodificación adicional de recursos.

* Los bloques funcionales o periféricos conectados mediante buses estándar con capacidad de enumeración por hardware (por ejemplo, SDIO y USB) no requieren figurar obligatoriamente en el **acpiNS**.

Sin embargo, pueden incluirse bajo su controlador correspondiente en el **acpiNS** cuando se requiera control específico de la plataforma (por ejemplo, en dispositivos embebidos USB HSIC o SDIO donde existen líneas GPIO o conexiones SPB asociadas). En estos casos, ``Acpi.sys`` se carga como un filtro en la pila de dispositivos para invocar los métodos de control necesarios.

* Los buses privados (por ejemplo, I2S dedicado a un controlador de audio) no necesitan figurar en el espacio de nombres ACPI. No obstante, los recursos del sistema utilizados por el dispositivo deben especificarse en su lista de recursos en el espacio de nombres. Para más información, consulte la sección sobre `Configuración de objetos de dispositivo <https://learn.microsoft.com/es-es/windows-hardware/drivers/acpi/acpi-device-objects>`_.

Funciones Estándar del Espacio de Nombres
==========================================

ACPI define un conjunto estándar de objetos y métodos de control para operaciones comunes del sistema, entre las que destacan:

* **Descripción de la plataforma**: Identificación de dispositivos y asignación de recursos del sistema.
* **Control genérico de dispositivos**: Configuración de recursos y gestión de estados de energía.
* **Características específicas del sistema**: Control de estado de baterías, zonas térmicas y eventos de plataforma.

Administración del Espacio de Nombres
======================================

La inicialización del espacio de nombres ACPI es realizada por el firmware (BIOS/UEFI) durante el arranque del sistema mediante la carga de las tablas DSDT (*Differentiated System Description Table*) y SSDT (*Secondary System Description Table*).