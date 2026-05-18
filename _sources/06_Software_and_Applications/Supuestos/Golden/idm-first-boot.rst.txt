====================================================
Unidad de Servicio: idm-first-boot.service
====================================================

:Propósito: Disparador de automatización en el primer arranque
:Ubicación: ``/etc/systemd/system/idm-first-boot.service``
:Tipo de Servicio: ``oneshot``

Descripción
-----------
Esta unidad de ``systemd`` define las condiciones necesarias para que el proceso de enrolamiento en el Reino ``RAULVILCHEZ.ORG`` se inicie de forma automática y segura. Actúa como el puente entre la inyección de archivos realizada en el host y la ejecución de la lógica interna en el invitado.

Dependencias y Orden de Ejecución
---------------------------------
Para asegurar que la unión al IdM sea exitosa, el servicio incluye las siguientes directivas de control:

* **After=network-online.target**: El servicio espera a que la pila de red esté completamente operativa y con conectividad.
* **Wants=network-online.target**: Establece una dependencia deseada con el estado en línea de la red para garantizar que el instalador de IPA pueda contactar con el servidor maestro.

Configuración del Servicio
--------------------------
* **ExecStart**: Ejecuta el script de unión alojado en ``/usr/local/bin/idm-join.sh``.
* **RemainAfterExit**: Se mantiene en estado "activo" tras finalizar el script para indicar que el proceso de aprovisionamiento inicial se ha intentado o completado.

Instalación
-----------
El servicio se habilita mediante un enlace simbólico en ``multi-user.target.wants`` durante la fase de preparación del clon. Una vez que ``idm-join.sh`` confirma el éxito de la operación, el propio script se encarga de deshabilitar esta unidad para evitar ejecuciones en reinicios posteriores.