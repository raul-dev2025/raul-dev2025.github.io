
## Configuración de una VLAN

#### Comentario sobre el hardware

Para llevar a cabo este tipo de configuración son necesarios dos componentes  
principales:

  - Conmunador con soporte al standard IEEE 802.1q en una red ethernet.
  - Una NIC, o tarjeta de red(Network Interface Card).

> Tip: Los modelos de router, que suministra el proveedor habitual de servicios  
>     de internet(ISP), son algo distintos a los utilizados en empresas y  
>     organizaciones.  
>     Estos equipos son una especie de híbrido, agrupando varias funcionalidades  
>     que en otros equipos más sofisticados, encontraríamos por separado.  


De la Wiki:
  
Los equipos que actualmente se le suelen vender al consumidor de a pie como  
enrutadores _no son simplemente eso_, si no que son los llamados Equipos locales  
del cliente __(CPE)__. Los CPE están formados por un módem, un enrutador, un conmutador  
y opcionalmente un punto de acceso WiFi.  

Mediante este equipo se cubren las funcionalidades básicas requeridas en las 3 capas  
inferiores del modelo OSI.

---

Lo primero es comprobar que nuestro kernel va a soportar la configuración:  
  ~~~  
  $ lsmod |grep 8021q  
  ~~~  
En caso de no estar cargado el módulo, lo cargamos con:
  ~~~  
  $ modprobe 8021q  
  ~~~  

... e instalamos la aplicación necesaría:
  ~~~  
  # apt-get install vlan  
  ~~~  

Habrá que _tocar_ algún archivo de configuración

  ~~~  
  # nano /etc/modules
  ~~~  
Dentro del archivo, añadimos

  ~~~  
  8021q  
  ~~~ 
Guardamos y salimos. Hay una pequeña guía de comandos a pie del editor. Si no recuerdo  
mal: __ctrl + o__ para guardar y __ctrl + x__ para salir.  

En linux, siempre hay varias formas de realizar una misma tarea, aquí se utilizará  
la aplicación _ip_. Primero, es creado el dispositio:  

  ~~~  
  # ip link add link eth0 name eth0.my_vlan type vlan id my_vlan  
  # ip link  
  # ip -d link show eth0.my_vlan  
  ~~~  

> Por convención, se utilizan números para denominar la interface. Han sido utilizados  
> literales, por claridad. Igualmente son válidos.

Si la salida de _ip link_ nos devuelve un mensaje renombrando la interface virtual  
que acabamos de crear, leer vinculo a VLAN - ARCHIWIKI  

A continuación lo activamos y es añadida una dirección _IP_ al vínculo de la _VLAN_:
  ~~~  
  # ip addr add 192.168.1.200/24 brd 192.168.1.255 dev eth0.my_vlan  
  # ip link set dev eth0.my_vlan up  
  ~~~  

Todo el trafico que va a través de eth0 buscará la etiqueta _my-vlan_. Únicamente los  
dispositivos en aviso, podrán aceptar paquetes, de otra forma serán omitidos.

## Borrar el dispositivo

  ~~~  
  # ip link set dev eth0.my_vlan down  
  # ip link delete eth0.my_vlan  
  ~~~  

Esto es, desconectar primero, borrar después.

## Hacer permanente la configuración en un entorno Debian/Ubuntu.

Abrimos el archivo de configuración
  ~~~  
  /etc/network/interfaces  
  ~~~  

... y escribimos lo siguiente:
  ~~~  
  ## vlan en Debian/Ubuntu Linux##
  auto eth0.my_vlan  
  iface eth0.my_vlan  
      address 192.168.1.200  
      netmask 255.255.255.0  
      vlan-raw-device eth0
  ~~~  

> Puede omitirse 'vlan-raw-devie eth0' en la sección _iface_ si nombramos la _vlan_
> con un identificador tipo ethX.YY, donde el dispositivo bruto toma el nombre de la
> interfaz.


---

[archw]: https://wiki.archlinux.org/index.php/VLAN
