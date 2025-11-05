1. Lista `TODO` para el árbol de dispositivo
2. Estructura general
3. `CONFIG_OF_DYNAMIC`
4. [Referencias y agradecimientos](#i4)
## <a name="i1">Lista `TODO` para el árbol de dispositivo</a> ##

#### <a name="i2">Estructura general</a> ####

1. Cambios en listas personalizadas(custom lists) a `(h)list_head`, para los nodos y la  
estructura de propiedades.  


#### <a name="i3">`CONFIG_OF_DYNAMIC`</a>  ####

1. _Ciclo de vida_, para el documento `CONFIG_OF_DYNAMIC`.  
2. Cambiar a `RCU`, en actualizaciones del _árbol_ y, _deshacerse del bloqueo de giro_  
_global_.  
3. Configurar _por defecto_ `->full_name` a `of_attach_node()`, en todo momento.  
4. `pseries`, deshacerse de la modificación del _árbol_, _códificación abierta(open-  
coded)_ en `arch/powerpc/platforms/pseries/dlpar.c`  


#### <a name="i4">Referencias y agradecimientos</a> ####


nota d.t. _spin lock_, bloqueo de giro.  
nota d.t. _get rid_, deshacerse de.  

<ul id="firma">
	<li><b>Traductor:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
