.. SPDX-License-Identifier: GPL-2.0-or-later

===================
Firmware y Arranque
===================

El subsistema de firmware y arranque engloba los componentes de hardware y código de bajo nivel responsables de inicializar los circuitos electrónicos de la placa base, realizar la comprobación de integridad del sistema y transferir el control al gestor de arranque del sistema operativo.

Chip SPI Flash (EEPROM)
=======================

El **Chip SPI Flash** es una memoria no volátil de lectura/escritura eléctrica (**EEPROM**) conectada al Southbridge/PCH a través del bus serie **SPI** (*Serial Peripheral Interface*).

Contenido del Chip Flash
------------------------

Este chip almacena la imagen binaria unificada de firmware del sistema, la cual se organiza en distintas regiones lógicas:

1. **Código UEFI / BIOS**: Contiene el código ejecutable de inicialización de hardware, los controladores de dispositivos de bajo nivel (*UEFI Drivers*) y la interfaz de configuración del sistema (*Setup*).
2. **Tablas ACPI**: Especificaciones compiladas en lenguaje **AML** (*ACPI Machine Language*) que describen la topología del hardware, los controladores de energía, las interrupciones y los dispositivos del sistema hacia el sistema operativo.
3. **Microcódigo de la CPU**: Actualizaciones críticas de software suministradas por el fabricante del procesador para corregir errores de diseño (*errata*) o vulnerabilidades de seguridad en la CPU.
4. **Descriptor de Flash (Intel FD / AMD Descriptor)**: Estructura de datos al inicio del chip que define los permisos de acceso y el mapa de direcciones para los diferentes subsistemas (PCH, Intel ME / AMD PSP, GbE).


.. list-table:: CHIP SPI FLASH
   :widths: 30 70
   :header-rows: 0

   * - Flash Descripto
     - Configuración de regiones y bu
   * - Intel ME / PS
     - Firmware del motor de gestió
   * - BIOS / UEFI Regio
     - Código UEFI, Tablas ACPI, Microcódig
   * - NVRAM Regio
     - Variables UEFI (BootOrder, Keys)


Circuito RTC y Memoria CMOS
===========================

El **RTC** (*Real-Time Clock*) o *Reloj en Tiempo Real* es un circuito oscilador que mantiene la fecha y hora del sistema en tiempo absoluto, incluso cuando el equipo se encuentra desconectado de la red eléctrica.

* **Memoria CMOS**: Históricamente una pequeña memoria RAM estática de bajo consumo (típicamente 128 o 256 bytes) integrada dentro del Southbridge/PCH que conserva los parámetros configurados en la BIOS/UEFI.
* **Batería de Respaldo (CR2032)**: Pila de litio de :math:`+3\text{ V}` que suministra energía continua al circuito RTC y a la memoria CMOS.
* **Evolución**: En las placas base modernas, la mayor parte de las opciones de configuración de la UEFI se almacenan de forma no volátil en una sección de la propia memoria SPI Flash (**NVRAM**), mientras que la batería CR2032 se mantiene principalmente para alimentar el contador del reloj RTC y el estado del flag de limpieza de CMOS (*Clear CMOS*).

Proceso de Arranque e Inicialización (POST)
===========================================

Cuando se aplica energía a la placa base, el sistema ejecuta una secuencia estandarizada de fases de arranque:

1. **Reset y Vector de Arranque**: La fuente de alimentación estabiliza la tensión y emite la señal ``POWER_GOOD``. La CPU despierta en modo real (o modo protegido simplificado en x86-64) y ejecuta la instrucción ubicada en el vector de reset (*Reset Vector*), apuntando a la memoria Flash.
2. **SEC (Security Phase)**: Primera fase del estándar UEFI. Inicializa un entorno de ejecución temporal utilizando la memoria caché de la CPU como memoria RAM (*Cache-as-RAM / CAR*), ya que los módulos de RAM principales aún no han sido configurados.
3. **PEI (Pre-EFI Initialization)**: Detecta e inicializa la memoria RAM principal, aplica los perfiles de frecuencia (XMP/EXPO) y configura las líneas eléctricas básicas del chipset.
4. **DXE (Driver Execution Environment)**: Carga en la memoria RAM el resto de controladores UEFI (almacenamiento, USB, red, vídeo) y monta el entorno de ejecución necesario para procesar las tablas ACPI y la configuración del sistema.
5. **BDS (Boot Device Selection)**: Localiza las opciones de arranque definidas en la NVRAM, verifica las firmas digitales del gestor de arranque mediante **Secure Boot** (si está activado) y ejecuta la aplicación EFI (fichero ``.efi``) ubicada en la partición de sistema EFI (**ESP**).