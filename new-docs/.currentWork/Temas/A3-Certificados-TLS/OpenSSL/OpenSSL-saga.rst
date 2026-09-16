================================
OpenSSL Certificado de Autoridad
================================

.. contents:: Índice de contenidos
   :depth: 2


Introducción
------------

Con este archivo, empezamos en TécnicoSistemas a trabajar en una serie de artículos para la gestión de certificados.

En anteriores entregas, habíamos hablado de la configuración TLS para máquinas virtuales con la librería Libvirt. Con esta nueva serie de artículos, pretendemos cubrir un uso más generalizado para este protocolo.

El método usado es prácticamente idéntico, cambiaremos algunas herramientas y hablaremos de otras normas o consejos de seguridad que se quedaron en el tintero.


Estructura del Directorio de la CA
----------------------------------

Para gestionar una Entidad de Certificación (CA) de manera ordenada y segura, es necesario establecer un directorio de trabajo estructurado y mantener los archivos de estado del sistema.

.. list-table:: Estructura de archivos de la CA
   :widths: 30 70
   :header-rows: 1

   * - Archivo / Directorio
     - Función
   * - ``private/``
     - Almacena la clave privada de la CA con permisos restringidos (``0700`` / ``0400``).
   * - ``certs/``
     - Almacena los certificados emitidos en formato PEM.
   * - ``newcerts/``
     - Copias de seguridad de los certificados firmados indexados por su número de serie.
   * - ``index.txt``
     - Base de datos en texto plano que registra el estado de los certificados (válido, revocado, expirado).
   * - ``serial``
     - Archivo de texto que contiene el siguiente número de serie hexadecimal a asignar.


Configuración de OpenSSL (``openssl.cnf``)
------------------------------------------

Antes de inicializar la CA, es fundamental preparar o ajustar el archivo de configuración general de OpenSSL.

Secciones principales de configuración:

.. list-table:: Secciones clave de ``openssl.cnf``
   :widths: 30 70
   :header-rows: 1

   * - Sección
     - Descripción
   * - ``[ ca ]``
     - Define la CA predeterminada que utilizará el comando ``openssl ca``.
   * - ``[ CA_default ]``
     - Especifica las rutas de directorios, ubicación del archivo ``index.txt``, ``serial`` y el algoritmo de resumen por defecto (p. ej., SHA-256).
   * - ``[ req ]``
     - Opciones por defecto para la generación de claves y solicitudes de firma de certificado (CSR).
   * - ``[ v3_ca ]``
     - Extensiones X.509v3 aplicadas al certificado de la propia CA (``basicConstraints = CA:TRUE``).
   * - ``[ v3_req ]``
     - Extensiones aplicadas a las solicitudes de certificados de servidor o cliente (p. ej., ``subjectAltName``).


Creación de la Entidad de Certificación Raíz (Root CA)
-------------------------------------------------------

1. Inicialización del Entorno
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   mkdir -p /root/ca/{certs,crt,newcerts,private}
   chmod 700 /root/ca/private
   touch /root/ca/index.txt
   echo 1000 > /root/ca/serial

2. Generación de la Clave Privada de la CA
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Se genera una clave RSA de 4096 bits cifrada mediante AES-256 para proteger el acceso no autorizado:

::

   openssl genrsa -aes256 -out /root/ca/private/ca.key.pem 4096
   chmod 400 /root/ca/private/ca.key.pem

3. Creación del Certificado Autofirmado de la CA
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   openssl req -config openssl.cnf -key /root/ca/private/ca.key.pem \
       -new -x509 -days 7300 -sha256 -extensions v3_ca \
       -out /root/ca/certs/ca.cert.pem

   chmod 444 /root/ca/certs/ca.cert.pem


Proceso de Emisión de Certificados
----------------------------------

Paso 1: Generar la Clave Privada y la CSR del Servidor
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   openssl genrsa -out /etc/ssl/private/servidor.key.pem 2048
   chmod 400 /etc/ssl/private/servidor.key.pem

   openssl req -config openssl.cnf -key /etc/ssl/private/servidor.key.pem \
       -new -sha256 -out /tmp/servidor.csr.pem

Paso 2: Firmar el Certificado con la CA
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La CA valida la solicitud CSR y emite el certificado firmado añadiendo las extensiones de servidor correspondientes:

::

   openssl ca -config openssl.cnf -extensions server_cert \
       -days 375 -notext -md sha256 \
       -in /tmp/servidor.csr.pem \
       -out /root/ca/certs/servidor.cert.pem


Verificación y Despliegue del Certificado
-----------------------------------------

Inspección del Certificado Emitido
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   openssl x509 -noout -text -in /root/ca/certs/servidor.cert.pem

Validación de la Cadena de Confianza
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   openssl verify -CAfile /root/ca/certs/ca.cert.pem /root/ca/certs/servidor.cert.pem


Recomendaciones de Seguridad para la CA
---------------------------------------

.. list-table:: Buenas prácticas de administración de la CA
   :widths: 30 70
   :header-rows: 1

   * - Práctica
     - Recomendación
   * - Aislamiento
     - La CA Raíz (*Root CA*) debe mantenerse fuera de línea (*offline*) o aislada de la red en entornos de producción.
   * - Subordinación
     - Emplear una CA Intermedia para la firma periódica de los certificados operativos de servicios.
   * - Control de Accesos
     - Establecer permisos ``0400`` en las claves privadas y restringir la ejecución mediante perfiles de ``sudo`` dedicados.
   * - Vigencia Reducida
     - Limitar la validez de los certificados finales a períodos no superiores a 397 días para alinearse con los estándares web vigentes.
   * - Listas de Revocación (CRL)
     - Generar y mantener publicadas periódicamente las listas de revocación CRL para invalidar certificados comprometidos.


Referencias
-----------

* `OpenSSL Official Documentation <https://www.openssl.org/docs/>`_
* `Arch Linux Wiki - OpenSSL / Creating a CA <https://wiki.archlinux.org/title/OpenSSL>`_
* `OpenSSL PKI Tutorial <https://pki-tutorial.readthedocs.io/>`_