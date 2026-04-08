## RCU, read-copy-update

Leer-copiar-actualizar. Es un mecanismo de sincronización, basado en la mútua exclución. 

> RCU, no implementa la exclusión mútua en un sentido convencional: lectores _RCU_ pueden y  
> de hecho lo hacen, actuar concurentemente con actualizaciones de _RCU_. Las variantes de  
> _RCU_ se encuentran en un espacio, donde los lectores _RCU_ acceden a versiones anteriores  
> que están siendo concurrentemente actualizadas, en contraste a como se llevarían a cabo  
> con los mecanismos convencionales de concurrencia(en tiempo).

Es usado cuando la eficiencia en las lecturas es crucial. Es en ejemplo del mecanismo  
_space-time tradeoff(intercambio espacio/tiempo)_, activando rápidas operaciones a costa de
mayor uso de espacio.

Leer-copiar-actualizar(RCU), permite a múltiples hilos, leer eficientemente desde la memoria  
compartida, desreferenciando actualizaciones, después de lecturas preexistentes, en un tiempo  
posterior; mientras se marcan datos simultáneamente, asegurando que nuevos lectores podrán  
leer los datos actualizados. Esto permite a los _lectores_, proceder como si no hubiese  
sincronización involucrada. Por esta razón, serán más rápidos, aunque las actualizaciones  
más difíciles.
