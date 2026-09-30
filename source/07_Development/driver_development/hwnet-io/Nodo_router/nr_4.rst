============================================
Herramientas de Automatización e Integración
============================================

Para evitar la intervención manual repetitiva y garantizar la repetibilidad en las operaciones sobre el nodo de pruebas, la infraestructura incorpora un conjunto de utilidades de desarrollo en la estación de trabajo (``buildlab``) y en el propio nodo enrutador (``router-node``). Estas herramientas están versionadas y gestionadas directamente dentro de la rama de trabajo en curso.

Herramienta de Recolección Diagnóstica (dataGrabber.sh)
=======================================================

El script ``dataGrabber.sh`` actúa como el componente centralizado de auditoría y recolección de estado del sistema operativo huésped. Su diseño evita la comprobación redundante de paquetes y se centra en la inspección dinámica de los subsistemas activos del kernel y del cortafuegos.

.. list-table:: Módulos de Inspección de dataGrabber.sh
   :widths: 30 70
   :header-rows: 1

   * - Subsistema Auditado
     - Comando o Verificación Ejecutada
   * - Información del Sistema
     - Versión del kernel (``uname -r``) y distribución (``/etc/os-release``).
   * - Estado del Kernel y Módulos
     - Comprobación de módulos cargados y parámetros de enrutamiento (``sysctl``).
   * - Topología de Enlaces
     - Listado resumido de interfaces de red activas (``ip -br link``).
   * - Seguridad y Enmascaramiento
     - Estado de zonas activas en ``firewalld`` e inspección de reglas de ``nftables``.

Despachador Remoto y Orquestación (dispatcher-rn)
=================================================

Para coordinar la ejecución de los scripts de mantenimiento y pruebas desde la estación de trabajo hacia el entorno virtualizado sin comprometer la seguridad ni requerir despliegues complejos de CI/CD externos, se emplea la utilidad de despacho remoto ``dispatcher-rn``.

El flujo de trabajo automatizado mediante esta utilidad comprende las siguientes fases secuenciales:

1. **Sincronización de Versiones:**
   Propagación automática del estado actual del repositorio Git desde la estación de trabajo hacia la rama correspondiente en el host remoto ``router-node``:

   .. code-block:: bash

      git push "${REMOTE_HOST}" ``nombre_rama_en_curso``

2. **Ejecución Remota No Interactiva:**
   Invocación segura mediante protocolo SSH de las rutinas de configuración o diagnóstico residentes en el repositorio remoto:

   .. code-block:: bash

      ssh "${REMOTE_HOST}" "bash ${SCRIPT_PATH}" > "${OUTPUT_LOG}" 2>&1

3. **Captura y Volcado de Trazas:**
   Redirección unificada de la salida estándar y de error hacia un archivo de registro temporal local (``/tmp/out.log``), permitiendo una auditoría inmediata del resultado de la ejecución sin necesidad de mantener sesiones persistentes abiertas.