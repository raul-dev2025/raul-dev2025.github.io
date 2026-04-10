MITM
----

La aplicación cliente, debe comprobar el nombre de dominio del servidor,
especificado en el certificado de servidor, comparando con el nombre de
dominio del servidor, al cuál el cliente está tratando de comunicarse.
Este paso es necesario para protegerse del llamado atque MitM. > también
conocido como hombre en el medio o mono en el medio.

El *mitm* es un programa ladrón , que intercepta las comunicaciones
entre un cliente y el servidor al cúal el cliente trata de comunicarse
via *SSL(Secure Socket Layer)*. El programa ladrón intercepta las llaves
legítimas, que son retransmitidas durante la negociación *SSL*,
sustituyendo estas llaves, por las suyas própias(*falsas*), apareciendo
ante el cliente como el *verdadero* servidor y, ante el servidor, como
el verdadero *cliente*.

El intercambio de información encriptada, al principio de la negociación
*SSL* en su lugar, es encriptada por la llave *pública o privada* del
programa *ladrón*. Éste *programa ladrón*, termina por establecer un
conjunto de llaves de sesión, para usarlas con el servidor *real*, y
otro conjunto distinto para usarlas ante el cliente. Así, el *caco* no
sólo lée los datos que fluyen entre cliente y servidor, sino que también
puede alterarlos, sin que estos sean antes borrados. De ahí, que sea tan
importante para el cliente, el comprobar que el nombre de dominio en el
certificado de servidor, corresponde realmente, al nombre de dominio del
servidor con el que está tratando de comunicarse.
