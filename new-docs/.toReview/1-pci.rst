`Vinculaciones Pci`_
`Referencias y agradecimientos`_

.. _i1:

Vinculaciones Pci
=================

Las siguientes, son propiedades adicionales, descritas en los documentos relacionados en la sección de referencias y agradecimientos. La implementación de controlador de puente *host* podría dar soporte a las siguientes propiedades:

- ``linux,pci-domain``
  De estar presente, esta propiedad asignará un número de dominio PCI fijo, a un puente *host*, de otra forma -en sucesivos reinicios, será asignado un único número.
  Es requerido en ambos casos; no establecer esta propiedad, o definirla para todos los puentes *host* en el sistema. Lo contrario, significaría que fuesen asignados números de dominio potencialmente conflictivos, a los *buses* raíz, tras los distintos puentes *hosts*. El número de dominio para cada puente *host* en el sistema, deberá ser único.
- ``max-link-speed``
  De estar presente, la propiedad especifica las capacidades para el enlace. Los controladores de *host*, podrían añadir esto, como estrategia para evitar operaciones innecesarias, en cuanto a velocidades no soportadas, por ejemplo, al tratar de establecer velocidades no soportadas, etc. Debe ser ``4`` para *gen4*, ``3`` para *gen3*, ``2`` para *gen2*, ``1`` para *gen1*. Cualquier otro valor es inválido.

.. _i99:

Referencias y agradecimientos
=============================

`PCI Bus Binding to: IEEE Std 1275-1994 <http://www.devicetree.org/open-firmware/bindings/pci/pci2_1.pdf>`_

`Open Firmware Recommended Practice: Interrupt Mapping <http://www.devicetree.org/open-firmware/practice/imap/imap0_9d.pdf>`_

**Traducción:** Heliogabalo S.J.
*www.territoriolinux.net*