## NUMA

__Non-uniform memory acces(NUMA)__, memoria de acceso no uniforme.
Es un diseño de memoria para computador, usado sobre multiprocesadores, donde el tiempo
de acceso a memoria, depende de la localización de la memoria, relativa al procesador.

Bajo _NUMA_, un procesador puede tener acceso más rápido a su própia memoria local, que a
la memoria local o compartida, de otro procesador. El beneficio de _NUMA_, está asociado
a ciertas cargas de trabajo, sobre todo en _servidores_ donde los datos están ligados a
determinadas tareas o usuarios.


Los procesadores más modernos, operan considerablemente más rápido, que la momoria que
usan. Con los procesadores más antiguos, ocurría lo contrario; la _CPU_ generalmente
operaba más lenta, que su própia memoria.

En la década de los _80_ y, con la aparición de los supercomputadores, algunos diseños
de estos supercomputadores, se centraron más en el rápido acceso a la memoria, que en
el desarrollo de procesadores más rápidos, permitiendo a las computadoras, trabajar sobre
grandes conjuntos de datos, a velocidades que otros sistemas ni se aproximaban.

Limitar el número de accesos a memoria, proporcionaría la clave para extraer un alto
rendimiento a modernas computadoras.
Para el desempeño de los procesadores, ésto significó un creciente montante de memoria
_caché_ de alta velocidad y, el uso de numerosos algoritmos con el fin de evitar
pérdidas en estas _cachés_.

Pero con el dramático incremento en tamaño de los sistemas operativos y de las aplicaciones
que corren sobre ellos, se ha sobrepasado el beneficio que suponía la mejora en las _cachés_.
Para sistemas con multiprocesadores, sin el sistema _NUMA_, representa un mayor problema,
el sistema puede interferir con varios procesadores al mismo tiempo, puesto que sólo un 
procesador podrá tener acceso a la memoria a la vez. 

_NUMA_ intenta resorver esta problemática, proporcionando memoria separada para cada
procesador...

>Leer artículo completo en la _wiki_.
