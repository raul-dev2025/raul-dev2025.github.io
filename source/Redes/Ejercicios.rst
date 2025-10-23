Puntos de restauración
======================

Ejercicios
----------

**Puntos de restauración**
1. Pulsar tecla Windows y escribir: "punto de restauracion". o
   configuración-> Sistema -> Información -> Configuración avanzada del sistema ->
   en el panel "Propiedades del sistemas" en la pestaña -> Protección del sistema ->
   Si ya están configurad sonfigurados :
    - Con el medio de almacenamiento ya configurado pulsamos el botón "crear" y escribimos el nombre del punto de restauración.
   Si no están configurados:
    - Seleccionar la unidad donde se almacenarán los puntos de restauración. 
    - pulsamos el botón "Configurar"
    - activar "Activar protección del sistema"
    - En la sección "Usuo del espacio en disco" habrá que seleccionar la cantidad de espacio a reservar.
    - Aceptamos y volvemos al panel "Propiedades del sistemas" pestaña "Protección del sistema"
    - Con el medio de almacenamiento ya configurado pulsamos el botón "crear" y escribimos el nombre del punto de restauración.


**Cortafuegos**
Panel de control
Cortafuegos de Windows
Configuración avanzada
nueva regla, pide que seleccionemos si la regla afectará a un puerto, a un programa, también aparece la opción "predefinida" y Personalizada. En este caso seleccionamos la opción programa, puesto que es el explorador "Brave" una aplicación a la que queremos bloquear el acceso a internet. 
A continuación seleccionamos la ruta al binario o ejecutable, en este caso "C:\Program Files\BraveBrowser\Application\brave.exe". Seguidamente nombramos la rela y podremos también añadir una descripción. Validamos al salir y comprobamos que la regla se ha creado correctamente.






El comando "chkdsk
------------------

El comando "chkdsk /f d:" es una instrucción de administración de Windows que ejecuta un análisis y reparación de errores en el sistema de archivos del disco duro especificado. Aquí está lo que cada parte del comando significa:

"chkdsk": Es el comando para ejecutar el análisis y reparación de errores en el sistema de archivos.
"/f": Es la opción que indica que se deben realizar reparaciones automáticas en el sistema de archivos si se encuentran errores.
"d:": Es la unidad de disco a la que se aplicará el análisis y reparación de errores. En este caso, se está especificando el disco duro "d:". Puedes reemplazar "d:" con la letra de la unidad de disco que desees analizar y reparar.
Cuando ejecutas este comando, el sistema de Windows realizará un análisis exhaustivo del sistema de archivos del disco duro especificado y buscará y reparará cualquier error que encuentre. Esto puede llevar algún tiempo, dependiendo del tamaño del disco duro y la cantidad de errores que haya.

Es importante tener en cuenta que el comando "chkdsk" requiere privilegios de administrador para ejecutarse, por lo que debes ejecutarlo con privilegios de administrador o iniciar sesión como administrador antes de ejecutarlo. Además, si hay archivos abiertos en el disco duro que se va a analizar, se te pedirá que los cierres antes de ejecutar el comando.


.. code-block:: powershell

    # chkdsk /f [unidad]
    chkdsk /f d:

    chkdsk /scan
    chkdsk /r /f


------
Convertir a su forma binaria los siguientes números:

33  -> 0010 0001
145 -> 1001 0001
103 -> 0110 0111
3   -> 0000 0011
128 -> 1000 0000
249 -> 1111 1001
248 -> 1111 1000
48  -> 0011 0000
184 -> 1011 1000
153 -> 1001 1001
118 -> 0111 0110
247 -> 1111 0111
197 -> 1100 0101
100 -> 0110 0100
99  -> 0110 0011


------
1. copia seguridad
2. punto restauración
3. instalación de alguna aplicación
4. cortafuegos, configuración
5. configuración de la red


windows+R "mmc" 