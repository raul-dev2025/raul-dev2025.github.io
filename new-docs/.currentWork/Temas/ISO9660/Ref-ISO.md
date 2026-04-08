## Referencias ISO

			 genisoimage
       devdump,  isoinfo,  isovfy,  isodump - Utility programs for dumping and
       verifying iso9660 images.


#### GenIsoImage

		options -o:
			-appid - incluye la etiqueta para la cabecera del volumen.
			-ldots - nombre de archivos pueden empezar por punto.
			-biblio - nombre bibliografico
			-no-cache-inodes - solo guarda una vez el contenido del archivo simulando
												el comportamiento del origen(con cuidado-revisar).
			-mipsel-boot mipsel boot image
			-sparc-boot -- comma-separated list of boot img needed on bootable CD for sparc.
			-hard-disk-boot -- read man page 

		genisoimage -v -J -r -V Etiqueta -o file.iso /path/from/for_iso


---

#### Enlaces útiles
[metodo][https://fedoraproject.org/wiki/How_to_create_and_use_a_Live_CD]
[metodo][https://fedoraproject.org/wiki/Livemedia-creator-How_to_create_and_use_a_Live_CD]
