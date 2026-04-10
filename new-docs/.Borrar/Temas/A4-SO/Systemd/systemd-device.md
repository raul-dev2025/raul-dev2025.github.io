## Systemd.device

1. Configuración de unidades de dispositivo
2. Dependencias automáticas
3. La base de datos UDEV
---

#### Configuración de unidades de dispositivo

Un archivo de configuración de unidad, cuyo nombre termina en `.device` codifica información  
sobre la unidad de dispositivo, expuesta en el árbol de dispositivo `sysfs-udev(7)`.  

Éste tipo de unidad, no tiene opciones específicas. _ver systemd.unit(5)_, para las opciones  
comunes de todos los archivos de configuración de unidades. Los artículos de común configuración  
están en la secciones genéricas [Unit] e [Install]. Una sección {Device} a parte, no existe  
debido a que no hay configuración de _opciones específicas de dispositivo_.

`Systemd` creará dinámicamente unidades de dispositivo, para todos los dispositivos del  
núcleo que son marcados con la etiqueta udev _"systemd"_(por defecto, todos los dispositivos  
de bloques y red). Esto puede ser usado para definir las dependencias entre dispositivos  
y otras unidades. Para marcar un dispositivo _udev_ usar `TAG+="systemd"` en el archivo de  
reglas _udev_. Ver `udev(7)`.

Las unidades de dispositivo son nombradas después de las rutas que los controlan `/sys` y `/dev`  
Por ejemplo, el dispositivo `/dev/sda5` será expuesto en _systemd_ como `dev-sda5.device`.  
Para más detalles sobre la lógica de escape(símbolos), usada para convertir una ruta de  
archivo de sistema a un nombre de unidad, ver `systemd.unit(5)`.

#### Dependencias automáticas

Muchos de los tipos de unidades, adquieren dependencias sobre las unidades de dispositivos que  
ellos mismos requieren. Por ejemplo, la unidad `.socket` adquiere las dependencias sobre unidades  
de dispositivo de la interfase de red, especificada en `BindToDevice=`. De forma similar,  
las unidades `mount` y `swap`(intercambio), adquieren las dependencias en las unidades que
_encapsulan_ sus _bloques de dispositivo de respaldo_.

> __backing block device__ traducido como _bloques de dispositivo de respaldo_.

#### La base de datos UDEV

La configuración de unidades de dispositivo, puede llevarse a cabo, a través de archivos de  
unidades o, diréctamente desde la base de datos _udev_ -opción recomendable. Las siguientes  
propiedades de dispositivo _udev_ son entendidas por _systemd_:

- SYSTEMD_WANTS=, SYSTEMD_USER_WANTS=
Añade dependencias de tipo `Wants` desde la unidad de dispositivo a todos las unidades listadas.  
La primera forma es usada por la instancia de sistema _systemd_, la segunada por la instancia  
de usuario. Tales configuracionesm pueden ser utilizadas par activar unidades arbitrariamente,  
cuando un dispositivo específico resulta disponible.

Notese que ésta y otras etiquetas, no son tomadas en cuenta, hasta que el dispositivo es  
etiquetado con la cadena `"systemd"`, en la base de datos _udev_, por que de otra manera, el  
dispositivo no sería expuesto como _unidad systemd_ (ver más abajo).

Nótese que, _systemd_ sólo actúa sobre las dependencias `Wants` cuando el dispositivo resulta  
activo `active` por primera vez. No actuará sobre ellos, si el dispositivo se encuentra ya 
activo. Usar SYSTEMD_READY= (más abajo) para influenciar sobre qué evento de dispositivo hay
que _disparar_ las dependencias.

- `SYSTEMD_ALIAS=`
Añade un _alias_ a la unidad de dispositivo. Debe ser una ruta absoluta, transformada  
automáticamente en nombre de unidad(más abajo).

- `SYSTEMD_READY=`
Si se asigna a `0`, _systemd_ considerará este dispositivo desconectado, incluso si se muestra
cómo _subido(up)_, en el árbol de _udev_. Si esta propiedad no es configurada o asignada a `1`,
el dispositivo será considerado como _conectado_, si es que es visible en el árbol de _udev_.
Ésta propiedad no influeye en el comportamiento, cuando un dispositivo desaparece del árbol de  
_udev_.

Es una opción útil, para ayudar a dispositivos que inicialmente se muestran en el árbol como  
_subidos_ en un estado _no inicializado_, y por el que un enventod `"changed"`_(cambiado)_,  
se generó en el momento de su configuración. Notar, que `SYSTEMD_WANTS=` no actúa sobre un  
dispositivo marcado como `SYSTEMD_READY=0`.

- `ID_MODEL_FROM_DATABASE=`, `ID_MODEL=`
Si es configurada, esta propiedad será usada como cadena de descripción, para la unidad de  
dispositivo.


