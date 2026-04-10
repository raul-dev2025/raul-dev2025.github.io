Comprovación y supervisión de certificados
------------------------------------------

Linux
^^^^^

Con OpenSSl puede verificarse la procedencia de un determinado *CA* por
medio del comando:

::

   openssl verify -verbose -CAfile cacert.pem server.crt

Macintosh
^^^^^^^^^

Windows 7/8
^^^^^^^^^^^

En Windows existe la aplicación certmgr.msg, la cuál muestra con detalle
todas los *Certificados de Autoridad o CA*, -aplicables al usuario en
uso.

certmgr.msc - muestra una vista “agregada?” mmc.exe - con “certificate
viewer” sigcheck -v - aplicación para comprobar CA’s ??

Almacenes de claves:

- \_Local Machine(máquina local): aplicables a todos los usuarios.
- \_Current User(Usuario en uso): específico para el usuario en uso.
- *Enterprise:* similar a *local machine*,

--------------

conexión http:80 [winCtl]:ctldl.windowsupdate.com

Desde una ``cmd``\ con privilegios, el siguiente comando nos arroja
información acerca de una determinda *CA*

::

   C:\certuitl -config - -ping
