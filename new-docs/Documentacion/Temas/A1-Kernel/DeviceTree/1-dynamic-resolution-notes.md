* Notas del Solucionador dinámico del Árbol de dispositivo
* Cómo funciona el _solucionador_
* Referencias y agradecimientos

## Resolución dinámica, notas ##

Éste documento describe la implementación -en el lado del _kernel_, del 
_Solucionador del árbol de dispositivo_.
__localización:__ `drivers/devicetree/resolver.c`
__lectura:__ `Documentation/devicetree/dt-object-internal.txt`[[f1]](#f1)


#### Cómo funciona el _solucionador_ ####

El solucionador es dado como _entrada_, un _árbol_ arbitrario, compilado con la 
apropiada _opción_ `dtc` y, sosteniendo la _etiqueta_ `/plugin/`. Ésto genera los
nodos `__fixups__ & __local_fixups__`, tal y como se describe en [[f1]](#f1).

La secuencia de funcionamiento del _solucionador_ es como sigue:

1. Obtine el valor _phandle_ máximo, del árbol de dispositivo -desde el árbol  
_activo_ `+ 1`.
2. Ajusta mtodos los _phandel_ locales del árbol de dispositivo, para resolver 
el _montante_(cantidad).
3. Usa la información del nodo `__local__fixups__`, para ajustar las referencias 
locales al mismo montante.
4. Para cada propiedad en el nodo `__fixups__`, localiza el nodo referenciado  
en el árbol _activo_. Es la etiqueta usada para marcar el nodo.  
5. Recupera el _phandle_ del _objetivo_ de la corrección.  
6. Para cada corrección en la propiedad, encuentra la localización del  
`node:property:offset` y lo reemplaza con el valor _phandle_.

***************


#### Referencias y agradecimientos ####

> <a name="f1">[f1] __nota:__ El documento no aparece en la documentación,(270218). Hay  algunas  
otras referencias a `overlay-notes.txt`, otras referencias en internet -por comprobar  
advierte de que tal archivo, aún no ha sido implementado por razones técnicas.  
</a>

> __phandle:__ especie de puntero de un nodo, el cuál apunta a la definición del nodo,
pudiéndo ser guardado en el mismo archivo o, en otro distinto.



__Traductor:__ Heliogabalo S.J.





