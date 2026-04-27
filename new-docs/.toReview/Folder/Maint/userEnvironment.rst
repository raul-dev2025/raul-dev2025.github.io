=====================================================================
Informe Técnico: Configuración de Monitorización VDO vía IdM/Sudo
=====================================================================

:Proyecto: Infraestructura del Hipervisor Rocky Linux
:Rol: Ingeniero de Documentación Técnica
:Fecha: 2026-02-16
:Estado: Verificado y Operativo

Objetivo Técnico
----------------

El objetivo principal de esta configuración fue resolver la denegación de permisos al ejecutar el comando ``vdostats`` dentro de un entorno de virtualización. El problema central residía en que el usuario de gestión de infraestructura, **raul-ipa**, carecía de privilegios para comunicarse con el controlador **kernel device-mapper** (``/dev/mapper/control``), resultando en fallos de comunicación con la **libdevmapper**.

Se requería una solución que permitiera a **raul-ipa** realizar tareas de monitorización sin necesidad de login como **root** ni la introducción manual de contraseñas, todo gestionado de forma centralizada a través de **Identity Management (IdM)**.

Procedimiento
-------------

1. Registro de Comandos en IdM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Se procedió a dar de alta el binario de monitorización en la base de datos de comandos autorizados de FreeIPA:

.. code-block:: bash

   ipa sudocmd-add /usr/bin/vdostats --desc="Allow monitoring VDO stats"

2. Creación de la Regla de Sudo Centralizada
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Se configuró la regla **virtual-admin-monitor-storage** para definir el flujo de privilegios. Esta regla vincula al usuario de sistema con los privilegios de superusuario para el comando específico.

.. code-block:: bash

   # Creación de la regla principal
   ipa sudorule-add virtual-admin-monitor-storage --desc="Allow raul-ipa to monitor VDO status as root."

   # Asociación del usuario ejecutor (identificado como External User en logs)
   ipa sudorule-add-user virtual-admin-monitor-storage --users=raul-ipa

   # Definición del contexto de ejecución (RunAs)
   ipa sudorule-add-runasuser virtual-admin-monitor-storage --users=root

   # Asociación del comando autorizado
   ipa sudorule-add-allow-command virtual-admin-monitor-storage --sudocmds=/usr/bin/vdostats

3. Configuración de Acceso sin Contraseña (NOPASSWD)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dado que IdM no utiliza el flag ``--nopasswd`` en la línea de comandos de modificación de reglas, se inyectó la opción de sudo pertinente:

.. code-block:: bash

   ipa sudorule-add-option virtual-admin-monitor-storage --sudooption='!authenticate'

4. Ajuste del Entorno de Usuario y Prompt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Se modificó el archivo ``~/.bashrc`` del usuario de red **raul-ipa** para corregir la función de acceso **vwork()**, eliminando la referencia incorrecta a "virt-storage" y estableciendo el entorno operativo real.

.. code-block:: bash

   vwork() {
       sudo -u raul-ipa /usr/bin/bash -c "
           export LIBVIRT_DEFAULT_URI='qemu:///system'
           cd /var/lib/virt_storage/
           exec /usr/bin/bash --rcfile <(echo \"
               alias vdostats='sudo /usr/bin/vdostats'
               _ps_git() { 
                   local b=\\\$(git rev-parse --abbrev-ref HEAD 2>/dev/null); 
                   [ -n \\\"\\\$b\\\" ] && echo -e \\\" \033[0;33m(\\\$b)\033[0m\\\"; 
               }
               export PS1=\\\"\[\033[0;36m\]raul-ipa\[\033[0m\]\\\$( _ps_git) > \\\"
           \")
       "
   }

Justificación
-------------

* **Gestión de Identidad**: Se identificó que la infraestructura es gestionada por el usuario de sistema **raul-ipa**. Mantener este contexto es vital para la seguridad y auditoría del hipervisor.
* **!authenticate**: Se utilizó esta opción de sudo para permitir que la monitorización sea fluida y automatizable, eliminando la fricción de entrada de credenciales en tareas de supervisión recurrente.
* **Encadenamiento de Alias**: La inyección de ``alias vdostats='sudo /usr/bin/vdostats'`` permite al operario ejecutar la herramienta como si fuera un comando nativo del usuario, mientras que por detrás el sistema valida la regla de IdM.
* **Consistencia de Nomenclatura**: Se corrigió el prompt de **virt-storage** a **raul-ipa** para que la documentación técnica, las reglas de IdM y el entorno de shell coincidan al 100%, evitando errores humanos durante incidentes.

Verificación
------------

La configuración se validó satisfactoriamente tras recargar el entorno (``reload-bash``) y ejecutar el acceso al entorno de trabajo (``vwork``). 

**Resultado de la prueba de ejecución:**

.. code-block:: bash

   raul-ipa > vdostats --hu
   Device                  Size      Used Available Use% Space saving%
   infra_dev-vpool0-vpool  900.0G     29.7G    870.3G   3%           25%

La salida confirma que el usuario **raul-ipa** ha obtenido acceso exitoso al pool de virtualización de **900.0G**, visualizando correctamente el ahorro de espacio del **25%** sin solicitudes de contraseña adicionales.

```

¿Desea que añada una sección de solución de problemas relacionada con la caché de SSSD (`sss_cache`) a este documento?