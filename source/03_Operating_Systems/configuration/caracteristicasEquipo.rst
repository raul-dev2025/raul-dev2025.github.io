Caracteristicas del equipo
=============================

- **PB**: Gigabyte H410M S2H V3
- **CPU**: I3-10100F CPU @ 3.60GHz - 4 núcleos. En Intel la ¨F¨ indica que la placa no integra ninguna tarjeta gráfica.
- **RAM**: DIMM-DDR4 2666 MHz 
- **Gráfica**: NIDIA GeForce 710 (no lleva tarjeta gráfica integrada.)
- **HDD/SSD**: Kingston SSD 224GB
- **Fuente**: 500W ATX



----------------

En *PowerShell* podemos mirar las especificaciones de la placa base con el siguiente comando::
	
   Get-WmiObject Win32_BaseBoard | Select-Object Product, Manufacturer, SerialNumber
