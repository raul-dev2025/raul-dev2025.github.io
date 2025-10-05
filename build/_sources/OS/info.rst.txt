Información del sistema
==========================

**Dispositivos conectados (fabricante y modelo)**

Para obtener información detallada del hardware del sistema, incluyendo fabricantes y modelos de dispositivos conectados, puedes usar varios métodos dependiendo de tu sistema operativo.

1. Windows
-------------

1.1 Usando Información del Sistema (GUI)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Presiona ``Win + R``, escribe ``msinfo32`` y presiona **Enter**.
2. Expande **Componentes** para ver detalles sobre:

   - **Pantalla** (GPU)
   - **Almacenamiento** (Discos)
   - **Red** (Adaptador)
   - **Dispositivo de sonido** (Audio)
   - **Entrada** (Teclado/Ratón)
3. Revisa **Resumen del sistema** para información de la placa base, BIOS y CPU.

1.2 Usando Línea de Comandos (CMD/PowerShell)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Estos comando están disponibles en versiones anteriores del sistema operativo(Windows 7, 8 y algunas versiones de Windows 10). Microsoft ha marcado la aplicación ``WMIC`` como **obsoleta**.

Información básica del sistema:

.. code-block:: powershell

   systeminfo

   # Placa base y BIOS:
   wmic baseboard get product,Manufacturer,version

   # CPU:
   wmic cpu get name,manufacturer

   # GPU:
   wmic path win32_videocontroller get name

   # Discos:
   wmic diskdrive get model,manufacturer,size

   # Dispositivos USB:
   wmic path Win32_USBControllerDevice get Dependent

   # Adaptadores de red:
   wmic nic get name,manufacturer

1.3 Usando PowerShell (Más detallado)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. code-block:: powershell

   Get-WmiObject Win32_ComputerSystem | Select Manufacturer,Model
   Get-WmiObject Win32_Processor | Select Name,Manufacturer
   Get-WmiObject Win32_DiskDrive | Select Model,Manufacturer
   Get-WmiObject Win32_NetworkAdapter | Where { $_.PhysicalAdapter -eq $true } | Select Name,Manufacturer

1.4 Herramientas de terceros
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- **Speccy** (de Piriform)
- **HWiNFO** (Avanzado)
- **CPU-Z** (CPU, GPU, Placa base)

2. Linux
--------

2.1 Usando Comandos de Terminal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # CPU:
   lscpu
   cat /proc/cpuinfo | grep "model name"

   # Placa base y BIOS:
   sudo dmidecode -t baseboard
   sudo dmidecode -t bios

   # GPU:
   lspci | grep -i vga
   lshw -C display

   # Discos:
   lsblk
   sudo hdparm -I /dev/sda | grep "Model"

   # Dispositivos USB:
   lsusb

   # Adaptadores de red:
   lspci | grep -i network

**Resumen completo del hardware**:

.. code-block:: bash

   sudo lshw -short

2.2 Herramientas GUI (Linux)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- **Hardinfo** (``sudo apt install hardinfo``)
- **GNOME Disks** (para almacenamiento)
- **inxi** (``sudo apt install inxi`` y luego ``inxi -Fxz``)

3. macOS
-----------

3.1 Usando Informe del Sistema (GUI)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Haz clic en **Logo de Apple () > Acerca de esta Mac**.
2. Haz clic en **Informe del sistema** para detalles del hardware (USB, Thunderbolt, SATA, etc.).

3.2 Usando Terminal
~~~~~~~~~~~~~~~~~~~~~~~~~

Hardware general:

.. code-block:: bash

   system_profiler SPHardwareDataType

   # CPU:
   sysctl -n machdep.cpu.brand_string

   # GPU:
   system_profiler SPDisplaysDataType

   # Dispositivos USB:
   system_profiler SPUSBDataType

   # Thunderbolt:
   system_profiler SPThunderboltDataType

   # Discos:
   diskutil list

3.3 Herramientas de terceros (macOS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- **MacTracker** (para detalles de hardware Apple)
- **iStat Menus** (para monitorización en tiempo real)

Resumen
---------

+-----------+---------------------------------+----------------------------------------+
|   **SO**  |  **Mejor Comando/Herramienta**  |             **Ejemplo**                |
+===========+=================================+========================================+
| Windows   |    ``msinfo32``, ``wmic``       |      ``wmic diskdrive get model``      |
+-----------+---------------------------------+----------------------------------------+
|   Linux   |       ``lshw``, ``lspci``       |          ``sudo lshw -short``          |
+-----------+---------------------------------+----------------------------------------+
|   macOS   |       ``system_profiler``       | ``system_profiler SPHardwareDataType`` |
+-----------+---------------------------------+----------------------------------------+

Para **dispositivos USB externos**:

- Linux/macOS: ``lsusb``
- Windows: ``wmic path Win32_USBControllerDevice``
