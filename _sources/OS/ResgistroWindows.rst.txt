El Registro de Windows: Guía Básica y Ejemplo Práctico
==========================================================

¿Qué es el Registro de Windows?
-------------------------------
El Registro de Windows es una base de datos jerárquica que almacena configuraciones del sistema operativo, aplicaciones y usuarios. Contiene información crítica para el funcionamiento de Windows.

Estructura Básica
-----------------
El Registro se organiza en **claves raíz** (hives) principales:

- ``HKEY_CLASSES_ROOT (HKCR)``: Asociaciones de archivos y COM.
- ``HKEY_CURRENT_USER (HKCU)``: Configuraciones del usuario actual.
- ``HKEY_LOCAL_MACHINE (HKLM)``: Configuraciones globales del sistema.
- ``HKEY_USERS (HKU)``: Todos los perfiles de usuarios.
- ``HKEY_CURRENT_CONFIG (HKCC)``: Configuración de hardware actual.

Cómo Acceder al Registro
------------------------
1. Abre el Editor del Registro (``regedit.exe``):
   - Presiona ``Win + R``, escribe ``regedit`` y presiona Enter.

Ejemplo Práctico: Deshabilitar el Menú Inicio
---------------------------------------------
1. Navega a:

   ::
      HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer

2. Crea un nuevo valor ``DWORD (32-bit)`` llamado ``NoStartMenu``.
3. Establece su valor a ``1`` para deshabilitar el Menú Inicio.
4. Reinicia el sistema para aplicar los cambios.

Precauciones
------------
- **Siempre haz una copia de seguridad** antes de modificar el Registro.
- Exporta una clave antes de editarla (``Archivo > Exportar``).
- Los cambios incorrectos pueden inestabilizar el sistema.

-----

.. todo

.. Error al apuntar una carpeta de usuario a su ubicación de destino.

.. Al cambiar la ubicación de la carpeta documentos y pasarla a una partición de disco no creó una carpeta documento, en lugar de seleccionar una carpeta seleccionó el disco.

.. Para solucionar el problema se corrige el error con el registro de windows, en :
..    Equipo\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
.. Doble click en el nombre de registo "Persnal" y volvemos a definir la ruta a la carpeta por ``Documentos`` cambiando ``información del valor``.



.. Guardar el registro antes de hacer ningún cambio.

.. como arrancar el sistema llamando a un punto de restauración.
