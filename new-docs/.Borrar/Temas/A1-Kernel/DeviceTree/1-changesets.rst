1. `conjunto de cambios <#i1>`__
2. `Referencias y agradecimientos <#i99>`__

--------------

conjunto de cambios
-------------------

| El conjunto de cambios de un *DT*, es un método que permite aplicar
  cambios sobre un
| árbol *activo*, de tal forma, que sean aplicados el *conjunto de
  cambios totales* o,
| puede que ninguno de ellos. Si ocurre un error *parcial*, mientras es
  aplicado el
| *conjunto de cambios*, se retrocederá al *estado anterior*.

| Cuando es aplicado un cambio, serán aplicados *de una sóla vez*, todos
  ellos, antes de
| emitir notificaciones ``OF_RECONFIG``. De ésta manera el receptor verá
  un consistente y,
| completo estado del *árbol*, cuando los receptores sean notificados.

La secuenccia de un cambio es como sigue:

1. ``of_changeset_init()`` – inicializa un *conjunto de cambios*.
2. Un número de llamadas a *cambios* en el árbol *DT*,
   ``of_changeset_attach_node(),   of_changeset_detach_node(), of_changeset_add_property(),   of_changeset_remove_property, of_changeset_update_property()``,
   para preparar el
   *conjunto de cambios*. En este momento no se realizará ningún cambio.
   Todas las operaciones de cambio, son guardadas en la lista de
   *entradas* ``of_changeset``.
3. ``of_changeset_apply()`` – aplica los cambios al árbol.
   Ya sean aplicados, el *conjunto de cambios* al completo o, si hubo un
   error en el árbol
   y tuvo que ser restaurado, a un estado anterior. El\ `[f1] <#f1>`__
   *núcleo*, asegura la
   *serialización* correcta, a través de un bloqueo. Una versión
   desbloqueada de
   ``__of_changeset_apply``, estará disponible si fuese necesaria.
4. Si los cambios son aplicados correctamente, el *conjunto de cambios*,
   necesitará ser
   retirado, esto podrá llevarse a cabo por medio de
   ``of_changeset_revert()``.

--------------

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| [f1]nota d.t. el *núcleo*, referido a la *aplicación*, o “motor”, que
| lleva a cabo los cambios. No al kernel.

.. raw:: html

   <ul id="firma">

.. raw:: html

   <li>

Traducción: Heliogabalo S.J.

.. raw:: html

   </li>

.. raw:: html

   <li>

www.territoriolinux.net

.. raw:: html

   </li>

.. raw:: html

   </ul>
