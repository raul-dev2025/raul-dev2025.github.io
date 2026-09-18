==========================================
Comprobación y Supervisión de Certificados
==========================================

.. contents:: Índice de contenidos
   :depth: 2


Sistemas Linux
--------------

Verificación con OpenSSL
^^^^^^^^^^^^^^^^^^^^^^^^

Con la herramienta ``openssl`` se puede verificar la procedencia y validez de un determinado certificado respecto a una Entidad de Certificación (*CA*):

::

   openssl verify -verbose -CAfile cacert.pem server.crt

Para consultar la información detallada de un certificado en formato PEM:

::

   openssl x509 -in server.crt -text -noout

Verificación mediante el almacén del sistema:

::

   trust list
   openssl verify -CAfile /etc/pki/tls/certs/ca-bundle.crt server.crt


Sistemas macOS (Macintosh)
--------------------------

Interfaz Gráfica
^^^^^^^^^^^^^^^^

En macOS, la gestión y supervisión de certificados se realiza a través de la aplicación **Acceso a Llaveros** (*Keychain Access*), ubicada en ``/System/Applications/Utilities/Keychain Access.app``.

Línea de Comandos (Herramienta ``security``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para verificar la validez de un certificado desde la terminal:

::

   security verify-cert -c server.crt -p ssl

Para listar todos los certificados instalados en el llavero del sistema:

::

   security find-certificate -a /Library/Keychains/System.keychain

Para añadir un certificado CA de confianza al almacén del sistema:

::

   sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain cacert.pem


Sistemas Windows
----------------

Herramientas de Gestión
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table:: Herramientas de administración de certificados en Windows
   :widths: 30 70
   :header-rows: 1

   * - Herramienta
     - Descripción
   * - ``certmgr.msc``
     - Consola de gestión gráfica para los certificados del usuario actual (``Current User``).
   * - ``certlm.msc``
     - Consola de gestión gráfica para el almacén de la máquina local (``Local Machine``).
   * - ``mmc.exe``
     - Consola MMC donde se puede agregar el complemento (*snap-in*) de "Certificados" para cualquier ámbito.
   * - ``certutil.exe``
     - Herramienta CLI nativa para administración, verificación y diagnóstico profundo del servicio de certificados.
   * - ``sigcheck.exe``
     - Utilidad de Sysinternals para comprobar la validez de las CAs y detectar certificados no reconocidos.


Uso de ``certutil``
^^^^^^^^^^^^^^^^^^^

Desde una consola de comandos (``cmd``) con privilegios de administrador, se puede comprobar la conectividad y el estado de una CA:

::

   C:\> certutil -config - -ping

Para verificar la cadena de confianza completa de un certificado descargando listas CRL y datos AIA:

::

   C:\> certutil -verify -urlfetch certificado.crt

Para volcar el contenido del almacén de Entidades de Certificación Raíz de confianza:

::

   C:\> certutil -store Root


Uso de Sigcheck (Sysinternals)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para comprobar la lista de CAs instaladas frente al programa de certificados raíz de confianza de Microsoft:

::

   C:\> sigcheck.exe -tv


Gestión mediante PowerShell
^^^^^^^^^^^^^^^^^^^^^^^^^^^

PowerShell permite inspeccionar el almacén del sistema navegando por la unidad de proveedor ``Cert:``:

::

   Get-ChildItem -Path Cert:\LocalMachine\Root
   Get-ChildItem -Path Cert:\CurrentUser\My


Almacenes de Certificados en Windows
------------------------------------

.. list-table:: Tipos de almacenes de certificados
   :widths: 30 70
   :header-rows: 1

   * - Almacén
     - Ámbito de aplicación
   * - ``Local Machine``
     - Configuración global aplicable a todos los usuarios y servicios del equipo.
   * - ``Current User``
     - Específico para el perfil del usuario activo en la sesión.
   * - ``Enterprise``
     - Centralizado en Active Directory y distribuido a los equipos del dominio mediante directivas de grupo (GPO).


Actualización de Listas CTL (Certificate Trust List)
----------------------------------------------------

Windows actualiza dinámicamente las listas de certificados raíz de confianza (*Trust List*) y de certificados revocados realizando peticiones HTTP (puerto 80) a los servidores de Microsoft:

* Punto de conexión CTL: ``http://ctldl.windowsupdate.com``

Este mecanismo automático descarga las listas CTL firmadas periódicamente para actualizar las CA de confianza bajo demanda sin requerir la instalación manual de parches del sistema.