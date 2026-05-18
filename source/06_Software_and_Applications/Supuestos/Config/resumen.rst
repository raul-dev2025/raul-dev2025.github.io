================================
Infraestructura y Almacenamiento
================================

1. Almacenamiento (VDO)
=======================

* **Tecnología:** Implementado **VDO (Virtual Data Optimizer)** sobre Rocky Linux 9.4.
* **Estado:** Disco virtual de 40GB montado sobre un volumen VDO con **19% de ahorro** real (deduplicación y compresión activas).
* **Rendimiento:** El volumen `.raw` reside en un entorno de metadatos específico (`/var/lib/virt_storage/`).


2. Configuración de la VM (Libvirt/KVM)
=======================================

* **Arquitectura:** Chipset **Q35** (`pc-q35-rhel9.4.0`), optimizado para sistemas modernos.
* **Aislamiento (Pinning):** * **VCPUs:** Núcleos 2, 3, 4 y 5 dedicados exclusivamente a Windows.
* **Emulator:** Núcleos 8 y 9 para las tareas de gestión del hipervisor.


* **Memoria:** 4GB con **Huge Pages** habilitadas, eliminando la latencia de paginación del kernel.
* **Gráficos:** Protocolo **VNC** con driver de video **VirtIO** y dispositivo `tablet` para sincronía total del ratón.

3. Sistema Operativo (Windows Server 2022)
==========================================

* **Drivers:** Instalación exitosa de **VirtIO Guest Tools** (Video, Red y Ballooning).
* **Estado actual:** Sistema estable, con el Antimalware terminando sus tareas iniciales y una eficiencia de CPU del 1-3% en el host.

-----

Red e Integración IdM
=====================

En nuestra próxima sesión, el objetivo es que el **Windows Server** deje de ser una isla y se convierta en parte de tu ecosistema de gestión de identidades.

**Lo que haremos:**

1. **Configuración de Red Estática:** Asignar identidad fija y apuntar el DNS al futuro servidor IdM (Rocky Linux).
2. **Instalación del FreeIPA/IdM:** Configurar en el host (o en otra VM) el servidor de identidades.
3. **Cross-Realm Trust / Unirse al Dominio:** La parte técnica donde Windows confía en Rocky para los usuarios.
