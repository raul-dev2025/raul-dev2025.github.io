==================================================
INFORME DE CIERRE DE HITO Y ESTADO DEL REPOSITORIO
==================================================

.. list-table:: Resumen Ejecutivo del Despliegue
   :widths: 30 70
   :header-rows: 1

 * - Parámetro
   - Valor
 * - Repositorio
   - ``hwbus-io.git``
 * - Rama Principal
   - ``main`` (Sincronizada)
 * - Estado del Hito
   - En producción / Consolidado
 * - Commit de Cierre
   - ``41652c7`` (docs: add GPL header to build scripts and source files)
 * - Tag Firmado (GPG)
   - ``v1.0.0-ci-integration``
 * - Fecha de Cierre
   - 15 de Agosto de 2026



Objetivo de la Fase
===================

Finalización de la arquitectura modular de scripts de automatización CI/CD, control de entornos virtuales KVM/QEMU, configuración de privilegios mínimos en ``sudoers`` y sincronización multi-remoto.

Matriz de Sincronización de Nodos y Remotos
-------------------------------------------

.. list-table:: Estado de Topología Git
   :widths: 25 35 40
   :header-rows: 1

 * - Nodo / Remoto
   - Rama Activa / Estado
   - Último Commit / Referencia
 * - Workstation (Local)
   - ``main``
   - ``41652c7``
 * - ``buildlab`` (Entorno VM)
   - ``main``
   - ``41652c7``
 * - ``nas-backup`` (Almacenamiento)
   - ``main``
   - ``41652c7``
 * - ``origin`` (GitHub)
   - ``main`` (y ``feature/env-testing`` en gracia)
   - ``41652c7`` / ``v1.0.0-ci-integration``


Arquitectura de Scripts Integrados (``Scripts/``)
-------------------------------------------------

.. code-block:: text

   Scripts/
   ├── ci-builder.sh         # Orquestador principal de CI desde WS
   ├── ci-runLauncher.sh     # Lanzador del entorno de pruebas
   ├── ci-runner.sh          # Ejecutor de batería de tests en buildlab
   ├── ci-signer.sh          # Generador de manifiestos y firmado de artefactos
   ├── Envs/                 # Control de Infraestructura Virtual (IV)
   │   ├── vm-poll.sh        # Sondeo de sockets y conectividad SSH
   │   ├── vm-start.sh       # Arranque de VM bajo virt-admin
   │   ├── vm-status.sh      # Estado de instancias KVM/QEMU
   │   └── vm-stop.sh        # Apagado y liberación de recursos
   └── Tools/
   └── herramientas.sh   # Funciones y utilidades compartidas

Control de Accesos y Seguridad (RBAC)
-------------------------------------

Se ha establecido la delegación de privilegios en ``/etc/sudoers.d/ipa-virt-admin`` garantizando el principio de menor privilegio:

 * **Invocación Interactiva:**   - Restringida a la ejecución exacta de ``/usr/bin/bash --rcfile /var/lib/virt_storage/scripts/bashrc_virt_admin``.
 * **Hipervisor:**   - Permiso explícito sobre ``/usr/bin/virsh``.
 * **Rutas Absolutas:**   - Ejecución directa de los scripts de control sin solicitar contraseña (``NOPASSWD``).

Validación Criptográfica
------------------------

El hito ha sido verificado satisfactoriamente mediante firma digital ED25519:

.. code-block:: text

   object 41652c766d664296e8f31cb6ac2a3a1eb72dcba4
   type commit
   tag v1.0.0-ci-integration
   tagger Raul Vilchez [raulmicrosistemas@gmail.com](mailto:raulmicrosistemas@gmail.com)

   Milestone: Complete CI/CD integration and virtualization management scripts
   Good "git" signature for raulmicrosistemas@gmail.com with ED25519 key SHA256:yoHuxIoxl4JWZfYgGWK7R1bqwj3CE9+MuanEEPzXlOc

Conclusión
----------

El pipeline de CI/CD, la gestión de infraestructura y la documentación en formato rST quedan plenamente funcionales y consolidados en la rama ``main``. Fase concluida con éxito.