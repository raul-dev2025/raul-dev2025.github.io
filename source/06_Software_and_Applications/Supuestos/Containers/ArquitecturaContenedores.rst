==============================================================
Arquitectura de Almacenamiento de Contenedores (Podman/Libpod)
==============================================================

:Fecha: 2026-03-09
:Entorno: /var/lib/virt_storage/containers/
:Usuario: raul-ipa
:Optimización: Almacenamiento VDO (Deduplicación/Compresión)

Introducción
============
El directorio ``containers/`` actúa como el motor físico de la infraestructura de contenedores gestionada por el usuario de sistema ``raul-ipa``. Esta estructura es autogestionada por la librería ``libpod`` y no debe ser manipulada manualmente para evitar la corrupción de los metadatos del sistema.

Análisis de la Estructura de Directorios
========================================

.. list-table:: Funciones del Sistema de Archivos
   :widths: 20 50 30
   :header-rows: 1

   * - Directorio
     - Función Técnica
     - Interacción del Usuario
   * - ``libpod/``
     - Contiene la base de datos de estado de Podman. Almacena el inventario de contenedores, IDs y configuraciones de ejecución.
     - **Solo Lectura**: El motor la gestiona automáticamente.
   * - ``overlay/``
     - Punto de montaje del driver de almacenamiento. Es donde reside el sistema de archivos de capas (layers) de las imágenes.
     - **Optimización**: VDO realiza la deduplicación en este nivel.
   * - ``overlay-images/``
     - Almacena los metadatos y las capas estáticas de las imágenes importadas (ej. ``rocky10-base``).
     - Modificado por: ``podman import/pull/rmi``.
   * - ``overlay-containers/``
     - Contiene las capas de lectura/escritura (R/W) específicas de cada contenedor activo.
     - Se purga/crea al iniciar o detener instancias.
   * - ``volumes/``
     - Directorio destinado a la persistencia de datos externos al ciclo de vida del contenedor.
     - **Uso Manual**: Aquí mapeamos los datos de Authelia y Keycloak.
   * - ``dockerfiles/``
     - Directorio residual para caché de construcción o plantillas.
     - Generalmente vacío en favor de ``/configs``.

Gestión de Logs y Trazabilidad (Metadata)
=========================================
Para mantener la integridad de la estructura anterior, los artefactos de texto y logs de construcción se desvían fuera del árbol binario de Podman:

* **Ruta de Logs**: ``/var/lib/virt_storage/metadata/Containers/Logs/``
* **Propósito**: Almacenar la salida de los comandos ``podman build`` y reportes de auditoría sin ensuciar el almacenamiento de capas.

.. note:: 
   Cualquier intervención manual en ``overlay/`` o ``libpod/`` puede invalidar el índice de imágenes y requerir una ejecución de ``podman system reset``.