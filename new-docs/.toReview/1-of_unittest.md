1. [Introducción](#i1)
2. [datos de ensayo](#i2)
3. [Añadiendo datos de ensayo](#i3)
4. [Retirando los datos de ensayo](#i4)
99. [Referencias y agradecimientos](#99)

***************

# _Unidad de prueba_, del árbol de dispositivo _Open Firmware_ #

#### <a name="i1">Introducción</a> ####

Éste  documento   explica   cómo  los  datos de ensayo necesarios  para   ejecutar   la  
Unidad de prueba_, son acoplados al árbol en activo, dinámicamente. De forma independien  
a la arquitectura de la máquina.  

Es recomendable leer los siguiente documentos, antes de seguir avanzando:  

1. [Documentation/devicetree/usage-model.txt](usageModel.html)  
2. [[2]](http://www.devicetree.org/Device_Tree_Usage)  

Ha sido diseñado un _autotest_ para probar la interfase `include/linux/of.h` proporcio-  
nada a los desarrolladores de _controladores de dispositivo_, para recoger la infor-  
mación de los mismos. Para una estructura de datos, que no está _a nivel_, del árbol de  
dispositivo.  

#### <a name="i2">datos de ensayo</a> ####

El archivo fuente, del árbol de dispositivo `drivers/of/unittest-data/testcases.dts`  
contiene los datos de ensayo requeridos, en `drivers/of/unittest.c` para ejecutar de  
forma la  automatizada _Unidad de prueba_ . Actualmente, los siguientes archivos de  
fuente de inclusion del árbol de dispositivo(Device Tree Source Include), `.dtsi`  
son _relacionados_ en `testcases.dts`:  

		drivers/of/unittest-data/tests-interrupts.dtsi
		drivers/of/unittest-data/tests-platform.dtsi
		drivers/of/unittest-data/tests-phandle.dtsi
		drivers/of/unittest-data/tests-match.dtsi

Cuándo el kernel es construido con `OF_SELFTEST` activada, son aplicadas  
las reglas `make`:  

		$(obj)/%.dtb: $(src)/%.dts FORCE
			$(call if_changed_dep, dtc)

... utilizadas para compilar el archivo fuente `testcases.dts`, a un _pequeño binario_  
`testcases.dtb`. En ocasiones referido como _DT nivelado_(... equilibrado, comparado,  
coincidente).  

Después de esto, utilizando las siguientes reglas del _pequeño binario_ de arriba, serán  
replegadas, envueltas, como un archivo `assembly`(ensamblador) `testcases.dtb.S`.  

		$(obj)/%.dtb.S: $(obj)/%.dtb
			$(call cmd, dt_S_dtb)

El archivo `assembly`, es compilado dentro del archivo _objeto_ `testcases.dtb.o`, que  
será enlazado a la imagen del kernel.  

#### [Añadiendo datos de ensayo](i3) ####

Una estructura desnivelada:  

Consiste en un `device_node`s -nodo de dispositivo, en forma de _estructura de árbol_,  
descrita más abajo.  

		// following struct members are used to construct the tree
		struct device_node {
				...
				struct  device_node *parent;
				struct  device_node *descendiente;
				struct  device_node *parejo;
				...
		};
	
__Figura 1__. Describe una estructura genérica _DT_ desnivelada, en una máquina.  
Considera,   únicamente,  punteros _descendientes_ y _parejos_.  Existe otro   puntero;  
_ascendiente_, utilizado para _atravesar_ el árbol, en dirección opuesta. Así, en un  
determinado nivel, el _nodo descendiente_ y, todos los nodos parejos, estarán asociados  
a un puntero ascendente, en un _nodo común_. Ejemplo, los: descendiente1, parejo2,  
parejo3, parejo4, del ascendente apuntan a del nodo raíz.  

		root ('/')
			 |
		descendiente1 -> parejo2 -> parejo3 -> parejo4 -> null
			 |         			|      			|       		 |
			 |        			|      			|       		null
			 |         			|      			|
			 |         			|        descendiente31 -> parejo32 -> null
			 |         			|      		  |    				      |
			 |         			|      		 null    	  			 null
			 |         			|
			 |      descendiente21 -> parejo22 -> parejo23 -> null
			 |        		 	|          	|            |
			 |       		   null      	 null         null
			 |
		descendiente11 -> parejo12 -> parejo13 -> parejo14 -> null
			 |           			|            |   			   |
			 |           			|            |   			  null
			 |           			|            |
			null        		 null       descendiente131 -> null
				                			       |
				                      			null


Figura 1: estructura genérica de un árbol de dispositivo desnivelado.  

Antes de ejecutar _Unidad de prueba_, es un requisito _acoplar_ los datos de ensayo,  
al _DT_ de la máquina -si está presente. Así, cuando  es llamado `selftest_data_add()`,  
tan pronto como son leídos los datos del _DT_, enlazados en la imagen del kernel.  
Los símbolos del kernel, consiguen esto.  

		root ('/')
				|
		 testcase-data
				|
		 test-descendiente0 -> test-parejo1 -> test-parejo2 -> test-parejo3 -> null
				|             			  |                |                |
		 test-descendiente01     null             null             null


__Figura 2__. Ejemplo de los datos de ensayo de un árbol, siendo acoplados a un árbol  
activo.

De acuerdo al anterior escenario, el _árbol activo_ está ya presente, por lo que no  
será necesario acoplar la raíz `/`, al nodo. El resto de nodos, son acoplados mediante  
la llamada `of_attach_node()` sobre cada nodo.

En la función `of_attach_node()`, el nuevo nodo será acoplado como _descendiente_ del  
en   el  árbol activo. Si el ascendiente,  ya tiene un descendiente, el  nuevo   nodo  
reemplzará al descendiente activo, convirtiéndolo en su parejo. Por consiguiente,  
acoplado los datos del nodo al árbol activo -_figura 1_, la estructura final es como se  
muestra en la _figura 3_

		root ('/')
			 |
		testcase-data -> descendiente1 -> parejo2 -> parejo3  	->	  parejo4 -> null
			 |           			    |          |           |        	  		 |
		 (...)           			  |          |           |        	 		  null
				           			    |          |         descendiente31 -> parejo32 -> null
				           			    |          |           |        			   |
				           			    |          |          null      			  null
				           			    |          |
				           			    |        descendiente21 -> parejo22 -> parejo23 -> null
				           			    |          |         				  |   			  |
				           			    |         null        		   null    		 null
				           			    |
				            descendiente11 -> parejo12 -> parejo13 -> parejo14 -> null
				           			    |          |            |            |
				            		   null       null          |           null
				                 			                      |
				                                    descendiente131 -> null
				                 		                     	 |
				                 		                     	null
		-----------------------------------------------------------------------

		root ('/')
			 |
		testcase-data -> descendiente1 -> parejo2 -> parejo3 -> parejo4 -> null
			 |               |        			  |           |           |
			 |             (...)      			(...)       (...)        null
			 |
		test-parejo3 -> test-parejo2 -> test-parejo1 -> test-descendiente0 -> null
			 |                |                   |                |
			null             null                null         test-descendiente01

__figura 3:__ Estructura de árbol activa, después de acoplar los datos del _caso de_  
_prueba_.

Astutos lectores, habrán notado que el nodo `test-descendiente0`, se convierte en el  
último _parejo_, comparándolo con la estructura anterior en _figura 2_. Después de  
acoplar `test-descendiente0`, el	`test-parejo1`, es acoplado al que empuja al nodo  
descendiente, ejem. `test-descendiente0` para convertirse en el parejo y, haccerse a él  
mismo, nodo descendiente.  

Si es encontrado un nodo duplicado -por ejemplo si un nodo con el mismo nombre de pro-  
piedad, está ya presente, el nodo será no acoplado, en su lugar la propiedad será  
actualizada, llamando a la función `update_node_properties()`.  

#### <a name="i4">Retirando los datos de ensayo</a> ####

Tras haber completado el _caso de prueba_, `selftest_data_remove`, será llamado con  
objeto de retirar los nodos de dispositivo, acoplados inicialmente. Primero la hoja  
de nodo es _desacoplada_, entonces moviendo los nodos ascendientes, retirado;  
eventualmente el árbol al completo. `selftest_data_remove()` llama a  
`detach_node_and_children()`, el cuál usa `of_detach_node()`, para liberar el nodo del  
árbol activo.  

Para liberar el nodo, `of_detach_node()` actualiza el puntero descendiente a un  
nodo ascendiente concretado o, al anterior _parejo_.  


***************

#### <a name="i99">Referencias y agradecimientos</a> ####

__Author:__ Gaurav Minocha <gaurav.minocha.os@gmail.com>  

nota d.t. parent, ascendientes, u organizados de manera ascendente.  
nota d.t. descendiente, descendientes, u organizados de forma descendiente.  
nota d.t. sibling, parejos u organizados _en la horizontal_. Kall 7o Poli23.  

<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
