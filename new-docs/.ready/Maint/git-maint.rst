================================================
Informe de Consolidación: Entorno de Desarrollo
================================================

:Fecha: 2026-04-20
:Responsable: Raúl Vílchez
:Estado: Completado
:Sistemas: Nodo NAS (DSM), IdM Integration, Workstations

Descripción General
===================

Se ha llevado a cabo una reestructuración integral de la configuración de usuario para optimizar la modularidad, la seguridad y la sincronización distribuida entre los repositorios locales, GitHub y el respaldo físico en el NAS corporativo.

Arquitectura de Configuración (.bashrc)
=======================================

La lógica de la terminal se ha segmentado en archivos independientes para facilitar el mantenimiento y evitar redundancias:

**.bashrc (Núcleo):**
    * Gestión de identidades Kerberos para usuarios de red (IdM) con almacenamiento en ``/tmp/``.
    * Función dinámica ``git-sync`` con estrategia de ``--rebase`` para mantener un historial lineal.
    * Función de protección avanzada para el disco persistente ``/mnt/datos_raul/`` sobrecargando el comando ``rm``.

**.bashrc.local (Herramientas):**
    * Alias de Git para flujo de trabajo rápido: ``gits``, ``gitb``, ``gita``, ``gitr``.
    * Entornos virtuales de Python y utilidades de conversión (``pyconverter``, ``htmlBuild``).
    * Perfiles específicos de VS Code (``code-helio``, ``code-raul``).

**.bashrc.local-ipa (Gestión de IdM):**
    * Alias para el cambio de contexto de identidad: ``set-tech``, ``set-maint``, ``set-raul``, ``set-admin``.
    * Automatización de apertura de navegador bajo identidades específicas de Kerberos.

Sincronización de Repositorios (Git)
====================================

Se ha estandarizado la rama principal y el flujo de respaldo en los tres pilares del ecosistema, asegurando que el NAS (192.168.17.38) actúe como espejo de seguridad:

+----------------------+-------------+-------------------------------------------------+
| Repositorio          | Rama        | Acción Realizada                                |
+======================+=============+=================================================+
| web-docs.git         | main        | Renombrado de rama y actualización de HEAD NAS. |
+----------------------+-------------+-------------------------------------------------+
| web-helioHub.git     | master      | Inclusión de .code-workspace en .gitignore.     |
+----------------------+-------------+-------------------------------------------------+
| web-raul.git         | main        | Migración a SSH y alineación de remotos duales. |
+----------------------+-------------+-------------------------------------------------+

Seguridad y Persistencia
========================

**Protección de Datos:**
    Se ha implementado un sistema de validación interactiva que bloquea el borrado accidental en directorios críticos dentro de ``/mnt/``.

**IdM / Kerberos:**
    La configuración ahora permite la coexistencia de múltiples tickets para distintos usuarios de red (``DIR:/tmp/krb5cc_collection_${USER}``).

.. note::
   El alias ``git-sync`` es ahora la herramienta estándar para garantizar que todos los cambios se repliquen de forma atómica en GitHub y el NAS tras un rebase limpio.