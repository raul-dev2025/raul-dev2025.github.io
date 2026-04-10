**## -J stands for Joliet filesystem type. It’s a regular ISO9660** **##
usable on Windows machines** **## -r Set permissions to any, the uid and
gid are set to zero.** **##-V specifies a Volume Name** **## -o Output
file** **## -v Verbose execution** **## Utf-8 has not ~ and characters
like that. It is necesary to choose a ‘mode’** **## that this kind of
character will be recognized.** **## I can’t undestand why UTF is not
the global-world accepted/used method to code!!**

::

       genisoimage -v -J -r -V Etiqueta -o file.iso /path/from/for_iso

Para comprobar que la imagen se realizó correctamente, solo hay que
montarla.

#Then write to disk:

xorriso -as cdrecord -v dev=/dev/sr0 -dao ms775.iso
