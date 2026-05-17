==========================================================
Informe de Purificación: Imagen Maestra GOLDEN_ROCKY10_IDM
==========================================================

:Proyecto: Raúl Vílchez
:Estado: Certificada para Clonación
:Fecha: 19 de marzo de 2026
:SO de Referencia: Rocky Linux 10

Descripción General
===================

Este documento detalla el procedimiento de saneamiento aplicado a la máquina virtual maestra para garantizar que cada instancia clonada genere identidades únicas, evite conflictos de red y mantenga una auditoría limpia desde el primer arranque.

Fases del Proceso de Saneamiento
================================

1. Gestión de Identidades Locales
---------------------------------
Se ha procedido a renombrar el usuario administrador local para evitar colisiones con las cuentas del dominio IdM (IPA).

* **Usuario de origen:** ``admin`` (UID 1000)
* **Usuario de destino:** ``maint``
* **Acciones realizadas:**
    * Renombrado de login y grupo principal. Renombre del usuario administrador local para evitar colisiones con el usuario ``admin`` del IdM.
    * Migración del directorio ``/home/admin`` a ``/home/maint``.
    * Verificación de persistencia de UID/GID.


.. code-block:: bash

   # Renombrar login y grupo principal
   usermod -l maint admin
   groupmod -n maint admin
   # Migrar directorio home y confirmar
   usermod -d /home/maint -m maint
   cat /etc/passwd | grep maint

2. Reset de Identidad de Máquina
--------------------------------
Para evitar duplicidad de identificadores en el inventario del servidor Maestro (IdM), se han eliminado los IDs únicos del sistema operativo.

* **Machine-ID:** Se ha vaciado ``/etc/machine-id`` (0 bytes) para forzar la regeneración por parte de *systemd* en el próximo arranque.
* **D-Bus:** Se ha vinculado el ID de D-Bus al archivo maestro de la máquina.
* **SSH:** Eliminación de todas las llaves de host (``ssh_host_*``) para garantizar que cada clon genere su propia huella digital criptográfica.

Eliminación de identificadores únicos para forzar su regeneración en el primer arranque de cada clon.

.. code-block:: bash

   # Resetear machine-id del sistema y D-Bus
   truncate -s 0 /etc/machine-id
   rm -f /var/lib/dbus/machine-id
   ln -s /etc/machine-id /var/lib/dbus/machine-id
   # Eliminar llaves de host SSH
   rm -f /etc/ssh/ssh_host_*


3. Limpieza de Capa de Red
--------------------------
Se han eliminado los rastros de hardware específicos para asegurar la portabilidad de la imagen entre diferentes nodos del hipervisor.

* **NetworkManager:** Eliminación de perfiles de conexión persistentes y archivos ``.nmconnection``.
* **Udev:** Borrado de reglas de persistencia de interfaces (``70-persistent-net.rules``).
* **Hostname:** Persistencia del nombre de host ``golden-idm`` para identificación de origen.

Eliminación de rastros de hardware (MAC) y perfiles de red específicos.

.. code-block:: bash

   # Borrar conexiones persistentes de NetworkManager
   rm -f /etc/NetworkManager/system-connections/*.nmconnection
   # Limpiar reglas udev y timestamps
   rm -f /etc/udev/rules.d/70-persistent-net.rules
   rm -f /var/lib/NetworkManager/timestamps
   # Mantener hostname de referencia
   hostnamectl set-hostname golden-idm


4. Higiene de Datos y Logs
--------------------------
Saneamiento del sistema de archivos para eliminar el historial de configuración y optimizar el tamaño del disco virtual.

* **Logs:** Vaciado de ``journalctl`` y truncado de archivos en ``/var/log/``.
* **DNF:** Limpieza completa de metadatos y caché de paquetes para reducir el espacio en disco.
* **Historial:** Borrado total del historial de comandos de Bash.

Vaciado de registros y limpieza de caché de paquetes.

.. code-block:: bash

   # Vaciar Journal de Systemd y archivos de log
   journalctl --vacuum-time=1s
   find /var/log -type f -exec truncate -s 0 {} \;
   # Limpiar caché de DNF
   dnf clean all
   # Borrar historial de comandos (último paso)
   history -c && history -w


5. Cierre de Seguridad
----------------------
Bloqueo de vectores de acceso directo para forzar el uso de escalada de privilegios controlada.

* **Root:** Cuenta bloqueada mediante ``passwd -l root``. El acceso administrativo queda delegado exclusivamente al usuario ``maint`` vía ``sudo``.

Bloqueo de la cuenta de superusuario tras la configuración.

.. code-block:: bash

   # Bloqueo de contraseña de Root
   sudo passwd -l root



Estado Final
============

La imagen se encuentra en estado **apagado consistente**. Está preparada para ser convertida en **Template** o para la creación de **Snapshots** de despliegue masivo.

.. note:: 
   Cualquier arranque posterior de esta imagen maestra sin el script de "First Boot" regenerará los IDs, requiriendo repetir el proceso de purificación.

.. important:: 
   Al primer arranque de un clon basado en esta imagen, se recomienda ejecutar el script de integración al reino ``RAULVILCHEZ.ORG``.