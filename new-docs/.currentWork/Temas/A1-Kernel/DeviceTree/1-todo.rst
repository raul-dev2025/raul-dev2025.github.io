1. Lista ``TODO`` para el árbol de dispositivo
2. Estructura general
3. ``CONFIG_OF_DYNAMIC``
4. `Referencias y agradecimientos <#i4>`__ ## Lista ``TODO`` para el
   árbol de dispositivo ##

Estructura general
^^^^^^^^^^^^^^^^^^

1. Cambios en listas personalizadas(custom lists) a ``(h)list_head``,
   para los nodos y la
   estructura de propiedades.

\ ``CONFIG_OF_DYNAMIC``\ 
^^^^^^^^^^^^^^^^^^^^^^^^^

1. *Ciclo de vida*, para el documento ``CONFIG_OF_DYNAMIC``.
2. Cambiar a ``RCU``, en actualizaciones del *árbol* y, *deshacerse del
   bloqueo de giro*
   *global*.
3. Configurar *por defecto* ``->full_name`` a ``of_attach_node()``, en
   todo momento.
4. ``pseries``, deshacerse de la modificación del *árbol*, *códificación
   abierta(open-
   coded)* en ``arch/powerpc/platforms/pseries/dlpar.c``

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| nota d.t. *spin lock*, bloqueo de giro.
| nota d.t. *get rid*, deshacerse de.

.. raw:: html

   <ul id="firma">

.. raw:: html

   <li>

Traductor: Heliogabalo S.J.

.. raw:: html

   </li>

.. raw:: html

   <li>

www.territoriolinux.net

.. raw:: html

   </li>

.. raw:: html

   </ul>
