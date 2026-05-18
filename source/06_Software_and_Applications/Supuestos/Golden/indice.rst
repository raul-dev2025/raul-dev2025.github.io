===============================
Infraestructura RAULVILCHEZ.ORG
===============================

.. meta::
   :description: Documentación central del flujo de automatización de nodos Rocky 10
   :keywords: Sphinx, IdM, Automation, Devops

Bienvenido a la documentación técnica del ecosistema de despliegue desatendido. Este portal centraliza los procedimientos de clonado, inyección de datos y enrolamiento automático en el Reino IdM.

.. toctree::
   :maxdepth: 2
   :caption: Flujo de Trabajo:

   /06_Software_and_Applications/Supuestos/Golden/goldenImage      
   /06_Software_and_Applications/Supuestos/Golden/clone_golden
   /06_Software_and_Applications/Supuestos/Golden/get_otp   
   /06_Software_and_Applications/Supuestos/Golden/idm-first-boot
   /06_Software_and_Applications/Supuestos/Golden/prepare_clone
   /06_Software_and_Applications/Supuestos/Golden/idm-join
   /06_Software_and_Applications/Supuestos/Golden/Sellado
   /06_Software_and_Applications/Supuestos/Golden/golden_purificacion

Secciones Detalladas
--------------------

1. **La Semilla: Preparación de la Golden Image**

   Describe el proceso de sellado, limpieza y configuración de hogares dinámicos en la VM maestra.
   *Ver detalles en:* :doc:`./Sellado` y :doc:`./golden_purificacion`

2. **Fase de Orquestación (Host)**

   Gestión del ciclo de vida del clon, desde la captura del token hasta el registro en el hipervisor.
   *Ver detalles en:* :doc:`./clone_golden` y :doc:`./get_otp`
   
   **Descargas de Scripts:**

   * :download:`Descargar clone_golden.sh <./clone_golden.rst>`
   * :download:`Descargar get_otp.sh <./get_otp.rst>`

3. **Fase de Inyección (Offline)**

   Procedimiento de "cirugía de disco" mediante ``guestfs`` para inyectar identidad y credenciales.
   *Ver detalles en:* :doc:`./prepare_clone`

   **Unidad de Servicio**: *idm-first-boot.service*
   Unidad de systemd que dispara la lógica al detectar red.
   *Ver detalles en:* :doc:`./idm-first-boot`

   **Descarga:**

   * :download:`Descargar idm-first-boot.service </07_Development/scripts/idm-first-boot.service>`

   **Descargas de Scripts:**

   * :download:`Descargar prepare_clone.sh <./prepare_clone.rst>`

4. **Fase de Activación (First-Boot)**

   Automatización interna de la VM para la unión definitiva al Reino durante el primer arranque.
   *Ver detalles en:* :doc:`./idm-join`
 
   **Descargas de Scripts:**

   * :download:`Descargar idm-join.sh <./idm-join.rst>`
   * :download:`Descargar idm-first-boot.service </07_Development/scripts/idm-first-boot.service>`

Métricas de Seguridad
---------------------
Todos los scripts listados cumplen con el protocolo de **Zero-Footprint**. 
El sistema está diseñado bajo el principio de **huella mínima**:

* Los tokens nunca se guardan en el historial del host.
* Los archivos temporales dentro del clon son eliminados mediante borrado seguro (``shred``) tras su uso.

Apéndice: Rutas de Interés
--------------------------
* **Scripts del Host**: ``/var/lib/virt_storage/scripts/``
* **Almacenamiento VMS**: ``/var/lib/virt_storage/vms/``
* **Logs de Enrolamiento**: ``/var/log/idm-setup.log`` (dentro del clon)