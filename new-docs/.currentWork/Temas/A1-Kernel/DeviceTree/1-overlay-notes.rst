1. `Sobreposición del árbol de dispositivo, notas <#i1>`__
2. `Cómo funciona la obreposición <#i2s>`__
3. `Sobreposición, en la API del núcleo <#i3>`__
4. `Formato de sobreposición DTS <#i4>`__
5. `Referencias y agradecimientos <#i99>`__

\ *Sobreposición* del árbol de dispositivo, notas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Éste documento describe la implementación -*en el lado del kernel*, de
  la funcionalidad
| de la *sobreposición* del árbol de dispositivo. **Localización:**
  ``drivers/of/overlay.c``. **lectura:**
  ``Documentation/devicetree/dynamic-resolution-notes.txt``.

Cómo funciona la *obreposición*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| El principal objetivo del *Árbol de Dispositivo*, es modificar el
  *árbol del kernel* en
| *activo(live)* y, proporcionar una *manera* de que tales cambios, sean
  reflejados el el
| núcleo. Puesto que el núcleo, principalmente *trabaja* con
  dispositivos, cualquier nuevo *nodo*
| de dispositivo, resultará en que un dispositivo *activo*, debería ser
  creado, incluso
| si el *nodo de dispositivo* es desactivado, retirado o, ambos. El
  dispositivo afectado
| debería ser *desregistrado -esto es, quitado de la lista en el
  registro*.

Tómese el siguiente ejemplo, dónde aparece la *placa* foo *-base del
árbol*:

::

       ---- foo.dts -----------------------------------------------------------------
           /* FOO platform */
           / {
               compatible = "corp,foo";

               /* shared resources */
               res: res {
               };

               /* On chip peripherals */
               ocp: ocp {
                   /* peripherals that are always instantiated */
                   peripheral1 { ... };
               }
           };
       ---- foo.dts -----------------------------------------------------------------

El sobrepuesto ``bar.dts``, cuando sea cargado -y resuelto tal y como se
describe en
`ResolucionDinamica-Notes.html <DeviceTree/dynamicResolutionNotes.html#f1>`__,
debería:

::

       ---- bar.dts -----------------------------------------------------------------
       /plugin/;   /* allow undefined label references and record them */
       / {
           ....    /* various properties for loader use; i.e. part id etc. */
           fragment@0 {
               target = <&ocp>;
               __overlay__ {
                   /* bar peripheral */
                   bar {
                       compatible = "corp,bar";
                       ... /* various properties and child nodes */
                   }
               };
           };
       };
       ---- bar.dts -----------------------------------------------------------------

Resultando en ``foo+bar.dts``

::

       ---- foo+bar.dts -------------------------------------------------------------
           /* FOO platform + bar peripheral */
           / {
               compatible = "corp,foo";

               /* shared resources */
               res: res {
               };

               /* On chip peripherals */
               ocp: ocp {
                   /* peripherals that are always instantiated */
                   peripheral1 { ... };

                   /* bar peripheral */
                   bar {
                       compatible = "corp,bar";
                       ... /* various properties and child nodes */
                   }
               }
           };
       ---- foo+bar.dts -------------------------------------------------------------

| Como resultado de la sobreposición, el nuevo nodo de dispositivo
  (bar), ha sido creado
| así un dispositivo de plataforma *bar*, será registrado y si un
  controlador de dispo-
| sitivo coincidente, es cargado, el dispositivo será creado tal y como
  se espera.

Sobreposición, en la *API* del núcleo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La *API*, es bastante fácil de usar:

1. Llamada a ``of_overlay_create()``, para crear y aplicar la
   *sobreposición*. El valor
   retornado es una galletita(cookie) identificando la *sobreposición*.
2. Llamada a ``of_overlay_destroy()`` para retirar y limpiar, la
   sobreposición previa-
   mente creada, por medio de ``of_overlay_create()``. La retirada de
   una *sobreposición*
   *apilada* por otra, no será permitida.
3. Finalmente, si es necesario retirar la *sobreposición*, de *una sóla
   vez*, llamar
   únicamente a ``of_overlay_destroy_all()`` para retirar cada una de
   ellas, en el orden
   correcto.

Formato de sobreposición *DTS*\ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El *DTS* de una sobreposición, debería tener el siguient formato:

::

       {
           /* ignored properties by the overlay */

           fragment@0 {    /* first child node */

               target=<phandle>;   /* phandle target of the overlay */
           or
               target-path="/path";    /* target path of the overlay */

               __overlay__ {
                   property-a; /* add property-a to the target */
                   node-a {    /* add to an existing, or create a node-a */
                       ...
                   };
               };
           }
           fragment@1 {    /* second child node */
               ...
           };
           /* more fragments follow */
       }

Utilizar un método no basado en *phandle*, permite el uso de un *DT* de
base, no conteniendo ningún nodo ``__symbols__``. Por ejemplo, si no fue
compilado con la opción ``-@``. El nodo ``__symbols__``, es sólo un
requisito para el método: ``target=<phandle>``, ya que contiene la
información para *mapear* un *phandle* a una localización del árbol. 7

--------------

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**[f1]:** phandle, ver
`dynamicResolutionNotes.html <dynamicResolutionNotes.html#f1>`__
