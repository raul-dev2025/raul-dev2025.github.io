Información del Sistema relacionada con UEFI usando PowerShell
=================================================================

Este documento describe cómo obtener información sobre el firmware y el modo de arranque del sistema (UEFI o BIOS) utilizando PowerShell en Windows.

1. Comprobar si el sistema usa UEFI o BIOS
---------------------------------------------

Puedes determinar si el sistema está arrancando en modo UEFI, BIOS o UEFI con CSM usando el siguiente comando:

.. code-block:: powershell

   (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\").PEFirmwareType

Los valores posibles son:

- ``0``: BIOS
- ``1``: UEFI
- ``2``: UEFI con CSM (Compatibility Support Module)

Para mostrar una descripción legible:

.. code-block:: powershell

   switch ((Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\").PEFirmwareType) {
       0 { "BIOS" }
       1 { "UEFI" }
       2 { "UEFI con CSM" }
       default { "Desconocido" }
   }

2. Obtener detalles del firmware (BIOS/UEFI)
-----------------------------------------------

Para consultar el fabricante, versión y fecha del firmware:

.. code-block:: powershell

   Get-WmiObject -Class Win32_BIOS | Format-List Manufacturer, SMBIOSBIOSVersion, ReleaseDate

3. Verificar si el disco de sistema utiliza GPT (UEFI) o MBR (BIOS)
----------------------------------------------------------------------

El siguiente comando muestra el estilo de partición del disco del sistema operativo:

.. code-block:: powershell

   Get-Disk | Where-Object IsSystem -eq $true | Select-Object Number, PartitionStyle

- ``GPT``: Usualmente indica una instalación en modo UEFI.
- ``MBR``: Generalmente indica BIOS.

4. Script completo de diagnóstico UEFI
-----------------------------------------

Este script combina todas las verificaciones anteriores y presenta un resumen:

.. code-block:: powershell

   Write-Host "== Modo de arranque (UEFI/BIOS) =="
   switch ((Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\").PEFirmwareType) {
       0 { "BIOS" }
       1 { "UEFI" }
       2 { "UEFI con CSM" }
       default { "Desconocido" }
   }

   Write-Host "`n== Información del BIOS =="
   Get-WmiObject -Class Win32_BIOS | Format-List Manufacturer, SMBIOSBIOSVersion, ReleaseDate

   Write-Host "`n== Estilo de partición del disco del sistema =="
   Get-Disk | Where-Object IsSystem -eq $true | Select-Object Number, PartitionStyle

Opcionalmente, puedes redirigir esta salida a un archivo para generación de informes.
