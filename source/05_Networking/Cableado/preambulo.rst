========================
Análisis de la topología
========================

Preámbulo
=========

Este documento técnico establece las directrices, el marco de diseño y las soluciones de ingeniería adoptadas para el despliegue de una red de comunicaciones de alta velocidad en inmuebles que carecen de una infraestructura centralizada o de espacio físico dedicado para la instalación de armarios de distribución (racks).

Contexto de la Infraestructura
==============================

En entornos profesionales de dimensiones reducidas u oficinas distribuidas en múltiples plantas, la planificación de redes se enfrenta con frecuencia a severas limitaciones arquitectónicas. La ausencia de un cuarto de comunicaciones o de canalizaciones principales dedicadas obliga a repensar el trazado físico de los medios de transmisión. Para solventar este obstáculo, el proyecto contempla la reutilización de los conductos tubulares preexistentes —originalmente destinados a la distribución de señales de antena y telecomunicaciones analógicas— para el despliegue de cableado de datos de altas prestaciones de categoría 6 con malla (FTP/STP).

Desafíos Técnicos y Restricciones Físicas
=========================================

La sustitución del cableado coaxial tradicional por pares trenzados blindados de categoría 6 plantea desafíos técnicos críticos que deben ser abordados bajo estrictos criterios de ingeniería de sistemas:

* **Confluencia de Líneas (Topología en Estrellas Parciales):** La convergencia de varios tramos de cable en puntos específicos del recorrido, condicionados por la ubicación de las cajas de registro empotradas originales, genera una topologia de interconexión compleja que no admite métodos de empalme pasivo convencionales.
* **Integridad de la Señal y Alta Frecuencia:** Al operar en frecuencias elevadas propias de redes Gigabit y 10G, cualquier alteración de la impedancia característica, la ruptura de la torsión de los pares o la introducción de derivaciones en paralelo provoca reflexiones de señal, diafonía severa y la degradación irreversible del enlace.
* **Apantallamiento y Compatibilidad Electromagnética (CEM):** La utilización de cableado apantallado (FTP/STP) exige mantener una continuidad eléctrica ininterrumpida de la malla de protección en todo el trayecto para preservar el efecto de jaula de Faraday frente a interferencias electromagnéticas inducidas por el tendido eléctrico adyacente.
* **Restricciones Espaciales y Térmicas:** Las cajas de registro empotradas en tabiques ofrecen un volumen útil muy reducido y carecen de ventilación forzada, lo que condiciona de manera drástica el factor de forma y la disipación térmica de los elementos activos o pasivos albergados en su interior.

Objetivo del Documento
======================

El presente dosier documenta de manera formal las soluciones técnicas adoptadas para resolver la confluencia de líneas en espacios confinados, garantizando el cumplimiento de los estándares de transmisión de datos, la seguridad eléctrica de la instalación y la robustez exigida en entornos corporativos.