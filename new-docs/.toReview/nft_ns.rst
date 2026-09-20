=======================================================================
Arquitectura de Filtrado y Virtualización de Red: nftables y Namespaces
=======================================================================

:Fecha: 31 de Julio de 2026
:Entorno: Laboratorio de Compilación y Pruebas (buildlab)
:Sistema Operativo: Rocky Linux 10.1 (Kernel 6.12.0)

Resumen Ejecutivo
=================

Durante la sesión de análisis del entorno de ejecución de LTP (*Linux Test Project*),
se profundizó en la arquitectura del subsistema de filtrado de paquetes `nftables`
y su relación con la capacidad de instanciación y clonación de estructuras de red
en el kernel de Linux.

Arquitectura del Motor nftables
===============================

El módulo `nft_tables` sustituye el modelo tradicional de *iptables* introduciendo
un intérprete de bytecode de bajo nivel que se ejecuta directamente en el espacio de kernel.

* **Traducción en Espacio de Usuario**: Las reglas escritas mediante la utilidad `nft`
se compilan a bytecode estructurado (instrucciones simples como *load*, *cmp*, *set*).
* **Máquina Virtual del Kernel**: El subsistema en kernel actúa como un motor de
ejecución de alta velocidad que procesa dicho bytecode para evaluar cada paquete.
* **Portabilidad y Cloned**: Dado que la lógica de filtrado es declarativa, el conjunto
de reglas (*ruleset*) puede exportarse, clonarse e instanciarse de forma atómica en
diferentes entornos.

Instanciación de la Pila de Red (Network Namespaces)
====================================================

La duplicación completa de la infraestructura de red no recae únicamente en el motor de
filtrado, sino en la combinación de `nftables` con los **Network Namespaces** (`netns`)
del kernel.

.. list-table:: Comparativa de Capas de Virtualización de Red
:header-rows: 1
:widths: 20 25 55

  * - Capa
    - Tecnología
    - Capacidad de Instanciación
  * - **Aislamiento de Red**
    - Network Namespaces (``netns``)
    - Duplica la pila de red completa (interfaces, tablas de rutas, sockets, ARP) en espacios aislados.
  * - **Lógica de Filtrado**
    - Máquina Virtual ``nftables``
    - Instancia un motor de filtrado programable e independiente por cada namespace de red.



Aplicación en el Entorno de Laboratorio
=======================================

Esta arquitectura permite crear topologías complejas y aisladas dentro del host de
compilación de forma eficiente:

1. **Creación de Entornos Aislados**: Posibilidad de instanciar múltiples pilas de red
lógicas en milisegundos sin sobrecarga de hipervisor.
2. **Pruebas de Estrés y Validación**: Ejecución paralela de baterías de test de LTP
sobre conjuntos de reglas `nftables` aislados evitando interferencias con la red principal.
3. **Replicación de Estado**: Volcado e inyección directa de *rulesets* para pruebas
regresivas mediante la sintaxis nativa de `nftables`.