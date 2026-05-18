============================================================
Informe de Configuración Base de la VM: ipa02
============================================================

:Fecha: 2026-02-24
:Autor: Gemini AI Colaborador
:Descripción: Resumen de pasos iniciales para preparar el sistema operativo.

Preparación del Sistema Operativo
=================================
Antes de iniciar la instalación de FreeIPA, se realizaron ajustes fundamentales en el entorno de Rocky Linux para asegurar la compatibilidad y conectividad.

1. Configuración de Identidad (Hostname)
----------------------------------------
Se estableció el nombre de host calificado para evitar conflictos con servicios de red y Kerberos.

.. code-block:: bash

   hostnamectl set-hostname ipa02.raulvilchez.org

2. Gestión de Repositorios y Paquetes
-------------------------------------
Se habilitaron los módulos necesarios para los servicios de identidad y se instalaron las herramientas de gestión.

.. code-block:: bash

   dnf install @idm:DL1
   dnf install freeipa-server ipa-server-dns -y

3. Seguridad y Firewall
-----------------------
Se abrieron los puertos críticos para la comunicación entre el Maestro y la Réplica (LDAP, Kerberos, DNS, HTTP/S).

.. code-block:: bash

   firewall-cmd --add-service={freeipa-ldap,freeipa-ldaps,dns,ntp,kerberos,kpasswd,http,https} --permanent
   firewall-cmd --reload

4. Persistencia de Credenciales
-------------------------------
Para facilitar la automatización y evitar la exposición de contraseñas en el historial de bash, se implementó un sistema de lectura de archivos.

* **Comando original:** ``read -sp "Contraseña de Admin: " IPA_PASS && echo ""``
* **Evolución:** Uso de un archivo protegido en ``/root/ipa_admin_password.txt`` con permisos restringidos (600).



Pasos de Saneamiento Recientes
==============================
Tras los fallos de instalación, se aplicaron correcciones manuales para "limpiar" la VM:

* **Limpieza de SSSD:** Eliminación de bases de datos corruptas en ``/var/lib/sss/db/``.
* **Estructura de Directorios:** Creación manual de ``/var/lib/ipa-client/pki`` para soportar los certificados del KDC.
* **Resolución de Nombres:** Limpieza del archivo ``/etc/hosts`` eliminando referencias antiguas a nombres tipo 'idm'.

Conclusión
==========
La VM ha pasado de una configuración estándar a un entorno endurecido y preparado específicamente para las particularidades de FreeIPA en Rocky Linux 9, superando las limitaciones de los scripts de instalación automáticos.