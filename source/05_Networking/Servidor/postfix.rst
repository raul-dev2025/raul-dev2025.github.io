.. SPDX-License-Identifier: GPL-2.0-or-later

==============================================
Servidor de Correo Postfix: Notificaciones RCU
==============================================

El demonio ``bounce(8)`` de **Postfix** es el componente del agente de transferencia de correo (*MTA*) encargado de generar informes de estado de entrega de correo (*Delivery Status Notifications* o DSN). Gestiona avisos de rebote por fallos permanentes, advertencias de retardo (*delay warnings*) e informes de éxito o verificación de direcciones.

Proceso de Notificaciones y Demonio ``bounce(8)``
=================================================

Cuando un mensaje no puede ser entregado, el servidor realiza un seguimiento del proceso y notifica las incidencias. Por defecto, las alertas administrativas y copias de los informes de rebote se dirigen a la cuenta local ``postmaster``.

La plantilla con las cadenas de texto utilizadas para estos mensajes administrativos se configura mediante el archivo ``bounce.cf``, ubicado por defecto en ``/etc/postfix/bounce.cf``.

Configuración de Plantillas Personalizadas de Rebote
====================================================

Para personalizar los mensajes de notificación del sistema, se sigue el procedimiento estandarizado mediante la utilidad ``postconf``:

1. Generar la plantilla de configuración por defecto
----------------------------------------------------

Obtener la plantilla base predeterminada con el comando ``postconf -b`` y guardarla en un archivo de trabajo:

.. code-block:: console

   $ postconf -b > /etc/postfix/bounce.cf.default

Esta plantilla contiene las definiciones para cuatro tipos de eventos de entrega:

* **Failure** (``failure_template``): Fallo permanente en la entrega de correo.
* **Delay** (``delay_template``): Mensaje pospuesto temporalmente en la cola.
* **Success** (``success_template``): Confirmación de entrega correcta.
* **Verify** (``verify_template``): Petición de informe o verificación de dirección de correo.

2. Vincular la plantilla personalizada en ``main.cf``
-----------------------------------------------------

Edite el archivo de configuración principal de Postfix (``/etc/postfix/main.cf``) e indique la ruta de la plantilla activa:

.. code-block:: ini

   bounce_template_file = /etc/postfix/bounce.cf

3. Parámetros de Cabecera y Variables Modificables
--------------------------------------------------

Dentro de la plantilla se pueden redifinir las siguientes cabeceras para adaptar la localización de los mensajes:

* ``Charset``: Juego de caracteres de la notificación (ej. ``UTF-8``).
* ``From``: Remitente del mensaje del sistema (ej. ``Mail Delivery System <postmaster@midominio.com>``).
* ``Subject``: Asunto del informe de estado.
* ``Postmaster-Subject``: Asunto asignado a la copia enviada al administrador.

Asimismo, las plantillas permiten la expansión dinámica de variables definidas en ``main.cf``:

* ``$delay_warning_time``
* ``$maximal_queue_lifetime``
* ``$mydomain``
* ``$myhostname``

Diagnóstico y Registro de Errores (Bitácora)
============================================

Los eventos de entrega y errores de resolución se registran en los archivos de depuración del sistema en ``/var/log/mail.log`` o ``/var/log/maillog``.

Análisis de Error de Resolución DNS
-----------------------------------

En los registros del sistema puede aparecer el siguiente fallo de resolución de nombres de dominio:

.. code-block:: text

   DNS Error: 9546905 DNS type 'mx' lookup of mydomain responded with code NOERROR
   9546905 DNS type 'aaaa' lookup of mail.mydomain. responded with code NXDOMAIN
   9546905 DNS type 'a' lookup of mail.mydomain. responded with code NXDOMAIN

* **Causa**: El servidor de correo de destino especificó un registro **MX** válido (``mail.mydomain.``), pero los registros de dirección **A** (IPv4) y **AAAA** (IPv6) para el nombre de host ``mail.mydomain.`` no existen en las zonas DNS o devuelven la respuesta ``NXDOMAIN`` (*Non-Existent Domain*).
* **Solución**: Verificar la configuración del servidor DNS de destino utilizando utilidades como ``dig`` o ``host`` para asegurar que el registro A/AAAA apunte a la IP pública correcta del servidor de correo:

.. code-block:: console

   $dig A mail.mydomain. +short$ dig AAAA mail.mydomain. +short