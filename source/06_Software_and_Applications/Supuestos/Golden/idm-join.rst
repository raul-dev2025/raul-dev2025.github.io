====================================================
Script de Post-Instalación: idm-join.sh
====================================================

:Propósito: Automatización del enrolamiento en IdM (First-Boot)
:Ubicación en el Clon: ``/usr/local/bin/idm-join.sh``
:Activación: Disparado por ``idm-first-boot.service``

Descripción
-----------
Este script es el componente final de la cadena de automatización. Se ejecuta exclusivamente durante el primer arranque del clon para realizar la configuración de identidad y la unión al Reino ``RAULVILCHEZ.ORG``.

Lógica de Operación
-------------------

1. **Fase de Descubrimiento**:
   Busca los archivos de configuración inyectados por el orquestador en el directorio ``/root/``. Si falta alguno de los artefactos (Token o Hostname), el script aborta para evitar inconsistencias en el IdM.

2. **Configuración de Hostname**:
   Establece el FQDN (Fully Qualified Domain Name) definitivo de la máquina utilizando ``hostnamectl``. Este paso es crítico para que los certificados de Kerberos se generen con el nombre correcto.

3. **Enrolamiento Desatendido**:
   Ejecuta ``ipa-client-install`` en modo no interactivo. Los parámetros destacados son:
   * ``--password``: Utiliza el OTP Token recuperado del disco.
   * ``--mkhomedir``: Asegura que la configuración de la Golden Image sea efectiva para los usuarios de red.
   * ``--fixed-primary``: Fija el servidor IdM principal para estabilidad.

4. **Limpieza Forense (Seguridad)**:
   Independientemente del resultado de la unión, el script ejecuta un borrado seguro (``shred``) de los archivos temporales. Esto garantiza que el OTP Token desaparezca del almacenamiento físico.

Gestión de Logs
---------------
Toda la actividad, incluyendo la salida detallada del instalador de IPA, se registra en ``/var/log/idm-setup.log`` para auditoría y resolución de problemas.

Desactivación
-------------
Tras una unión exitosa, el script deshabilita su propio servicio de ``systemd`` para asegurar que el proceso no se repita en futuros arranques del sistema.