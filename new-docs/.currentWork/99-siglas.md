## Indice

1. [Referencias Generales](#i1)  
	  1.1 [Referencias SO](#i1i1)  
	  1.2 [_Placas_](#i1i2)  
2. [Referencias a memorias](#i2)
3. [Referencias a Disco Duro](#i3)
4. [Referincias a Unidades de procesamiento](#i4)
5. [APM(Advanced Power Management)](#i5)
6. [Referencias Acpi/Acpica/Tablas-Acpi](#i6)
7. [Referencias a Video](#i7)
8. [Referencias a Supuestos](#i8)
9. [Referencias a criptografia](#i9)
10. [Referencias Cryptomonedas](#i10)
11. [Referencias/enlaces](#i11)  
11.1 [Núcleo](#i11i1)  
11.1.1 [Repositorios](#i11i1i1)  
 			  11.1.1.1 HTTP  
		 	  11.1.1.2 FTP  
11.1.2 [Documentacion](#i11i1i2)  
       11.1.2.1 HTTP  
		 	 11.1.2.2 FTP  
11.2 [Patentes](#i11i2)  

<a name=""></a>
---
## 1. <a name="i1">Referencias Generales</a>

#### OS --- Operating system
#### OSL ---  OS Service Layer
#### ABI --
#### HDL -- Hardware Description Language
#### HPET -- High Precision Event Timer
#### APIC --  Advanced Programmable Interrupt Controller
#### LAPIC -- Local component, integrado en el procesador
#### SMI
#### PCMCIA -- Personal Computer Memory Card International Association
#### SPI -- Serial Peripheral Interface -- Interfase de periféricos en serie.
#### PIC -- Programmable Interrupt Controller
#### DSP -- Procesadores Digitales de Señal
#### FPGA -- Matrices de puertas reconfigurables
#### DPMI -- DOS Protected Mode Interface
#### PCB -- Process Control Block - define el estado actual del sistema operativo.
#### IP -- Intellectual Property(desambiguación).
#### DMI -- Desktop Management Interface.
#### DMI(intel) -- Direct Media Interface(desambiguación)
#### UMI(amd)
#### DVI -- Digital Visual Interface
#### GPGPU -- General Purpous Computing on GPU
#### PE's -- Processing Elements
#### API -- Application Programming Interface
#### CRT -- Tubo de Rayos Catódicos
#### TDP -- Thermal Design Power. Indica la cantidad de W de calor, que puede disipar el sistema antes de alcanzar el máximo d.
#### FMA -- Fused Multiply-Add. Mejora para el cálculo de operaciones con punto flotante.
#### PASID -- Process Adress Space Identifiers, Identificadores del espacio de direccionamiento de proceso.
#### EDID -- 
#### JIT -- Just In Time
#### PAE -- Phisical Address Extension
#### FPU -- (Floating Poinmt Unit)??
#### FLOPS -- Floatin Point per second
#### MIPS -- Millions of instructions per second
#### LUN --
#### PMMU -- paged memory management unit
#### RCU -- Read Copy Update [rcu](A4-Hardware/Procesador/rcu.md)
#### PME power management event support
#### UUID -- User Unique Identifier
#### CSR -- Cambridge Silicon Radio
#### IPC -- InterProcess Communication
#### SMP -- Symmetric multiprocessing
#### SMBUS -- o SMB, System Management Bus
#### MCA -- Micro Channel Architecture
#### VLB -- VESA Local Bus
#### AER -- Advanced Error Reporting
#### NFS
#### GPM -- relacionado con una interfase para ratón(controlador de ventos). Una "especie de Clipboard".
#### ABRT -- Automatic Bug Reporting Tool
#### MBR -- Master Boot Record
#### EBR -- Extended Boot Record, logical partition precedent sector unalloc space
#### ACM -- comunication device class _Abstract Control Model_ interfase
#### UART --
#### HPC -- High Performance Computing
---


## 1.1 <a name="i1i1">Referencias SO</a>

#### SysV --  SysV init run level system `/etc/rc.d/` 
#### Systemd -- a system and a service manager
#### Udev -- Dynamic Device management


## 1.2 <a name="i1i2">_Placas_</a>

#### OEM  -- Original Equipment Manufacture
#### SoC -- Sistemas en Chip
#### SCI --- System Control Interrupt
#### ISA -- Industry Standard Architecture, también llamado I/O channel.
#### ASIC -- Circuitos Integrados de Aplicación Específica
#### PCI -- Peripheral Component Interconnect
#### PCI-SIG -- PCI Special Interest Group
#### BIOS -- Basic Input Output System
#### CMOS -- Complementary metal-oxide-semiconductor (RTC and basic info PC config)
#### SMBIOS -- System Management BIOS, define data structures & acces methods to read BIOS.
#### Northdridge -- Comunicacion directa con CPU y PCI-Express
#### SouthBridge -- Otras operaciones secundarias sobre PCI -- (Serial ATA, SCSI)???
#### ICH -- Input/Output Controller Hub - SouthBridge
#### AoE -- ATA over Ethernet
#### HID -- Human Interface Device, it take INPUTS and give OUTPUTS.[hardware/hid]:[hid.md]
#### HCI -- Host Controller Interface
#### HCD -- Host Controller Driver
#### OHCI -- Open Host Controller Interface to talk to USB 1.1 - ver xHCI.md
#### UHCI -- Universal Host Controller Interface - ver xHCI.md
#### EHCI -- Enhanced Host Controller Interface - ver xHCI.md
#### AHCI -- Advanced Host Controller Interface
#### xHCI -- Extensible Host Controller Interface [hardware/driver][xHCI.md]
#### OC -- OverClocking
#### `G` Connector --
#### Form Factor(FF) -- Standard ATX, Micro ATX, Mini ATX, Nano ATX, Pico ATX
#### AT	-- Advanced Tecnology
#### ATX -- Advanced Tecnology Extended
#### FBS -- Front Side Bus
#### Mother Board -- sadly called _"mobo"_ thing.
---


## 2. <a name="i2">Referencias Memorias/chips</a>

#### ROM -- Read Only Memory
#### PROM -- Programmable Read Only Memory
#### EPROM --Erasable Programmable Read Only Memory
#### EEPROM -- Electricaly Erasable Programmable Read Only Memory
#### FLASH -- rams de nueva generacion necesita explicar!
#### RAM -- Random Acces Memory
#### MCU -- Memory Controller Unit
#### DRAM -- Dynamic Random Acces Memory
#### DRAM -- RAM dinamica "memoria principal del sistema"
#### SRAM -- RAM estatica (común en el procesador como memoria caché)
#### SMRAM --
#### NVRAM -- Non Volatile RAM, llamada _CMOS RAM_ en PCs, guarda la _config de la BIOS_
#### CMOS-- tipo de memoria, usa la bateria de litio del sistema para guardar los datos tras offlined.
#### SADC -- System Activity Data collector
#### FPGA -- Field-programmable gate array(integrated circuit)
#### IOMMU -- I/O Memory Management Unit. 
#### DMA -- Direct Memory Acces
#### DDR -- Double Data Rate
#### DDRx -- desambiguación// Data Direction Register
#### GDDR5 -- Double Data Rate type five Synchronous Graphics Random-acces Memory
#### DDR SDRAM -- Double Data Rate Synchronous Dynamic Random-Acces Memory
#### IMC -- Integrated Memory Controller
#### MCH -- Memory Controller Hub
#### MLC -- Multi-Level Cell
#### NAND --
#### NOR
#### VRM -- Voltage Regulator Module
#### PCB -- Printed Circuit Board
#### CFI -- Common flash memory interface
#### ECC memory -- Error-correcting code memory
#### OOM -- Out Of Memory manager
#### EDAC -- Error Detection And Correction 
#### DAC -- Digital Audio Converter
#### LDPC
#### SDDC --(Intel) Single Device Data Correction
#### MLC -- Multi-Level Cell
#### SLC -- Single-Level Cell
#### HBC -- Human Based Computation
#### HMC -- Hybrid Memory Cube
#### TSV -- Through-Silicon Vias
#### HBM2 -- High Bandwidth Memory(2ª generacion).
#### MTRR -- Memory Type Range Registers.
#### MRPC -- Memory-maped Remote Procedure Call
#### RSS -- Resident Set Memory Size
#### MSB -- Most Significant Bit?
#### LSB -- Less Significant Bit?
#### SSP -- Synchronous Serial Protocol
#### PSP -- Programable Serial Protocol
#### MOSI -- Master Out Slave In
#### MISO -- Master In Slave Out
#### TXT -- Trusted Execution Technology (intel TXT)
#### ISP -- in-system-programming
#### PDI -- Program and Debug Interface
#### AVR -- family of microcontrollers developed by Atmel.
#### AVR -- Alf and Vegard's Risc (commonly accepted).
#### MIPS -- Millions of Instructions Per Second
#### PXE -- Preboot Execution Enviroment
#### JTAG -- the Join Test Action Group
#### MCU --
#### GPIO -- General Purpose input/output (port/Ver ACPI) 
#### GPIO	   pin genérico en un circuito integrado.
#### POST -- Power-On Self-Test
#### UDMA -- Ultra Direct Memory Acces
#### NPU -- Network Processing unnit
---

## 3. <a name="i3">Referencias Disco Duro</a>

#### IDE -- Integrated Drive Electronic
#### ATA -- AT Attachment
#### ATAPI -- AT Attachment Packet Interface
#### PATA -- Parallel ATA
#### SATA -- Serial ATA
#### SAS -- Serial Attached SCSI
#### MBR -- Master Boot Record
#### VBR -- Volume Boot Record
#### LBA -- Logical Block Addressing
#### CHS -- Cylinder Head Sector
#### GPT
#### EFI
#### UEFI
#### HDD -- Hard Disk Drive
#### SSD -- Solid State Drive
#### SSHD -- Solid State Hybrid Drive
---


## 4. <a name="i4">Referincias a Unidades de procesamiento</a>

#### NUMA -- Non Uniform Memory Acces (policy to alocate memory areas)[hardware/procesador]:[numa.md]
#### HSA --(AMD) Heterogeneus System Architecture
#### CPU -- Central Process Unit, Unidad de Procesador Central.
#### APU -- Accelerated Processing Unit, is a CPU and a GPU on a single die, known as _Fusion_.
#### MPS -- Multiprocessor Specification
#### MSR -- Model Specific Registers
#### AMD64 -- the x86_64 chipset invented by AMD
#### LMSLE -- (CPU-AMD) Long Mode Segment Limit Enable
#### IA64 -- Intel Itanium chipseet
#### IA32 -- Intel architecture, 32-bit.
#### 8080 -- 
#### LONG MODE -- 64bit OS can acces 64bit instructions
#### REAL MODE -- or _virtual 8086 mode_, apps can't run on LONG MODE
#### UNREAL MODE -- intel 80286, ega video type
#### SMM -- System Management Moode or _rin-2_, all execution is suspended
#### VIA 
#### TRANSMETA
#### SRAT -- tabla...
---

## 5. <a name="i5">Referencias APM(Advanced Power Management)</a>

#### APM -- Advanced Power Management [hardware/apm]:[apm.md]
---

## 6. <a name="i6">Referencias Acpi/Acpica/Tablas-Acpi</a>

#### ASWG -- ACPI Specification Working Group
#### API -- Application Programming Interface
#### ACPI -- Advanced Control Power Interface
#### ACPICA --ACPI Component Architecture
#### SLIC -- System Licensed Internal Code
#### OSI -- Operating System Interfaces" (_OSI)
#### OSPM --- Operating System directed Power Management
  ---------------
#### BGRT -- Tabla de recursos del arranque de gráficos.

#### CSRT -- Tabla de recursos del núcleo del sistema.

#### DBG2 -- Tabla 2 del puerto de depuración.

#### DSDT --- Sistema de Descripción de Tabla Diferenciado
#### DMAR -- DMA Remapping table 
#### DRHD -- DMA Remapping Hardware Unit Definition
#### RMRR -- Reserved memory Region Reporting Structure
#### ZLR  -- Zero length reads from PCI devices
#### IOVA -- IO Virtual address.

#### FACP
#### FACS -- Firmware ACPI Control Structure
#### FADT -- Tabla de Descripcion fija ACPI
#### FPDT -- Tabla para la mejora de datos del firmware.

#### GTDT

#### HPET -- Hight Precision Event Timer

#### MADT -- Tabla controlador múltiple de interrupción.
#### MCFG

#### RSDP
#### RSDT

#### SSDT -- System Service Desription Table- Tabla de descripción de servicio de sistema

#### XSDT

#### WSMT
  ---------------
#### DSL  --- .dsl -- extension, disassembled ASL
#### AML -- ACPI Machine Language
#### ASL -- ACPI Source Language
#### ASM --
  ---------------
#### GPE --- General Purpouse Events
#### SCI -- Sistema de control de Interrupcion
---

---
## 7. <a name="i7">Referencias a Video</a>

#### AGP -- Accelerated Graphics Port
#### APU -- Accelerated Processing Unit, is a CPU and a GPU on a single die, known as _Fusion_.
#### GPU -- Graphic Processing Unit
#### ATI -- GPU vendor acquired by AMD in 2006
#### GART -- Graphics Address Remapping   table
#### HUD -- Heads Up Display, el jad, o hud. Arriva las manos.
---

## 8. <a name="i8">Referencias a Supuestos</a>

#### CMMA -- Collaborative Memory Management Assist
#### Intel-VT -- Virtualization technology(by Intel)
#### AMD-V -- Virtualization technology(by AMD side), initialy SVM("Flag", Secure Virtual Machine)
---

## 9. <a name="i9">Referencia criptografia</a>

#### GPG -- GnuPG, GNU Privacy Guard
#### SELinux --
#### TLS --
#### bss -- Basis Service Set. on static libs, the need to init vars before call it(c/c++).
#### HMAC -- Hash-Based message authentification code.
---


## 10. <a name="i10">Referencias Cryptomonedas</a>

#### ETC -- Ethereum Classic
#### ETH -- Ethereum
#### BlockChain -- Distributed database (equiparable al commit!). Registro público de una
     transaccion de bitcoin.
#### Block -- record in the block chain contining "confirms" and many "waiting transactions"
#### DAO -- Descentralised Autonomous Organisation
#### DAPP -- Decentralized Application
#### Bitcoin -- The concept, the net!
#### bitcoin -- units of account, unidad de medida.
#### bit -- subunidad del bitcoin(BTC, XBT)
#### hash rate -- measuring unit of the processing power of the Bitcoin network.
#### Contract -- an account which contains, and is controlled by EVM code.
#### EVM code -- Ethereum Virtual Machine Code. Programming language 
#### Message -- a sort of "virtual transaction" sent by EVM code
#### Uncle -- The gender-neutral alternative to aunt/uncle
#### Ommer -- a child of a parent, of a parent of a block that is not a parent. Child of an ancestor.
#### Censorship Fault -- a validator failing to accept valid messages from other validators.
#### PoW -- Proof of Work
#### DAG -- Direct Acyclic Graph
---

## 11. <a name="i11">Referencias/enlaces</a>

#### 11.1.1 Nucleo/Repositorios
	- __HTTPS__
[UML](http://user-mode-linux.sourceforge.net)  

	- __FTP__
[UML-ftp](ftp://ftp.ca.kernel.org/pub/kernel/v2.4/linux-2.4.0-prerelease.tar.bz2)  
[Project-builder](ftp://ftp.project-builder.org/)  
[pivot_root](ftp://ftp.kernel.org/pub/linux/utils/utils-linux)  
### 11.1.2 Documentacion
	- HTTPS
[IOMMU](http://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/vt-directed-io-spec.pdf)  
[RCU](http://www.rdrop.com/users/paulmck/RCU/)  
[RCU/Linux-kernel](http://www.rdrop.com/users/paulmck/RCU/linuxusage/rculocktab.html)  
[GPMC](http://www.ti.com/lit/pdf/spruh73)  
[DDR2 SDRAM](en.wikipedia.org/wiki/DDR2_SDRAM)  
[fedoraCustomKernel](https://fedoraproject.org/wiki/Building_a_custom_kernel) muy buena!!!  
[Acpi-in-Linux](https://www.kernel.org/doc/ols/2005/ols2005v1-pages-59-76.pdf)  
[CodeGuro](https://www.codeguru.com/) buena pero no funciona la busqueda!! SMBIOS Demystified  

[asistenteDelControlador-intel](http://www.intel.la/content/www/xl/es/support/detect.html?iid=dc_iduu)  
[cpu-E7300](http://ark.intel.com/es-es/products/36463/Intel-Core2-Duo-Processor-E7300-3M-Cache-2_66-GHz-1066-MHz-FSB#@downloads)  

### 11.2 Patentes
[RCU-patente](http://liburcu.org/)  


--- a more comprehensive tool device --fwupdmgr  




