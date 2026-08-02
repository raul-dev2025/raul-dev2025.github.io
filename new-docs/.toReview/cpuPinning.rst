=============================================================
Estrategia de Asignación de CPUs y Optimizaciones en KVM/QEMU
=============================================================

:Fecha: 26 de julio de 2026
:Sistemas de Origen: Windows 10 (`win10-compilador`), Rocky Linux 10 (`buildlab`)
:Hipervisor: KVM / QEMU / libvirt (Arquitectura AMD Zen)

Este documento detalla los principios de diseño, optimizaciones y justificación técnica aplicados a la asignación de CPUs (*vCPU pinning*), emulación y topología en la infraestructura de virtualización sobre procesadores AMD.

-----

Análisis Comparativo de Configuración
=====================================

A continuación se resumen los aspectos clave identificados y adaptados entre las plantillas de las máquinas virtuales:

1. **Topología de CPU y vCPU Pinning**:
   
   * **Windows 10**: Configurado con 4 vCPUs asignadas a un rango contiguo de cores físicos (hilos ``2``, ``3``, ``4`` y ``5``).
   * **Rocky Linux 10**: Inicialmente configurado con asignación asimétrica (hilos ``3`` y ``9``). Tras la optimización, se escaló a 4 vCPUs utilizando el bloque contiguo ``2``, ``3``, ``4`` y ``5``.

2. **Aislamiento del Emulador (`emulatorpin`)**:

   * En la configuración original de Rocky Linux, ``emulatorpin`` compartía los procesadores ``0-1, 6-7`` dedicados al hipervisor.
   * Tras el ajuste, se asignó ``10-11`` a ``emulatorpin`` en ambas plantillas, liberando tanto a los cores del hipervisor como a las vCPUs del *guest* de la carga de E/S y gestión de emulación.

3. **Optimizaciones de Red y Almacenamiento**:

   * Integración de la característica ``vhost`` con 4 colas de red (``queues='4'``) en la interfaz ``virtio`` conectada al puente ``br_lab``.



Justificación Técnica: Asignación Contigua vs. Discontinua de CPUs
==================================================================

En procesadores modernos basados en la arquitectura **AMD Zen (Ryzen / EPYC)**, la elección de asignación de CPUs para las máquinas virtuales responde a tres factores clave de rendimiento:

1. Mapeo de Hilos SMT y Cores Físicos
-------------------------------------

En la topología lógica expuesta por el kernel Linux, los números de CPU suelen asignarse en secuencia. Al elegir un bloque contiguo (por ejemplo, los hilos ``2`` y ``3``):

* Se asignan hilos lógicos (*Simultaneous Multithreading* - SMT) pertenecientes al mismo núcleo físico.
* Ambos hilos comparten las cachés de Nivel 1 (L1) y Nivel 2 (L2) del núcleo, minimizando latencias e ineficiencias en la sincronización de procesos del sistema invitado.

2. Localidad en el Complejo de Núcleos (CCX) y Caché L3
-------------------------------------------------------

Los núcleos en procesadores AMD están agrupados en **CCX (Core Complex)**, compartiendo una estructura unificada de caché L3.

* **Asignación Contigua**: Mantiene todas las vCPUs de la máquina virtual dentro del mismo CCX o dominio de caché.
* **Asignación Discontinua**: Si se asignan hilos distantes (como ``3`` y ``9``), los hilos de la máquina virtual deben atravesar el bus de interconexión (*Infinity Fabric*) para sincronizar memoria, provocando *cache misses* (fallos de caché L3) y penalizaciones drásticas de latencia.

3. Diferencia respecto a la Reserva del Hipervisor
--------------------------------------------------

La reserva de los procesadores ``0-1, 6-7`` para el hipervisor responde a objetivos distintos:

* **Hipervisor**: Requiere aislamiento y tolerancia a fallos para atender interrupciones E/S del sistema host, tareas de kernel y demonios de gestión independientes.
* **Máquina Virtual (*Guest*)**: Ejecuta cargas intensivas paralelas (compilaciones con ``make -j4``, pipelines de CI/CD, etc.) que dependen críticamente de un acceso rápido, coherente y localizado a las memorias caché de la CPU.
"""