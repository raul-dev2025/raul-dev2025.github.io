1. [conjunto de cambios](#i1)
99. [Referencias y agradecimientos](#i99)

***************


## <a name="i1">conjunto de cambios</a> ##

El conjunto de cambios de un _DT_, es un método que permite aplicar cambios sobre un  
árbol _activo_, de tal forma, que sean aplicados el _conjunto de cambios totales_ o,  
puede que ninguno de ellos. Si ocurre un error _parcial_, mientras es aplicado el  
_conjunto de cambios_, se retrocederá al _estado anterior_.  

Cuando es aplicado un cambio, serán aplicados _de una sóla vez_, todos ellos, antes de  
emitir notificaciones `OF_RECONFIG`. De ésta manera el receptor verá un consistente y,  
completo estado del _árbol_, cuando los receptores sean notificados.  

La secuenccia de un cambio es como sigue:  

1. `of_changeset_init()` -- inicializa un _conjunto de cambios_.  
2. Un número de llamadas a _cambios_ en el árbol _DT_, `of_changeset_attach_node(),  
of_changeset_detach_node(), of_changeset_add_property(),  
of_changeset_remove_property, of_changeset_update_property()`, para preparar el  
_conjunto de cambios_. En este momento no se realizará ningún cambio.  
Todas las operaciones de cambio, son guardadas en la lista de _entradas_ `of_changeset`.  
3. `of_changeset_apply()` -- aplica los cambios al árbol.  
Ya sean aplicados, el _conjunto de cambios_ al completo o, si hubo un error en el árbol  
y tuvo que ser restaurado, a un estado anterior. El[[f1]](#f1) _núcleo_, asegura la  
_serialización_ correcta, a través de un bloqueo. Una versión desbloqueada de  
`__of_changeset_apply`, estará disponible si fuese necesaria.  
4. Si los cambios son aplicados correctamente, el _conjunto de cambios_, necesitará ser  
retirado, esto podrá llevarse a cabo por medio de `of_changeset_revert()`.  





***************

#### <a name="i99">Referencias y agradecimientos</a> ####

<a name="f1">[f1]</a>nota d.t. el _núcleo_, referido a la _aplicación_, o "motor", que  
lleva a cabo los cambios. No al kernel.  

<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
