=========================
Tipos de Commits Estándar
=========================



.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Tipo
     - Descripción
   * - **feat**
     - Añade una nueva funcionalidad al proyecto (ej. nueva sección de idiomas).
   * - **fix**
     - Corrige un error o errata (ej. corregir un enlace o falta de ortografía).
   * - **docs**
     - Cambios exclusivos en la documentación (el más usado para actualizar el CV).
   * - **style**
     - Cambios de formato que no afectan al contenido (espacios, comas, etc.).
   * - **refactor**
     - Reestructuración de archivos o código que no añade ni quita funciones (ej. renombrar archivos).
   * - **perf**
     - Mejoras de rendimiento (ej. optimizar la carga de archivos estáticos).
   * - **test**
     - Adición o corrección de pruebas o tests.
   * - **build**
     - Cambios en el sistema de construcción o dependencias (ej. ajustes en ``conf.py``).
   * - **ci**
     - Cambios en scripts de Integración Continua (ej. GitHub Actions).
   * - **chore**
     - Tareas de mantenimiento general (ej. mover archivos a la carpeta ``OtrosFormatos``).


Tipos de Etiquetas (Tags)
=========================


.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Categoria
     - Descripción
   * - **release/**
     - Versiones estables listas para producción o despliegue final (ej. `v1.0.0` o `release/v1.0.0`).
   * - **rc/**
     - *Release Candidate*: Versiones congeladas para pruebas finales de integración previo a release.
   * - **alpha/** / **beta/**
     - Versiones preliminares de prueba en entornos de desarrollo o sandbox.
   * - **checkpoint/**
     - Puntos de restauración para guardar el estado funcional previo a un gran cambio.
   * - **refactor/**
     - Marcas específicas que delimitan el inicio o fin de una reestructuración importante.
   * - **milestone/**
     - Hitos clave del proyecto o entregables de fase alcanzados.
   * - **env/** / **sandbox/**
     - Etiquetas temporales para validaciones de infraestructura, CI/CD o scripts de pruebas.