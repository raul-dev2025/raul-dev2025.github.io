.. SPDX-License-Identifier: GPL-2.0-or-later

=============================================
Submódulos de Almacenamiento, Red y Seguridad
=============================================

Esta sección aborda los controladores y conectores integrados en la placa base dedicados a la interconexión de almacenamiento masivo de alta velocidad, las interfaces de red locales o inalámbricas y las tecnologías de seguridad criptográfica por hardware.

Zócalos M.2 (NGFF) y Protocolo NVMe
===================================

El conector **M.2** (antiguamente conocido como *Next Generation Form Factor* - NGFF) es el estándar de factor de forma compacto diseñado para tarjetas de expansión internas de pequeño tamaño (unidades SSD, tarjetas Wi-Fi/Bluetooth, etc.).

Mapeo de Líneas y Codificación Mecánica (*Keying*)
--------------------------------------------------

Los conectores M.2 utilizan muescas mecánicas (*Keys*) en el zócalo para determinar la compatibilidad eléctrica y evitar la inserción de dispositivos incompatibles:

* **M-Key**: Asigna hasta 4 líneas de **PCI Express** (PCIe x4) o SATA. Es el estándar utilizado por los SSDs **NVMe** (*Non-Volatile Memory Express*) de alto rendimiento.
* **B-Key**: Asigna hasta 2 líneas PCIe (PCIe x2), SATA o buses de comunicación de baja velocidad (USB 2.0/3.0, HSIC).
* **B+M Key**: Dispositivos que incorporan ambas muescas mecánicas, limitados a 2 líneas PCIe o interfaz SATA.
* **E-Key / A-Key**: Diseñados principalmente para módulos de conectividad inalámbrica (Wi-Fi, Bluetooth y módem celular) combinando líneas PCIe x1, USB 2.0 y la interfaz **CNVi** (*Intel Integrated Connectivity*).

.. list-table:: Comparativa de Rendimiento en Almacenamiento M.2
   :widths: 25 35 40
   :header-rows: 1

   * - Interfaz
     - Protocolo
     - Ancho de Banda Máximo Teórico
   * - **M.2 SATA**
     - AHCI
     - ~600 MB/s (limitado por SATA III)
   * - **M.2 NVMe (PCIe 3.0 x4)**
     - NVMe
     - ~3.9 GB/s
   * - **M.2 NVMe (PCIe 4.0 x4)**
     - NVMe
     - ~7.8 GB/s
   * - **M.2 NVMe (PCIe 5.0 x4)**
     - NVMe
     - ~15.7 GB/s

Controladores de Red (Ethernet PHY / MAC)
=========================================

El subsistema de red local Ethernet en la placa base se divide en dos componentes funcionales principales:

1. **Controlador MAC (*Media Access Control*)**: Integrado directamente dentro del chipset principal (PCH/Southbridge) o en un circuito integrado PCI Express independiente. Gestiona la capa de enlace de datos, las tramas Ethernet y el direccionamiento MAC.
2. **Chip PHY (*Physical Layer*)**: Transceptor físico independiente ubicado en la placa base que convierte las señales digitales del controlador MAC en las señales analógicas requeridas por el cable de red de pares trenzados (puerto **RJ-45**).

La comunicación entre el controlador MAC interno y el chip PHY externo se realiza habitualmente a través de interfaces estandarizadas como **MII** (*Media Independent Interface*) o **RGMII**.

Módulo TPM 2.0 (Trusted Platform Module)
========================================

El **TPM** (*Trusted Platform Module*) es un criptoprocesador seguro diseñado para realizar operaciones criptográficas, almacenar claves de cifrado de forma protegida y verificar la integridad de la plataforma.

Implementaciones del TPM
------------------------

Existen dos formas principales de integrar el estándar TPM 2.0 en una placa base:

* **dTPM (*Discrete TPM*)**: Chip dedicado independiente soldado en la placa base (o conectado mediante un cabezal SPI/LPC de 14-20 pines) con su propia memoria integrada y mecanismos físicos contra manipulación (*tamper resistance*).
* **fTPM / PTT (*Firmware TPM*)**: Implementación basada en firmware que ejecuta las funciones de seguridad dentro de un entorno de ejecución seguro (*Trusted Execution Environment - TEE*) dentro del propio procesador principal (Intel PTT - *Platform Trust Technology* o AMD fTPM).

Funciones Clave de Seguridad
----------------------------

* **Arranque Medido (*Measured Boot*)**: Registra los checksums criptográficos de cada componente del proceso de arranque (firmware UEFI, tablas ACPI, cargador de arranque y kernel) en los registros **PCR** (*Platform Configuration Registers*) del TPM.
* **Almacenamiento de Claves de Cifrado**: Guarda de forma segura las claves de cifrado de volumen completo para herramientas del sistema operativo como **BitLocker** (Windows) o **LUKS** (Linux), liberando la clave únicamente si la secuencia de arranque no ha sido alterada.
* **Generador de Números Aleatorios Por Hardware (TRNG)**: Proporciona entropía de alta calidad para la generación de claves asimétricas (RSA, ECC).