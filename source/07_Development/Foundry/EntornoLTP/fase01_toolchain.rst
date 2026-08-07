==================================================
Fase 1: Despliegue de Cadena de Herramientas Local
==================================================

.. sectionauthor:: Raul Vilchez Ruiz

Resumen de la Fase
==================

Se ha completado la configuración e instalación offline del entorno de compilación dentro de la máquina virtual ``buildlab``. Toda la paquetería necesaria para la compilación de código C en espacio de usuario y módulos de núcleo (*kernel drivers*) fue provista localmente mediante el automontaje y enganche en caliente (*hotplug*) del medio USB con Rocky Linux 10.

Procedimiento Ejecutado
=======================

1. **Hotplug del Almacenamiento Local (WS Host):**
   Conexión dinámica de la etiqueta del medio sin interrupción del ciclo de vida de la máquina:

   .. code-block:: bash

      virsh attach-disk buildlab /dev/disk/by-label/Rocky-10-1-x86_64-dvd vdb --type disk --mode readonly

2. **Montaje y Activación de Repositorios (Guest VM):**
   Ejecución del script de activación para el mapeo del dispositivo ``/dev/vdb`` e inhabilitación de espejos remotos:

   En el Guest:

   * :download:`activate_repo <scripts/activate_repo.sh>`   

3. **Instalación de la Pila de Desarrollo:**
   Despliegue del grupo principal de desarrollo e inclusión del repositorio CodeReady Builder (CRB) local:

   .. code-block:: bash

      dnf config-manager --set-enabled crb
      dnf groupinstall -y "Development Tools"
      dnf install -y bc cmake

4. **Desacoplamiento de Medios:**
   Una vez completada la instalación de dependencias, se procedió al desmontaje del punto local y retiro del disco virtualizado:

   En el Guest:

   * :download:`deactivate_repo <scripts/deactivate_repo.sh>`

   .. code-block:: bash

      # En el Host (WS)
      virsh detach-disk buildlab vdb

Inventario de Herramientas Instaladas
=====================================

+-------------------------+-----------------------------------------+
| Componente              | Versión Identificada                    |
+=========================+=========================================+
| Compiler (GCC)          | 14.3.1 (Red Hat 14.3.1-2)               |
+-------------------------+-----------------------------------------+
| Build Automation        | GNU Make 4.4.1 / CMake 3.30.5           |
+-------------------------+-----------------------------------------+
| Kernel Headers          | kernel-devel-6.12.0-124.8.1.el10_1.x86  |
+-------------------------+-----------------------------------------+
| Kernel Utilities        | bc 1.07.1 / elfutils-libelf-devel 0.193 |
+-------------------------+-----------------------------------------+
| Lexer/Parser            | flex 2.6.4 / bison 3.8.2                |
+-------------------------+-----------------------------------------+
| Security / Analysis     | openssl-devel 3.5.1 / GDB 16.3          |
+-------------------------+-----------------------------------------+
| VCS                     | Git 2.47.3                              |
+-------------------------+-----------------------------------------+

Estado del Entorno
==================

El entorno ``buildlab`` se encuentra totalmente aislado, operativo y provisto de la cadena de compilación adecuada para continuar hacia la **Fase 2: Compilación y Carga de Controladores del Núcleo**.