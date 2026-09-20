.. SPDX-License-Identifier: GPL-2.0-or-later

=========================================================
Resumen de Infraestructura - Servidor dev.raulvilchez.org
=========================================================

Almacenamiento Optimizado (VDO + XFS)
=====================================

* **Dispositivo Físico:** NVMe M.2 de 4TB.
* **Capa de Optimización:** VDO (*Virtual Data Optimizer*) configurado con un tamaño lógico de 3TB.
* **Funcionalidades Activas:** Deduplicación en línea, compresión y soporte de descarte de bloques (*Discard/TRIM*).
* **Punto de Montaje:** ``/var/lib/virt_storage`` (Montado mediante UUID con opción ``discard``).
* **Estructura de Directorios:**

  * ``/var/lib/virt_storage/containers``: Almacenamiento para motores de contenedores (Podman).
  * ``/var/lib/virt_storage/vms``: Discos virtuales QCOW2.
  * ``/var/lib/virt_storage/iso_images``: Repositorio de imágenes ISO.
  * ``/var/lib/virt_storage/configs``: Definiciones XML y plantillas de Libvirt.
  * ``/var/lib/virt_storage/scripts``: Automatización y despliegue.
  * ``/var/lib/virt_storage/metadata``: Documentación y bitácoras.

Configuración del Sistema y Rendimiento
======================================

* **Aislamiento de CPU:** Configurado mediante afinidad/aislamiento para los núcleos ``2-5`` y ``8-11``.
* **Memoria RAM:** 16GB dedicados para el stack de virtualización.
* **Huge Pages:** Implementadas con un tamaño de página de ``2M`` para reducir la latencia de acceso a memoria en VMs.

Red y Conectividad
==================

* **Interfaz Física:** NIC conectada al bus PCIe a través del puerto ``pciex1_1``.
* **Configuración de Red:** Implementación de un *Linux Bridge* para el aislamiento y segmentación del tráfico de la tarjeta PCIe.

Virtualización y Contenedores
=============================

* **Hipervisor:** KVM/Libvirt gestionando pools de almacenamiento (``vdo_infra``, ``vdo_iso``).
* **Motor de Contenedores:** Podman configurado para utilizar el almacenamiento VDO (*Driver Overlay*).
* **Librerías de Drivers:** Disponibilidad de ``virtio-win.iso`` para optimización de E/S en sistemas Windows.

Estado de Seguridad
===================

* **SELinux:** Activo, con políticas específicas (``virt_content_t``) aplicadas sobre el almacenamiento VDO para permitir el acceso correcto del usuario ``qemu``.
* **Permisos:** Estandarización de archivos ISO a ``644`` y propiedad del usuario ``qemu``.