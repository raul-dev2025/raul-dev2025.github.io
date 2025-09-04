Creación de medios de instalación 
===================================

En Windows, la aplicación **Rufus** permite crear unidades USB de instalación o sistemas portátiles mediante "Windows To Go". En Linux, existen alternativas como Live USB persistentes o instalaciones completas en discos externos.

1. Proceso en Windows con Rufus (Windows To Go)
--------------------------------------------------

Requisitos:

- ISO de Windows (solo ediciones Enterprise o Education).
- USB 3.0+ o SSD externo (mínimo 32 GB recomendado).
- Rufus (https://rufus.ie/).

Pasos detallados:

1. Descargar e instalar Rufus desde su página oficial.
2. Conectar el dispositivo USB o SSD externo al computador.
3. Abrir Rufus y seleccionar el dispositivo en la lista de unidades.
4. En "Selección de imagen", hacer clic en "Elegir" y seleccionar la ISO de Windows.
5. En "Opciones de imagen", cambiar a "Windows To Go".
6. Verificar que el "Esquema de partición" coincida con el sistema destino (MBR para BIOS, GPT para UEFI).
7. Hacer clic en "Empezar" y esperar a que finalice el proceso.
8. Reiniciar el equipo y configurar la BIOS/UEFI para arrancar desde la unidad USB.

**Limitaciones**:

- Solo disponible para versiones Enterprise y Education de Windows
- Requiere hardware compatible certificado
- El rendimiento depende de la velocidad del medio de almacenamiento

2. Proceso en Linux
----------------------

Existen dos enfoques principales en Linux: Live USB con persistencia o instalación completa.

2.1. Live USB con Persistencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Permite ejecutar el sistema desde USB guardando configuraciones y archivos.

**Método 1**: Usando mkusb (recomendado para Ubuntu/Debian)

1. Instalar mkusb:
   ::
   
     sudo add-apt-repository ppa:mkusb/ppa
     sudo apt update
     sudo apt install mkusb

2. Ejecutar mkusb:
   ::
   
     sudo -H mkusb

3. Seleccionar "Persistent live" en el menú principal.
4. Elegir la imagen ISO del sistema Linux.
5. Seleccionar el dispositivo USB destino.
6. Configurar el espacio de persistencia (recomendado al menos 4GB).
7. Confirmar y esperar a que complete el proceso.

**Método 2**: Método manual con dd.

1. Identificar el dispositivo USB:
   ::
   
     lsblk

2. Grabar la imagen ISO (reemplazar ``/dev/sdX`` con tu dispositivo):
   ::
   
     sudo dd if=imagen.iso of=/dev/sdX bs=4M status=progress && sync

3. Crear partición persistente:

   a. Usar gparted o fdisk para crear nueva partición
   b. Formatear como ext4 con etiqueta "casper-rw"
   c. Para sistemas basados en Debian, también puede necesitarse una partición "writable"

2.2. Instalación completa en USB/SSD externo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Proceso similar a instalación normal pero en medio externo.

Pasos detallados:

1. Crear USB de instalación con cualquier método (Rufus, dd, etc.)
2. Arrancar desde el medio de instalación
3. Seleccionar "Instalar" en lugar de "Probar"
4. En el tipo de instalación, elegir "Algo más" para particionamiento manual
5. Seleccionar el dispositivo externo (ej: ``/dev/sdb``)
6. Crear particiones necesarias:

	.. code-block:: bash
	 
     - / (raíz)
     - swap (opcional)
     - /home (opcional)
   
7. IMPORTANTE: En "Dispositivo para instalar el gestor de arranque", seleccionar el mismo dispositivo externo (ej: ``/dev/sdb``)
8. Completar la instalación normalmente
9. Reiniciar y configurar BIOS/UEFI para arrancar desde el dispositivo externo

Herramientas alternativas para Linux
------------------------------------

Ventoy
~~~~~~
- Soporta múltiples ISOs en un mismo USB
- Permite persistencia configurable
- Sitio web: https://www.ventoy.net/

Instalación básica:

.. code-block:: bash

   # Descargar y extraer
   wget https://github.com/ventoy/Ventoy/releases/download/v1.0.88/ventoy-1.0.88-linux.tar.gz
   tar xvf ventoy-1.0.88-linux.tar.gz
   cd ventoy-1.0.88
  
   # Instalar en dispositivo
   sudo ./Ventoy2Disk.sh -i /dev/sdX

Balena Etcher
~~~~~~~~~~~~~
- Interfaz gráfica simple
- Multiplataforma
- Sitio web: https://www.balena.io/etcher/

UNetbootin
~~~~~~~~~~
- Soporta persistencia para Live USBs
- Disponible en repositorios

.. code-block:: bash

   sudo apt install unetbootin

Comparación de métodos
----------------------

+-------------------+---------------------+---------------------------+--------------------------------+
|       Método      |     Persistencia    |        Rendimiento        |    Casos de uso recomendados   |
+===================+=====================+===========================+================================+
|   Windows To Go   |       Completa      |       Bueno (con SSD)     |  Windows portable para trabajo |
+-------------------+---------------------+---------------------------+--------------------------------+
|     Live USB      | Parcial/Configurable|           Regular         |        Pruebas/reparación      |
+-------------------+---------------------+---------------------------+--------------------------------+
|     Instalación   |       Completa      |       Bueno (con SSD)     |   Uso diario sistema primario  |
|   completa en USB |                     |                           |                                |
+-------------------+---------------------+---------------------------+--------------------------------+

      
**Notas importantes**:

- Para mejores resultados con instalaciones completas, usar SSD externos USB 3.0+.
- La vida útil de USBs puede verse afectada por escrituras constantes.
- Algunas BIOS/UEFI pueden tener problemas para arrancar desde ciertos dispositivos.
