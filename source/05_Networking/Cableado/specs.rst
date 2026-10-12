===============================
Especificaciones de componentes
===============================


Derivación Activa mediante Mini Switch y Conectores Blindados
=============================================================

Este documento detalla la especificación técnica adoptada para la resolución del nudo de confluencia en "Y" dentro de la caja de registro empotrada, fundamentada en la implementación de una arquitectura de derivación activa.

Justificación técnica
---------------------

En una infraestructura de red de categoría 6 con cableado apantallado (FTP/STP), la unión física de múltiples segmentos de cable no puede resolverse mediante empalmes directos de los hilos ni mediante regletas de derivación pasiva en paralelo. Dicha práctica altera de forma crítica la impedancia característica del medio de transmisión, introduciendo ondas estacionarias, atenuación severa y diafonía inaceptable para protocolos de alta velocidad.

Para solventar la confluencia de tres extremos de cable en un espacio confinado sin comprometer el rendimiento del enlace, se descartan los repartidores pasivos y se adopta un esquema de **conmutación activa**, el cual aísla eléctricamente cada uno de los segmentos y regenera la señal digital de manera íntegra.

Componentes del Sistema de Derivación Activa
--------------------------------------------

La solución se compone de dos elementos hardware principales seleccionados por sus características técnicas y su factor de forma optimizado para espacios reducidos:

* **Mini Switch Ethernet Gigabit de 5 Puertos (Chasis Metálico):**
* Dispositivo conmutador de red de formato ultracompacto diseñado para integrarse en cajas de registro o cuadros de distribución secundarios.
* Incorpora un chasis metálico robusto que actúa como pantalla protectora frente a interferencias electromagnéticas externas y permite una correcta disipación térmica por conducción.
* Dispone de puertos RJ45 blindados integrados en la propia estructura del switch, asegurando la continuidad galvánica del apantallamiento de todo el sistema.

* **Conectores RJ45 Macho Blindados (Cat-6 FTP/STP):**
* Conectores de alta gama con cuerpo exterior recubierto de aleación metálica.
* Incluyen una pestaña o abrazadera posterior diseñada para realizar una fijación mecánica y eléctrica directa sobre la malla de aluminio y el hilo de drenaje del cable Cat-6, garantizando que el apantallamiento del cable permanezca cerrado perimetralmente hasta la entrada del puerto del switch.

Esquema de Interconexión y Gestión de Malla
-------------------------------------------

El despliegue de los elementos dentro de la caja de registro obedece a las siguientes directrices de montaje:

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Parámetro / Componente
     - Especificación de Diseño
   * - **Topología Lógica**
     - Estructura de estrella centrada en el mini switch activo, permitiendo comunicación simultánea a velocidad Gigabit entre los tres extremos.
   * - **Continuidad del Blindaje**
     - Las mallas de aluminio y hilos de drenaje de los tres cables Cat-6 se crimpan firmemente a las carcasas metálicas de sus respectivos conectores RJ45, cerrando el circuito de apantallamiento a través del chasis del switch.
   * - **Adaptación Espacial**
     - Orientación de los radios de curvatura del cableado respetando los límites normativos del estándar Cat-6 para evitar estrangulamientos en la caja de registro empotrada.