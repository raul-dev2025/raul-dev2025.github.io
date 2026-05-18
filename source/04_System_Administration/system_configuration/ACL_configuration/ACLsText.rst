============================================================
Informe de Configuración: Saneamiento de Directorios de Perfil
============================================================

:Fecha: 2026-03-20
:Responsable: Administrador de Sistemas (Gemini AI Collaboration)
:Directorios: Desktop, Public, Templates
:Estado: Finalizado

Introducción
============

Se ha procedido a la normalización de los permisos de seguridad en los directorios de perfil del usuario ``raul-ipa``. A diferencia de la intervención en ``Documents``, estos directorios no cuentan con zonas de exclusión, aplicándose una política restrictiva uniforme.

Objetivos de la Intervención
============================

1.  **Eliminación de Ejecución en Datos:** Supresión total del bit de ejecución (``x``) en todos los archivos existentes para prevenir lanzamientos accidentales de binarios o scripts.
2.  **Optimización de la Máscara:** Ajuste de la ``mask`` de ACL para que la salida de los comandos de inspección (``ls -l``) refleje con precisión que los archivos son exclusivamente de lectura/escritura.
3.  **Configuración de Herencia Limpia:** Establecimiento de reglas ``default`` que permiten la creación de subdirectorios navegables pero fuerzan archivos no ejecutables por defecto.

Detalles de la Implementación
=============================

La intervención se ha realizado mediante un procesamiento por lotes (batch processing). Al no existir dependencias con servicios externos (como ``virt-admin``) en estas rutas, se ha aplicado una máscara de permisos estándar ``rw-`` para archivos y ``rwx`` para directorios.

Resultados
==========

* Los directorios ``Desktop``, ``Public`` y ``Templates`` ahora cumplen con la normativa de seguridad de "mínimo privilegio" para archivos de usuario.
* Se ha verificado que la navegación por subcarpetas sigue siendo funcional para el propietario y el grupo.

Implementación Técnica
======================

Los comandos y la lógica de bucle utilizada para estas tres ubicaciones pueden ser consultados en el script de soporte:

**Archivo de referencia:** ``ACLsDocuments.sh``

.. note::
   Este script es seguro para re-ejecución en caso de que se detecten desviaciones en los permisos tras transferencias masivas de archivos (ej. vía SCP o RSYNC).