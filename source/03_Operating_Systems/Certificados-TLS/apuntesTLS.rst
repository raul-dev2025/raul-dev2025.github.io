=====================================================
Apuntes sobre Protocolo TLS y Gestión de Certificados
=====================================================

.. contents:: Índice de contenidos
   :depth: 2

Gestión Centralizada de Certificados (Fedora / RHEL)
====================================================

Fedora utiliza un sistema de gestión de certificados llamado ``SharedSystemCertificates`` para proveer un almacén de certificados centralizado en el sistema.

Aplicaciones como Firefox prestan atención a este almacén central, aunque algunas aplicaciones gestionan sus certificados de forma independiente (como herramientas con almacenes NSS propios o librerías específicas).

Desgraciadamente, como el *software* puede escoger la manera de gestionar los certificados, es necesaria la adopción de la característica ``Fedora enforcing`` y ser diligentes si queremos que nuestro sistema haga uso de él.

Estructura de Directorios del Almacén Central
---------------------------------------------

Las rutas principales utilizadas por el subsistema ``ca-certificates`` son:

.. list-table:: Directorios del sistema de confianza
   :widths: 40 60
   :header-rows: 1

   * - Ruta
     - Propósito
   * - ``/etc/pki/ca-trust/source/anchors/``
     - Certificados CA de confianza añadidos por el administrador.
   * - ``/etc/pki/ca-trust/source/blacklist/``
     - Certificados explícitamente revocados o aislados.
   * - ``/etc/pki/tls/certs/ca-bundle.crt``
     - *Bundle* consolidado generado automáticamente para OpenSSL.


Procedimiento para Aislar (*Blacklisting*) Certificados No Deseados
-------------------------------------------------------------------

Históricamente o de forma manual, se han utilizado enlaces simbólicos directos hacia la ruta de *blacklist*:

::

   $ for f in /etc/ssl/certs/*.pem; do sudo ln -sfn "$f" /etc/ca-certificates/trust-source/blacklist/; done
   $ update-ca-trust

Para verificar los recuentos de certificados presentes y aislados:

::

   $ sudo rm DigiCert_* GeoTrust_* Go_Daddy_* GlobalSign_* VeriSign_* StartCom_Certification_Authority* Comodo_* AddTrust_* Thawte_* thawte_Primary_Root_CA* Baltimore_CyberTrust_Root.pem UTN_USERFirst_Hardware_Root_CA.pem Visa_eCommerce_Root.pem

   $ ls /etc/ssl/certs/*.pem | wc -l
   206
   $ ls /etc/ca-certificates/trust-source/blacklist/ | wc -l
   163

Procedimiento estándar para descargar y aislar un certificado remoto:

::

   $ < /dev/null openssl s_client -showcerts -connect www1.cnnic.cn:https > ccnic
   # mv ccnic /etc/pki/ca-trust/source/blacklist/
   # update-ca-trust extract

Es necesario reiniciar la aplicación (por ejemplo, Firefox) para que recargue el almacén actualizado por ``SharedSystemCertificates``.


Diagnóstico e Inspección con OpenSSL
====================================

Inspección de Certificados Locales
----------------------------------

Para verificar el contenido, fechas de validez e emisor de un archivo PEM:

::

   $ openssl x509 -in certificado.crt -text -noout

Verificación de Conexiones TLS Remotas
--------------------------------------

Para comprobar la cadena de certificados devuelta por un servidor web:

::

   $ openssl s_client -connect dominio.com:443 -servername dominio.com -CAfile /etc/pki/tls/certs/ca-bundle.crt


Fundamentos del Protocolo TLS
=============================

Versiones del Protocolo
-----------------------

.. list-table:: Comparativa de versiones TLS
   :widths: 20 80
   :header-rows: 1

   * - Versión
     - Estado y Características
   * - TLS 1.2
     - Soporta algoritmos de cifrado auténtico (AEAD). Se encuentra obsoleto en configuraciones de alta seguridad si utiliza intercambios de clave no efímeros.
   * - TLS 1.3
     - Estándar actual. Reduce la latencia de negociación a 1-RTT, elimina cifradores inseguros y obliga el uso de Secreto Perfecto Hacia Adelante (PFS).


Políticas de Cifrado en Fedora (Crypto-Policies)
------------------------------------------------

Fedora permite definir el nivel de seguridad criptográfica global para todas las aplicaciones del sistema mediante el comando ``update-crypto-policies``:

::

   # update-crypto-policies --show
   # update-crypto-policies --set FUTURE

.. list-table:: Niveles de Crypto-Policies
   :widths: 20 80
   :header-rows: 1

   * - Política
     - Descripción
   * - ``DEFAULT``
     - Nivel equilibrado entre compatibilidad y seguridad.
   * - ``LEGACY``
     - Permite algoritmos antiguos (como TLS 1.0/1.1) para sistemas heredados.
   * - ``FUTURE``
     - Desactiva algoritmos débiles y exige parámetros criptográficos de alta resistencia.


Referencias y Fuentes
=====================

* `Documentación oficial de Red Hat / Fedora sobre ``ca-certificates`` y ``update-crypto-policies`` <https://ask.fedoraproject.org/en/question/66484/how-to-blacklist-a-specific-ca-certificate/>`_