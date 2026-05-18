============================================================
Informe de Configuración: Directorios Compartidos de Usuario
============================================================

:Fecha: 2026-03-20
:Responsable: Administrador de Sistemas
:Usuarios: raul-ipa (Red/IdM), raul (Local/Contingencia)
:Ruta Física: /mnt/datos_raul/home_config/
:Directorios: Downloads, Music, Pictures, Videos

Objetivo
========

Configurar una infraestructura de archivos agnóstica al usuario que permita la interoperabilidad total entre una cuenta de dominio (IdM) y una cuenta de rescate local, manteniendo una política estricta de "No-Ejecución" para mitigar riesgos de seguridad.

Implementación Técnica
======================

1. Propiedad y Grupos
---------------------
Se ha establecido el grupo ``raul`` como propietario de toda la estructura en el almacenamiento físico. Esto permite que cualquier cambio de contexto (switch user) mantenga los privilegios de lectura y escritura (``rw-``) sin depender de la disponibilidad de los servicios de red de IdM.

2. Política de No-Ejecución
---------------------------
Se han normalizado los permisos de los archivos existentes a ``644`` (``rw-r--r--``).
* **Motivación:** Evitar que binarios descargados o archivos multimedia malformados se ejecuten accidentalmente.
* **Procedimiento:** Eliminación del bit ``setgid`` y limpieza de máscaras de ACL restrictivas.

3. Factoría de Herencia (Defaults)
----------------------------------
Se ha configurado la herencia de directorios mediante ACLs por defecto:
* **Directorios nuevos:** Reciben ``rwx`` para permitir la navegación (traversing).
* **Archivos nuevos:** Reciben ``rw-`` de forma mandatoria.



Resultados Validados
====================

La verificación mediante ``ls -l`` confirma que:
* Los archivos son identificados correctamente como datos no ejecutables.
* El grupo ``raul`` tiene privilegios de escritura simétricos.
* La ruta es accesible de forma transparente desde ``/home/raul-ipa/`` y ``/home/raul/``.

Conclusión
==========

La infraestructura es ahora resiliente ante fallos de autenticación en red, garantizando que el usuario local de contingencia pueda trabajar sobre el mismo set de datos con las mismas garantías de seguridad.





============================================================
Informe de Configuración: Política Unificada de No-Ejecución
============================================================

:Fecha: 2026-03-20
:Responsable: Administrador de Sistemas (Gemini AI Collaboration)
:Directorios: Downloads, Music, Pictures, Videos
:Estado: Implementado

Introducción
============

Se ha implementado una política de seguridad restrictiva en los directorios de contenido dinámico y multimedia. El objetivo es mitigar riesgos de ejecución accidental de código malicioso o scripts no verificados, especialmente en el área de descargas.

Principios de la Configuración
==============================

1.  **Denegación de Ejecución por Defecto:** Ningún archivo dentro de estas rutas posee el bit de ejecución (``x``) activo. Esto aplica tanto a archivos existentes como a los que se generen en el futuro.
2.  **Arquitectura de Herencia:** Las ACLs por defecto (``default``) se han ajustado para permitir la creación de subestructuras de directorios navegables (manteniendo ``rwx`` para carpetas), pero forzando archivos de datos puros (``rw-``).
3.  **Intervención Manual en Descargas:** Se establece como norma operativa que cualquier binario o script legítimo en ``Downloads`` que requiera ser ejecutado, deberá recibir permisos de forma explícita por el usuario propietario.

Detalles Técnicos
=================

La configuración asegura que la máscara de ACL (``mask``) no permita la promoción accidental de privilegios. Esto limpia la visibilidad de archivos en el sistema, eliminando resaltados de color (típicos de archivos ejecutables) en la terminal para archivos que son estrictamente datos.



Resultados Esperados
====================

* Eliminación del riesgo de "doble clic" accidental sobre scripts descargados.
* Consistencia visual en el listado de archivos multimedia.
* Compatibilidad total con el grupo de IdM ``raul`` para futuras colaboraciones en red.

Implementación
==============

La automatización de esta política se encuentra disponible en el script de gestión:

**Archivo de referencia:** ``ACLsMultimediaDescargas.sh``

.. note::
   Esta configuración es especialmente crítica para el directorio ``Downloads``, actuando como una "zona de cuarentena" donde nada es ejecutable por omisión.
