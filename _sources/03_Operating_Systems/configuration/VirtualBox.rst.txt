Virtual Box
==============

Prerequisitos
-----------------

En primer lugar habrá que comprobar que la característica de la placa base ``VT-d`` está activada. Este paso es específico de cada maquina, donde el fabricante de la placa base es distinto en cada caso. 

En el sistema académico donde se realiza esta práctica dicha característica se encuentra en:

   :kbd:`Settings` -> :kbd:`varios` -> ``VT-d``


.. note::

   **IOMMU**, Input Output Memory Management Unit:
   
   - **AMD**: AMD-Vi, IOMMU.
   - **Intel**: VT-d.
      ... el procesador puede o no, tener dicha capacidad. Para poder utilizarla, la placa base debe ser compatible y deberá ser activada como función de la propia placa, ya que el procesador no precisa de "interruptor" para activar/desactivar la característica.



Entorno Virtual Box
-----------------------
Esta es la lista de aplicaciones que son utilizadas para preparar el entorno de virtualización.

- ``VC_redist.x64.exe``
- ``Oracle_VirtualBox_Extension_Pack-7.1.8.vbox-extpack`` ó
- ``Oracle_VirtualBox_Extension_Pack-7.1.8-168469.vbox-extpack``
- ``VBoxGuestAdditions_7.1.8.iso``
- ``VirtualBox-7.1.8-168469-Win.exe``

Las VBoxGuestAdditions -*o "Adiciones de Invitado de VirtualBox"*, son un conjunto de controladores de dispositivo y aplicaciones de sistema que Oracle VirtualBox instala dentro del sistema operativo huésped -*la VM*. Su objetivo principal es mejorar significativamente la experiencia del usuario y el rendimiento de la máquina virtual, facilitando una interacción más fluida entre el sistema anfitrión -*tu computadora real*, y el sistema huésped.

¿Cómo se instalan?
----------------------

Las VBoxGuestAdditions se distribuyen como una imagen ISO llamada ``VBoxGuestAdditions.iso``. Desde el menú de VirtualBox de tu máquina virtual, generalmente puedes seleccionar :kbd:`Dispositivos` -> :kbd:`Insertar imagen de CD de Guest Additions`. Esto monta la ISO dentro de la máquina virtual, desde donde puedes ejecutar el instalador (que varía según el sistema operativo huésped, siendo un script ``.run`` en Linux o un ejecutable ``.exe`` en Windows, por ejemplo). Después de la instalación, generalmente es necesario reiniciar la máquina virtual para que los cambios surtan efecto.

En resumen, las VBoxGuestAdditions son esenciales para tener una experiencia fluida y optimizada al usar máquinas virtuales en VirtualBox, desbloqueando muchas características que de otra manera no estarían disponibles o serían incómodas de usar.


Transferir archivos y carpetas
----------------------------------------

- Las opciones **Bidirecional** y **Enable Clipboard File Transfer**. en :kbd:`Dispositivos` -> :kbd:`portapapeles compartido`, deberán ser activadas.
- La opción **Bidirecional**, en el menú :kbd:`Dispositivos` -> :kbd:`Arrastrar y soltar`, también deberá estar activa.


Modificar el tamaño del disco de la máquina.
-----------------------------------------------

      **Comprobar en primer lugar que la máquina está apagada.**

En el menú :kbd:`herramientas` hacer click al *icono de lista*, y nuevamente click a :kbd:`medio` (de almacenamiento). Aparece un cuadro con los dispositivos asociados. En la pestaña :kbd:`Atributos` podremos cambiar el tamaño. En la pestaña :kbd:`Información` podremos consultar los detalles identificativos del medio en cuestión -comprobar esto.

.. warning::

   Recuerda que al crear un disco de un tamaño determinado(provisionado o no), reducirlo no se puede hacer como lo harías normalmente con el administrador de discos. Necesitarás herramienta extra. Cuidado.


Añadir disco
-------------------

Selecionar el menú :kbd:`Almacenamiento`, el árbol de dispositivo, mostrará el *controlador SATA*, si pulsamos sobre él, aparecerán dos iconos; uno para añadir unidad óptica y otro para añadir un nuevo disco duro.
Para crear un nuevo disco, pulsaremos sobre el icono **añadir disco duro**. Aparece entonces una nueva ventana, donde podremos añadir o crear otros medios.
Habrá que *recordar acoplar el disco al sistema*, una vez creado el nuevo medio, si es este el caso. Para ello podremos hacerlo con doble click sobre el nombre de dicho medio.


**omitir instalacion desatendida**
Esto significa que los datos específicos de la instalación, habrá que ir definiéndolos a medida que sean solicitados por el instalador del sistema operativo. En lugar de definirlos desde el gestor de virtual Box.


Combinaciones de teclas en la VM
-----------------------------------

- Tecla Host: :kbd:`Ctrl` derecho.
- Captura de pantalla: :kbd:`ctrl` + :kbd:`E`.
- Maximizar ventana de la máquina: :kbd:`ctrl` + :kbd:`F`.
- Redimensionar dinámicamente: :kbd:`ctrl` + :kbd:`C`.
- Abrir el menú de dispositivos: :kbd:`ctrl` + :kbd:`I`.
- Envía la secuencia ``Ctrl + Alt + Del`` a la máquina: :kbd:`ctrl` + :kbd:`Del`.
- Reiniciar máquina virtual: :kbd:`ctrl` + :kbd:`R`.
- Abre el menú de la VM: :kbd:`ctrl` + :kbd:`R`, útil si el cursor está atrapado.

