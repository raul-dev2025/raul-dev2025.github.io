1. [Cónsola en serie Linux](#i1)

2. [Referencias y agradecimientos](#i2)

---

## <a name="i1">Cónsola en serie Linux</a>

Para utilizar la cónsola en serie, es necesario compilar dicho soporte, al kernel.
Por defecto, no está compilado. Dentro del menú de configuración:

	menuselection: `Character devices --> Serial drivers -->`
		8250/16550 and compatible serial support -->
		Console on 8250/16550 and compatible serial port

Debe compilarse la funcionalidad como parte del kernel, __no por separado__.

Es posible especificar múltiples dispositivos para la salida de cónsola. Pueden definirse nuevos comando de línea, para seleccionar qué dispositivo/s será usado en la salida de cónsola. El formato de esta opción es:

		console=device,options
		
	__device:__		tty0 for the foreground virtual console
			ttyX for any other virtual console
			ttySx for a serial port
			lp0 for the first parallel port
			ttyUSB0 for the first USB serial device

	__options:__	depend on the driver. For the serial port this
			defines the baudrate/parity/bits/flow control of
			the port, in the format BBBBPNF, where BBBB is the
			speed, P is parity (n/o/e), N is number of bits,
			and F is flow control ('r' for RTS). Default is
			9600n8. The maximum baudrate is 115200.
	
Puede especificarse múltiples opciones `console=`, sobre la línea de órdenes. La salida aparecerá en todas ellas. Será utilizado el último dispositivo, cuando sea abierto `/dev/ console`, ejemplo:

		console=ttyS1,9600 <strong>console=tty0</strong>
		
... define que abriendo `/dev/console` tomará la actual cónsola virtual, corriendo en segundo plano. Los mensajes del _kernel_ aparecerán en ambas; el segundo puerto en serie (ttyS1 ó COM2) _a 9600 baudios_, y la cónsola VGA.

> _Nótese que sólo puede definirse una cónsola por tipo de dispositivo_.

Si no hay _dispositivo de cónsola_ especificado, será utilizado el primer dispositivo encontrado, capaz de actuar como cónsola de sistema. 
En este punto, el sistema primero buscará la _tarjeta VGA_ y después, el puerto en serie. Así que, si no hay _tarjeta VGA_ en el sistema, será utilizado el primer puerto en serie como cónsola.

Será necesario crear un nuevo dispositivo para usar `/dev/console`. El `/dev/console` _habitual_, es un _dispositivo de carácteres 5,1_ (`ll -s /dev/console`).

Es posible usar, incluso un _dispositivo de red_ como cónsola.
Ver `Documentation/networking/netconsole.txt`, para más información.

Aquí hay un ejemplo de uso `/dev/ttyS1` (COM2) como cónsola.
Reemplazar los valores de ejemplo, de ser necesario:

1. Crear `/dev/console` (cónsola real) y `/dev/tty0` (cónsola virtual _maestra_)

		cd /dev
		rm -f console tty0
		mknod -m 622 console c 5 1
		mknod -m 622 tty0 c 4 0

2. `LILO` puede también tomar entradas desde un dispositivo en serie. Se trata de una _característica_ de gran utilidad. 
Uso del puerto en serie; en el archivo `lilo.conf`, sección `[global]`:

		serial= 1,9600n8 (ttyS1, 9600 bd, no parity, 8 bits)
		
3. Ajustar las _opciones del kernel_, en el archivo `lilo.conf`, sección _[kernel]_:

		append = "console=ttyS1,9600"
		
4. Confirmar que un `getty` corre en el puerto en serie, y poder así, _entrar_ una vez el sistema termine de arrancar. Ésto se realiza añadiendo una línea como ésta a `/etc/ inittab/`.
La sintaxis depende de la aplicación `getty` instalada en el sistema.

		S1:23:respawn:/sbin/getty -L ttyS1 9600 vt100

5. _Init_ y `/etc/ioctl.save`

_Sysvinit_ recuerda la configuración _stty_ en un archivo colocado en `/etc`, llamado `/etc/ioctl.save`. BORRA ÉSTE ARCHIVO, antes de usar la cónsola en serie por primera vez, por que de otra manera, `init`, probablemente ajustaria el _baud rate_ a `38400`.

> __baud rate:__ ratio de baudios, rango de baudios, señal en baudios, o velocidad de transmisión de una señal, estimada en baudios(unidad).

6. `/dev/console` y programas _X(Xorg)_, que necesiten trabajar en cónsolas virtuales, abrirán `/dev/console`. Si después de haber creado un dispositivo `/dev/console`, la cónsola _no es_ la _cónsola virtual_, algunos programas fallarán. Son esos programas que necesitan _acceso_ a la interfase VT(virtual terminal), y usan `/dev/console` en lugar de `/dev/tty0`. Algunos son:

- _Xfree86, svgalib, gpm, SVGATextMode_

Debería ser arreglado en versiones mas modernas de esos programas.

Nótese que al _arrancar_ sin la opción `console=` -o `console=/dev/tty0`,
`/dev/console` es lo mismo que `/dev/tty0`. En ese caso, todo seguirá funcionando.


#### <a name="i2">Referencias y agradecimientos</a>

>> __maestro/esclavo:__ términos habitualmente usados, para referirse a procesos, servicios, máquinas, entidades dependientes unas de otras. Podría decirse que la entidad _maestro__regula_ la entidad _esclavo_, dando lugar a una relación de dependencia. 




 Thanks to Geert Uytterhoeven <geert@linux-m68k.org>
 for porting the patches from 2.1.4x to 2.1.6x for taking care of
 the integration of these patches into m68k, ppc and alpha.
