## Comprovación y supervisión de certificados

#### Linux
Con OpenSSl puede verificarse la procedencia de un determinado _CA_ por medio
del comando:

    openssl verify -verbose -CAfile cacert.pem server.crt




#### Macintosh
#### Windows 7/8

En Windows existe la aplicación certmgr.msg, la cuál muestra con detalle
todas los _Certificados de Autoridad o CA_, -aplicables al usuario en uso.

certmgr.msc - muestra una vista "agregada?"
mmc.exe     - con "certificate viewer"
sigcheck -v - aplicación para comprobar CA's ??

Almacenes de claves:

- _Local Machine(máquina local): aplicables a todos los usuarios.
- _Current User(Usuario en uso): específico para el usuario en uso.
- _Enterprise:_ similar a _local machine_, 

---
conexión http:80
[winCtl]:ctldl.windowsupdate.com


Desde una `cmd`con privilegios, el siguiente comando nos arroja información
acerca de una determinda _CA_

    C:\certuitl -config - -ping
