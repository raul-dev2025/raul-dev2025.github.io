
    $ for f in /etc/ssl/certs/*.pem; do sudo ln -sfn "$f" /etc/ca-certificates/trust-source/blacklist/; done

    $ update-ca-trust

-----

    $ sudo rm DigiCert_* GeoTrust_* Go_Daddy_* GlobalSign_* VeriSign_* StartCom_Certification_Authority* Comodo_* AddTrust_* Thawte_* thawte_Primary_Root_CA* Baltimore_CyberTrust_Root.pem UTN_USERFirst_Hardware_Root_CA.pem Visa_eCommerce_Root.pem

    `$ ls /etc/ssl/certs/*.pem | wc -l`
    $ 206
    $ ls /etc/ca-certificates/trust-source/blacklist/
    $ 163


Fedora utiliza un sistema de gestion de certificados llamado
`SharedSystemCertificates` para proveer un sistema centralizado de almacén
de certificados.

Parece ser que Firefox en concreto, presta atención al mismo, aunque puede
ser que algunas aplicaciones, no hagan caso de este sistema y, gestionen
los certificados de forma independiente.

Desgraciadamente, como el _software_ puede escojer la manera de gestionar
los certificados, es necesario la adopción de la característica:
`Fedora enforcing` y ser diligente, si queremos que nuestro sistema haga
uso de él.


Procedimiento para aislar(_blacklisting_) certificados _no deseados_:

    $ < /dev/null openssl s_client -showcerts -connect www1.cnnic.cn:https > ccnic
    # mv ccnic /usr/share/pki/ca-trust-source/blacklist/
    # update-ca-trust extract <-- `SharedSystemCertificates`
Riniciar la aplicación, en este caso _Firefox_.

---

fuente: https://ask.fedoraproject.org/en/question/66484/how-to-blacklist-a-specific-ca-certificate/
