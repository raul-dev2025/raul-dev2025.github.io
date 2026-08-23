============================================================
Generación de OTP para la incorporación de hosts en FreeIPA
============================================================

Este documento detalla el procedimiento para generar un OTP (One-Time Password) o contraseña temporal asignada a un host registrado en FreeIPA. Este valor es necesario durante la instalación del cliente (vía ``ipa-client-install``) para autenticar y unir el sistema al dominio de manera segura.

.. note::
   
   Si utiliza sustituciones de la shell como ``--password=$(openssl rand -base64 16)``, la clave se asignará correctamente pero **no se mostrará en pantalla**, impidiendo su captura. Para obtener la contraseña directamente en la terminal, se debe utilizar el parámetro nativo ``--random``.


Método 1: Desde la línea de comandos (CLI)
===========================================

Para solicitar a FreeIPA que autogenere una contraseña aleatoria y la imprima por pantalla, ejecute el comando ``ipa host-mod`` incluyendo la opción ``--random``.

Sintaxis
--------

.. code-block:: bash

   ipa host-mod <NOMBRE_DEL_HOST> --random

Ejemplo de uso
--------------

.. code-block:: bash

   ipa host-mod buildlab.raulvilchez.org --random

Salida esperada
---------------

.. code-block:: text

   ----------------------------------------
   Modified host "buildlab.raulvilchez.org"
   ----------------------------------------
     Host name: buildlab.raulvilchez.org
     Random password: <AQUÍ_VERÁS_TU_NUEVO_OTP>
     Keytab: False
     Managed by: buildlab.raulvilchez.org

Copie la clave mostrada en el campo ``Random password`` para utilizarla posteriormente en la configuración del cliente.


Método 2: Desde la consola web (Web UI)
=======================================

Si prefiere gestionar las credenciales desde la interfaz gráfica de FreeIPA, siga estos pasos:

1. Inicie sesión en la consola web de FreeIPA con una cuenta con privilegios de administración.
2. Diríjase a **Identity** > **Hosts**.
3. Seleccione el FQDN del host deseado (por ejemplo, ``buildlab.raulvilchez.org``).
4. En el menú desplegable de **Actions** (esquina superior derecha), seleccione **Reset Password** o **Provisioning**.
5. La consola mostrará un cuadro de diálogo emergente con la nueva contraseña temporal generada. Copie el valor antes de cerrar la ventana.


Uso del OTP en el cliente
=========================

Una vez obtenido el OTP (por CLI o Web UI), ejecute el instalador en el nodo cliente pasando la contraseña mediante el parámetro ``-w`` o ``--password``:

.. code-block:: bash

   ipa-client-install --domain=raulvilchez.org \
                      --server=ipa.raulvilchez.org \
                      -w '<AQUÍ_TU_OTP>'