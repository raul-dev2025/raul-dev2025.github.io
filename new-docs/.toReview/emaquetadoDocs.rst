=============================================================
Guía de Empaquetado y Despliegue de Documentación en Python
=============================================================

Esta guía describe el flujo de trabajo estandarizado para compilar documentación estática en un paquete ejecutable redistribuible de Python (``.whl``) y configurar sus correspondientes herramientas de automatización para el despliegue y desinstalación en entornos Windows.

Fase 1: Configuración del Archivo de Construcción
=================================================

El proceso se basa en un archivo ``setup.py`` dinámico encargado de rastrear recursivamente los artefactos generados (por ejemplo, por Sphinx) e indexarlos como datos internos del paquete.

.. code-block:: python

   from setuptools import setup
   import os

   def find_build_files(directory):
       paths = []
       for (path, directories, filenames) in os.walk(directory):
           for filename in filenames:
               rel_path = os.path.relpath(os.path.join(path, filename), directory)
               paths.append(rel_path)
       return paths

   build_dir = 'build/NombrePaquete/html'
   html_files = find_build_files(build_dir)

   setup(
       name='nombre_paquete_docs',
       version='1.0.0',
       description='Paquete de documentación HTML generada por Sphinx',
       author='Raúl Vílchez',
       packages=['nombre_paquete_docs'],
       package_dir={'nombre_paquete_docs': build_dir},
       package_data={
           'nombre_paquete_docs': html_files,
       },  
   )

Fase 2: Secuencia de Empaquetado y Validación Local
=====================================================

Ejecute la siguiente secuencia de comandos en la consola de comandos dentro del entorno virtual de desarrollo para limpiar residuos previos, compilar el binario y verificar su integridad estructural:

1. **Instalar dependencias de construcción:**
   Garantiza que las herramientas de empaquetado se encuentren actualizadas en el entorno.

   .. code-block:: bash

      pip install build setuptools

2. **Limpieza de artefactos previos:**
   Elimina directorios residuales y metadatos corruptos antes de una nueva compilación.

   .. code-block:: bash

      rm -rf dist/ nombre_paquete_docs.egg-info/

3. **Compilación del paquete Wheel:**
   Construye de forma directa el paquete binario (``.whl``) sin aislamiento de entorno.

   .. code-block:: bash

      python setup.py bdist_wheel

4. **Instalación de validación:**
   Fuerza la instalación limpia del paquete generado para testearlo localmente.

   .. code-block:: bash

      pip install dist/nombre_paquete_docs-1.0.0-py3-none-any.whl --force-reinstall

5. **Auditoría de archivos internos:**
   Inspecciona el árbol detallado de ficheros desplegados en el disco para verificar que no falte ningún recurso HTML o estático.

   .. code-block:: bash

      pip show -f nombre-paquete-docs

6. **Limpieza del entorno:**
   Remueve el paquete del entorno local tras concluir la verificación.

   .. code-block:: bash

      pip uninstall nombre-paquete-docs -y

Fase 3: Infraestructura de Despliegue Automatizado
===================================================

Para distribuir el paquete a los usuarios finales mediante dispositivos de almacenamiento (como discos virtuales o unidades USB), se utiliza una arquitectura combinada de scripts en lotes (``.cmd``) y PowerShell (``.ps1``).

Estructura del Repositorio de Distribución
------------------------------------------

.. code-block:: text

   📦 Raíz del Dispositivo (D:\)
    ├── 📄 instalar.cmd                 # Lanzador principal de doble clic (ANSI)
    ├── 📄 desinstalador.cmd            # Lanzador de desinstalación (ANSI)
    └── 📁 NombrePaquete
         ├── 📄 installer.ps1           # Script lógico de instalación
         ├── 📄 desinstalar.ps1         # Script lógico de desinstalación
         └── 📦 nombre_paquete_docs-1.0.0-py3-none-any.whl


Lógica Interna del Instalador (`installer.ps1`)
----------------------------------------------------

Este script es el núcleo del despliegue en la máquina destino. Se encarga de aislar el entorno mediante Python ``venv``, interactuar con el intérprete local para extraer la ruta dinámica del directorio ``site-packages`` una vez montado el paquete, y automatizar la creación del acceso directo multiplataforma en el escritorio del usuario final apuntando al archivo base ``index.html``.

.. code-block:: powershell

   # ==============================================================================
   # SCRIPT DEFINITIVO DE DESPLIEGUE AUTOMóTICO DE DOCUMENTACIóN
   # ==============================================================================
   # Destino: Windows 10 (Entorno Limpio)
   # Función: Crear venv, instalar wheel y generar lanzador directo en Escritorio.
   # ==============================================================================

   # Parametro que recibe la ruta dinamica del pendrive
   param (
      [string]$UsbPath
   )

   $ErrorActionPreference = "Stop"

   # Si se ejecuta suelto, toma la ruta del script
   if (-not $UsbPath) { $UsbPath = Split-Path -Parent $MyInvocation.MyCommand.Path }

   # 1. Definición de rutas lógicas
   $BaseDir     = "C:\NombrePaquete"
   $VenvName    = ".env"
   $VenvPath    = Join-Path $BaseDir $VenvName

   # El .whl se busca dinamicamente en la carpeta NombrePaquete del USB
   $WheelFile   = Join-Path $UsbPath "NombrePaquete\nombre_paquete_docs-1.0.0-py3-none-any.whl"
   $DesktopPath = [Environment]::GetFolderPath("Desktop")

   Write-Host "[+] Iniciando despliegue de infraestructura local..." -ForegroundColor Cyan

   # 2. Creación del entorno virtual si no existe
   if (-not (Test-Path $VenvPath)) {
      Write-Host "[+] Creando entorno virtual aislado de Python..." -ForegroundColor Green
      python -m venv $VenvPath
   }

   # 3. Instalación silenciosa del paquete Wheel (.whl)
   Write-Host "[+] Instalando paquete de documentación estótica en el bónquer..." -ForegroundColor Green
   #$PythonExe = Join-Path $VenvPath "Scripts\python.exe"
   #Start-Process -FilePath $PythonExe -ArgumentList "-m", "pip", "install", "`"$WheelFile`"", "--quiet", "--no-warn-script-location" -Wait -NoNewWindow

   # 4. Obtener de forma dinómica la ruta absoluta de instalación en site-packages
   Write-Host "[+] Extrayendo rutas fósicas del paquete..." -ForegroundColor Green
   $PythonExe = Join-Path $VenvPath "Scripts\python.exe"
   $PkgPath = & $PythonExe -c "import nombre_paquete_docs; print(nombre_paquete_docs.__path__[0])"
   $IndexHtml = Join-Path $PkgPath.Trim() "index.html"

   # 5. Automatización del Lanzador del Escritorio (Acceso directo limpio)
   Write-Host "[+] Creando lanzador directo en el Escritorio del usuario..." -ForegroundColor Green
   $WshShell = New-Object -ComObject WScript.Shell
   $ShortcutPath = Join-Path $DesktopPath "Nombre enlace.lnk"
   $Shortcut = $WshShell.CreateShortcut($ShortcutPath)

   # Apuntamos directamente a MS Edge pasóndole la ruta del archivo index.html local
   $Shortcut.TargetPath = "cmd.exe"
   $Shortcut.Arguments  = "/c start `"`" `"$IndexHtml`""
   $Shortcut.Description = "Abrir la documentación de la Nombre paquete en el navegador"
   $Shortcut.IconLocation = "shell32.dll, 14"
   $Shortcut.Save()

   # Desbloque del archivo generado
   Unblock-File -Path (Join-Path $DesktopPath "Nombre enlace.lnk")

   Write-Host "`n[ok] Despliegue completado con éxito!" -ForegroundColor Yellow
   Write-Host "[i] Ya puedes cerrar la consola y hacer doble clic en 'Nombre enlace' en el Escritorio." -ForegroundColor Cyan


Código del Lanzador Automatizado (`instalar.cmd`)
-------------------------------------------------

Este archivo debe guardarse estrictamente con codificación **ANSI** o **UTF-8 sin BOM** para evitar errores de interpretación en la consola de Windows.

.. code-block:: cmd

   @echo off
   title Instalador - Documentacion Nombre Paquete
   echo [+] Iniciando el asistente de instalacion...

   :: 1. Comprobar si existe el entorno virtual; si no, delegar en PowerShell su creación
   if not exist "C:\NombrePaquete\.env\Scripts\python.exe" PowerShell -ExecutionPolicy Bypass -File "%~dp0NombrePaquete\installer.ps1" -UsbPath "%~dp0" >nul 2>&1

   :: 2. Instalar el paquete de forma nativa desde CMD para mitigar conflictos de parseo de tokens
   "C:\NombrePaquete\.env\Scripts\python.exe" -m pip install "%~dp0NombrePaquete\nombre_paquete_docs-1.0.0-py3-none-any.whl" --quiet --no-warn-script-location

   :: 3. Invocar la fase final de PowerShell para la extracción de rutas y generación del acceso directo
   PowerShell -ExecutionPolicy Bypass -File "%~dp0NombrePaquete\installer.ps1" -UsbPath "%~dp0"

   echo.
   echo [=] Proceso finalizado. Ya puede usar el acceso directo del Escritorio.
   pause

Código del Desinstalador Automatizado (`desinstalar.cmd`)
---------------------------------------------------------

.. code-block:: cmd

   @echo off
   title Desinstalador - Documentacion Nombre Paquete
   echo [+] Iniciando el proceso de desinstalacion...

   PowerShell -ExecutionPolicy Bypass -File "%~dp0NombrePaquete\desinstalar.ps1"

   echo.
   echo [✔] Limpieza realizada con exito.
   pause

Lógica Interna del Desinstalador (`desinstalar.ps1`)
----------------------------------------------------

Este script elimina de forma segura la infraestructura local creada y remueve el acceso directo generado en el escritorio del usuario.

.. code-block:: powershell

   # Eliminación de infraestructura local y acceso directo del escritorio
   Remove-Item -Recurse -Force "C:\NombrePaquete" -ErrorAction SilentlyContinue
   Remove-Item -Force (Join-Path ([Environment]::GetFolderPath("Desktop")) "Nombre Paquete.lnk") -ErrorAction SilentlyContinue