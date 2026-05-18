Verificar si la placa base integra tarjeta gráfica (GPU)
==========================================================

Este documento explica cómo comprobar si una placa base tiene gráficos integrados en sistemas **Windows** y **Linux**.

--------------

Sistemas Windows
-------------------

Método 1: Administrador de dispositivos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Presiona :kbd:`Win + X` y selecciona **Administrador de dispositivos**.
2. Busca la sección **Adaptadores de pantalla**.
   - Si aparece un modelo (ej: *Intel HD Graphics*, *AMD Radeon Graphics*), hay GPU integrada.
   - Si solo muestra "Controlador de pantalla básica de Microsoft", no hay gráficos integrados o faltan drivers.

Método 2: Información del sistema (msinfo32)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Ejecuta :kbd:`Win + R`, escribe ``msinfo32`` y presiona :kbd:`Enter`.
2. Navega a:  

   **Componentes → Pantalla**.
   - Si hay datos en **Nombre del adaptador**, existe GPU integrada.

Método 3: Herramienta DXDiag
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Ejecuta :kbd:`Win + R`, escribe ``dxdiag`` y presiona :kbd:`Enter`.
2. Revisa la pestaña **Pantalla**:

   - El campo **Nombre** indica el modelo de GPU.

Método 4: Consultar modelo de placa base
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Abre :kbd:`cmd` y ejecuta:

   .. code-block:: bash
      
      wmic baseboard get product,Manufacturer

2. Busca el modelo en Google (ej: *"Asus B550M specs"*) para confirmar si incluye gráficos.

------------

Sistemas Linux
--------------

Método 1: Comando ``lspci``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Ejecuta en terminal:

   .. code-block:: bash
      
      lspci | grep -i vga

   - Si muestra una GPU (ej: *Intel UHD Graphics*), está integrada.
   - Sin salida = no hay GPU integrada.

Método 2: Verificar drivers activos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Instala herramientas (si es necesario):

   .. code-block:: bash
      
      sudo apt install mesa-utils # Debian/Ubuntu

2. Ejecuta:

   .. code-block:: bash
      
      glxinfo | grep "OpenGL renderer"

Método 3: Detalles de hardware
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Usa:

   .. code-block:: bash
      
      sudo lshw -C display

   o:
   
   .. code-block:: bash
      
      hwinfo --gfxcard

Método 4: Verificar CPU
~~~~~~~~~~~~~~~~~~~~~~~~~

1. Ejecuta:

   .. code-block:: bash
      
      lscpu | grep -i "model name"

2. Busca el modelo en:

   - `Intel ARK <https://ark.intel.com>`_
   - `AMD <https://www.amd.com>`_

------------

Notas importantes
-----------------

- **Intel**: CPUs **no** terminadas en *F* (ej: i3-12100) suelen incluir GPU (Intel UHD/IRIS).
- **AMD**: Modelos con *G* (ej: Ryzen 5 5600G) tienen gráficos integrados (Radeon Vega).
- **Placas base modernas**: Dependen de la CPU para gráficos integrados.

Si no se detecta GPU integrada, se requiere una tarjeta gráfica dedicada.
