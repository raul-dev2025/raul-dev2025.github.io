- Notas del Solucionador dinámico del Árbol de dispositivo
- Cómo funciona el *solucionador*
- Referencias y agradecimientos

Resolución dinámica, notas
--------------------------

Éste documento describe la implementación -en el lado del *kernel*, del
*Solucionador del árbol de dispositivo*. **localización:**
``drivers/devicetree/resolver.c`` **lectura:**
``Documentation/devicetree/dt-object-internal.txt``\ `[f1] <#f1>`__

Cómo funciona el *solucionador*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El solucionador es dado como *entrada*, un *árbol* arbitrario, compilado
con la apropiada *opción* ``dtc`` y, sosteniendo la *etiqueta*
``/plugin/``. Ésto genera los nodos ``__fixups__ & __local_fixups__``,
tal y como se describe en `[f1] <#f1>`__.

La secuencia de funcionamiento del *solucionador* es como sigue:

1. Obtine el valor *phandle* máximo, del árbol de dispositivo -desde el
   árbol
   *activo* ``+ 1``.
2. Ajusta mtodos los *phandel* locales del árbol de dispositivo, para
   resolver el *montante*\ (cantidad).
3. Usa la información del nodo ``__local__fixups__``, para ajustar las
   referencias locales al mismo montante.
4. Para cada propiedad en el nodo ``__fixups__``, localiza el nodo
   referenciado
   en el árbol *activo*. Es la etiqueta usada para marcar el nodo.
5. Recupera el *phandle* del *objetivo* de la corrección.
6. Para cada corrección en la propiedad, encuentra la localización del
   ``node:property:offset`` y lo reemplaza con el valor *phandle*.

--------------

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   | [f1] **nota:** El documento no aparece en la
     documentación,(270218). Hay algunas
   | otras referencias a ``overlay-notes.txt``, otras referencias en
     internet -por comprobar
   | advierte de que tal archivo, aún no ha sido implementado por
     razones técnicas.
   | 

..

   **phandle:** especie de puntero de un nodo, el cuál apunta a la
   definición del nodo, pudiéndo ser guardado en el mismo archivo o, en
   otro distinto.

**Traductor:** Heliogabalo S.J.
