Comando ``Attrib``
======================
.. code-block:: powershell
   
   PS C:\Users\UserName> attrib.exe /?
   Muestra o cambia los atributos de un archivo.

   ATTRIB [+R | -R] [+A | -A] [+S | -S] [+H | -H] [+O | -O] [+I |
           -I] [+X | -X] [+P | -P] [+U | -U]
          [unidad:][ruta][nombre_de_archivo] [/S [/D]] [/L]

     +   Establece un atributo.
     -   Borra un atributo.
     R   Atributo de archivo de solo lectura.
     A   Atributo de archivo de almacenamiento.
     S   Atributo de archivo del sistema.
     H   Atributo de archivo oculto.
     O   Atributo sin conexión.
     I   Atributo de archivo sin indexado de contenido.
     X   Atributo de archivo sin limpieza.
     V   Atributo de integridad.
     P   Atributo anclado.
     U   Atributo desanclado.
     B   Atributo de blob SMR.
     [unidad:][ruta][nombre_de_archivo]
         Especifica los archivos que procesará el atributo.
     /S  Procesa archivos que coinciden en la carpeta actual
         y todas las subcarpetas.
     /D  También procesa carpetas.
     /L  Se trabaja en los atributos del vínculo simbólico
         frente al destino del vínculo simbólico.
