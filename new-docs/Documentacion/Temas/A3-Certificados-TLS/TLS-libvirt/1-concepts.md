## Contenido
1. [certificados](#1c)
2. [Configurando __libvirt__ para TLS](#2c)
    1. [Lista completa del proceso](#2c1)
    2. [Concepto central](#2c2)
    3. [Nuestro escenario](#2c3)
    4. [Llaves privadas](#2c4)
    5. [Firmando otros certificados](#2c5)
    6. [Certificado de autoridad](#2c6)
---
## <a name ='1c'> Certificados</a>

Los certificados son una _forma_ segura de comunicarnos entre computadoras. A esta _forma_ de
establecer la comunicación la llamamos _protocolo_. Hoy en día existen dos tipos de protocolos
ampliamente utilizados; protocolos SSL y TLS.

En esta documentación se hablará exclusivamente del protocolo TLS, que es una versión mas
moderna o actualizada del protocolo SSL(capa de sockets seguros).
Algunos desarrolladores siguen llamándolos: certificado SSL; aunque en realidad se trata
igualmente del protocolo TLS(seguridad de la capa de transporte), con opciones ECC,RSA o DSA.
> Estos últimos son _algoritmos de cifrado_.

## <a name = '2c'>Configurando __libvirt__ para TLS</a>

Establecer la infraestructura de virtualización a través de la __Capa segura de transporte__,
es relatívamente sencillo; aunque puede resultar confuso, cuando aún no se está familiarizado
con ciertos detalles.

Mediante este documento, se tratará de explicar los pasos involucrados, en el proceso de
configuración de __libvirt__ con __TLS__. Se utilizarán conceptos avanzados y ejemplos.
Adaptando los ejemplos directamente, sobre la intraestructura de virtualización, se atenderá el
caso en particular.

#### <a name = '2c1'>Lista completa del proceso </a>
  1. Crear certificado de __Autiridad de certificados__(CA en adelante).
  2. Crear certificado de servidor.
  3. Crear certificado de cliente.
  4. Configuración de _demonio_ __libvirt__.
  5. Otras referencias.

#### <a name = '2c2'>Concepto central</a>

En esencia, _la capa segura de transporte_ es una forma de comunicarnos entre dos máquina,
donde será utilizada una aproximación llamada __PKI__; infraestructura de llave pública.Es un concepto bastante simple, el cuál involucra siempre a dos computadoras; un _cliente_
establece conexión con otra máquina llamada _servidor_.

![alt text](/images/Tls_concepts_basic_client_to_server.png)

Para la comunicación, TLS usa archivos llamados _Certificados_; el cliente establece la comunicación
con un _Certificado de cliente_. La computadora que recibe la conexión, hace uso del _Certificado
de servidor_.

![alt text](/images/connection.png)

Si la necesidad, es comunicar dos computadoras en ambos sentidos, para poder hacer uso del protocolo
TLS, habrá que instalar los dos tipos de certificados en los dos equipos.

![alt text](/images/cruzado.png)
> Es éste ejemplo, nuestro escenario.

#### <a name='2c3'>Nuestro escenario</a>

Aquí subyacen dos servidores virtualizados. El primer servidor; _sistema 1_, será llamado __host1__.
El segundo; recibe el nombre __host2__.

![alt text](/images/hosts.png)

En éste escenario, los servidores necesitarán comunicarse puntualmente, el uno con el otro. Por
ejemplo, cuando movemos un _supuesto_, desde el _host1_ al _host2_ o _vice versa_.
Para que esto funcione, ambos servidores deben poseer su própio certificado cliente/servidor.
> ... término en inglés, para referirse a una máquina virtualizada(guest).

![alt text](/images/ser-crs.png)

En éste punto, será introducido el concepto _servidor administrativo_. Desde el _servidor
administrativo_, se llevarán a cabo tareas de administración; como crear nuevos _supestos_,
moverlos entre servidores y reconfigurarlos o borrarlos.

A partir de ahora, su nombre será __admindesktop__. Únicamente se conectará a los servidores,
es decir, no recibirá conexiones desde ellos. Por lo tanto, sólo necesitará el _certificado de
cliente_, o lo que es lo mismo; no contará con el _certifidcado de servidor_.

![alt text](/images/admindesktop.png)


#### <a name = '2c4'>Llaves privadas</a>
Como parte de la aproximación __PKI__, usada en __TLS__ (infraestructura de llave pública), cabe
mencionar, que cada certificado debe contar con dos entidades: _llave pública_ y _llave privada_.

![alt text](/images/key-par.png)

Los archivos de llave privada, son de especial importancia y, deben ser guardados en lugar seguro.
Estas _llaves_ permiten a cualquier computadora -con el correspondiente certificado; representarse
a sí misma, como la descrita _en el própio certificado!!_.

Por ejemplo, el servidor _host1_, tiene ambos certificados: _certificado de cliente y servidor_.
Estos certificados, indican su pertenencia al _host1_. Por que sólo el _host1_ tiene la llave
privada del par de certificados(cliente/servidor); es el único que puede decir: _"yo soy el host1"_.

En caso de que una persona no autorizada obtenga el archivo de _llave_, podría generar su própio
certificado y, reclamar la posesión del servidor _host1_ en su lugar, por lo que potencialmente
podría darle acceso al servidor virtualizzado. _No es lo que queremos!_.

#### <a name = '2c5'>Frimando otros certificados</a>

La posesión de los certificados y sus respectivas _llaves privadas_, también proporciona un
beneficio adicional; de esta forma, se podrán firmar otros certificados. Esto añade una pequeña
pieza segura de información criptográfica, indicando la autenticidad, del certificado que está
siendo firmado.

Es importante, por que condiciona si una _web_ es de confianza o no. Donde todos los certificados
han sido firmados por los otros, o por un certificado central -__admindesktop__, que
se sabe es seguro.

#### <a name = '2c6'>Certificado de autoridad</a>
Mediante esta aproximación, contar con un certificado central, capaz de firmar
muchos otros, es considerado _como buena práctica de seguridad_. También
permite su administración, mediante un, razonablemente, simple certificado,
comparado con otras alternativas y, es la aproximación usada por _libvirt_.

Éste certificado central, se refiere al __Certificado de Autoridad__. Será creado
uno, al principio de nuestra configuración __TLS__, en la próxima sección.
Después, usado para firmar cada certificado _Cliente_ y _Servidor_.

![relacion-certificado-autoridad](/images/image_ca.png)
