## Notas y observaciones

- Programar nueva tabla??
- arquitectura 64-bit
  "no 64-bit math support"

- exceso nº CPU -- 4??
- ámbito o raíz \_PR
- Bios RAM map
- MTRR type -- Memory Type Range Registers
- MTRR fixed ranges
- RAMDISK range


__nota:__ cuando el rango direccionamiento de un dispositivos es limitado y, 
no existe _IOMMU_, podría el dispositivo no ser capaz de alcanzar la memoria
física. 
En este caso, una región de la memoria del sistema, a la que el dispositivo si
puede acceder, es reservada; el dispositivo es programado al _DMA_, a esta area
reservada.
EL procesador copia entonces el resultado de este "objetivo" de memoria, que
estaba más ayá de poder ser alcanzado por el dispositivo. Éste método es conocido
como _límite de almacenado(bounce buffering)_.
