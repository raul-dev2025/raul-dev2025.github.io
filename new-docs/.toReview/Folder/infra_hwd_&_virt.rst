============================================================
Informe Técnico: Infraestructura de Hardware y Virtualización
============================================================

:Proyecto: Infraestructura del Hipervisor (RaulVilches.org)
:Hardware: Gigabyte B550 AORUS Elite V2 / Ryzen 5 5600
:Estado: Fase de Validación de Hardware y Seguridad del Firmware

Objetivo Técnico
================

El objetivo de esta sesión ha sido la validación técnica y documentación de la infraestructura base para un entorno de **virtualización (libvirt/KVM)** que operará bajo una arquitectura híbrida de Workstation y Servidor. Se ha priorizado el aislamiento de recursos, la redundancia del firmware y la seguridad criptográfica mediante el análisis de líneas PCIe y la integración del módulo de plataforma segura (TPM).

Configuración de Hardware y Arquitectura de Datos
=================================================

Se ha documentado la topología de buses para optimizar el rendimiento de las máquinas virtuales y evitar cuellos de botella en el acceso a almacenamiento y red:

- **Almacenamiento NVMe:**
    * **M2A_CPU (Superior):** Conectado directamente a la CPU (**PCIe 4.0 x4**). Destinado al SO anfitrión y VMs críticas.
    * **M2B_SB (Inferior):** Conectado al Chipset B550 (**PCIe 3.0 x4**).
- **Conectividad de Red (Dual 2.5GbE):**
    * Interfaz integrada **Realtek 2.5GbE**.
    * Tarjeta de red externa **TP-Link TX201** (PCIe) para segmentación de tráfico en ``libvirt``.

Seguridad y Gestión del Firmware
================================

Justificación del fTPM
---------------------

Se ha optado por el uso de **AMD CPU fTPM** integrado en el procesador **Ryzen 5 5600** en lugar de un módulo físico (dTPM). La justificación técnica radica en:

1. **Seguridad de Bus:** El fTPM opera dentro del silicio, eliminando la vulnerabilidad de interceptación de claves (*sniffing*) en el bus SPI/LPC.
2. **Escalabilidad:** Capacidad para gestionar miles de rotaciones de claves OS, con opción de purga mediante **Clear TPM**.

Redundancia y Recuperación
--------------------------

A diferencia de la arquitectura DualBIOS física (GA-AX370), se documenta el sistema **Q-Flash Plus** para la recuperación ante desastres:

- **Controlador dedicado:** Permite el flasheo del firmware sin presencia de CPU o RAM.
- **Indicador:** Uso del LED de diagnóstico adyacente al botón BIOS en el panel trasero para monitoreo de escritura.

Configuración de la BIOS (AMD B550 Series)
==========================================

Para garantizar la funcionalidad del hipervisor, se deben aplicar los siguientes parámetros críticos:

.. code-block:: bash

    # Parámetros críticos para habilitar la virtualización y el aislamiento
    Tweaker > Advanced CPU Settings > SVM Mode = [Enabled]
    Settings > Miscellaneous > IOMMU = [Enabled]
    Settings > Miscellaneous > AMD CPU fTPM = [Enabled]
    Settings > Platform Power > AC BACK = [Always On]

Optimización del Kernel para Libvirt
====================================

Para el correcto funcionamiento de los grupos **IOMMU** y el passthrough de la NIC TP-Link, se requiere la modificación de los parámetros del grub en el anfitrión:

.. code-block:: bash

    # Modificación del archivo /etc/default/grub
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amd_iommu=on iommu=pt"

.. code-block:: bash

    # Actualización de la configuración
    sudo update-grub

Verificación de la Configuración
================================

La comprobación de la integridad del sistema se basa en los siguientes puntos validados:

1. **Identificación de Pines:** El **Pin 1 (Positivo)** de los conectores LED se ha identificado mediante la marca del **triángulo** grabado, asegurando la polaridad correcta en el cabezal **12VGRB** (Pin de 12V).
2. **Post-Arranque:** Verificación mediante el sistema de 4 LEDs de diagnóstico integrados en la placa (**CPU, DRAM, VGA, BOOT**).
3. **Firmware:** El LED del botón **Q-Flash Plus** debe cesar su parpadeo para confirmar una escritura exitosa antes de la primera inicialización del SO.



Notas Adicionales
=================

Se ha descartado el uso de un módulo físico TPM de 14-1 pines por incompatibilidad dimensional con el nuevo cabezal de 12 pines de la serie B550, validándose que la funcionalidad de seguridad es idéntica en versión lógica (2.0) a través del firmware del procesador.
