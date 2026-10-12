===================================================
Directrices de Instalación Física y Apantallamiento
===================================================

Procedimiento de Montaje y Continuidad Galvánica
================================================

Este documento especifica el procedimiento de instalación física, conectorización y gestión de la malla de apantallamiento para el cableado Cat-6 en la caja de registro empotrada.

Preparación del Cable y Gestión de la Malla
-------------------------------------------

Durante el pelado de la cubierta exterior de los cables Cat-6 (FTP/STP), se debe extremar la precaución para evitar dañarla o cortar la malla de apantallamiento y el hilo de drenaje.

* **Descubrimiento del blindaje:** Retirar aproximadamente 25 mm de la cubierta exterior de PVC/LSZH.
* **Consolidación del drenaje:** Relegar la lámina de aluminio hacia atrás sobre la cubierta exterior y enrollar el hilo de drenaje firmemente alrededor del tramo expuesto para asegurar un contacto perimetral sólido.
* **Orden de pares:** Descomponer el trenzado de los pares únicamente lo estricto necesario para su inserción en la guía del conector RJ45, manteniendo la geometría original hasta el punto de contacto.

Conectorización y Fijación Mecánica
-----------------------------------

El crimpado de los conectores RJ45 blindados debe garantizar la fijación mecánica del cable y la conexión eléctrica del blindaje al chasis.

* **Inserción:** Introducir los pares siguiendo el código de colores del estándar T568B o T568A de forma consistente en ambos extremos del enlace.
* **Cierre de pantalla:** Asegurar que la abrazadera metálica posterior del conector RJ45 aprisione directamente la lámina de aluminio y el hilo de drenaje.
* **Crimpado:** Aplicar la herramienta de crimpado específica para conectores blindados de categoría 6, verificando que la lengüeta metálica quede perfectamente asentada y proporcione un contacto de baja impedancia.

Alojamiento en Caja de Registro y Ventilación
---------------------------------------------

El espacio interior de la caja empotrada requiere una distribución ordenada de los componentes para evitar interferencias, sobrecalentamiento e impedimento mecánico.

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Aspecto de Montaje
     - Criterio de Ejecución
   * - **Radio de Curvatura**
     - Mantener un radio de curvatura mínimo equivalente a 4 veces el diámetro externo del cable para evitar alterar la impedancia y provocar reflexiones de señal.
   * - **Disipación Térmica**
     - Orientar el mini switch con el chasis metálico en posición vertical o despejada, evitando que quede totalmente cubierto por bucles de cable sobrante.
   * - **Separación de Red Eléctrica**
     - Si la caja comparte espacio o proximidad con conductores de corriente alterna, mantener la máxima separación posible o instalar una barrera física aislante.

Comprobación de Continuidad y Verificación
------------------------------------------

Finalizado el montaje, se debe validar cada latiguillo y segmento mediante un comprobador de cableado de red que incluya la prueba de continuidad del apantallamiento (GND/Shield).

1. Conectar cada extremo al comprobador de cableado.
2. Verificar la correspondencia pin a pin (1 al 8) sin cruzamientos ni pares abiertos.
3. Confirmar que la luz indicadora de pantalla (S / GND) se enciende en verde, garantizando la continuidad galvánica de la malla de extremo a extremo a través del conector.