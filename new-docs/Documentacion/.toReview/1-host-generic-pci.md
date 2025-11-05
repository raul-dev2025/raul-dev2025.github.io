# Controlador de _host_ PCI, genérico #

Los controladores de host PCI, inicializdos por el _firmaware_, como la implementación _virtio-pci_, encontrada en `kvmtool` y otros sistemas paravirtualizados, no requieren soporte complejo, al controlador; como la gestión del _regulador(vrm?)_  o al reloj.
De hecho, el controlador podría no requerir la configuración de una interfase de control, por el sistema operativo. En su lugar, es presentada un conjunto de ventanas fijas, describiendo un subconjunto de IO, _memoria_ y, _expacios de configuración_.

Este tipo de controladores pueden ser descritos, estrictamente, en términos de las vinculaciones al _Árbol de dispositivo_ estandarizado; comunicadas en `pci.txt`

Propiedades de nodo, del _controlador pci host_:

- `compatible`: Debe ser `pci-host-cam-generic` o `pci-host-ecam-generic`, dependiendo de la _capa_ para el espacio de configuración (CAM vs ECAM, respectívamente).

- `device_type`: Debe ser `pci`.

- `ranges`: Descrito en _IEEE Std 1275-1994_, pero deberá proporcionar, como mínimo, una definición de _memoria no predecible_. Uno o ambos espacios de memoria e IO, podrían ser proporcionados.

- `bus-range`: Propiedad opcional -también descrita en _IEEE Std 1275-1994_, para indicar un rango de números de bus, para este controlador.
De estar ausente, por defecto es `<0 255>` -todos los buses.

- `#address-cells`: Debe ser 3.

- `#size-cells`: Debe ser 2.

- `reg`: La configuración del espacio base, de dirección y tamaño, tal y como es accedido desde el bus ascendente. La _dirección base_, corresponde al primer bus, en la propiedad `bus-range`. Si no es especificada `bus-range`, será el bus 0 -por defecto.

Propiedades del nodo `/chosen`:

`linux,pci-probe-only`: Propiedad opcional, la cuál toma un sólo argumento de celda.
Si `0`, entonces _Linux_ asignará dispositivos de manera habitual. de cualquier otra forma, no intentará asignar dispositivos y en su lugar, los utilizará tal y como están ya configurados.

Es asumido el espacio de configuración, para ser mapeados en la memoria -en oposición, a ser accedidos vía un _ioport_. Permanecen  con una correspondencia directam a la geografía, de una dirección bus PCI, por medio de la concatenación de varios componentes y, formar así un `offset`.

Para CAM, este `offset` de 24'bits es:

		cfg_offset(bus, device, function, register) =
              bus << 16 | device << 11 | function << 8 | register

Mientras que ECAM, extiende esto en 4 bits, para acomodar un espacio de función de `4K`.

		cfg_offset(bus, device, function, register) =
              bus << 20 | device << 15 | function << 12 | register


El _mapa de interrupciones_,  es excactamente igual, a como está descrito en _Open Firmware Recommended Practice: Interrupt Mapping_ y, requiere las siguientes propiedades:

- `#interrupt-cells`: Debe ser 1.
- `interrupt-map`: ver especificaciones mencionadas anteriormente.
- `interrupt-map-mask` : ver especificaciones mencionadas anteriormente.


Ejemplo:

		pci {
    compatible = "pci-host-cam-generic"
    device_type = "pci";
    #address-cells = <3>;
    #size-cells = <2>;
    bus-range = <0x0 0x1>;

    // CPU_PHYSICAL(2)  SIZE(2)
    reg = <0x0 0x40000000  0x0 0x1000000>;

    // BUS_ADDRESS(3)  CPU_PHYSICAL(2)  SIZE(2)
    ranges = <0x01000000 0x0 0x01000000  0x0 0x01000000  0x0 0x00010000>,
             <0x02000000 0x0 0x41000000  0x0 0x41000000  0x0 0x3f000000>;


    #interrupt-cells = <0x1>;

    // PCI_DEVICE(3)  INT#(1)  CONTROLLER(PHANDLE)  CONTROLLER_DATA(3)
    interrupt-map = <  0x0 0x0 0x0  0x1  &gic  0x0 0x4 0x1
                     0x800 0x0 0x0  0x1  &gic  0x0 0x5 0x1
                    0x1000 0x0 0x0  0x1  &gic  0x0 0x6 0x1
                    0x1800 0x0 0x0  0x1  &gic  0x0 0x7 0x1>;

    // PCI_DEVICE(3)  INT#(1)
    interrupt-map-mask = <0xf800 0x0 0x0  0x7>;
		}



### <a name="199">Referencias y agradecimientos</a> ###

vrm -- voltage regulator module

pci-- peripheral component interconnect
