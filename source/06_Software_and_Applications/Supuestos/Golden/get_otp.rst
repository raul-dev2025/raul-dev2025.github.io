====================================================
Script de Validación: get_otp.sh
====================================================

:Propósito: Captura interactiva y segura del OTP Token
:Ubicación: ``/var/lib/virt_storage/scripts/get_otp.sh``
:Nivel de Seguridad: Alto (Captura en memoria volátil)

Descripción
-----------
Este script es la primera línea de ejecución del flujo de despliegue. Su objetivo es solicitar de forma interactiva el token de un solo uso (OTP) generado en FreeIPA, validando su presencia antes de proceder con el clonado del disco.

Funcionamiento
--------------

1. **Interrupción de Seguridad**:

   Solicita confirmación explícita al operador. Si el operador no confirma la posesión del token, el proceso se aborta de forma segura sin realizar cambios en la infraestructura.

2. **Captura Ofuscada**:

   Utiliza el comando ``read -sp`` para capturar la entrada del usuario. Esto asegura que:
   
   * El token no se muestre en pantalla mientras se escribe.
   * El token no quede registrado en el historial de comandos (``.bash_history``) del usuario.

3. **Validación de Contenido**:

   Comprueba que la cadena introducida no sea nula. En caso de error, envía un mensaje de advertencia y finaliza la ejecución con un estado de salida no nulo.

Integración con el Orquestador
------------------------------
El script está diseñado para ser invocado mediante sustitución de comandos por ``clone_golden.sh``::

   OTP_TOKEN=$(/ruta/al/script/get_otp.sh)

Esta arquitectura garantiza que el token viaje directamente desde el teclado del operador a la memoria RAM del proceso padre, sin pasar nunca por archivos de texto plano o logs del sistema.

Advertencias
------------
* Este script debe ser ejecutado en una terminal interactiva (TTY).
* Si se intenta automatizar mediante tuberías (pipes), se debe asegurar la gestión correcta de la entrada estándar para la captura del token.