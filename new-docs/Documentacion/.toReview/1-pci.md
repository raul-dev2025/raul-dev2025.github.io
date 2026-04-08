[Vinculaciones Pci](#i1)
[Referencias y agradecimientos](#i99)

### [Vinculaciones Pci](#i1) ###

Las siguientes, son propiedades adicionales, descritas en los documentos relacionados en la sección de referencias y agradecimientos. La implementación de controlador de puente _host_ podría dar soporte a las siguientes propiedades:

- `linux,pci-domain`
De estar presente, esta propiedad asignará un número de dominio PCI fijo, a un puente _host_, de otra forma -en sucesivos reinicios, será asignado un único número.
Es requerido en ambos casos; no establecer esta propiedad, o definirla para todos los puentes _host_ en el sistema. Lo contrario, significaría que fuesen asignados números de dominio potencialmente conflictivos, a los _buses_ raíz, tras los distintos puentes _hosts_. El número de dominio para cada puente _host_ en el sistema, deberá ser único.
- `max-link-speed`
De estar presente, la propiedad especifica las capacidades para el enlace. Los controladores de _host_, podrían añadir esto, como estrategia para evitar operaciones innecesarias, en cuanto a velocidades no soportadas, por ejemplo, al tratar de establecer velocidades no soportadas, etc. Debe ser `4` para _gen4_, `3` para _gen3_, `2` para _gen2_, `1` para _gen1_. Cualquier otro valor es inválido.


### [Referencias y agradecimientos](i99) ###

[PCI Bus Binding to: IEEE Std 1275-1994](http://www.devicetree.org/open-firmware/bindings/pci/pci2_1.pdf)

[Open Firmware Recommended Practice: Interrupt Mapping](http://www.devicetree.org/open-firmware/practice/imap/imap0_9d.pdf)



<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
