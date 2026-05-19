A1-so/sistemaficheros
=====================

1. `Sistema de fichero Overlay <#i1>`_
2. `El más alto, el más bajo. <#i2>`_
3. `Directorios <#i3>`_
    - `Whiteouts y directorio opacos <#i3i1>`_
    - `readdir <#3i2>`_
4. `Referencias y agradecimientos <#i4>`_

.. _i1:

1. Sistema de fichero ``Overlay``
=================================

Éste documento, describe un prototipo para la nueva aproximación a la funcionalidad de los sistemas de ficheros ``overlays``. Un sistema de ficheros ``overlay``, intenta presentar un sistema de ficheros el cuál, es el resultado de sobreponer un sistema de ficheros sobre otro.

El resultado, falla en el sentido de que no se parece a un sistema de ficheros tradicional, por varias razones técnicas. Se espera que en muchos casos prácticos, puedan ser ignorados estas diferencias.

Ésta aproximación es *hibrida*, por que los *objetos* que aparecen en el sistema de ficheros, no parecen pertenecer todos, al sistema de ficheros. En muchos casos, un objeto accedido en la unión, será indistinguible el acceder a él, desde el sistema de fichero original. Ésto resulta obvio, en el campo ``st_dev``, retornado con ``stat(2)``.

Mientras que los directorios, reportarán un ``st_dev`` desde el *FS-overlay*, objetos que no sean del directorio, podrían reportar un ``st_dev``, desde el *FS inferior* o, *FS superior*, el cuál está proporcionando el objeto.
Similarmente ``st_into`` será único, cuando sea combinado con ``st_dev`` y, ambos puedan cambiar sobre un objeto *no directory*. Muchas aplicaciones y herramientas ignorarán estos valores y no serán afectados.

En el caso especial de todas las capas de ``overlays``, en el mismo *FS*, todos los objetos reportarán un ``st_dev`` desde la capa subyacente. Esto hará al montaje ``overlay`` más compatible con *escaneadores* de sistemas de archivos y, los objetos ``overlay``, resultarán indistinguibles desde el correspondiente objeto del *FS* original.

.. _i2:

2. El más alto, el más bajo.
===========================

Un *FS overlay* combina dos sistemas de archivo, uno por encima y, otro por debajo. Cuando un nombre existe en ambos *FS*, el objeto en el *FS más alto*, es visible, mientras que el objeto en el *FS más bajo*, es escondido -o en caso de directorio, mezclado con el *objeto más alto*.

Sería más adecuado referirse a un *más alto* o *más bajo* "árbol de directorio" que "sistema de archivo"; por que es muy posible para ambos "árbol de directorio" el estar en el mismo *sistema de archivo* y, no hay la necesidad de que el *sistema de archivo raíz*, sea dado al *más alto* o *más bajo*.

El *sistema de archivo* *más bajo*, puede ser un *sistema de archivo* soportado por Lynux, y no necesita ser escribible. Incluso puede ser otro ``overlay``. El *sistema de archivo más alto* será normalmente escribible, pero si lo és, debe soportar los *atributos extendidos* de ``trusted.*`` y, debe proporcionar un ``d_type`` válido en respuestas de lectuara de directorio, así que NFS, no se ajusta.

Un ``overlay`` de *sólo lectura*, de dos sistemas de archivo de *sólo lectura*, puede utilizar cualquier(FS) tipo.

.. note::
   **n. de t.:** la traducción ``overlay`` de ser exacta, sería algo como "sobreyacente".

.. _i3:

3. Directorios
==============

Mayormente los ``overlay`` involucran a directorios. Si un nombre dado, aparece en ambos; el *más alto* y el *más bajo* y, se refiere a un *no directorio* en los dos, entonces el objeto *más bajo* es escondido; el nombre es referido sólo al objeto *más alto*.

Cuando son directorios, se forma un *directorio mezclado*. Durante el tiempo de montaje, los dos directorios referidos, aportan la opción al montaje ``lowerdir`` y ``upperdir``, son entonces combinados en un directorio *mezclado*.

.. code-block:: shell

   mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
   workdir=/work /merged

.. note::
   *argumentos separados por comas* ``,`` *y sin espacios.*

El ``workdir``(directorio de trabajo), necesita ser un directorio vacío en el mismo *sistema de archivo* que ``upperdir`` Cuando es solicitado un ``loockup``, en un determinado directorio, se lleva a cabo y el resultado, de la combinación de ambos, es almacenado en *caché* en la *entrada* que pertenece al *sistema de archivo* ``overlay``.
Si los dos ``loockup`` encuentran directorios, ambos son almacenados y se crea un directorio con la *mezcla*. De cualquier otra forma, sólo uno es almacenado; el ``upper`` si es que existe, de lo contrario el ``lower``.

Únicamente se mezcla, la lista de nombres desde un directorio. Otro contenido como ``metadata``, y *atributos extendidos*, son reportados sólo para el directorio ``uppper``. Estos atributos se ocultan, para el directorio ``lower``.

.. note::
   **n. de t.** ``loockup``, echar un vistazo. Normalmente se referiere a comparar objetos. Hay muchas aplicaciones con una funcionalidad similar, ``host`` es una de ellas, encargado del *DNS lookup*.
   **metadata** referido a datos identificativos de distinto tipo.

.. _i3i1:

Whiteouts y directorio opacos.
------------------------------

Para dar soporte a ``rm`` y ``rmdir`` sin cambiar el *FS lower*, el *FS* ``overlay`` necesita recordar qué ficheros han sido borrados del *FS upper*. Se consigue hacer esto, usando ``whiteouts`` y directorios opacos(``non-directory`` son siempre opacos).

Se crea un ``whiteouts`` como un dispositivo ``character`` con número ``0/0``. Cuando es encontrado un ``whiteout`` en el *nivel más alto* de un directorio mezclado, cualquier nombre coincidente en el *nivel más bajo* es ignorado, y el mismo ``whiteout`` es también escondido.

Un directorio *opaco* se constituye, al configurar el ``xatrr`` atributo ``trusted.overlay.opaque`` a ``y``(yes). Donde el sistema de archivos ``upper`` contiene un directorio ``opaque``, cualquier directorio en el FS ``lower`` con el mismo nombre es ignorado.

.. note::
   **Whiteouts** blancos fuera.

.. _i3i2:

readdir
-------

Cuando se hace una petición de ``readdir`` sobre un directorio mezclado, los directorios ``upper`` y ``lower``, son leídos ambos y, la lista de nombres es mezclada de la misma forma - el directorio ``upper`` es leído primero, después el ``lower``; las entradas que ya existen no son re-añadidas. Ésta *lista mezclada* de nombres, se guarda en *caché* en el archivo ``struct``, y permanecerá, mientras el archivo se mantenga abierto.
Si es abierto el ldirectorio, y leído por dos procesos a la vez, deberá tener dos *cachés* por separado.

.. _i4:

4. Referencias y agradecimientos
================================

kernel <Documentation>/filesistems