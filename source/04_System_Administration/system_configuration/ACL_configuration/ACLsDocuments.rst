====================================
Saneamiento de Permisos en Documents
====================================

:Fecha: 2026-03-20
:Responsable: Administrador de Sistemas (Gemini AI Collaboration)
:Estado: Finalizado
:Ámbito: Directorio de Usuario / home_config

Introducción
============

Este informe documenta las acciones realizadas para normalizar los permisos de acceso en el directorio ``Documents`` del usuario ``raul-ipa``. El objetivo principal ha sido la eliminación de bits de ejecución en archivos de datos, garantizando la seguridad y la correcta visualización de atributos en el sistema de archivos.

Objetivos de la Intervención
============================

1.  **Eliminar la Ejecución Residual:** Asegurar que ningún archivo (``.rst``, ``.xml``, ``.txt``, etc.) dentro de ``Documents`` posea permisos de ejecución (``x``).
2.  **Protección de Zonas Excluidas:** Garantizar que la configuración previa aplicada en el subdirectorio ``Virt-metadatos`` (área de trabajo de ``virt-admin``) permanezca intacta y no se vea afectada por la limpieza masiva.
3.  **Mantenimiento de la Navegabilidad:** Conservar el bit de ejecución estrictamente en los directorios para permitir el acceso y listado de subcarpetas.
4.  **Control de Herencia:** Configurar entradas de ACL por defecto para prevenir que nuevos archivos creados en el futuro adquieran permisos de ejecución de forma automática.

Metodología Aplicada
====================

Aislamiento de la Zona Protegida
--------------------------------
Se ha utilizado una técnica de "poda" (pruning) durante el escaneo del sistema de archivos. Esta técnica permite al motor de búsqueda identificar la ruta ``Virt-metadatos`` y omitir cualquier modificación sobre ella, protegiendo así las ACLs específicas configuradas para el flujo de trabajo de virtualización.

Saneamiento de Archivos Existentes
----------------------------------
Se ha aplicado una reconfiguración de ACLs sobre todos los objetos de tipo "archivo" encontrados en la jerarquía de ``Documents``. Esta acción ha normalizado la máscara (``mask``) de los archivos, eliminando la confusión visual en la salida de comandos como ``ls -l`` y restringiendo los permisos efectivos a lectura y escritura (``rw-``).

Ajuste de ACLs por Defecto
--------------------------
Se ha modificado la estructura de herencia del directorio raíz ``Documents``. La nueva configuración asegura que:
* Los **directorios** nuevos hereden permisos de acceso total.
* Los **archivos** nuevos se creen sin el bit de ejecución activo para el usuario, el grupo y otros.

Resultados y Verificación
=========================

* **Integridad:** Se ha verificado que los archivos en ``Documents`` ya no muestran el bit de ejecución.
* **Persistencia:** La zona de trabajo ``Virt-metadatos`` mantiene su configuración de acceso compartido para ``virt-admin`` sin alteraciones.
* **Accesibilidad:** Los usuarios ``raul-ipa`` y ``raul`` conservan sus facultades de edición y navegación en todo el árbol de directorios.

Implementación Técnica
======================

La lógica exacta de exclusión y los parámetros de máscara aplicados para este saneamiento se encuentran detallados y automatizados en el script de soporte:

**Archivo de referencia:** ``ACLsDocuments.sh``

.. warning::
   Cualquier despliegue de nuevos scripts ejecutables dentro de ``Documents`` (fuera de la zona protegida) requerirá una asignación manual de permisos de ejecución, dado que la política actual los restringe por defecto para mejorar la seguridad del entorno.