==========================
Network Namespaces (netns)
==========================

.. admonition:: red virtual
   
   "...basada en una máquina virtual en espacio de kernel"... lo que en teoría, significa que es posible de alguna manera, duplicar/clonar/instanciar, la propia estructura de red?


La respuesta corta es **sí, es absolutamente posible**, pero con un matiz importante sobre qué hace la "máquina virtual" de *nftables* y qué componentes del kernel se encargan de duplicar la red.

-----

1. La "Máquina Virtual" de *nftables* (Nivel de Reglas)
=======================================================

Cuando se dice que `nftables` funciona con una **máquina virtual de bytecode en el espacio del kernel**, no significa que cree una VM tipo QEMU/KVM que ejecute un sistema operativo. Significa que:

* Tu herramienta en espacio de usuario (`nft`) traduce las reglas que escribes a un **bytecode de bajo nivel** (instrucciones muy simples como `load`, `cmp`, `set`).
* El módulo `nft_tables` del kernel contiene un **mando de ejecución (intérprete) súper rápido** que procesa ese bytecode para evaluar los paquetes.

¿Se puede clonar/instanciar este motor?
---------------------------------------

**Sí.** Gracias a esta arquitectura, la lógica de filtrado es totalmente declarativa y está aislada de la pila de red global. Puedes:

* **Exportar e importar el estado completo**: Con un simple ``nft list ruleset > ruleset.nft`` puedes volcar el estado bytecode completo y replicarlo/clonarlo instantáneamente en otra máquina o espacio aislado.
* **Múltiples tablas/cadenas aisladas**: Puedes instanciar múltiples tablas independientes dentro del mismo kernel sin que interfieran entre sí.

2. Instanciar la *Pila de Red Completa*: *Network Namespaces* (``netns``)
=========================================================================

Si lo que buscas es **duplicar o clonar la propia estructura física y lógica de la red** (tablas de rutas, interfaces, sockets, reglas de firewall, vecinos ARP), la tecnología del kernel de Linux encargada de esto son los **Network Namespaces** (``netns``).

Aquí es donde `nftables` y la virtualización de red se unen a la perfección:

* **Pila de red independiente**: Un *Network Namespace* crea una copia/instancia completamente aislada de la pila de red. Un proceso asignado a ese namespace tiene sus propias interfaces (ej. ``eth0``, ``lo``), su propia tabla de rutas y **su propia instancia del motor nftables**.
* **Infraestructura de contenedores**: Esta es la base sobre la que funcionan Docker, Podman o Kubernetes. Cuando lanzas un contenedor, el kernel le asigna un `netns` propio.

En Resumen: ¿Cómo se combina esto en el laboratorio?
====================================================

.. list-table::
   :widths: 20 25 55
   :header-rows: 1

   * - Capa
     - Tecnología
     - ¿Qué permite instanciar/duplicar?
   * - **Aislamiento de Red**
     - **Network Namespaces** (``ip netns``)
     - Clona/duplica la **pila de red completa** (interfaces, sockets, routing, loopback) en el mismo kernel sin overhead de hardware.
   * - **Aislamiento de Firewall**
     - **``nftables`` Bytecode VM**
     - Instancia un **mecanismo de filtrado de paquetes programable** por cada namespace de red de forma ligera y de alta velocidad.


En tu entorno de laboratorio en *buildlab*, podrías crear en cuestión de milisegundos 50 estructuras de red idénticas mediante ``ip netns add test1``, y cargar en cada una de ellas una instancia independiente de *nftables* con sus propias reglas para ejecutar pruebas de carga o simulación de topologías de red complejas sin salir de la misma VM.