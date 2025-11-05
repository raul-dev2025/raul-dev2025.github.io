[Construir el depurador](#i1)
[Iniciar la interfase](#i2)
[Parar la interfase del depurador](#i3)
[Ejecución del depurador en un escrito](#i4)



## El depurador AML ##

Copyright (C), Intel Corporation
__Autor__: Lv Zheng <lv.zheng@intel.com>

Este documento describe el uso del depurador AML, embebido en el kernel de Linux.


<a name="i1">#### Construir el depurador ####</a>

Los siguiente componentes en la configuración del kernel, son necesarios para _activar_ la interfase del depurador, en el kernel de Linux:

		CONFIG_ACPI_DEBUGGER=y
		CONFIG_ACPI_DEBUGGER_USER=m

Las utilidades en el espacio de usuario, podrán ser construidas desde la fuente del kernel, mediante los comandos a continuación:

		$ cd tools
		$ make acpi

Los resultantes binarios, de las herramientas en el espacio de usuario, están localizadas en:

		tools/acpi/power/acpi/acpidbg/acpidbg

Podrá ser instalado en los directorios del sistema, ejecutando `lmake install` -como usuario con los suficientes permisos.


<a name="i2">#### Iniciar la interfase del depurador, en el espacio de usuario ####</a>

Después de arrancar el kernel, con el _depurador_ ya construido, tan sólo queda iniciarlo. Desde la cónsola, escribir los siguientes comandos:

		# mount -t debugfs none /sys/kernel/debug
		# modprobe acpi_dbg
		# tools/acpi/power/acpi/acpidbg/acpidbg

Aparecerá el entorno del depurador interactivo, donde podrán ejecutarse los comandos del depurador.

Los comandos están documentados en "Resumen ACPICA y Referencias de Programador", pudiendo ser descargado desde 

		[https://acpica.org/documentation](https://acpica.org/documentation)

> ACPICA Overview and Programmer Reference, en inglés.

Las referencias detalladas a lso comandos, se encuentran en el __capítulo 12__, "ACPICA Debugger Reference". El comando `help` es utilizado para una rápida referencia a ellos.


<a name="#I3">#### Parar la interfase del depurador, del espacio de usuario. ####</a>

La interfase interactiva del depurador, podrá cerrarse presionando `Ctrl+C` o escribiendo los comandos `quit` o `exit`. Al finalizar, deberán _descargarse_ los módulos con:

		# rmmod acpi_dbg

La descarga del módulo, podría fallar si hubiese alguna otra instancia de `acpidbg` en activo.


<a name="i4">#### Ejecución del depurador en un escrito(script) ####</a>

Podría resultar útil, iniciar el depurador AML en un escrito, `acpidbg` soporta éste modo especial `batch`. Por ejemplo, el siguiente comando entrega como salida el _espacio de nombres ACPI_ al completo:

		# acpidbg -b "namespace"


> __batch__: aplicación de _cónsola_, habitualmente utilizada en entornos Linux.


---

<ul id="firma">
	<li><b>Traducción:</b> Heliogabalo S.J.</li>
	<li><em>www.territoriolinux.net</em></li>
</ul>
