indice
------

1. `Systemd <#i1>`__
2. `Conceptos <#i2>`__
3. `Directorio de configuración y precedencia <#i3>`__
4. `Relación entre .rc y targets(objetivos) <#i4>`__
5. `Cambiar el objetivo(runlevel) con el sistema en marcha. <#i5>`__

Systemd
-------

| Systemd es el reemplazo de sysV; es un sistema más moderno, donde se
  han
| reemplazado las condiciones de carrera del sistema (race condition/run
  levels, *rc.*),
| por un sistema basado en objetivos(*targets*).

::

   $ systemctl get-default  

..

   identifica el *target* o *run level*, en uso.

| ``Systemd`` es un sistema y un gestor de servicios, para las
  operaciones de sistema de *Linux*.
| Cuando corre como primer proceso en el arranque(como ``PID 1``), actua
  como un *sistema de inicio*
| que entrega y mantiene los servicios en el espacio de usuario.

| Por compatibilidad con ``SysV``, cuando ``Systemd`` es llamacado como
  *“init”* y el ``PID`` no es 1,
| ``Systemd`` ejecutará ``tellinit`` y pasará todos los argumentos de
  línea de comando, sin modificar.
| Esto significa que ``init`` y ``tellinit`` son mayoritáriamente
  equivalentes al ser invocados desde
| una sesión de entrada normal.
| > ver ``man tellinit``.

| Cuado corre como *instancia de sistema*, ``systemd``, interpretará el
  archivo de configuración
| ``system.conf`` y, los arlchivos de configuración en los directorios
  ``system.conf.d``.
| Cuando corre como *instancia de usuario*, interpretará el archivo de
  configuaración ``user.conf``
| y los archivos en los directorios ``system.conf.d``.
| > ver ``man systemd-system.conf``.
| —

Conceptos
---------

| ``systemd`` proporciona un sistema de dependencia entre varios
  entidades, llamado *“units”*, de
| 12 diferentes tipos. Las *unidades* encapsulan varios objetos que son
  relevantes para el
| *sistema de arranque* y *mantenimiento*. La malloría de *unidades* son
  configuradas en archivos
| de configuración de este tipo, cuya sintaxis y conjunto básico de
  opciones, es descrito en
| ``systemd.unit(5)``, aunque algunos de ellos, son creados
  automáticamente desde algún otro
| archivo de configuración, dinámicamente desde el *estado de sistema*
  o, programáticamente
| durante el *tiempo de ejecución*.

| Las *unidades*, pueden estar *activas*\ (``active``); significando
  esto último: *activas, vinculadas*
| \_conectadas en… dependiendo del tipo de unidad.

| También pueden estar *inactivas)*\ (``inactive``); significando:
  *paradas, desvinculadas,*
| *desconectadas …* así como en el proceso de estar alcanzando cualquier
  de los estados
| descritos, en tal caso ``activating`` o ``deactivating``, denota su
  estado transitorio.

| De igual forma, un estado *especial* ``failed`` está disponible, el
  cuál es muy similar al estado
| ``inactive`` donde el entra el servicio al momento de fallar de alguna
  manera -el proceso retorna
| código de error al salir, al *romper* o tras agotar el tiempo de
  operación.
| Si alcanza tal estado, la causa será anotada, para posteriores
  referencias. Nótese que varios
| de los typos de estados podrían tener un número adicional de
  subestados, los cuales serán *mapeados* en los cinco estados generales
  de unidades, descritos quí:

1. | *Servicio de unidades*, el cuál empieza y controla los demonios y
     procesos en que ellos
   | mismos consisten. *ver systemd.service(5)*.

2. | Unidad de zócalos(socket), el cuál encapsula *IPC*\ ’s o redes
     locales en el sistema, útil
   | para la activación basada en zócalos. *ver systemd.socket(5)*, para
     detalles sobre la
   | activación basada en zócalos, *ver daemon(7)*.

3. | Las *unidades objetivo*, son útiles para agrupar unidades o,
     proporcionar puntos de
   | sincronización bién formados, durante el *arranque*, ver
     ``systemd.target(5)``.

4. | Las unidades de dispositivo, exponen dispositivos del núcleo en
     ``systemd`` y pueden ser
   | usados para implementar la *activación* basada en dispositivos. Ver
     ``systemd.device``.

..

   | *IPC – InterProcess Communication*. ipc() es un punto de entrada
     *habitual* en el núcleo, para las llamadas de ``system V`` para
   | mensajes, semáforos y memoria compartida. ver msgctl(2), semctl(2),
     shmctl(2) sobre sistemas x86_64 y ARM, ya que estas arquitecturas,
   | no se utilizan las llamadas a sistema del tipo IPC.

--------------

Directorio de configuración y precedencia
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Durante la compilación del núcleo se crean automáticamente unos
  archivos de configuración
| por defecto, aunque habrá que revisarlos por que están en su mayoría
  comentados.

| Para mantener una copia o plantilla, que después sirva como inicio de
  una nueva
| configuración, es conveniente hacer una copias de estas *guías* a
  ``/etc/systemd/user.conf.d``
| y realizar sobre este directorio los cambios que se ajusten a un
  determinado systema o
| configuración.

| Cuando una aplicación personaliza alguna de estas configuraciones, lo
  hace sobre el
| directorio ``/usr/lib/systemd/*.conf.d/``. Los archivos de este tipo
  sobre ``/etc/`` son
| reservados para uso del administrador local, quien usará esta lógica
  para sobreescribir
| los archivos de configuración, instalados por el
  fabricante/distribuidor, etc.

- El archivo de configuración principal es el primero en leerse, con
  menor precedencia.
- Las entradas, en cualquier archivo de configuración, sobreescriben las
  entradas en otros
  archivos de configuración.
- Los archivos almacenados en subdirectorios de configuración
  ``*.conf.d/`` serán orndenados
  por nombre de archivo, en lugar de por el directorio en que se
  encuentren.
- Si múltiples archivos, especifican la misma opción, se tomará en
  cuenta la última leída.
- Es buena idea inidcar un número delante del archivo, para indicar el
  orden de precedencia, algo así: 01-Primero-EnLeer 20-Segundo-EnLeer
  50-tercero-EnLeer 99-Ultimo-EnLeer … y ajustar las variables
  contenidas, teniendo en cuenta lo anterior. > Es una question más del
  orden de precedencia; el momento en que el sistema carga un
  determinado
  > servicio o programa, que de la importancia del mismo(esto último es
  irrelevante).

Relación entre .rc y targets(objetivos)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Run level 0 – poweroff.target
  runlevel0 <–> enlace simbólico a poweroff.target
- Run level 1 – rescue.target
  runlevel1 <–> simbólico a rescue.target
- Run level 2 – PERSONALIZADO USUARIO?? runlevel2 <–> simbólico a
- Run level 3 – multi-user-target
  runlevel3 <–> simbólico a multi-user-target
- Run level 4 – PERSONALIZADO USUARIO??
  runlevel4 <–> simbólico a
- Run level 5 – graphical.target
  runlevel5 <–> simbólico a graphical.target
- Run level 6 – reboot.target
  runlevel6 <–> simbólico a reboot.target

Cambiar el objetivo(runlevel) con el sistema en marcha.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   # systemctl isolate multi-user.target  

..

   …con los permisos apropiados, se cambia el *run level*.

Listado de dispositibvos
^^^^^^^^^^^^^^^^^^^^^^^^

::

   systemctl list-units

..

   lista de unidades conocidad, según el man-page, revisar.
