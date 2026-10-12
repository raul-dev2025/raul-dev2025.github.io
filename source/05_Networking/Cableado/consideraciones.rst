=====================================================
Consideraciones Operativas y de Mantenimiento
=====================================================

Lineamientos de Operación y Mantenimiento Preventivo
=====================================================

Este documento final establece las consideraciones operativas, pautas de mantenimiento preventivo y restricciones de ampliación para asegurar la durabilidad y estabilidad de la infraestructura de red basada en derivación activa.

Mantenimiento Preventivo y Revisiones
--------------------------------------

La infraestructura de red instalada en espacios confinados requiere un plan de inspección periódica para garantizar la fiabilidad del sistema a largo plazo:

* **Inspección Térmica:** Verificar de manera visual o mediante termografía opcional que la disipación térmica del mini switch en la caja de registro opere dentro de los rangos seguros, evitando acumulación excesiva de calor.
* **Revisiones de Conexión:** Comprobar anualmente que las vibraciones o el asentamiento de los cables no hayan provocado aflojamientos en los conectores RJ45 blindados ni en el acoplamiento de las mallas de tierra.
* **Limpieza de Entorno:** Asegurar que las cajas de registro permanezcan libres de humedad, polvo o elementos extraños que puedan comprometer el aislamiento eléctrico de los componentes activos.

Restricciones de Ampliación y Carga
------------------------------------

Cualquier modificación o crecimiento futuro de la red debe ajustarse estrictamente a las limitaciones físicas y lógicas del diseño actual:

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Parámetro de Restricción
     - Condición Límite
   * - **Saturación de Puertos**
     - El mini switch de 5 puertos cuenta con un número máximo de conexiones disponibles; no se permite la inserción de divisores pasivos en cascada que alteren la impedancia.
   * - **Consumo Energético**
     - La fuente de alimentación externa debe mantenerse dentro de los márgenes de voltaje y amperaje especificados, evitando sobrecargas en las líneas auxiliares de la caja.
   * - **Ancho de Banda**
     - La arquitectura Gigabit centralizada soporta el tráfico nominal previsto; cualquier introducción masiva de equipos secundarios requerirá reevaluar la capacidad de conmutación.

Cierre del Dossier Técnico
----------------------------

La aplicación conjunta de las especificaciones de componentes, las directrices de apantallamiento, los protocolos de certificación y estas consideraciones operativas garantiza una infraestructura de alta velocidad robusta, segura y alineada con los estándares profesionales de ingeniería de redes.