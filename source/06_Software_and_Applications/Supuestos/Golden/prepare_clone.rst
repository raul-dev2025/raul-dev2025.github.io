====================================================
Script de Personalización: prepare_clone.sh
====================================================

:Propósito: Configuración *offline* del sistema de archivos del clon
:Herramienta Clave: ``libguestfs`` (guestmount)
:Seguridad: Inyección controlada de credenciales volátiles

Descripción
-----------
Este script realiza la "cirugía de disco" necesaria sobre el clon recién creado. Su función es modificar el sistema de archivos de la VM mientras esta permanece apagada, asegurando que al arrancar por primera vez, el nodo ya posea la configuración de red y las credenciales de enrolamiento necesarias.

Mecanismo de Inyección (Paso de Datos)
--------------------------------------
El script recibe el nombre del nodo y el OTP Token desde el orquestador y los inyecta en el directorio raíz del clon:

* **Archivo** ``/root/.new_name``: Almacena el hostname deseado.
* **Archivo** ``/root/.otp_token``: Almacena la clave temporal de FreeIPA.
* **Seguridad**: Ambos archivos se crean con permisos ``600`` y propiedad de ``root:root`` para evitar accesos no autorizados dentro del clon.

Procedimiento Técnico
---------------------

1. **Gestión de SELinux**:
   Aplica ``restorecon`` al archivo de disco y conmuta el host a modo ``Permissive`` temporalmente para permitir el montaje sin bloqueos de seguridad.

2. **Montaje del Sistema de Archivos**:
   Utiliza ``guestmount`` para mapear el disco de la VM en un directorio temporal del host (``/tmp/mount_[NAME]``).

3. **Configuración de Red (NetworkManager)**:
   Localiza el archivo ``.nmconnection`` original de la *Golden Image* y fuerza el uso del DNS del IdM (``192.168.17.39``), desactivando el DNS automático de DHCP para asegurar la resolución del Reino.

4. **Instalación de Componentes First-Boot**:
   * Copia el script de unión ``idm-join.sh`` a ``/usr/local/bin/``.
   * Instala el archivo de unidad de ``systemd`` (``idm-first-boot.service``).
   * Crea el enlace simbólico en ``multi-user.target.wants`` para disparar el proceso en el próximo arranque.

5. **Finalización**:
   Desmonta el sistema de archivos de forma segura y restaura las políticas de SELinux en el host.

Advertencias de Seguridad
-------------------------
* El script requiere privilegios de ``sudo`` para realizar el montaje y modificar archivos protegidos.
* La integridad del proceso depende de que el disco del clon no esté siendo utilizado por ningún otro proceso durante la ejecución.