``diskpark`` - particionado
===========================

Para comprobar el tipo de partición de un disco:

- Pulsamos tecla :kbd:`Win` y escribimos: ``símbolo de sistema`` o
- Abrimos el símbolo de sistema con :kbd:`Win + R` y escribir ``cmd``; a continuación escribimos los siguiente comandos::

   1. diskpark
   2. list disk
   3. select disk 1
   4. list partition
   5. clean
   6. list partition
   7. exit

- 1. El comando ``diskpark``, abrirá una nueva instancia del *símbolo de sistema* con la aplicación.
- 2. A continuación con el comando ``list disk``, serán listadas todas las particiones que estén definidas en el sistema. Si hay discos de otros sistemas operativos conectados, aparecerán también. Sin embargo el tipo de partición en éste caso, no aparecerá. Esto es así por que el gestor de discos de Windows no reconoce los sistemas de ficheros, ligados a esas *particiones externas*.
- 3. Con el comando ``select disk Nº``, seleccionamos el disco donde va a crearse la nueva partición. 
- 4. Volvemos a escribir el comando ``list disk``, y esta vez deberá aparecer un asterisco al principio de la línea, indicando el disco seleccionado. En este paso es importante asegurarse de que el disco seleccionado es el correcto, antes de continuar con el *borrado* de **todo el disco**.
- 5. El siguiente comando ``clean``; borrará efectivamente todo el contenido deldisco; datos, particiones, tabla de particiones, **todo**.
- 6. Nuevamente utilizamos el comando ``list disk``, para asegurarnos de que el disco a sido borrado, y no queda rastro alguno de la partición que contenía.
- 7. Terminado el proceso, podremos cerrar la aplicación -recordamos que la aplicación se está ejecutando en una segunda instancia del *símbolo de sistema*; la cerramos con el comando ``exit``.

Crear particiones
-----------------

- **Abrimos el administrador de discos** presionando :kbd:`Win + R`, se abre un cuadro de diálogo; escribimos ``diskmgmt.msc``. Otra alternativa;  mantenemos pulsalo  :kbd:`control izquierdo +` click en botón derecho del ratón y seleccionamos *Administrador de discos*.
- **Identifica el USB** Identificamos el disco, en este caso será un *USB*; el disco a particionar. 
- **Crear nueva partición** Click derecho en el espacio no asignado del *USB* y seleccionamos *Nuevo volumen simple*.
- **Seguir el asistente** Habrá que especificar el tamaño, la letra de la unidad y el sistema de archivos(*NTFS o FAT32*).
- **Formatear la partición** una vez creada la partición se deberá formatear, para hacerlo click derecho  en la partición y seleccionar *Formatear*.


Montar particiones en Windows
-----------------------------

Windows monta la partición al asignarle una letra de unidad. Dicho de otra forma: si no se le asigna una letra con el Administrador de discos, la unidad o medio de almacenamiento no será montada.

Aunque lo dicho anteriormente es cierto en términos generales, no es absolutamente exacto. Técnicamente, una partición puede estar montada sin letra de unidad, pero en ese caso solo sería accesible mediante rutas de montaje en carpetas o herramientas especializadas. Por ejemplo, Windows permite montar una partición en una carpeta vacía de una unidad existente, sin asignarle una letra.


Permisos de NTFS
----------------
Abrimos las propiedades de archivo y seleccionamos la pestaña
seguridad. Click en el botón editar.
