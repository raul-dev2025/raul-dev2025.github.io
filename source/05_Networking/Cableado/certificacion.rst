==================================================
Pruebas de Certificación y Protocolo de Validación
==================================================

Procedimiento de Verificación en Redes de Alta Velocidad (Cat-6)
================================================================

Este documento detalla el protocolo de pruebas y certificación requerido para validar el rendimiento de la infraestructura de red instalada, asegurando el cumplimiento de los estándares de transmisión Gigabit y la correcta atenuación de interferencias.

Parámetros Críticos de Transmisión
----------------------------------

Durante el proceso de certificación con equipo de medida homologado, se evaluarán los siguientes parámetros físicos y eléctricos para garantizar la estabilidad del enlace:

* **Pérdidas de Retorno (Return Loss):** Mide la cantidad de energía reflejada debido a discontinuidades en la impedancia característica a lo largo del enlace, especialmente relevante en los puntos de conectorización y derivación activa.
* **Atenuación (Insertion Loss):** Pérdida de potencia de la señal a lo largo del medio físico, comprobando que los tramos de cable y los conectores no superen los límites máximos permitidos por el estándar Cat-6.
* **Diafonía en el Extremo Cercano (NEXT):** Evalúa el nivel de acoplamiento de señal no deseada entre pares adyacentes dentro del mismo cable, garantizando que el aislamiento se mantenga por encima de los márgenes normativos.

Instrumentación y Metodología de Medida
---------------------------------------

La verificación de la red requiere el uso de un certificador de cables de categoría 6 (Nivel IIe o superior), siguiendo una metodología estricta de calibración y ensayo:

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Fase de Ensayo
     - Criterio Operativo
   * - **Calibración del Equipo**
     - Realizar la compensación de los adaptadores de test (autotest de referencia) inmediatamente antes de iniciar las mediciones en campo.
   * - **Inyección de Patrones**
     - Ejecutar barridos de frecuencia completos desde 1 MHz hasta 250 MHz en todos los pares de cada segmento interconectado.
   * - **Registro de Resultados**
     - Almacenar los informes de prueba en formato digital, identificando inequívocamente cada boca de red y tramo de derivación activa validado.

Criterios de Aceptación y Entrega
-----------------------------------

Un enlace se considerará certificado de manera positiva únicamente si cumple de forma simultánea con las siguientes condiciones técnicas:

1. **Margen de Confianza:** Todos los parámetros evaluados superan la prueba de "Pasa" (*Pass*) considerando la incertidumbre de medida del certificador.
2. **Integridad del Blindaje:** El informe confirma la continuidad galvánica de extremo a extremo sin interrupciones en la malla de aluminio ni en el hilo de drenaje.
3. **Documentación Conforme a Obra:** Entrega del dossier técnico completo incluyendo los reportes individuales de certificación de cada segmento de la instalación.