================================================================================
Informe de Infraestructura: Optimización de Almacenamiento y Topología PCIe
================================================================================

Objetivo Técnico
----------------

El objetivo de esta sesión ha sido la consolidación de la topología física y lógica para un hipervisor KVM/Libvirt basado en la placa **Gigabyte B550 AORUS Elite V2** y el procesador **AMD Ryzen 5 5600**. Se ha resuelto específicamente la distribución de carga en los carriles PCIe para mitigar la saturación del bus del chipset **B550**, garantizando que el subsistema de almacenamiento de infraestructura acceda a latencias mínimas mediante el bus **PCIe 4.0** y optimizando la densidad de datos mediante la implementación de **VDO** (Virtual Data Optimizer).

Procedimiento
-------------

Definición de la Topología Física de Hardware
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Se ha validado la disposición de los componentes en los slots de expansión para asegurar el aislamiento de los grupos **IOMMU** y maximizar el ancho de banda del almacenamiento de infraestructura:

* **Slot M2A_CPU (Superior)**: Instalación de unidad **NVMe Gen4 (1TB)**. Este slot utiliza carriles **PCIe 4.0 x4** directos a la CPU.
* **Slot M2B_SB (Inferior)**: Instalación de unidad **Samsung 960 EVO (250GB)** para el Sistema Operativo Host. Conexión vía carriles **PCIe 3.0 x4** gestionados por el Chipset.
* **Slot PCIEX1_1**: Instalación de tarjeta de red **TP-Link TX201** (Chip **RTL8125B 2.5GbE**).



Configuración del Almacenamiento Optimizado (VDO)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para el almacenamiento de imágenes de máquinas virtuales en el disco de **1TB**, se define la creación de un volumen VDO con deduplicación y compresión activas:

.. code-block:: bash

    # 1. Creación del volumen VDO
    # Se establece un tamaño lógico de 3000G (3TB) sobre el soporte físico de 1TB
    vdo create --name=vdo_infra \
               --device=/dev/nvme0n1 \
               --vdoLogicalSize=3000G \
               --writePolicy=auto

    # 2. Formateo con XFS optimizado (desactivando descarte para VDO)
    mkfs.xfs -K /dev/mapper/vdo_infra

    # 3. Punto de montaje para libvirt
    mount /dev/mapper/vdo_infra /var/lib/libvirt/images

Justificación
-------------

* **Priorización de Carriles (Lanes)**: El uso del slot **M2A_CPU** es crítico para evitar el cuello de botella del DMI 3.0 que conecta el chipset B550 con la CPU, permitiendo que las VMs operen a velocidades de **PCIe 4.0**.
* **Configuración VDO (3000G)**: Se selecciona un tamaño lógico de **3TB** basándose en la alta tasa de redundancia esperada en plantillas de SO similares (deduplicación), maximizando la inversión del disco físico de **1TB**.
* **XFS**: Elegido por su excelente manejo de archivos sparse y su escalabilidad en entornos de virtualización.

Verificación
------------

La comprobación de la correcta inicialización y el estado de la optimización se realiza mediante la herramienta de estadísticas de VDO:

.. code-block:: bash

    # Verificación de estadísticas de ahorro de espacio
    vdostats --human-readable

    # Comprobación de la topología PCIe reconocida
    lspci -vvv | grep -A 20 "Non-Volatile memory controller"

```

¿Deseas que genere ahora el archivo de configuración XML de **libvirt** para que el Storage Pool apunte directamente a este nuevo volumen `/dev/mapper/vdo_infra`?