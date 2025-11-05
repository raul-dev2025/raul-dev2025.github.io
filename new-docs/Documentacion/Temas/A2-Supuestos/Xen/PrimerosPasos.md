## Primeros pasos con Xen

Escribo esto para recordar que tendría que aclarar conceptos generales...
lo primero de todo:

 - Virtualización
 - Emulación
 - Paravirtualización
 - Passtrough
 - IOMMU y el _bounce buffer_
 
 
Lo primero que encuentro es una referencia al uso de las _LVM's_ desde varias
páginas de documentación. Así que habrá  que hacer un poco de memoria y, 
tomarse en serio lo dicho.

Esto implica que las imágenes de los _supuestos_ que serán creadas en el
sistema, partirán desde un _LV(Logical Volum)_.
Tiene su lógica; en lugar de ir creando archivos a lo bestia, y dejarlos
anclados en algún lugar del disco duro o, incluso crear particiones _extra_,
para contener las _MV(Maquina Virtual)_, lo que se hará, será aislar los 
componentes principales de dichas _MV_, en volúmenes lógicos.

El primer enigma que aparece, es si vamos a tener que expandir el espacio
que contiene la _LVM_ con nuestro sistema, dom0 -en este caso o, bien se 
encargá el propio _hipervisor_, de llevar a cabo la tarea, de forma _limpia y
aislada_.



Empezamos escribiendo un pequeño ejemplo de guía:

	xen-create-image \
	--dhcp --mac my:my:my:mac:mac:mac \
	--memory 512M --swap 1000M \
	--dist squeeze \
	--mirror http://10.80.16.196/debian \
	--hostname debian.guest.osstest \
	--lvm field-cricket --force \
	--kernel /boot/vmlinuz-2.6.32.57 \
	--initrd /boot/initrd.img-2.6.32.57 \
	--arch i386`

Al utilizar la opción `--lvm` 

 
#### Herramientas de gestión para Xenq

#### El boot con xen


#! /bin/sh
exec tail -n +3 $0
menuentry ' LINUX with Xen' --class fedora --class gnu-linux --class gnu --class os --class xen $menuentry_id_option 'xen-gnulinux-simple-UUID' {
#	set gfxpayload=$linux_gfx_mode
	recordfail
	insmod part_msdos
	insmod ext2
	set root='hd0,msdos6'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos6 --hint-efi=hd0,msdos6 --hint-baremetal=ahci0,msdos6 --hint='hd0,msdos6'  UUID
	else
	  search --no-floppy --fs-uuid --set=root UUID
	fi
	echo	'Loading Xen 4.6.6 ...'
        if [ "$grub_platform" = "pc" -o "$grub_platform" = "" ]; then
            xen_rm_opts=
        else
            xen_rm_opts="no-real-mode edd=off"
        fi
	multiboot	/xen-4.gz placeholder   ${xen_rm_opts}
	echo	'Loading Linux ...'
	module	/vmlinuz-4.0 placeholder root=UUID=UUID ro  xorg.device-UUID  rootflags=subvol=root rd.lvm.lv=miOS/swap quit splash vt.handoff=7
	echo	'Loading initial ramdisk ...'
	module	--nounzip   /initramfs-4.0.img
}



#### Modo emergencia

title 						pv_ops dpm0(2.6.32.24) with serial  sonsole
root							(hd0,0)
kernel						/xen-4.0.gz dom0_mem=1024 loglvl=all guest_loglvl=all
sync_console			console_to_ringcom1=19200,8n1 console=com1
module						/vmlinuz-2.6.32.24 ro root=/dev/vg00/lv01  console=hvc0
earlyprintk=xen nomodset
module						/initrd-2.6.32.24.img

























