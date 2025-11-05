__## -J stands for Joliet filesystem type. It's a regular ISO9660__
__## usable on Windows machines__
__## -r Set permissions to any, the uid and gid are set to zero.__
__##-V specifies a Volume Name__
__## -o Output file__
__## -v Verbose execution__
__## Utf-8 has not ~ and characters like that. It is necesary to choose a 'mode'__
__## that this kind of character will be recognized.__
__## I can't undestand why UTF is not the global-world accepted/used method to code!!__

		genisoimage -v -J -r -V Etiqueta -o file.iso /path/from/for_iso

Para comprobar que la imagen se realizó correctamente, solo hay que montarla.

#Then write to disk:

xorriso -as cdrecord -v dev=/dev/sr0 -dao ms775.iso
