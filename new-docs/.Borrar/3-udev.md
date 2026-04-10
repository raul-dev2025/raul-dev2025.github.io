[Reglas UDEV para DVB](#i1)

[Referencias y agradecimientos](#i99)


### [Reglas UDEV para DVB](#i1) ###

El subsistema DVB, registra actualmente el subsistema `sysfs`, utilizando la interfase _class_simple_.

Significa que únicamente información básica como la carga de los parámetros de módulo, estén presentes através de _sysfs_. Otras cosas potencialmente interesantes, __NO__ están disponibles.

Nunca antes había sido posible añadir reglas udev adecuadamente, por lo que nodos de dispositivos DVB serán creados automáticamente.

Es asumido el correcto funcionamiento de _udev_ y, que han sido creados manualmente, los nodos de dispositivo hasta ahora; debido a la omisión de soporte a _sysfs_.

0. No olvidar 



### [Referencias y agradecimientos](#i99) ###

__nota__: Esta documentación está desactualizada. En distribuciones modernas, Udev autodetecta dispositivos DVB.

__PENDIENTE__: cambiar este documento para explicar como hacer que dispositivos DVB sean persistentes, ejemplo; cuando una máquina tiene múltiples dispositivos, podrían ser detectados en distinto orden, causando que aplicaciones apuntando a números de dispositivo, fallasen.





<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
