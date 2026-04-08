## Postfix

#### Bounce(8)(5) <- _lecura recomendad!!_
Postfix bounce: formato de plantilla para mensajes. Servidor encargado de la
entrega de mensajes a nivel administrativo. Se encarga de hacer un seguimiento
sobre el proceso entrega/recepción de mensajes.

En caso de fallo, el servidor envía una série de notificaciones al administrador
de sistema. De forma predeterminada la dirección de entrega de este tipo de
correo administrativo es en la dirección(usuario) _postmaster_.

Según la página de manual, debería encontrase un archivo de configuración, por
defecto en:

    /etc/postfix/bounce.cf  

#### Proceso de configuración de mensajes administrativos:

  1. Crear un archivo temporal donde dirigir la salida de:
      `postconf -b archivo_temporal`.
      Puede nombrarse al archivo como: `bounce.cf.default`.

          $ postconf -b > bounce.cf.default  
     Esto  genera una lista de control de mensajes administrativos, donde se
     resume la acción llevada a cabo por el _MTA_. Es algo muy genérico que
     puede complentar el seguimiento de _logs_ vía sistema `/var/log/mail.$?`
        - Fallo en la entrega.
        - Mensaje pospuesto.
        - Entrega correcta.
        - Petición de informe(verificación de dirección).  

  2. Vincular la _plantilla_ en el `/etc/postifx/main.cf` archivo principal de
  configuración.

          bounce_template_file = /etc/postifx/bounce.cf  

  De esta forma podemos escribir personalizados mensajes administrativos, que
  se ajusten a nuestras preferencias.
  Igualmente se pueden _redifinir_ los siguientes parámetros en la cabecera de
  dichos mensajes:
    - Charset
    - From
    - Subject
    - Postmaster-Subject

  En la plantilla de mensajes pueden incluirse algunos parámetros alternativos,
  a los ya definidos en `main.cf`. Estos son:
    - `delay_warning_time_`_suffix_
    - `maximal_queue_lifetime_`_suffix_
    - `mydomain`
    - `myhostname`

---

#### Bitácora


---

DNS Error: 9546905 DNS type 'mx' lookup of mydomain responded with code NOERROR 9546905 DNS type 'aaaa' lookup of mail.mydomain. responded with code NXDOMAIN 9546905 DNS type 'a' lookup of mail.mydomain. responded with code NXDOMAIN
