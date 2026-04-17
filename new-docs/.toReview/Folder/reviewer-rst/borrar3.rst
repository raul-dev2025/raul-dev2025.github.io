============================================================
Hoja de Ruta: Transición a Arquitectura Modular (rST)
============================================================

:Proyecto: Reviewer-RST
:Responsable: Raúl Vílchez & Gemini
:Estado: Fase de Planificación Post-Test

Este documento detalla los pasos necesarios para desmantelar la función monolítica ``join_broken_paragraphs()`` y sustituirla por el nuevo sistema de procesamiento en tres fases, garantizando la estabilidad de la aplicación.

Fases de la Transición
======================

1. Auditoría de Referencias Cruzadas
------------------------------------
* **Tarea**: Localizar mediante herramientas de búsqueda (grep/IDE) todas las menciones a la función antigua en el paquete de scripts.
* **Objetivo**: Evitar errores de tipo ``NameError`` durante la ejecución.

2. Refactorización de la Suite de Tests
---------------------------------------
* **Tarea**: Editar ``test_rst.py`` para eliminar las pruebas que invocan directamente a la función suprimida.
* **Tarea**: Asegurar que los tests de las tres nuevas sub-funciones (Partes 1, 2 y 3) cubren todos los casos de uso previos. Es decir, replicar los test obsoletos en las nuevas funciones.
* **Objetivo**: Mantener una maquinaria de depuración limpia y sin falsos negativos.

3. Orquestación en el Módulo Principal (review.py)
--------------------------------------------------
* **Tarea**: Modificar el punto de entrada de procesamiento en ``review.py``.
* **Lógica a Implementar**:
    1. Obtención de títulos (``get_document_titles``).
    2. Agrupación estructural (``group_lines_into_raw_blocks``).
    3. Filtrado y refinado final (``filter_and_format_blocks``).
* **Objetivo**: Integrar la nueva lógica en el flujo de trabajo real del script.

4. Verificación de Integración Final
------------------------------------
* **Tarea**: Ejecutar el script sobre un archivo rST real y verificar que el resultado es idéntico o superior al método anterior.
* **Objetivo**: Confirmación final de éxito.

