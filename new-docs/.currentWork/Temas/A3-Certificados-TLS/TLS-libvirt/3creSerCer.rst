1. `Creando certificados de servidor, sobre la Capa de Transporte
   Seguro, para libvirt <#1>`__
   1.1 `Crear los certificados de servidor <#1i1>`__

   - 1.1.1 `Crear un archivo plantila, para el ertificado de servidor,
     utilizando un editor de textos <#1i1i1>`__
   - 1.1.2 `Crear el archivo de llave privada, para el certificado de
     servidor, usando ``certtool`` <#1i1i2>`__
   - 1.1.3 `Combinar el archivo plantilla, con el archivo llave privada,
     para crear el certificado de servidor <#1i1i3>`__
   - 1.1.4 `La plantillas pueden ser descartadas <#1i1i4>`__

| 1.2 `Moviendo los Certificados a su lugar <#1i2>`__ - 1.2.1
  `Propietario, Permisos, y etiquetas SELinux <#1i2i1>`__ - 1.2.2
  `Transfiriendo los archivos y, congirurándolos <#1i2i2>`__ - 1.2.2.1
  `Transfiriendo los archivos al host1 <#1i2i2i1>`__ - 1.2.2.2 `Conexión
  al host1 <#1i2i2i2>`__ - 1.2.2.3 `Transfiriendo los archivos al
  host2 <#1i2i2i3>`__ - 1.2.2.4 `Conexción al host2 <#1i2i2i4>`__ -
  1.2.2.5 `La configurarión del certificado de servidor, está ahora
  completa <#1i2i2i5>`__
| - 1.2.3 `Sobreescribiendo la ruta por defecto <#1i2i3>`__

1.3 `Lista completa de pasos <#1i3>`__
--------------------------------------

Creando certificados de servidor, sobre la *Capa de Transporte Seguro*, para libvirt
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En nuestro *escenario* de ejemplo, están siendo configurados, dos
servidores virtualizados, para una comunicación **TLS**. La Autoridad de
Certificado, y su llave privada, fueron configurados en el paso
anterior.

.. figure:: /images/Cert-img/smallTwoHosts.png
   :alt: dosHuéspedes

   dosHuéspedes

En éste paso, se creará el certificado **TLS** de servidor, que
necesitan los huéspedes. Una vez hecho esto, se moverán al mismo. Cuando
los certificados de servidor estén en su lugar, y *libvirt*
apropiadamente configurado, los clientes **TLS** podrán establecer la
comunicación con ellos.

Crear los certificados de servidor
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Podrá llevarse a cabo la tarea, combinando el Certificado de
Servidor(**CA**) y, su llave privada. Será utilizada la herramienta
``certtool``, procedente del paquete ``gnutls-utils``.
|combinandoArchivos|

Crear un archivo plantila, para el ertificado de servidor, utilizando un editor de textos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: /images/Cert-img/dosPlantilla.png
   :alt: editorParaDosPlantilla

   editorParaDosPlantilla

Son archivos en formato *texto plano*, uno para cada huesped
virtualizado; contienen los siguientes campos:

::

   organization = Nombre de tu organización
   cn = Nombre de huesped
   tls_www_server
   encryption_key
   signing_key

..

   Es conveniente no traducir el campo identificativo, pués
   probablemente la variable se llame de la misma forma, en el momento
   de la compilación, es decir, todo lo que está delante de ``=``.

| El campo ``Nombre de tu organización`` debe ser ajustado, para hacerlo
  coincidir con el nombre de la organización, a la pertenecerá el
  certificado.
| El *nombre de huesped*, deberá ser ajustado de igual manera,
  haciéndolo coincidir nuevamente, con el nombre escrito en la
  *plantilla*.

Siguiendo con el ejemplo:

::

   # cat host1_server_template.info
   organization = libvirt.org
   cn = host1
   tls_www_server
   encryption_key
   signing_key

   # cat host2_server_template.info
   organization = libvirt.org
   cn = host2
   tls_www_server
   encryption_key
   signing_key

   # ls -al *server_template.info  
   -rw-r--r--. 1 root root 82 Aug 25 13:26 host1ServerTemplate.info  
   -rw-r--r--. 1 root root 82 Aug 25 13:26 host2ServerTemplate.info
   ******************************* <-- just to avoid md confilcts(deprecated).

Crear el archivo de llave privada, para el certificado de servidor, usando ``certtool``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Son generados los archivos de *llave*, para ser después usados con los
  *Certificados de Servidor*.
| |creaLlaveServidor|
| Estas *llaves* son usadas para crear los *Certificados de Servidor*
  **TLS** y, por cada *supuesto*, una vez el sistema virtualizado
  arranque.

Será creada una *única llave privada*, por cada *supuesto*, comprobando
que los permisos, sólo dan acceso restringido a estos archivos.

::

   # (umask 277 && certtool --generate-privkey > host1_server_key.pem)
   Generating a 2048 bit RSA private key...

   # (umask 277 && certtool --generate-privkey > host2_server_key.pem)
   Generating a 2048 bit RSA private key...

   # ls -al *_server_key.pem
   -r--------. 1 root root 1675 Aug 25 13:33 host1_server_key.pem
   -r--------. 1 root root 1675 Aug 25 13:33 host2_server_key.pem
   ******************************* <-- just to avoid md confilcts(deprecated).  

..

   **NOTA: la seguridad de los archivos de llaves privadas, es muy
   importante.** Si una persona no autorizada obtiene la llave privada
   de servidor, puede usarla junto a un Certificado de Servidor, para
   suplantar a la máquina virtualizada. Usar una buena seguridad
   **Unix**, para restringir el acceso a estas llaves.

Combinar el archivo plantilla, con el archivo llave privada, para crear el certificado de servidor
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

|creaCertifServidor1|\ |creaCertifServidor2|

Son generados los *Certificados de Servidor*, usando las plantillas
junto a la correspondiente llave privada. El archivo de la *CA*,
igualmente es añadido con su llave privada, para asegurar que cada nuevo
certificado de servidor, es firmado apropiadamente.

::

   # certtool --generate-certificate \
             --template host1_server_template.info \
             --load-privkey host1_server_key.pem \
             --load-ca-certificate certificate_authority_certificate.pem \
             --load-ca-privkey certificate_authority_key.pem \
             --outfile host1_server_certificate.pem
   Generating a signed certificate...
   X.509 Certificate Information:
   Version: 3
   Serial Number (hex): 4c749699
   Validity:
         Not Before: Wed Aug 25 04:05:45 UTC 2010
         Not After: Thu Aug 25 04:05:45 UTC 2011
         Subject: O=libvirt.org,CN=host1
         Subject Public Key Algorithm: RSA
         Modulus (bits 2048):
                 da:75:bd:37:ac:30:4a:6c:fe:8c:8b:d9:d8:f4:94:80
                 5e:48:68:31:e7:de:85:d3:d7:54:13:da:8d:d1:f1:21
                 3b:d9:f1:eb:86:0a:4e:59:39:2c:53:ee:3e:81:29:7d
                 e5:83:6b:bd:e9:86:93:7c:ce:a4:5b:37:b3:b6:6d:7a
                 7e:60:14:99:4a:23:18:e3:0f:ff:58:68:09:08:f3:0f
                 ca:76:0d:bc:76:e0:8b:38:93:42:f6:8f:b9:d6:4c:21
                 2a:0e:d9:cd:1c:33:04:36:a3:eb:97:6b:84:bc:88:16
                 8e:0b:80:46:ed:ce:c5:56:fe:3b:f7:32:a7:91:c3:1f
                 86:b7:49:77:7b:35:e7:f4:a6:7a:3c:c9:0d:60:fd:b2
                 b7:e7:d9:02:02:a5:ef:e9:0c:43:14:15:3b:ef:96:52
                 a6:f9:ca:d5:fc:c0:fb:a0:5a:1f:69:6f:ce:66:0c:fc
                 d5:42:86:85:7e:ab:24:15:3e:5b:a3:85:a1:3b:41:ec
                 11:7c:6c:3d:14:8b:a5:14:7a:7b:79:15:a0:f6:79:2f
                 30:a9:a1:6e:8c:5e:3a:97:af:8e:7c:c0:a4:1f:2a:32
                 8b:4f:6b:53:e4:f0:28:48:db:2b:4c:0d:94:95:56:f0
                 53:e8:0f:ad:1a:a5:cf:35:e4:e3:0c:a6:ba:85:8a:33
                 Exponent (bits 24):
                 01:00:01
                 Extensions:
                 Basic Constraints (critical):
                 Certificate Authority (CA): FALSE
                 Key Purpose (not critical):
                 TLS WWW Server.
                 Key Usage (critical):
                 Digital signature.
                 Key encipherment.
                 Subject Key Identifier (not critical):
                 6ddcfcc00a5ffe064a756d2623ea90fa20ff782c
                 Authority Key Identifier (not critical):
                 9512006c97dbdedbb3232a22cfea6b1341d72d76
   Other Information:
       Public Key Id:
                 6ddcfcc00a5ffe064a756d2623ea90fa20ff782c



   Signing certificate...  

Esto creará el archivo *TLS* Certificado de Servidor
``host2_server_certificate.pem`` para el segundo huesped.

::

   # ls -la *server_certificate.pem
   -rw-r--r--. 1 root root 1164 Aug 25 14:05 host1_server_certificate.pem
   -rw-r--r--. 1 root root 1164 Aug 25 14:06 host2_server_certificate.pem
   ******************************* <-- just to avoid md confilcts(deprecated).  

La plantillas pueden ser descartadas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: /images/Cert-img/trashTemplate.png
   :alt: borrarPlantilla

   borrarPlantilla

::

   # rm host1_server_template.info host2_server_template.info

Moviendo los Certificados a su lugar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ahora que el cirtificado ha sido creado, es el momente de moverlo a su
lugar.

.. figure:: /images/Cert-img/movCertToHost.png
   :alt: moverCertAsuLugar

   moverCertAsuLugar

La localización -por defecto, donde el demonio *libvirt* busca el
archivo ``servercert.pem``, es en ``/etc/pki/libvirt/``. Para la la
*llave*, la ruta será ``/etc/pki/libvirt/private/``. Así que moveremos
los archivos a su lugar respectivo.

El archivo de *llave privada*, debe mantenerse en lugar seguro, donde
sólo pueda ser accedido por el usuario ``root``. El archivo *Certificado
de Servidos*, es algo menos sensible.

Propietario, Permisos, y etiquetas SELinux
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La pertenencia y permisos de ambos archivos, será ajustada
consecuentemente. Los directorios son los siguientes:

::

   Directory: /etc/pki/libvirt/
   Ownership: root:qemu
   Permissions: u=rwx,g=rx,o=rx (755)
   SELinux label: system_u:object_r:cert_t:s0

   Server Certificate path: /etc/pki/libvirt/servercert.pem
   Ownership: root:qemu
   Permissions: u=r,g=r,o= (440)
   SELinux label: system_u:object_r:cert_t:s0

   Directory: /etc/pki/libvirt/private/
   Ownership: root:qemu
   Permissions: u=rwx,g=rx,o= (750)
   SELinux label: system_u:object_r:cert_t:s0

   Private Key for Server Certificate: /etc/pki/libvirt/private/serverkey.pem
   Ownership: root:qemu
   Permissions: u=r,g=r,o= (440)
   SELinux label: system_u:object_r:cert_t:s0

Las etiquetas *SELinux*, únicamente son relevantes si el servidor tiene
activado *SELinux*. De qualquier otra forma, pueden ser ignoradas.

Otras consideraciones como prácticas de seguridad y requisitos
específicos para el servidor, deberán ser atendidas igualmente.

Transfiriendo los archivos y, congirurándolos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En el ejemplo de abajo, se utiliza la ``scp`` para transferir el par de
*llaves*, a cada huestped. Después, se conecta a cada uno de ellos, para
colocarlos en su lugar correcto.

Transfiriendo los archivos al host1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| |moverElparAsuLugar|
| > El nombre de los archivos es cambiado al transferirlos.

::

   # scp -p host1_server_certificate.pem someuser@host1:servercert.pem
   someuser@host1's password:
   host1_server_certificate.pem           100% 1164     1.1KB/s   00:00

   # scp -p host1_server_key.pem someuser@host1:serverkey.pem
   someuser@host1's password:
   host1_server_key.pem                   100% 1675     1.6KB/s   00:00

Conexión al host1
^^^^^^^^^^^^^^^^^

Primero son creados los directorios y asignados los permisos(del
directorio):

::

   # mkdir -p /etc/pki/libvirt/private
   # chmod 755 /etc/pki/libvirt
   # chmod 750 /etc/pki/libvirt/private

Después son movidos los archivos y ajustados sus permisos:

::

   # mv servercert.pem /etc/pki/libvirt
   # mv serverkey.pem /etc/pki/libvirt/private  

   # chgrp qemu /etc/pki/libvirt \
                 /etc/pki/libvirt/servercert.pem \
                 /etc/pki/libvirt/private \
                 /etc/pki/libvirt/private/serverkey.pem  

   # chmod 440 /etc/pki/libvirt/servercert.pem \
               /etc/pki/libvirt/private/serverkey.pem  

Si el servidor tiene SELinux activado, se actualizan las etiquetas:

::

   # restorecon -R /etc/pki/libvirt \
                   /etc/pki/libvirt/private  

   $ ls -laZ /etc/pki/libvirt
   /etc/pki/libvirt:
   total 20
   drwxr-xr-x  3 root qemu system_u:object_r:cert_t:s0 .
   drwxr-xr-x. 8 root root system_u:object_r:cert_t:s0 ..
   drwxr-x---  2 root qemu system_u:object_r:cert_t:s0 private
   -r--r-----. 1 root qemu system_u:object_r:cert_t:s0 servercert.pem

   $ ls -laZ /etc/pki/libvirt/private/  
   /etc/pki/libvirt/private/:
   total 16
   drwxr-x---  2 root qemu system_u:object_r:cert_t:s0
   drwxr-xr-x  3 root qemu system_u:object_r:cert_t:s0 ..
   -r--r-----. 1 root qemu system_u:object_r:cert_t:s0 serverkey.pem

Transfiriendo los archivos al host2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| |moverElparAsuLugarHost2|
| > El nombre de los archivos es cambiado al transferirlos.

::

   # scp -p host2_server_certificate.pem someuser@host2:servercert.pem
   someuser@host2's password:
   host2_server_certificate.pem           100% 1164     1.2KB/s   00:00

   # scp -p host2_server_key.pem someuser@host2:serverkey.pem
   someuser@host2's password:
   host2_server_key.pem                   100% 1675     1.8KB/s   00:00

Conexción al host2
^^^^^^^^^^^^^^^^^^

Primero son creados los directorios y asignados los permisos(del
directorio):

::

   $ sudo mkdir -p /etc/pki/libvirt/private
   $ sudo chmod 755 /etc/pki/libvirt
   $ sudo chmod 750 /etc/pki/libvirt/private

Después son movidos los archivos y ajustados sus permisos:

::

   # mv servercert.pem /etc/pki/libvirt
   # mv serverkey.pem /etc/pki/libvirt/private  

   # chgrp qemu /etc/pki/libvirt \
                 /etc/pki/libvirt/servercert.pem \
                 /etc/pki/libvirt/private \
                 /etc/pki/libvirt/private/serverkey.pem  

   # chmod 440 /etc/pki/libvirt/servercert.pem \
   /etc/pki/libvirt/private/serverkey.pem  

Si el servidor tiene SELinux activado, se actualizan las etiquetas:

::

   # restorecon -R /etc/pki/libvirt \
                   /etc/pki/libvirt/private  

   $ ls -laZ /etc/pki/libvirt
   /etc/pki/libvirt:
   total 20
   drwxr-xr-x  3 root qemu system_u:object_r:cert_t:s0 .
   drwxr-xr-x. 8 root root system_u:object_r:cert_t:s0 ..
   drwxr-x---  2 root qemu system_u:object_r:cert_t:s0 private
   -r--r-----. 1 root qemu system_u:object_r:cert_t:s0 servercert.pem

   $ ls -laZ /etc/pki/libvirt/private/  
   /etc/pki/libvirt/private/:
   total 16
   drwxr-x---  2 root qemu system_u:object_r:cert_t:s0
   drwxr-xr-x  3 root qemu system_u:object_r:cert_t:s0 ..
   -r--r-----. 1 root qemu system_u:object_r:cert_t:s0 serverkey.pem

La configurarión del certificado de servidor, está ahora completa
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: /images/Cert-img/setupComplete.png
   :alt: ConfiguraciónCompleta

   ConfiguraciónCompleta

Sobreescribiendo la ruta por defecto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si es necesario que el archivo de *Certificado* y la *llave*, estén en
otro lugar del servidor, deberá ajustarse mediante el archivo de
configuaración ``/etc/libvirt/libvirtd.conf``.

Las dos variables son:

::

   cert_file = "Full path to new Server Certificate location"
   key_file = "Full path to new Server Certificate Private Key location"

La ruta debe ser encerrada entre comillas dobles ``"``. Por ejemplo:

::

   cert_file = "/opt/libvirt/etc/pki/libvirt/servercert.pem"
   key_file = "/opt/libvirt/etc/pki/libvirt/private/serverkey.pem"

.. _lista-completa-de-pasos-1:

Lista completa de pasos
^^^^^^^^^^^^^^^^^^^^^^^

[textoAlEnlace][text-j1]

Lista completa del proceso 
^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Crear certificado de **Autiridad de certificados(CA)**.
2. Crear certificado de servidor.
3. Crear certificado de cliente.
4. Configuración de *demonio* **libvirt**.
5. Otras referencias.

-x3 [text-j1]: http://estoEsElenlace

.. |combinandoArchivos| image:: /images/Cert-img/caPrivateKey.png
.. |creaLlaveServidor| image:: /images/Cert-img/serverKey.png
.. |creaCertifServidor1| image:: /images/Cert-img/toolCrea1SC.png
.. |creaCertifServidor2| image:: /images/Cert-img/toolCrea1SC2.png
.. |moverElparAsuLugar| image:: /images/Cert-img/transferToHost1.png
.. |moverElparAsuLugarHost2| image:: /images/Cert-img/transferToHost2.png
