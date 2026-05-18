==========================================================
Informe de Configuración: ACLs para Nodo Virt-metadatos
==========================================================

:Fecha: 2026-03-20
:Responsable: Administrador de Sistemas (Gemini AI Collaboration)
:Estado: Implementado
:Referencia: Infraestructura IdM / Almacenamiento NAS

Introducción
============

Este documento detalla la configuración de permisos avanzados mediante Listas de Control de Acceso (ACLs) para permitir que el usuario técnico ``virt-admin`` gestione archivos de configuración y metadatos de virtualización en una ruta específica dentro del almacenamiento persistente.

Objetivos
=========

* Permitir acceso de **lectura y escritura** a ``virt-admin`` en el directorio de metadatos.
* Garantizar la **navegabilidad** (traversing) a través de rutas con permisos restrictivos (como el HOME del usuario).
* Evitar la propagación del bit de **ejecución** en archivos de datos (``.xml``, ``.rst``, ``.sh``), restringiéndolo exclusivamente a directorios.
* Mantener la integridad de los permisos originales para el propietario ``raul-ipa`` y el grupo ``raul``.

Análisis de la Estructura
=========================

La ruta de trabajo es un enlace simbólico que apunta a un volumen NFS/NAS montado:

* **Ruta Lógica:** ``/home/raul-ipa/Documents/Virt-metadatos/``
* **Destino Real:** ``/mnt/datos_raul/home_config/Documents/Virt-metadatos/``

Configuración Aplicada
======================

Acceso de Tránsito
------------------
Se ha habilitado el bit de ejecución (``x``) para ``virt-admin`` en el nivel superior (``/home/raul-ipa``). Esto permite al usuario atravesar el directorio sin necesidad de listar su contenido, manteniendo la privacidad de otros archivos del usuario.

Gestión de Permisos en Destino
------------------------------
Se ha implementado una configuración asimétrica para garantizar la operatividad:

1.  **Directorios:** Se ha asignado ``rwx`` (Lectura, Escritura y Ejecución) para permitir la entrada en subcarpetas y la creación/eliminación de objetos.
2.  **Archivos:** Se ha restringido a ``rw-`` (Lectura y Escritura). Se ha realizado una limpieza selectiva para asegurar que ningún archivo de texto o script herede accidentalmente permisos de ejecución.
3.  **Herencia (Default ACLs):** Se han configurado reglas de herencia en el directorio raíz para que cualquier objeto creado en el futuro por cualquier usuario mantenga la accesibilidad para ``virt-admin`` de forma automática.

Verificación de Seguridad
=========================

Tras la aplicación, se han confirmado los siguientes estados:

* **Aislamiento:** ``virt-admin`` puede navegar hasta el destino pero recibe *Permission Denied* si intenta listar el contenido del Home o escribir fuera del área autorizada.
* **Transparencia:** El propietario original (``raul-ipa``) mantiene su capacidad de gestión total.
* **Coherencia:** La máscara de ACL (``mask``) ha sido ajustada para no bloquear los permisos efectivos necesarios para la navegación.

Implementación Técnica
======================

Los comandos específicos de ``setfacl`` y la lógica de limpieza mediante ``find`` utilizados en este proceso están documentados y automatizados en el script de mantenimiento:

**Archivo de referencia:** ``ACLsVirtMetadatos.sh``

.. note::
   Cualquier modificación futura en la estructura de subdirectorios dentro de ``Virt-metadatos`` debería realizarse preferiblemente a través del script mencionado para asegurar la consistencia de los bits de ejecución.