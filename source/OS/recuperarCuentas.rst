Recuperación de cuentas de usuario
====================================

Éste tópico debía haber sido un documento único en cuanto a su extensión, pero dada la complejidad del tema y la cantidad de información relacionada con el mismo, resulta mas conveniente dividirlo en dos secciónes; una :doc:`práctica <recuperarCuentasPractica>` y otra teórica.

Como estamos trabajando con sistemas Windows, la teoría que acompañará este documento, estará centrada en este sistema en particular; Windows.
Sin embargo, las herramientas utilizadas para resolver cierta problemática, son apliciones Linux. 

En Windows no es habitual asignar el *rol administrativo* a cuentas separadas de usuario. Esto es así sobre todo en equipos personales, o que son utilizados habitualmente por una persona, que desarrolla su actividad laboral en el mismo equipo.
En esta definición *rápida*, podría catalogarse tanto estaciones de trabajo o terminal de usuario, como equipos personales que cualquiera podría estar utilizando en su própio domicilio.

Se espera que el técnico sea lo suficientemente hábil para enfrentarse a la recuperación de una contraseña perdida, de manera incondicional. Eso solamente pasa en las películas. Lo cierto es que aunque conocemos técnicas de programación y de gestión preventiva; no somos magos, y los sistemas se construyen con la idea de que no sean facilmente alterables o modificables. Esto es *fiabilidad*.

---------

Teoria - ``net user``
------------------------

.. _net_user:

Esta es una herramienta Windows. El propio sistema proporciona la aplicación y no es necesario instalar o descargar nada extra en el sistema.
Parte de la premisa *debemos tener acceso al sistema, para poder utilizar la aplicación*. 

El comando **net user** es una herramienta fundamental en Windows, para gestionar las cuentas locales de usuario. Permite a los administradores realizar diversas operaciones, como crear nuevas cuentas, modificar las existentes o ver información detallada sobre ellas.


Funcionalidades clave de *net user*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*  **Ver todas las cuentas de usuario locales:** Simplemente ejecutando ``net user`` sin ningún parámetro adicional, obtendrás una lista de todas las cuentas de usuario activas en el sistema.

*  **Ver información detallada de una cuenta específica:** Para obtener información detallada sobre una cuenta en particular, utiliza la siguiente sintaxis:
    
   .. code-block:: powershell

      net user [nombre_de_usuario]
    
Esto mostrará datos como el nombre completo, si la cuenta está activa o deshabilitada, cuándo fue la última vez que se inició sesión, la fecha de caducidad de la contraseña, etc.


*  **Crear una nueva cuenta de usuario:** Puedes crear una nueva cuenta de usuario con una contraseña utilizando:

   .. code-block:: powershell

      net user [nombre_de_usuario] [contraseña] /add

Por ejemplo, ``net user pepito P@ssw0rd123 /add`` crearía una cuenta llamada *pepito* con la contraseña *P@ssw0rd123*.


*  **Cambiar la contraseña de una cuenta existente:** Si necesitas cambiar la contraseña de un usuario, puedes hacerlo con:

   .. code-block:: powershell

      net user [nombre_de_usuario] [nueva_contraseña]
    
   Si la contraseña está en blanco,

   .. code-block:: powershell

      net user [nombre_de_usuario] ""

   se establecerá una contraseña vacía (no recomendado por seguridad).

*  **Eliminar una cuenta de usuario:** Para eliminar una cuenta de usuario, utiliza:

   .. code-block:: powershell

      net user [nombre_de_usuario] /delete

   ¡Ten cuidado con este comando, ya que la eliminación es irreversible!


*  **Activar o desactivar una cuenta de usuario:** Puedes activar o desactivar una cuenta sin eliminarla:

   * Activar: ``net user [nombre_de_usuario] /active:yes``
   * Desactivar: ``net user [nombre_de_usuario] /active:no``


*  **Agregar un usuario a un grupo local:** Aunque no es directamente con ``net user``, a menudo se usa en conjunto con ``net localgroup`` para asignar usuarios a grupos. Por ejemplo, para agregar *pepito* al grupo de *Administradores*:

   .. code-block:: powershell

      net localgroup Administradores pepito /add


Consideraciones importantes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Permisos de administrador:** Para la mayoría de las operaciones de ``net user`` que modifican o crean cuentas, necesitas ejecutar el Símbolo del sistema (CMD) o PowerShell **como administrador**.

**Seguridad:** Ten precaución al establecer contraseñas, especialmente si estás creando scripts. Evita contraseñas fáciles de adivinar.

**Contexto de dominio vs. local:** Este comando gestiona cuentas de **usuario locales**. Si tu equipo forma parte de un dominio de Active Directory, las cuentas de dominio se gestionan de otra manera (por ejemplo, con herramientas de Usuarios y equipos de *Active Directory*).

El comando ``net user`` es una herramienta potente y esencial para la administración básica de usuarios en entornos Windows.


¿Cuándo usarlo?
~~~~~~~~~~~~~~~~~~

  * **Cambiar una contraseña existente:** Es el uso más común y seguro para actualizar la contraseña de una cuenta de usuario local.
  * **Restablecer una contraseña olvidada:** Si eres un administrador y alguien ha olvidado su contraseña en un equipo local, puedes usar este comando para establecer una nueva contraseña sin necesidad de conocer la anterior.
  * **Scripts interactivos:** Aunque para scripts automatizados se prefiere especificar la contraseña directamente (con `net user UserName Password`), el asterisco es útil cuando se necesita una entrada manual y segura.

   Recuerda que, al igual que con cualquier comando `net user` que modifica cuentas, debes tener **permisos de administrador** para ejecutarlo con éxito.


--------

Función hibernación en Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La **hibernación** es una característica de ahorro de energía en Windows que guarda el contenido de la memoria RAM en el disco duro antes de apagar completamente el equipo. Tras el reinicio, el sistema carga el contenido guardado en el disco, permitiéndo reanudar el trabajo, exactamente donde se dejó, con todas las aplicaciones y documentos abiertos, pero sin consumir energía. Es similar a la suspensión, pero a diferencia de esta, la hibernación no necesita energía para mantener el estado.


Razones para desactivar la hibernación:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.  **Liberar espacio en el disco duro:** Cuando la hibernación está activada, Windows reserva un archivo oculto llamado :kbd:`hiberfil.sys` en la unidad del sistema (normalmente ``C:\``). El tamaño de este archivo es aproximadamente el mismo que la cantidad de RAM instalada en tu equipo. Desactivar la hibernación elimina este archivo, liberando ese espacio en disco, lo cual puede ser útil en equipos con SSDs pequeños o poco espacio disponible.

2.  **Solución de problemas:** En raras ocasiones, la hibernación puede causar problemas de inicio o estabilidad en ciertos sistemas. Desactivarla puede ser un paso de solución de problemas.

3.  **No la usas:** Si nunca utilizas la función de hibernación y prefieres apagar el equipo completamente o usar solo la suspensión, desactivarla evita que se reserve espacio innecesariamente.


Consideraciones antes de desactivarla:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Si desactivas la hibernación, no podrás usar la función de "Inicio rápido" (Fast Startup) de Windows 10/11, ya que esta característica utiliza la hibernación para un arranque más rápido.
* Perderás la capacidad de guardar tu sesión y apagar completamente el equipo sin consumir energía.



El archivo hibernación que guardó windows.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Comando ``attrib``
~~~~~~~~~~~~~~~~~~~~~
El comando ``attrib`` en Windows es una herramienta de línea de comandos utilizada para **mostrar o cambiar los atributos de archivos y directorios**. Los atributos son marcadores que el sistema operativo utiliza para controlar cómo se comporta un archivo.

   .. code-block:: powershell

      C:\>attrib

Atributos Comunes de Archivos y Directorios:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  * **R (Solo lectura - Read-only):** Indica que un archivo no se puede modificar, eliminar o sobrescribir fácilmente. Es una protección básica para evitar cambios accidentales.
  * **A (Archivo - Archive):** Este atributo se establece automáticamente cada vez que un archivo es modificado. Los programas de respaldo (copias de seguridad) suelen usar este atributo para identificar qué archivos han cambiado desde la última copia de seguridad y necesitan ser respaldados de nuevo. Después de la copia de seguridad, el atributo de archivo generalmente se borra.
  * **S (Sistema - System):** Indica que un archivo es un archivo del sistema operativo, esencial para el funcionamiento de Windows. Estos archivos suelen estar ocultos y protegidos para evitar que los usuarios los modifiquen o eliminen accidentalmente, lo que podría causar problemas al sistema.
  * **H (Oculto - Hidden):** Hace que un archivo o directorio sea invisible en la Explorador de Archivos de Windows a menos que se configure para mostrar archivos ocultos. Se usa para mantener fuera de la vista archivos que no son de interés para el usuario promedio o para ocultar archivos del sistema.
  * **I (No Indexado - Not Content Indexed):** Este atributo indica que el archivo no debe ser indexado por el servicio de indexación de contenido de Windows. Esto puede mejorar el rendimiento de búsqueda en grandes volúmenes de datos, ya que estos archivos se omiten durante la indexación.
  * **O (Fuera de línea - Offline):** Indica que el archivo está almacenado fuera de línea. Este atributo suele ser establecido por sistemas de administración de almacenamiento jerárquico (HSM).
  * **P (Analizado - Reparse Point):** Indica que el archivo o directorio tiene un punto de reanálisis asociado. Se utiliza para funcionalidades avanzadas como enlaces simbólicos, puntos de montaje de volúmenes, o la desduplicación de datos.
  * **U (Anclado - Unpinned):** Este atributo se usa en el contexto de OneDrive y significa que el archivo solo está disponible en la nube y no está descargado localmente.
  * **V (Integridad - Integrity):** Este atributo se usa en el contexto de los Espacios de Almacenamiento (Storage Spaces) y se relaciona con la integridad de los datos.
  * **X (Sin Scrubbing - No Scrub):** Relacionado con los Espacios de Almacenamiento, indica que un archivo no debe ser sometido a un "scrubbing" (proceso de verificación de integridad de datos).

Sintaxis Básica del Comando *attrib*:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La sintaxis general del comando ``attrib`` es la siguiente:

.. code-block:: powershell

      ATTRIB [+R | -R] [+A | -A] [+S | -S] [+H | -H] [+I | -I]
         [+O | -O] [+P | -P] [+U | -U] [+V | -V] [+X | -X]
         [unidad:][ruta][nombre de archivo] [/S [/D]] [/L]


Donde:

  * ``+``: Establece un atributo.
  * ``-``: Borra un atributo.
  * ``R``, ``A``, ``S``, ``H``, ``I``, ``O``, ``P``, ``U``, ``V``, ``X``: Son los atributos que puedes establecer o borrar.
  * ``[unidad:][ruta][nombre de archivo]``: Especifica la ubicación y el nombre del archivo o directorio al que quieres aplicar los cambios. Puedes usar comodines (``*`` y ``?``).
  * ``/S``: Procesa archivos que coinciden en el directorio actual y todos sus subdirectorios.
  * ``/D``: Incluye directorios en la operación ``/S``. (Es decir, si quieres aplicar el cambio de atributo a los directorios y no solo a los archivos dentro de ellos).
  * ``/L``: Trabaja en el atributo del enlace simbólico en lugar del destino del enlace simbólico.

Ejemplos de Uso:
~~~~~~~~~~~~~~~~~~

1.  **Hacer un archivo de solo lectura:**

   .. code-block:: powershell

      attrib +R miarchivo.txt


2.  **Quitar el atributo de solo lectura de un archivo:**

   .. code-block:: powershell

      attrib -R miarchivo.txt

3.  **Ocultar un archivo:**

   .. code-block:: powershell

      attrib +H archivo_secreto.docx

4.  **Mostrar un archivo oculto:**

   .. code-block:: powershell

      attrib -H archivo_secreto.docx

5.  **Establecer un archivo como oculto y de sistema:**

   .. code-block:: powershell

      attrib +H +S programa.exe

6.  **Quitar los atributos de oculto y sistema de un archivo:**

   .. code-block:: powershell

      attrib -H -S programa.exe

7.  **Quitar el atributo de solo lectura de todos los archivos .txt en el directorio actual y sus subdirectorios:**

   .. code-block:: powershell

      attrib -R *.txt /S

8.  **Hacer un directorio y todos sus subdirectorios ocultos:**

   .. code-block:: powershell

      attrib +H mi_carpeta /S /D

   Aquí, ``/D`` es crucial para aplicar el atributo a las carpetas mismas, no solo a su contenido.
   
   
Consideraciones Importantes:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  * **Permisos:** Necesitas tener los permisos adecuados (generalmente permisos de administrador) para modificar los atributos de algunos archivos, especialmente los de sistema.
  * **Archivos de Sistema:** Modificar los atributos de los archivos del sistema (``+S``) o archivos ocultos de sistema (``+H +S``) sin saber exactamente lo que haces puede causar inestabilidad en el sistema operativo. *¡Úsalo con precaución!*
  * **Comodines:** Los comodines ``*`` (cero o más caracteres) y ``?`` (un solo carácter) son muy útiles para aplicar cambios a múltiples archivos a la vez.

El comando ``attrib`` es una herramienta potente para gestionar la visibilidad y el comportamiento de archivos y directorios en Windows, especialmente útil en scripts o para solucionar problemas específicos de archivos.


-------

``powercfg``
--------------

* ``powercfg``: Es una utilidad de línea de comandos de Windows que se usa para configurar y controlar la configuración de energía del sistema. Permite trazar planes de energía, ver el estado de la batería, analizar el uso de energía, y controlar funciones como la hibernación y la suspensión.

* ``/hibernate``: Es un parámetro específico de `powercfg` que se relaciona con la función de hibernación.

* ``off``: Es el valor que se le da al parámetro `/hibernate` para indicar que la hibernación debe ser **desactivada**. Si quisieras activarla de nuevo, usarías `powercfg /hibernate on`.

¿Cómo usarlo?
----------------

Para ejecutar este comando, necesitas abrir el Símbolo del sistema o PowerShell **como administrador**.

1.  Busca "cmd" o "PowerShell" en el menú de inicio.
2.  Haz clic derecho sobre la aplicación y selecciona "Ejecutar como administrador".
3.  Una vez abierta la ventana de comandos, escribe ``powercfg /hibernate off`` y presiona :kbd:`Enter`.

Después de ejecutarlo, el archivo ``hiberfil.sys`` debería desaparecer de tu disco duro y la opción de hibernar ya no estará disponible en el menú de apagado.



-------

1. ¿Qué es el archivo SAM?
-----------------------------

* **Base de Datos de Cuentas:** SAM es la base de datos donde Windows guarda la información de las cuentas de usuario y grupo locales de un equipo. Esto incluye nombres de usuario, información de seguridad y, lo más importante, las contraseñas de los usuarios en formato "hash" (cifrado).
* **Parte del Registro:** El archivo SAM no es un archivo independiente que puedas abrir directamente. Es una "colmena" (hive) del registro de Windows y se encuentra típicamente en la ruta `C:\Windows\System32\config\SAM`.
* **Autenticación:** Cuando un usuario intenta iniciar sesión en un sistema Windows, el subsistema Local Security Authority (LSA) verifica las credenciales introducidas contra la información almacenada en la base de datos SAM. Si las contraseñas coinciden, el usuario es autenticado.
* **Contiene hashes, no contraseñas claras:** Es crucial entender que el archivo SAM no almacena las contraseñas en texto plano. En su lugar, guarda una versión "hash" (unidireccional y cifrada) de la contraseña. Esto significa que, incluso si alguien accede al archivo SAM, no puede ver directamente las contraseñas originales, sino sus representaciones cifradas (principalmente en formato NTLM).


2. ¿Cómo almacena la lista de usuarios y qué información contiene?
---------------------------------------------------------------------

El archivo SAM contiene la siguiente información sobre los usuarios locales:

* **Nombre de usuario:** El nombre de inicio de sesión de la cuenta.
* **Nombre completo:** El nombre completo asociado a la cuenta.
* **Comentario de usuario:** Un campo opcional para comentarios.
* **Ruta del perfil:** La ubicación de la carpeta de perfil del usuario.
* **Tipo de cuenta:** Si es una cuenta de administrador, usuario estándar, invitado, etc.
* **Estado de la cuenta:** Si la cuenta está activa, deshabilitada, si se requiere contraseña, si la contraseña ha caducado, etc.
* **Contador de inicio de sesión:** El número de veces que el usuario ha iniciado sesión.
* **RID (Relative Identifier):** Un identificador único para cada usuario o grupo dentro del dominio local.
* **Hashes de contraseña:** Las representaciones cifradas de las contraseñas de los usuarios (históricamente LM y NTLM, aunque LM está obsoleto por razones de seguridad).

**3. Seguridad del archivo SAM**

Dado que el archivo SAM contiene información tan sensible, Windows implementa varias medidas de seguridad para protegerlo:

* **Acceso Restringido:** Mientras Windows está en ejecución, el archivo SAM está bloqueado por el kernel del sistema operativo. Esto significa que un usuario normal no puede acceder, copiar o modificar directamente el archivo SAM. Solo los administradores del sistema y procesos específicos con altos privilegios pueden interactuar con él.
* **Cifrado de hashes:** Como se mencionó, las contraseñas se almacenan como hashes, no en texto plano, lo que dificulta su recuperación directa.
* **Syskey (obsoleto):** En versiones anteriores de Windows, existía la herramienta "Syskey" que proporcionaba una capa adicional de cifrado a la base de datos SAM. Sin embargo, Syskey ha sido eliminado en versiones modernas de Windows debido a vulnerabilidades.
* **Vulnerabilidades y mitigaciones:** A lo largo de los años, se han descubierto vulnerabilidades relacionadas con el acceso no autorizado al archivo SAM o la extracción de sus hashes (como "Serious SAM" o "HiveNightmare"). Microsoft ha emitido parches y recomendaciones para mitigar estos riesgos, como restringir el acceso a los contenidos de `C:\Windows\System32\config` y eliminar copias ocultas de volumen (Volume Shadow Copy Service).
* **Auditoría:** Windows permite auditar los intentos de acceso a objetos SAM, lo que puede ayudar a detectar actividades sospechosas.
* **Acceso remoto restringido a SAM-R:** Se recomienda restringir las llamadas RPC remotas al SAM (SAM-R) para evitar que agentes maliciosos accedan de forma remota a la base de datos y descubran información confidencial.

**En resumen:**

El archivo SAM es el corazón de la gestión de cuentas de usuario locales en Windows. Si bien almacena la "lista de usuarios" y sus contraseñas (en formato hash), su acceso está fuertemente protegido para garantizar la seguridad del sistema. Las técnicas de ataque a menudo buscan extraer estos hashes para intentar descifrarlos "offline" y obtener las contraseñas originales, lo que subraya la importancia de las medidas de seguridad y las buenas prácticas de gestión de contraseñas.


.. _superbloque:

Superbloque
~~~~~~~~~~~~~
Es una estructura de datos, de un sistema de archivos -o sistema de ficheros. Permite al sistema operativo interacturar con él(FS), de manera adecuada.









