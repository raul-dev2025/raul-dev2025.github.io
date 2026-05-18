============================================================
Informe de Incidencia: Error de Autenticación en Réplica IPA
============================================================

:Fecha: 26 de febrero de 2026
:Estado: Resuelto
:ID de Incidencia: INC-20260226-01
:Sistemas Afectados: ipa.raulvilchez.org (Maestro), ipa02.raulvilchez.org (Réplica)

Resumen
=======

Durante el despliegue de una réplica de FreeIPA sobre Rocky Linux 9 en un entorno virtualizado (Synology VMM), el instalador fallaba persistentemente con errores de credenciales inválidas (SASL Bind error 49). La investigación reveló una corrupción crítica en el archivo de configuración del motor LDAP del servidor Maestro.

Análisis de la Causa Raíz
=========================

Tras monitorizar los logs de acceso del servidor Directory Server (389-ds) en el maestro, se identificó el código de error ``err=49 tag=97 - No such entry`` y ``Invalid credentials`` al intentar autenticar al usuario ``cn=directory manager``.

La causa raíz fue una **corrupción del parámetro ``nsslapd-rootpw``** en el archivo ``dse.ldif``. Múltiples hashes de contraseñas se habían concatenado o codificado incorrectamente en Base64, impidiendo que el motor LDAP validara la cuenta administrativa raíz necesaria para autorizar la unión de nuevas réplicas.

Pasos de Resolución
===================

1. Diagnóstico del Maestro
--------------------------

Se intentó realizar una búsqueda LDAP local en el maestro para verificar la "llave maestra":

.. code-block:: bash

   ldapsearch -x -D "cn=directory manager" -W -b "dc=raulvilchez,dc=org" "(uid=admin)"

El comando devolvió ``ldap_bind: Invalid credentials (49)``, confirmando que el problema residía en el Maestro y no en la Réplica.

2. Saneamiento de la Configuración LDAP (Maestro)
-------------------------------------------------

Para recuperar el control del motor LDAP, se procedió a resetear manualmente la contraseña del Directory Manager.

**A. Generación de un hash limpio (formato SSHA):**

.. code-block:: bash

   MYHASH=$(/usr/bin/pwdhash "vilchez2026aa")
   echo $MYHASH


Alternativamente, se podrá utilizar un algoritmo criptográfico mas ligero;

.. code-block:: bash

   /usr/bin/pwdhash -s SSHA "Contraseña_Elegida"


**B. Edición del archivo de configuración:**

Es crítico detener el servicio antes de editar para evitar que los cambios sean sobrescritos por el proceso en memoria.

.. code-block:: bash

   systemctl stop dirsrv.target
   vi /etc/dirsrv/slapd-RAULVILCHEZ-ORG/dse.ldif

Es mejor evitar pegar caracteres extraños, para ello puede utilizarse el comando sed; que incrusta la cadena de texto en el lugar adecuado.

.. code-block:: bash

   sed -i "s|^nsslapd-rootpw:.*|nsslapd-rootpw: $MYHASH|" /etc/dirsrv/slapd-RAULVILCHEZ-ORG/dse.ldif

**C. Corrección del parámetro:**

Se eliminó el bloque de texto corrupto y se sustituyó por una línea limpia (un solo punto para texto plano):

.. code-block:: text

   nsslapd-rootpw: {SSHA}Hash_Generado_Previamente...

3. Verificación de Integridad
-----------------------------

Tras reiniciar los servicios, se confirmó que el Maestro ya aceptaba conexiones administrativas:

.. code-block:: bash

   systemctl start dirsrv.target
   ldapsearch -x -D "cn=directory manager" -W -s base -b "" "objectclass=*"
   ipactl restart

4. Ejecución de la Instalación (Réplica)
----------------------------------------

Con el Maestro sano, se procedió a la limpieza y promoción de la réplica:

.. code-block:: bash

   # En ipa02.raulvilchez.org
   ./ipa-clean.sh
   ./install-replica.sh

Comandos Clave Utilizados
=========================

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Comando
     - Propósito
   * - ``pwdhash``
     - Generar hashes compatibles con LDAP (SSHA/PBKDF2).
   * - ``systemctl stop dirsrv.target``
     - Detener el motor LDAP para edición física de la BD.
   * - ``ldapsearch -x -D "cn=..."``
     - Validar manualmente la autenticación contra el árbol LDAP.
   * - ``sed -i "s|...|...|"``
     - Inyectar valores de forma programática evitando errores de edición manual.

Lecciones Aprendidas
====================

* **Validación del Maestro:** Antes de depurar una réplica, es esencial validar que el Maestro responde correctamente a su propia cuenta de ``Directory Manager``.
* **Manipulación de LDIF:** El uso de dos puntos dobles (``::``) en archivos LDIF indica codificación Base64 automática por parte del sistema ante caracteres especiales o longitudes excesivas.
* **Simplicidad de Hashes:** En recuperaciones de emergencia, el formato ``{SSHA}`` es preferible al editar manualmente por ser más corto y menos propenso a errores de "escaping" que ``{PBKDF2}``.