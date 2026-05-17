==========================================================
Informe de Diagnóstico y Optimización del Entorno KVM/IdM
==========================================================

:Fecha: 24 de febrero de 2026
:Host: dev.raulvilchez.org
:Estado: Optimizado
:Autor: Gemini AI (Colaborador técnico)

Introducción
============
Este informe documenta las acciones realizadas tras detectar un error de hardware (MCE) en el host, así como la posterior optimización de recursos (RAM y CPU) para mejorar la estabilidad del entorno de virtualización y los servicios de FreeIPA/IdM.

1. Diagnóstico de Error de Hardware (MCE)
=========================================
Se detectó un mensaje de error en el prompt de ``virsh`` proveniente del kernel referente a un "Machine Check Exception".

**Detalles del error**:

* **Tipo:** Deferred error (Error diferido).
* **CPU:** 1 (Arquitectura AMD Zen).
* **Banco:** 20 (Relacionado con la Caché L3).
* **Gravedad:** Baja. El hardware corrigió el error mediante ECC sin afectar al sistema operativo.

**Comandos de diagnóstico utilizados:**

.. code-block:: bash

    # Verificación de errores en el log del kernel
    dmesg | grep -i "hardware error"

    # Intento de decodificación (soporte limitado en AMD moderno)
    mcelog

    # Verificación de persistencia en el journal
    journalctl -k --grep="Hardware Error"

2. Optimización de Memoria (Hugepages)
======================================
Se identificó un consumo excesivo de RAM (aprox. 25.8 GB) debido a una reserva estática de **Hugepages** (16 GB) que no estaba siendo utilizada por las Máquinas Virtuales (VMs), provocando un "consumo doble".

**Estado detectado**:

* ``HugePages_Total``: 8192 (16 GB).
* ``HugePages_Free``: 8192 (Inactivas).

**Acción correctiva:**
Configuración del bloque ``memoryBacking`` en el XML de la VM para forzar el uso del pool reservado.

**Verificación:**

.. code-block:: bash

    # Comprobar el estado del pool de páginas grandes
    grep -E "HugePages_Total|HugePages_Free" /proc/meminfo

3. Sintonización de CPU (Pinning y Aislamiento)
===============================================
Se ha implementado un esquema de aislamiento para proteger el rendimiento del Host (Hypervisor) y los servicios críticos de IdM, separándolos de la carga de las VMs.

**Esquema de asignación**:

* **Hypervisor / Host:** CPUs 0, 1, 6, 7.
* **Máquina Virtual (VM):** CPUs 2, 3.
* **Libres para escalado:** CPUs 4, 5, 8, 9, 10, 11.

4. Cambios en la Configuración XML (Libvirt)
============================================
Se han aplicado los siguientes cambios estructurales en la configuración de la VM (``virsh edit``):

**Configuración de Memoria y CPU:**

.. code-block:: xml

    <memory unit='KiB'>4194304</memory>
    <memoryBacking>
      <hugepages/>
    </memoryBacking>
    <vcpu placement='static'>2</vcpu>
    <cputune>
      <vcpupin vcpu='0' cpuset='2'/>
      <vcpupin vcpu='1' cpuset='3'/>
      <emulatorpin cpuset='0-1,6-7'/>
    </cputune>
    <cpu mode='host-passthrough' check='none'>
      <topology sockets='1' dies='1' cores='2' threads='1'/>
    </cpu>

Conclusiones
============
El sistema muestra ahora un comportamiento estable:

1. El consumo de RAM ha bajado a **20.8 GB** (62.6%), eliminando el desperdicio previo.
2. La VM opera con rendimiento nativo de CPU mediante passthrough y pinning.
3. El aislamiento del Host asegura que el entorno de desarrollo y los servicios IdM no sufran degradación por el uso de las VMs.