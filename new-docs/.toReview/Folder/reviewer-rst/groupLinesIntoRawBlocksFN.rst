===================================================
Análisis Técnico: ``group_lines_into_raw_blocks()``
===================================================

:Módulo: ``processor.py``
:Función: Agrupación estructural de líneas en bloques lógicos.
:Estado: Validado mediante Tests Unitarios.

Descripción General
===================

Esta función actúa como el **corazón estructural** del pipeline. Su objetivo no es limpiar el texto, sino decidir la frontera de los párrafos y bloques, permitiendo la reparación de frases fragmentadas.

Análisis Línea a Línea
======================

Definición y Estado Inicial
---------------------------

.. code-block:: python

    def group_lines_into_raw_blocks(lines):
        raw_blocks = []
        current_acc = []

* **Entrada**: Una lista de cadenas de texto (líneas crudas del archivo).
* **Estado**: Utiliza un acumulador (``current_acc``) para agrupar líneas antes de convertirlas en un bloque definitivo en ``raw_blocks``.

Iteración con "Look-ahead"
--------------------------

.. code-block:: python

    for i in range(len(lines)):
        line = lines[i].strip()
        next_line = lines[i+1].strip() if i+1 < len(lines) else None

* **Estrategia**: El uso de un índice permite inspeccionar la línea siguiente (``next_line``). Esto es vital para detectar si la línea actual es un título (mirando si la siguiente es un subrayado).

Lógica de Acumulación
---------------------

.. code-block:: python

    if line:
        current_acc.append(line)

* **Acción**: Si la línea tiene contenido, se recolecta. En esta fase no discriminamos el tipo de contenido; simplemente se preserva el orden.

Gestión de Rupturas
-------------------

La variable ``should_close`` es la bandera que determina si el acumulador debe "empaquetarse" y vaciarse.

**Caso A: Líneas Vacías y Reparación de Párrafos**

.. code-block:: python

    if not line:
        if current_acc and next_line:
            if not is_likely_same_paragraph(current_acc[-1], next_line):
                should_close = True
        elif current_acc:
            should_close = True

* **El Matiz de Seguridad**: la consulta a ``is_likely_same_paragraph`` está protegida. Solo se dispara si el acumulador tiene datos ``current_acc`` y existe una línea posterior ``next_line``. Esto evita errores de índice y asegura que no intentemos unir el vacío.
* **Lógica Core**: Si encontramos una línea vacía, consultamos a ``is_likely_same_paragraph``. 
* Si la función determina que es una continuación (ej: la siguiente línea empieza en minúscula), la línea vacía se ignora y el bloque **no se cierra**, reparando así la fragmentación.

**Caso B: Rupturas Estructurales**

.. code-block:: python

    elif is_structural_break(line, next_line):
        should_close = True

* **Fronteras Rígidas**: Si la línea es una directiva (``..``), un bloque de código (``::``) o un título, se fuerza el cierre del bloque previo para evitar colisiones de formato.

Empaquetado de Salida
---------------------

.. code-block:: python

    if should_close and current_acc:
        raw_blocks.append(" ".join(current_acc).strip())
        current_acc = []

* **Resultado**: Al cerrar, las líneas acumuladas se unen mediante un espacio simple. Esto transforma múltiples líneas físicas en un único párrafo lógico rST.

Conclusiones del Diseño
=======================

1. **Aislamiento**: La función no realiza limpieza (no usa ``clean_line_content``). Su única preocupación es la **estructura**.
2. **Robustez**: Al delegar la decisión de unión a ``is_likely_same_paragraph``, el código es fácil de mantener: si queremos cambiar qué se considera un párrafo unido, solo tocamos esa pequeña función auxiliar.
3. **Integridad**: Garantiza que el último bloque del archivo no se pierda mediante una comprobación final tras el bucle.