======================================
Ataques Man-in-the-Middle (MitM) y TLS
======================================

.. contents:: Índice de contenidos
   :depth: 2


Concepto y Funcionamiento de MitM
---------------------------------

El ataque *Man-in-the-Middle* (MitM), también conocido como *Person-in-the-Middle* (PitM) o "hombre en el medio", ocurre cuando un tercero no autorizado intercepta la comunicación entre dos partes (habitualmente un cliente y un servidor).

En un entorno cifrado mediante SSL/TLS, el objetivo del atacante es situarse entre el cliente y el servidor legítimo para:

1. Interceptar el proceso de negociación TLS (*handshake*).
2. Sustituir las claves y certificados legítimos presentados por el servidor por claves y certificados propios (*falsos*).
3. Establecer dos conexiones cifradas independientes y separadas:
   
   * Una sesión entre el cliente y el atacante (donde el atacante suplanta al servidor real).
   * Otra sesión entre el atacante y el servidor real (donde el atacante actúa como si fuera el cliente).

De este modo, el tráfico cifrado enviado por el cliente es descifrado por el atacante utilizando sus propias claves, lo que le permite leer, registrar o modificar el contenido de los mensajes antes de volver a cifrarlos y retransmitirlos al servidor de destino.


Validación del Certificado del Servidor
---------------------------------------

Para prevenir los ataques MitM, las aplicaciones cliente (navegadores web, clientes HTTP, aplicaciones móviles) deben realizar comprobaciones rigurosas sobre el certificado presentado por el servidor.

Validación del Nombre de Dominio (SAN / CN)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El cliente debe verificar que el nombre de dominio al que intenta conectarse coincida exactamente con el nombre especificado en el certificado digital del servidor:

* **Subject Alternative Name (SAN):** Extensión estándar moderna que especifica todos los dominios y subdominios para los que es válido el certificado.
* **Common Name (CN):** Campo histórico (obsoleto en estándares recientes) que contenía el nombre de dominio principal.

Si el nombre de dominio solicitado no coincide con los campos SAN o CN del certificado, la aplicación cliente debe abortar inmediatamente la conexión e informar del error de seguridad.

Verificación de la Cadena de Confianza
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El certificado debe estar firmado por una Autoridad de Certificación (*CA*) reconocida y presente en el almacén de confianza del sistema o de la aplicación.


Tipos de Intercepción y Ataques Comunes
---------------------------------------

.. list-table:: Clasificación de ataques e intercepción MitM
   :widths: 30 70
   :header-rows: 1

   * - Técnica
     - Descripción
   * - Suplantación de DNS / ARP
     - Redirección del tráfico IP del cliente hacia un servidor bajo control del atacante mediante envenenamiento de tablas ARP o caché DNS.
   * - Certificados Falsos / Maliciosos
     - Uso de un certificado emitido por una CA no confiable o por una CA raíz maliciosa instalada previamente en el dispositivo cliente.
   * - Degradación de Protocolo (*Downgrade Attack*)
     - Manipulación de la negociación inicial para forzar el uso de versiones obsoletas o débiles de SSL/TLS (p. ej., ataques POODLE o FREAK).
   * - Intercepción TLS Corporativa
     - Inspección de tráfico en entornos empresariales mediante la instalación de un certificado CA raíz corporativo en los equipos administrados.


Mecanismos de Protección y Mitigación
--------------------------------------

Para evitar o mitigar la efectividad de los ataques MitM se aplican las siguientes medidas:

* **HSTS (HTTP Strict Transport Security):** Cabecera HTTP que obliga al navegador a comunicarse exclusivamente mediante HTTPS, previniendo ataques de degradación a HTTP sin cifrar.
* **Certificate Pinning (Vinculación de Certificados):** Técnica en aplicaciones cliente que valida la clave pública o el certificado esperado contra una huella digital (*hash*) incrustada en el código.
* **Certificate Transparency (CT):** Registro público auditable de todos los certificados emitidos por CAs para detectar emisiones no autorizadas o fraudulentas.
* **Desactivación de Cifrados Obsoletos:** Configurar el servidor para admitir exclusivamente versiones TLS 1.2 y TLS 1.3 con algoritmos de cifrado auténtico (AEAD) y Secreto Perfecto Hacia Adelante (PFS).


Diagnóstico y Simulación de Intercepción
-----------------------------------------

Verificación manual con OpenSSL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Se puede comprobar la cadena de certificados que entrega un servidor y verificar el campo SAN/CN mediante el comando:

::

   openssl s_client -connect dominio.com:443 -servername dominio.com

Herramientas para Análisis e Inspección
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* **mitmproxy:** Herramienta en consola e interfaz web para interceptar, inspeccionar y modificar tráfico HTTP/HTTPS.
* **Wireshark:** Analizador de paquetes de red para examinar el intercambio de tramas durante la negociación TLS.
* **Burp Suite / Charles Proxy:** Proxies de intercepción utilizados en auditorías de seguridad de aplicaciones web y móviles.