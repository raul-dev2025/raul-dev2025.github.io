============================================================
Informe Técnico: Conflicto de Direccionamiento PCIe e IOMMU
============================================================

:Fecha: 2026-04-26
:Host: dev.raulvilchez.org
:Dispositivo Afectado: NVMe Samsung SM961 (OS/Journal)
:Hardware Causante: QNAP Dual-Port 2.5GbE (Intel I225-LM)
:Estado Final: Estabilizado mediante Downgrade a TX-201

Contexto del Problema
=====================
Tras la instalación de una tarjeta de red QNAP de doble puerto, el sistema comenzó a experimentar corrupciones críticas en el Journal de ``systemd``. El síntoma principal era la imposibilidad de escribir logs y el fallo de integridad del sistema de archivos, coincidiendo con la reserva de 16 GB de RAM en Hugepages.

Comandos de Diagnóstico y Mitigación
====================================

Para estabilizar y diagnosticar el sistema, se emplearon los siguientes comandos:

1. **Verificación de Integridad:**
   .. code-block:: bash

      journalctl --verify
      journalctl -p 3..0 -xb

2. **Gestión de Configuración del Kernel (grubby):**
   .. code-block:: bash

      # Desactivación de Hugepages y forzado de reasignación PCIe
      grubby --update-kernel=ALL --args="pci=realloc,assign-busses hugepages=0 nomodeset"
      
      # Intento de aislamiento de grupos IOMMU
      grubby --update-kernel=ALL --args="pcie_acs_override=downstream,multifunction,all"

3. **Análisis de Topología de Bus y Grupos IOMMU:**
   .. code-block:: bash

      # Identificar en qué dirección (Bus ID) ha quedado
      lspci -nn | grep -i "QNAP\|Ethernet\|Network"
      
      # Localización de BARs por encima de 4GB
      lspci -vv | grep -i "Region.*Memory at [0-9a-f]\{9,\}"
      
      # Mapeo de grupos IOMMU por dispositivo
      for d in /sys/kernel/iommu_groups/*/devices/*; do 
          n=${d#*/iommu_groups/*}; n=${n%%/*}; 
          printf 'IOMMU Group %s ' "$n"; lspci -nns "${d##*/}"; 
      done

Conclusiones Técnicas
=====================

El análisis reveló un conflicto de hardware insalvable en el **Grupo IOMMU 16**.

1. **Hacinamiento del Bus:** El slot PCIe utilizado cuelga de un switch ASMedia (Chipset) que agrupa en la misma unidad atómica de IOMMU al NVMe de sistema, la controladora Realtek integrada y la tarjeta QNAP.
2. **Conflicto MMIO:** La tarjeta QNAP dual-port reclama ventanas de direcciones (BARs) extensas. Al activarse los **16 GB de Hugepages**, el mapa de memoria se satura, provocando que las transacciones DMA de la red "pisen" el espacio de memoria reservado para el controlador del NVMe.
3. **Fallo de Aislamiento:** A pesar de aplicar ``pcie_acs_override=all``, el hardware no permite el divorcio lógico de estos dispositivos, lo que garantiza que cualquier error de bus en la red corrompa el flujo de datos del disco.

Justificación del Downgrade a TX-201
====================================

Se ha determinado que la vuelta a la tarjeta **TX-201 (Single Port)** es la única vía para mantener los requisitos de rendimiento de la estación:

* **Estabilidad del Journal:** La TX-201 posee una huella MMIO significativamente menor, reduciendo la probabilidad de colisión en el Grupo 16.
* **Prioridad de Virtualización:** Permite mantener los **8192 Hugepages (2M)** necesarios para ``libvirt`` sin comprometer la integridad del sistema de archivos.
* **Seguridad de Datos:** Las pruebas con la TX-201 devuelven un estado de ``PASS`` constante en el Journal, confirmando que la convivencia en el bus es posible con una carga de registros reducida.

Estado Actual
=============
El sistema opera con la TX-201, con el stack de baja latencia activo y los parámetros de diagnóstico (``nomodeset``, ``pci=realloc``) retirados, recuperando la funcionalidad completa de la GPU y el entorno gráfico.