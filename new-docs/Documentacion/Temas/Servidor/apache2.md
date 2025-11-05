## Bitácora apache
Esta función carga manualmente las variables de entorno
que utiliza apache2: sudo service apache2 restart
Sin embargo, es en modo "hardcode", de alguna manera
solo es aplicable de forma temporal?
El caso es que la forma correcta de hacerlo es via "ctl"
# apache2ctl start|stop|etc...
apache2ctl -V --> muestra variables entorno.
apache2ctl -M --> módulos cargados.

Imagino que esto tiene algo que ver con el demonio del binario.
apache2 -- a secas no debe cargar el proceso como demonio y, por lo tanto todas la varibles de entorno quedan fuera de ámbito. Usa CTL!!!!!

#### Problemas con el cert SSL en los clientes!!

Aquí Doc/apache recomienda el uso de diversas herramientas, para depurar las conexiones:
- En windows: Network Monitor
- MyLinux: WhireShark y TcpDump.
https://wiki.apache.org/httpd/SSL
https://wiki.apache.org/httpd/DebuggingSSLProblems

Los módulos son activados por medio de la aplicacion:
a2enmod - activar/desactivar(?) módulos
a2ensite - activar/desactivar(?) espacioWWW
a2enconf - activar/desactivar(?) archivo de configuracion


nota: por cierto he comprobado en D.O. si los puertos estaban filtrados. No, no lo están respuesta positiva por parte de D.O. -problema menos. En ocasiones los admins de la granja filtran los puertos del dropplet para evitar spam masivos con emails privados(abuso de emails). No es mi caso!
