
Práctica - Recuperación de cuentas de usuario
=============================================

- `net user <recuperarCuentas.html#net_user>`_
- :ref:`chntpw<chntpw>`

-------

``net user``
------------
Resulta útil éste comando cuando las cuentas de usuario son locales y tenemos acceso al sistema. *Se deben cumplir ambas condiciones*. Podremos utilizar el comando desde otra cuenta distinta, a la que vayamos a modificar.

*  **Reiniciar una contraseña** El comando ``net user UserName *`` en Windows se utiliza específicamente para **cambiar la contraseña de una cuenta de usuario local de forma interactiva**.
   Imagina que tienes un usuario llamado *Administrador* y quieres cambiar su contraseña:

1.  **Abre el Símbolo del sistema (CMD) o PowerShell como administrador.** Esto es crucial, ya que necesitas permisos elevados para modificar contraseñas de usuario.
2.  Escribe el comando:

   .. code-block:: powershell

      net user [nombre_de_usuario] *

   el sistema hace lo siguiente:

3.  **Solicita la nueva contraseña:** Después de presionar :kbd:`Enter`, el sistema te pedirá que ingreses la nueva contraseña para el usuario especificado.

   .. code-block:: powershell

      Escriba una contraseña para el usuario:
      ## Aquí, ingresa la nueva contraseña (no se mostrará).

4.  **Confirma la nueva contraseña:** Para asegurar que no hay errores tipográficos, te pedirá que ingreses la contraseña de nuevo.

   .. code-block:: powershell

      Vuelva a escribir la contraseña para confirmar:

   Ingresa la misma contraseña nuevamente y pulsa :kbd:`Enter`.

5.  Si las contraseñas coinciden, verás un mensaje que dice: ``El comando se completó correctamente.`` La contraseña del usuario *Administrador* habrá sido cambiada.

   Es un método muy útil porque **la contraseña que escribes no se muestra en la pantalla** (aparecen asteriscos o simplemente el cursor se mueve, dependiendo de la terminal), lo que aumenta la seguridad al evitar que alguien mire por encima de tu hombro y la vea.

.. note::

   Queda implícito la opción *cuenta sin contraseña*; si en lugar de escribir la contraseña cuando sea solicitada, pulsamos :kbd:`enter`, y volvemos a confirmar con *enter* nuevamente. La contraseña estará vacía. No es muy útil para una cuenta administrador, pero sí para otro tipo de cuenta *usuario*.

¿Qué pasa si únicamente hay una cuenta de usuario y hemos perdido la contraseña?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Si la cuenta es local, es decir; la cuenta **no está asociada** a un servidor *Active Directory* o cuenta *Microsoft*; aún podremos recuperar la cuenta, utilizando herramientas externas al sistema.

En esta situación, serán utilizadas herramientas Linux para montar -o definir una ruta hacia los datos, la partición Windows que contiene la contraseña olvidada, y se utilizará la própia aplicación que proporciona Windows, para la gestión de cuentas de usuario: ``net user``.

1.  **Arrancar el ordenador desde el USB:** Entra en el BIOS/UEFI de tu ordenador (normalmente presionando :kbd:`F2`, :kbd:`Supr`, :kbd:`F10`, :kbd:`F12` o :kbd:`Esc` al inicio) y cambia el orden de arranque para que el USB sea la primera opción. Asegúrate de desactivar "Secure Boot" si está habilitado y el USB no está firmado.
2.  **Iniciar sistema Live:** Selecciona la opción de arranque predeterminada. Se cargará un entorno Linux.
3.  **Entorno Linux** Iniciado el sistema, buscaremos el icono de disco que aparecerá en el escritorio. Al abrirlo con el ratón, se desplegará en una nueva ventana el explorador de archivos; igual que lo haría en un entorno Windows.

   Esto es clave, por que en este punto podremos determinar si la partición Windows fue montada o no, sin problema.
   La práctica descrita a continuación, asume que la partición Windows fue montada normalmente.
   
.. tip::

   Han sido preparadas otras dos prácticas, en caso de encontrar algún problema durante el montaje de la partición Windows. Ver secciones :ref:`hibernación<alternativa-1>` y :ref:`errores superbloque<alternativa-2>`.

   AL observar la carpeta que aparece en el escritorio, se deberá localizar la carpeta ``/Windows/System32/``, dentro hay un archivo llamado osk.exe que pertenece al teclado virtual.
   Nos situamos con ``nautilus`` -el explorador de archivos Linux, dentro de la carpeta mencionada y utilizaremos la barra de direcciones o rutas de archivo, para copiar la ruta hacia el archivo. Si esto resulta demasiado abstracto, lo mejor es ir copiando y pegando sobre la *shell*, los comandos que dejaré escritos a continuación.

   .. code-block:: powershell

      ls /Windows/System32/osk.exe

   Renombraremos este archivo a:

   .. code-block:: powershell

      mv /Windows/System32/osk.exe /Windows/System32/osk.old

   Buscaremos también el archivo cmd.exe y lo copiaremos en:

   .. code-block:: powershell

      ls /Windows/System32/cmd.exe
      cp /Windows/System32/cmd.exe /Windows/System32/osk.exe

   Cuando hayamos completado la tarea; *reiniciar la contraseña olvidada* habrá que:

   1. Borrar ``/Windows/System32/osk.exe``, ya que hemos jaqueado el sistema, copiando la aplicación ``cmd``, con el nombre del *teclado virtual*. Si lo dejamos tal cuál, dejariamos abierta una puerta trasera; esto rompe la integridad del sistema; hay que arreglarlo!
   2. Devolvemos el acceso al teclado virtual desde el login o pantalla de inicio de usuario. Para ello copiamos ``/Windows/System32/osk.old`` en ``/Windows/System32/osk.exe``. Otras combinaciones de este "mecanismo" podían resultar en problemas con los permisos que el sistema confiere al archivo.

.. tip::

   En la pantalla de inicio de sesión(login) o bloqueo, hacer :kbd:`click` en el icono accesibilidad(figura de persona con un círculo) en la esquina inferior derecha. Abrirá la shell, en lugar del teclado virtual, deberemos seguir la práctica descrita al pricipio de éste documto; comandos ``net user`` de Windows.


--------

Gestión de particiones
----------------------

Problemática asociada al montaje de una partición, con el objeto de "recuperar" de alguna manera una cuenta de usuario, de la que hayamos perdido u olvidado la contraseña.

Conocemos algunos problemas que podrían ocasionar dificultades, al tratar de montar la partición NTFS(FS) de Windows:

- El archivo hibernación que guardó Windows.
- Errores de superbloque que impiden el montaje.

.. _alternativa-1:

El archivo hibernación que guardó Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
En una situación como esta, el archivo que utiliza Windows para guardar el estado del sistema -estado del procesador y la RAM; evita que la partición sea montada normalmente. ¿Porqué? por que el gestor de particiones detecta que hay datos importantes que afectan al sistema, guardados en disco. En otras palabras; el contexto de ejecución del procesador, y los datos de la RAM en el momento de cierre, son guardados a disco con el objeto de ser recuperados en el próximo inicio.

Abrimos el simbolo de sistema como administrador. El siguiente comado desactiva el fichero de hibernación, que a veces crea Windows, y que impide montar la partición en modo *r/w*(lectura/escritura) si arrancamos desde un *Live*.

   .. code-block:: powershell

      C:\Windows\system32>powercfg /hibernate off

El comando ``powercfg /hibernate off`` en el contexto de Windows se utiliza para **desactivar la función de hibernación** en tu sistema.

   .. code-block:: powershell

      powercfg /a

Comprobamos que la característica *modo hibernación* está desactivada. A continuació podremos seguir alguna de las prácticas de este mismo documento, para o bién borrar la contraseña de la cuenta de usuario, o bién reiniciarla con una nueva cadena alfanumérica.


.. _chntpw:

``chntpw``
----------


En esta otra práctica, vamos a utilizar comandos Linux. Daremos solución a otro poblema de montaje, ya que la partición, *nuevamente se resiste*, y concluiremos el ejercio de la misma forma que en prácticas anteriores: borrando o reiniciando la contraseña olvidada, de una cuenta de usuario Windows.

En esta ocasión, el que suscribe aconsejará una distribución Linux en particular, por ser una referencia **inigualable** a la hora de gestionar barra estudiar un sistema. *kali dot org*.

No necesariamente debe ser **kali**, puede se cualquier sistema operativo que proporcione las herramientas necesarias para seguir la práctica. Otros sistemas como **SistemRescueCD** o **alternativa**, resultarán igualmente útiles. Habrá que comprobar que dichos sistemas proporcionen las herramientas sugeridas. 


1.  **Identificar la partición de Windows:** Usa comandos como ``lsblk`` o ``fdisk -l`` para listar las particiones y encontrar la partición donde está instalado Windows (generalmente un sistema de archivos NTFS, como ``/dev/sda2`` o similar).
2.  **Montar la partición de Windows:** Crea un punto de montaje y monta la partición de Windows. Por ejemplo:

   .. code-block:: bash

    mkdir /mnt/Windows
    ntfs-3g /dev/sdaX /mnt/Windows -o force

    (Reemplaza ``/dev/sdaX`` con la ruta de tu partición de Windows). El ``-o force`` ayuda si Windows se apagó de forma incorrecta.

3.  **Acceder al directorio de la base de datos SAM:**

   .. code-block:: bash

   cd /mnt/Windows/Windows/System32/config

4.  **Ejecutar ``chntpw``:**

   * Para listar los usuarios: ``chntpw -l SAM``
   * Para editar un usuario específico (por ejemplo, "MiUsuario"): ``chntpw -u "MiUsuario" SAM``
   * Si no especificas un usuario (``chntpw -i SAM``), te mostrará un menú interactivo para elegir el usuario.
   * Una vez dentro del menú de ``chntpw``, las opciones típicas son:
   
      * ``1``: Borrar la contraseña del usuario.
      * ``2``: Cambiar la contraseña (a veces problemático, la opción 1 es preferible).

5. **Guardar los cambios y salir:** Sigue las instrucciones de `chntpw` para guardar los cambios (normalmente presionando `q` y luego `y` para confirmar).
6. **Desmontar la partición y reiniciar:**

   .. code-block:: bash
   
    cd /
    umount /mnt/Windows
    reboot

7. **Iniciar Windows:** Ahora deberías poder iniciar sesión en la cuenta de Windows sin contraseña, o con la nueva contraseña que estableciste.

   .. tip::

      **Importante:**

      * **Cuentas de Microsoft:** Este método **solo funciona para cuentas de usuario locales de Windows.** Si la cuenta que quieres restablecer es una cuenta de Microsoft (conectada a un correo electrónico de Outlook, Hotmail, etc.), este método no funcionará. Para cuentas de Microsoft, necesitas usar la opción de restablecimiento de contraseña en línea de Microsoft.
      * **Cuentas de dominio:** Tampoco funciona para cuentas de dominio en redes corporativas(IDM - Active Directory).
      * **Precaución:** Manipular archivos del sistema puede ser delicado. Sigue las instrucciones cuidadosamente.

      En resumen, SystemRescueCd es una excelente y potente herramienta para solucionar problemas de Windows, incluyendo el restablecimiento de contraseñas de cuentas locales.

.. tip::

   ``man chntpw``

--------

.. _alternativa-2:

Errores de superbloque que impiden el montaje
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si Windows rechaza montar la partición "debido a un fs erroneo o `superbloque <recuperarCuentas.html#superbloque>`_ defectuoso", la partición podría contener algún tipo de error. La función  Windows **Comprobación de errores** tratará de solucionar la problematica, para esto:

- Abrimos el explorador de archivos.
- click en "Este equipo".
- buscamos ``C:``, con el botón secundario abrimos las propiedades del disco *C:*
- En la pestaña Herramientas, buscamos la opción :kbd:`Comprobación de errores`  y el botón :kbd:`comprobar`. Esto debería resolver los errores que indicaba el gestor de discos, permitiéndonos montar la partición y borrar la contraseña olvidada.

   .. code-block:: powershell
   
      ## El archivo prodria estar en mayúsculas o minúsculas
      chntpw -l /Windows/System32/config/samOrSAM
   
      chntpw -u "usuario" /Windows/System32/config/sam




