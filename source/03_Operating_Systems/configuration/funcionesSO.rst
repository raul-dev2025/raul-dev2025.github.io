Funciones del Sistema Operativo
===============================

Es un conjunto de programas que gestionan y controlan los recursos de un ordenador.

Funciones principales
---------------------

- **Gestión de procesos**: es el sistema operativo quien se encarga de gestionar la creación, ejecución y terminación de cualquier proceso, asignando los recursos necesarios al mismo; memoria, tiempo de procesador, etc.
- **Servicios**: Un servicio es un programa en ejecución gestionado por el sistema.
- **Procesos**: es un programa en ejecución, por ejemplo un programa que ha abierto el usuario. 

  Un proceso es una entidad activa que sigue una secuencia de instrucciones, accede a recursos del sistema (CPU, memoria, archivos, dispositivos de E/S) y puede comunicarse con otros procesos.
- **Instancia(Proceso)**:  Cuando ejecutas un programa (por ejemplo, abres un navegador web o un editor de texto), el sistema operativo crea una instancia de ese programa en la memoria. A esta instancia se le conoce como proceso.

  Aunque tengas el mismo programa instalado varias veces, cada vez que lo ejecutes, el sistema operativo creará una nueva instancia (un nuevo proceso) de él, con su propio espacio de memoria y recursos asignados.

.. tip::

    prodríamos decir que es la copia de un proceso en un momento determinado.

- **Hilos/Hebra**: Es la unidad más pequeña de procesamiento que puede ser gestionada por un planificador de procesos en un sistema operativo. Imagina un programa como un libro. Tradicionalmente, un proceso sería como si solo pudieras leer un capítulo a la vez, y para leer otro, tendrías que cerrar el que estabas leyendo y abrir el siguiente.

  Un hilo permite que un único programa (proceso) realice múltiples tareas simultáneamente. Volviendo a la analogía del libro, un hilo te permitiría tener varios marcadores en diferentes páginas y leerlas al mismo tiempo, o incluso tener a varias personas leyendo diferentes secciones del mismo libro a la vez.

- **Gestión de Archivos**: son numerosas las operaciones que pueden realizarse sobre un archivo: abrir, cerrar, crear, eliminar, guardar, modificar`...` todo éste conjunto de medidas están definidas por el **Sistema de Archivos** en cada caso. En Windows el sistema de ficheros ``NTFS``, es el más común, y el que suele utilizarse en la mayoria de instalaciones estandar; pero no el único. 
  ``Fat32`` se ha convertido de hecho, en un estandar para la partición de arranque de cualquier sistema operativo moderno(EFI). Tanto es así, que incluso otros sistemas operativos han adoptado este sistema de ficheros, para configurar dicha partición -*el arranque del sistema*.
  ``Fat32`` no es una partición, es un sistema de ficheros, al igual que lo es ``ext2``; comparativamente, es otro de los sistemas de ficheros utilizados para la partición de arranque de un sistema, esta vez, ligado al arranque de un sistema Linux. 
  
- **Gestión de Memoria**: El *SO* es el encargado de gestionar la memoria principal del sistema(RAM), asignando espacio de memoria a los procesos. Es un componente crítico, a la hora de asignar de forma segura y óptima este recurso compartido. Su objetivo principal es abstraer la complejidad del *hardware* de memoria, proporcionando a las *aplicaciones* y al *kernel*, un entorno de ejecución fiable y de alto rendimiento.

En mi opinión, es necasario hacer una distinción entre el espacio de usuario(las aplicaciones) y el espacio del **kernel**. Un ejemplo claro estaría representado por un controlador de dispositivo, que no siendo una aplicación de usuario -*canonicamente hablando*, ocupa un espacio con unos privilegios muy específicos.

- **Gestión de Entada/Salida**
- **Seguridad**

Sistemas monoproceso y multiproceso
-----------------------------------
Los primeros ordenadores utilizaron sistemas operativos monoproceso; eran capaces de trabajar de forma secuencial con los procesos. Un único proceso entraba al procesador y hasta que no terminaban los cálculos de dicho proceso, no entraba al procesador un nuevo proceso.

Los sistemas actuales trabajan de forma asincrónica, siendo capaces de trabajar en distintas tareas al mismo tiempo. El procesador es capaz de ejecuatar varios procesos a la vez.


El Kernel
---------
El núcleo del sistema -o kernel, es el componente central de un sistema operativo. Haces las veces de intermediario entre la maquinaria de la computadora(hardware) y los programas(software) que corren en el sistema. Su principal cometido es gestionar los recursos de todo el sistema; permitiendo la comunicación entre los componentes físicos y las aplicaciones.


Llamadas a sistema
------------------
Es un mecanismo que permite a una aplicación de usuario, solicitar un servicio al sistema operativo. Son funciones de código, escritas en lenguaje de programación. Actúan como interfases, entre los procesos de usuario y el núcleo del sistema operativo(kernel). Permiten *acceso* controlado a recursos *hardware* y servicios que requieren de ciertos privilegios.

 
Administrador de discos
-----------------------
Es una herramienta esencial en cualquier sistema operativo, siendo su principal función, la gestión de unidades de almacenamiento(discos duros, unidades externas, etc.). Entre sus capacidades o funciones principales:

- Crear, formatear y eliminar particiones.
- Redimensionar y extender volúmenes.
- Cambiar letras de unidad(Windows).
- Mostrar el estado del disco(espacio, salud, etc.)


Administrador de dispositivos
-----------------------------
En esencia, es un mecanismo que permite el control y la gestión de la maquinaria -o hardware, en la computadora. Los distintos sistemas operativos, recurren a una implementación diferenciada, aunque su función es la misma.

Una de las diferencias en cuanto a la implementación, es el caracter céntrico que denota dicho mecanismo en un entorno Windows; donde es el Administrador de dispositivos(Device Manager) quien se encarga de todas las cuestiones relacionadas con la gestión del/los dispositivos.

En un entorno Linux, en cambio, el núcleo del sistema operativo, implementa un subsistema en sí mismo, quien se encarga de la gestión de los dispositivos. Los controladores son parte del kernel; de forma que es posible construirlos de manera integrada -como parte del kernel, como módulo cargable u obviarlos completamente. Esta forma de trabajar con los controladores se la conoce como **sistema de construcción triestado**; con tres opciones: ``yes - no - m``.

