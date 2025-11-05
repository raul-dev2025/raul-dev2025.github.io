# 04/11/2018

Se han hecho varias pruebas del sistema antes de instalar el sistema operativo:

Descripción, (ambiguedad) en la configuración de lets para la copia de seguridad de la BIOS.

Especificación descrita en el manual de la placa:

Interruptor BIOS-SW :

		2		1
<on-ON> -- 1. Main BIOS(Boot from the main BIOS). Activa __posición 1__.

Led asociado: M_BIOS(MBIOS_LED) __ON__
Led asociado: B_BIOS(BBIOS_LED) __off__

		2		1
<ON-on> -- 2. Backup BIOS(Boot from the backup BIOS). Activa __posición 2__.

Led asociado: 
Led asociado: M_BIOS(MBIOS_LED) __off__
Led asociado: B_BIOS(BBIOS_LED) __ON__



## ErP, descripción

WARINING
Consumo de la energía remanente durante el apgado del sistema(shutdown) S5. Ver _acpi y estados de energía del sistema_.

Habiéndo desactivado la característica, el sistema sigue manteniendo el remanente de energía, disipada tras contacto al botón encendido.

Esto desabilita la característica "levantar el sistema" desde los periféricos habituales.

## USB hub




