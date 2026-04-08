Indice
======

1.  `Referencias Generales <#i1>`__
    1.1 `Referencias SO <#i1i1>`__
    1.2 `Placas <#i1i2>`__
2.  `Referencias a memorias <#i2>`__
3.  `Referencias a Disco Duro <#i3>`__
4.  `Referincias a Unidades de procesamiento <#i4>`__
5.  `APM(Advanced Power Management) <#i5>`__
6.  `Referencias Acpi/Acpica/Tablas-Acpi <#i6>`__
7.  `Referencias a Video <#i7>`__
8.  `Referencias a Supuestos <#i8>`__
9.  `Referencias a criptografia <#i9>`__
10. `Referencias Cryptomonedas <#i10>`__
11. `Referencias/enlaces <#i11>`__
    11.1 `Núcleo <#i11i1>`__
    11.1.1 `Repositorios <#i11i1i1>`__
    11.1.1.1 HTTP
    11.1.1.2 FTP
    11.1.2 `Documentacion <#i11i1i2>`__
    11.1.2.1 HTTP
    11.1.2.2 FTP
    11.2 `Patentes <#i11i2>`__

--------------

1. Referencias Generales
------------------------

-  **OS** — Operating system
-  **OSL** — OS Service Layer (Capa de Servicio del SO)
-  **ABI** — Application Binary Interface (Interfaz Binaria de Aplicación)
-  **HDL** — Hardware Description Language
-  **HPET** — High Precision Event Timer
-  **APIC** — Advanced Programmable Interrupt Controller
-  **LAPIC** — Local component, integrado en el procesador
-  **SMI** — System Management Interrupt (Interrupción de Gestión del Sistema)
-  **PCMCIA** — Personal Computer Memory Card International Association
-  **SPI** — Serial Peripheral Interface (Interfaz Periférica en Serie)
-  **PIC** — Programmable Interrupt Controller
-  **DSP** — Procesadores Digitales de Señal
-  **FPGA** — Matrices de puertas reconfigurables
-  **DPMI** — DOS Protected Mode Interface
-  **PCB** — Process Control Block - define el estado actual del sistema
   operativo.
-  **IP** — Intellectual Property (Propiedad Intelectual)
-  **DMI** — Desktop Management Interface.
-  **DMI(intel)** — Direct Media Interface (Interfaz de Medios Directos)
-  **UMI(amd)** — Unified Media Interface (Interfaz de Medios Unificada)
-  **DVI** — Digital Visual Interface
-  **GPGPU** — General Purpous Computing on GPU
-  **PE's** — Processing Elements
-  **API** — Application Programming Interface (Interfaz de Programación de Aplicaciones)
-  **CRT** — Tubo de Rayos Catódicos
-  **TDP** — Thermal Design Power. Indica la cantidad de W de calor, que
   puede disipar el sistema antes de alcanzar el máximo d.
-  **FMA** — Fused Multiply-Add. Mejora para el cálculo de operaciones
   con punto flotante.
-  **PASID** — Process Adress Space Identifiers, Identificadores del
   espacio de direccionamiento de proceso.
-  **EDID** — Extended Display Identification Data (Datos de Identificación de Pantalla Extendidos)
-  **JIT** — Just In Time
-  **PAE** — Phisical Address Extension
-  **FPU** — Floating Point Unit (Unidad de Punto Flotante)
-  **FLOPS** — Floating Point Operations Per Second
-  **MIPS** — Millions of instructions per second
-  **LUN** — Logical Unit Number (Número de Unidad Lógica)
-  **PMMU** — paged memory management unit
-  **RCU** — Read Copy Update `rcu <A4-Hardware/Procesador/rcu.md>`__
-  **PME power management event support**
-  **UUID** — User Unique Identifier
-  **CSR** — Cambridge Silicon Radio
-  **IPC** — InterProcess Communication
-  **SMP** — Symmetric Multiprocessing (Multiprocesamiento Simétrico)
-  **SMBUS** — o SMB, System Management Bus
-  **MCA** — Micro Channel Architecture
-  **VLB** — VESA Local Bus
-  **AER** — Advanced Error Reporting
-  **NFS** — Network File System (Sistema de Archivos en Red)
-  **GPM** — relacionado con una interfase para ratón(controlador de
   ventos). Una “especie de Clipboard”.
-  **ABRT** — Automatic Bug Reporting Tool
-  **MBR** — Master Boot Record
-  **EBR** — Extended Boot Record, logical partition precedent sector
   unalloc space
-  **ACM** — comunication device class *Abstract Control Model*
   interfase
-  **UART** —
-  **HPC** — High Performance Computing

--------------

1.1 Referencias SO
------------------

-  **SysV** — SysV init run level system ``/etc/rc.d/``
-  **Systemd** — a system and a service manager
-  **Udev** — Dynamic Device management

1.2 \ *Placas*\ 
----------------

-  **OEM** — Original Equipment Manufacture
-  **SoC** — Sistemas en Chip
-  **SCI** — System Control Interrupt
-  **ISA** — Industry Standard Architecture, también llamado I/O
   channel.
-  **ASIC** — Circuitos Integrados de Aplicación Específica
-  **PCI** — Peripheral Component Interconnect
-  **PCI-SIG** — PCI Special Interest Group
-  **BIOS** — Basic Input Output System
-  **CMOS** — Complementary metal-oxide-semiconductor (RTC and basic
   info PC config)
-  **SMBIOS** — System Management BIOS, define data structures & acces
   methods to read BIOS.
-  **Northdridge** — Comunicacion directa con CPU y PCI-Express
-  **SouthBridge** — Otras operaciones secundarias sobre PCI — (Serial
   ATA, SCSI)???
-  **ICH** — I/O Controller Hub - SouthBridge
-  **AoE** — ATA over Ethernet
-  **HID** — Human Interface Device, it take INPUTS and give
   OUTPUTS.[hardware/hid]:[hid.md]
-  **HCI** — Host Controller Interface
-  **HCD** — Host Controller Driver
-  **OHCI** — Open Host Controller Interface to talk to USB 1.1 - ver
   xHCI.md
-  **UHCI** — Universal Host Controller Interface - ver xHCI.md
-  **EHCI** — Enhanced Host Controller Interface - ver xHCI.md
-  **AHCI** — Advanced Host Controller Interface
-  **xHCI** — Extensible Host Controller Interface
   [hardware/driver][xHCI.md]
-  **OC** — OverClocking
-  **``G`` Connector** — (No se encontró una definición común para "G Connector" en este contexto. Se recomienda añadir una si es específica.)
-  **Form Factor(FF)** — Standard ATX, Micro ATX, Mini ATX, Nano ATX,
   Pico ATX
-  **AT** — Advanced Tecnology
-  **ATX** — Advanced Tecnology Extended
-  **FBS** — Front Side Bus
-  **Mother Board** — sadly called *“mobo”* thing.

--------------

2. Referencias Memorias/chips
-----------------------------

-  **ROM** — Read Only Memory
-  **PROM** — Programmable Read Only Memory
-  **EPROM** — Erasable Programmable Read Only Memory
-  **EEPROM** — Electricaly Erasable Programmable Read Only Memory
-  **FLASH** — rams de nueva generacion necesita explicar!
-  **RAM** — Random Acces Memory
-  **MCU** — Memory Controller Unit
-  **DRAM** — Dynamic Random Acces Memory
-  **DRAM** — RAM dinamica “memoria principal del sistema”
-  **SRAM** — RAM estatica (común en el procesador como memoria caché)
-  **SMRAM** —
-  **NVRAM** — Non Volatile RAM, llamada *CMOS RAM* en PCs, guarda la
   *config de la BIOS*
-  **CMOS** — tipo de memoria, usa la bateria de litio del sistema para
   guardar los datos tras offlined.
-  **SADC** — System Activity Data collector
-  **FPGA** — Field-programmable gate array(integrated circuit)
-  **IOMMU** — I/O Memory Management Unit.
-  **DMA** — Direct Memory Acces
-  **DDR** — Double Data Rate
-  **DDRx** — desambiguación// Data Direction Register
-  **GDDR5** — Double Data Rate type five Synchronous Graphics
   Random-acces Memory
-  **DDR SDRAM** — Double Data Rate Synchronous Dynamic Random-Acces
   Memory
-  **IMC** — Integrated Memory Controller
-  **MCH** — Memory Controller Hub
-  **MLC** — Multi-Level Cell
-  **NAND** —
-  **NOR**
-  **VRM** — Voltage Regulator Module
-  **PCB** — Printed Circuit Board
-  **CFI** — Common flash memory interface
-  **ECC memory** — Error-correcting code memory
-  **OOM** — Out Of Memory manager
-  **EDAC** — Error Detection And Correction
-  **DAC** — Digital Audio Converter
-  **LDPC**
-  **SDDC** — (Intel) Single Device Data Correction
-  **MLC** — Multi-Level Cell
-  **SLC** — Single-Level Cell
-  **HBC** — Human Based Computation
-  **HMC** — Hybrid Memory Cube
-  **TSV** — Through-Silicon Vias
-  **HBM2** — High Bandwidth Memory(2ª generacion).
-  **MTRR** — Memory Type Range Registers.
-  **MRPC** — Memory-maped Remote Procedure Call
-  **RSS** — Resident Set Memory Size
-  **MSB** — Most Significant Bit?
-  **LSB** — Less Significant Bit?
-  **SSP** — Synchronous Serial Protocol
-  **PSP** — Programable Serial Protocol
-  **MOSI** — Master Out Slave In
-  **MISO** — Master In Slave Out
-  **TXT** — Trusted Execution Technology (intel TXT)
-  **ISP** — in-system-programming
-  **PDI** — Program and Debug Interface
-  **AVR** — family of microcontrollers developed by Atmel.
-  **AVR** — Alf and Vegard's Risc (commonly accepted).
-  **MIPS** — Millions of Instructions Per Second
-  **PXE** — Preboot Execution Enviroment
-  **JTAG** — the Join Test Action Group
-  **MCU** —
-  **GPIO** — General Purpose input/output (port/Ver ACPI)
-  **GPIO** — pin genérico en un circuito integrado.
-  **POST** — Power-On Self-Test
-  **UDMA** — Ultra Direct Memory Acces
-  .. rubric:: **NPU** — Network Processing unnit
      :name: npu-network-processing-unnit

3. Referencias Disco Duro
-------------------------

-  **IDE** — Integrated Drive Electronic
-  **ATA** — AT Attachment
-  **ATAPI** — AT Attachment Packet Interface
-  **PATA** — Parallel ATA
-  **SATA** — Serial ATA
-  **SAS** — Serial Attached SCSI
-  **MBR** — Master Boot Record
-  **VBR** — Volume Boot Record
-  **LBA** — Logical Block Addressing
-  **CHS** — Cylinder Head Sector
-  **GPT**
-  **EFI**
-  **UEFI**
-  **HDD** — Hard Disk Drive
-  **SSD** — Solid State Drive
-  **SSHD** — Solid State Hybrid Drive

--------------

4. Referincias a Unidades de procesamiento
------------------------------------------

-  **NUMA** — Non Uniform Memory Acces (policy to alocate memory
   areas)[hardware/procesador]:[numa.md]
-  **HSA** — (AMD) Heterogeneus System Architecture
-  **CPU** — Central Process Unit, Unidad de Procesador Central.
-  **APU** — Accelerated Processing Unit, is a CPU and a GPU on a single
   die, known as *Fusion*.
-  **MPS** — Multiprocessor Specification
-  **MSR** — Model Specific Registers
-  **AMD64** — the x86_64 chipset invented by AMD
-  **LMSLE** — (CPU-AMD) Long Mode Segment Limit Enable
-  **IA64** — Intel Itanium chipseet
-  **IA32** — Intel architecture, 32-bit.
-  **8080** —
-  **LONG MODE** — 64bit OS can acces 64bit instructions
-  **REAL MODE** — or *virtual 8086 mode*, apps can’t run on LONG MODE
-  **UNREAL MODE** — intel 80286, ega video type
-  **SMM** — System Management Moode or *rin-2*, all execution is
   suspended
-  **VIA**
-  **TRANSMETA**
-  **SRAT** — tabla…

--------------

5. Referencias APM(Advanced Power Management)
---------------------------------------------

-  **APM** — Advanced Power Management [hardware/apm]:[apm.md]

--------------

6. Referencias Acpi/Acpica/Tablas-Acpi
--------------------------------------

-  **ASWG** — ACPI Specification Working Group
-  **API** — Application Programming Interface
-  **ACPI** — Advanced Control Power Interface
-  **ACPICA** — ACPI Component Architecture
-  **SLIC** — System Licensed Internal Code
-  **OSI** — Operating System Interfaces” (\_OSI)
-  **OSPM** — Operating System directed Power Management

--------------

-  **BGRT** — Tabla de recursos del arranque de gráficos.
-  **CSRT** — Tabla de recursos del núcleo del sistema.
-  **DBG2** — Tabla 2 del puerto de depuración.
-  **DSDT** — Sistema de Descripción de Tabla Diferenciado
-  **DMAR** — DMA Remapping table
-  **DRHD** — DMA Remapping Hardware Unit Definition
-  **RMRR** — Reserved memory Region Reporting Structure
-  **ZLR** — Zero length reads from PCI devices
-  **IOVA** — IO Virtual address.
-  **FACP**
-  **FACS** — Firmware ACPI Control Structure
-  **FADT** — Tabla de Descripcion fija ACPI
-  **FPDT** — Tabla para la mejora de datos del firmware.
-  **GTDT**
-  **HPET** — Hight Precision Event Timer
-  **MADT** — Tabla controlador múltiple de interrupción.
-  **MCFG**
-  **RSDP**
-  **RSDT**
-  **SSDT** — System Service Desription Table- Tabla de descripción de
   servicio de sistema
-  **XSDT**
-  **WSMT**

--------------

-  **DSL** — .dsl — extension, disassembled ASL
-  **AML** — ACPI Machine Language
-  **ASL** — ACPI Source Language
-  **ASM** —

--------------

-  **GPE** — General Purpouse Events
-  **SCI** — Sistema de control de Interrupcion

--------------

7. Referencias a Video
----------------------

-  **AGP** — Accelerated Graphics Port
-  **APU** — Accelerated Processing Unit, is a CPU and a GPU on a single
   die, known as *Fusion*.
-  **GPU** — Graphic Processing Unit
-  **ATI** — GPU vendor acquired by AMD in 2006
-  **GART** — Graphics Address Remapping table
-  **HUD** — Heads Up Display, el jad, o hud. Arriva las manos.

--------------

8. Referencias a Supuestos
--------------------------

-  **CMMA** — Collaborative Memory Management Assist
-  **Intel-VT** — Virtualization technology(by Intel)
-  **AMD-V** — Virtualization technology(by AMD side), initialy
   SVM(“Flag”, Secure Virtual Machine)

--------------

9. Referencia criptografia
--------------------------

-  **GPG** — GnuPG, GNU Privacy Guard
-  **SELinux** —
-  **TLS** —
-  **bss** — Basis Service Set. on static libs, the need to init vars
   before call it(c/c++).
-  **HMAC** — Hash-Based message authentification code.

--------------

10. Referencias Cryptomonedas
-----------------------------

-  **ETC** — Ethereum Classic
-  **ETH** — Ethereum
-  **BlockChain** — Distributed database (equiparable al commit!).
   Registro público de una transaccion de bitcoin.
-  **Block** — record in the block chain contining “confirms” and many
   “waiting transactions”
-  **DAO** — Descentralised Autonomous Organisation
-  **DAPP** — Decentralized Application
-  **Bitcoin** — The concept, the net!
-  **bitcoin** — units of account, unidad de medida.
-  **bit** — subunidad del bitcoin(BTC, XBT)
-  **hash rate** — measuring unit of the processing power of the Bitcoin
   network.
-  **Contract** — an account which contains, and is controlled by EVM
   code.
-  **EVM code** — Ethereum Virtual Machine Code. Programming language
-  **Message** — a sort of “virtual transaction” sent by EVM code
-  **Uncle** — The gender-neutral alternative to aunt/uncle
-  **Ommer** — a child of a parent, of a parent of a block that is not a
   parent. Child of an ancestor.
-  **Censorship Fault** — a validator failing to accept valid messages
   from other validators.
-  **PoW** — Proof of Work
-  **DAG** — Direct Acyclic Graph

--------------

11. Referencias/enlaces
-----------------------

11.1.1 Nucleo/Repositorios
^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   - __HTTPS__

`UML <http://user-mode-linux.sourceforge.net>`__

::

   - __FTP__

| `UML-ftp <ftp://ftp.ca.kernel.org/pub/kernel/v2.4/linux-2.4.0-prerelease.tar.bz2>`__
| `Project-builder <ftp://ftp.project-builder.org/>`__
| `pivot_root <ftp://ftp.kernel.org/pub/linux/utils/utils-linux>`__
| ### 11.1.2 Documentacion - HTTPS
  `IOMMU <http://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/vt-directed-io-spec.pdf>`__
| `RCU <http://www.rdrop.com/users/paulmck/RCU/>`__
| `RCU/Linux-kernel <http://www.rdrop.com/users/paulmck/RCU/linuxusage/rculocktab.html>`__
| `GPMC <http://www.ti.com/lit/pdf/spruh73>`__
| `DDR2 SDRAM <en.wikipedia.org/wiki/DDR2_SDRAM>`__
| `fedoraCustomKernel <https://fedoraproject.org/wiki/Building_a_custom_kernel>`__
  muy buena!!!
| `Acpi-in-Linux <https://www.kernel.org/doc/ols/2005/ols2005v1-pages-59-76.pdf>`__
| `CodeGuro <https://www.codeguru.com/>`__ buena pero no funciona la
  busqueda!! SMBIOS Demystified

| `asistenteDelControlador-intel <http://www.intel.la/content/www/xl/es/support/detect.html?iid=dc_iduu>`__
| `cpu-E7300 <http://ark.intel.com/es-es/products/36463/Intel-Core2-Duo-Processor-E7300-3M-Cache-2_66-GHz-1066-MHz-FSB#@downloads>`__

11.2 Patentes
~~~~~~~~~~~~~

`RCU-patente <http://liburcu.org/>`__

-  **fwupdmgr** — Firmware update manager
