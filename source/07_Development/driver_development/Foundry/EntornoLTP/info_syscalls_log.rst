==================
IDcheck script log
==================

Checking for required user/group ids

* **'root'** user id and group found.
* **'nobody'** user id and group found.
* **'bin'** user id and group found.
* **'daemon'** user id and group found.
* Users group found.
* Sys group found.
* Required users/groups exist.
* If some fields are empty or look unusual you may have an old version.
* Compare to the current minimal requirements in Documentation/Changes.
* ``/etc/os-release``
* ``/etc/redhat-release``
* ``/etc/rocky-release``
* ``/etc/system-release``
* **NAME** ="Rocky Linux".
* **VERSION** ="10.1 (Red Quartz)".
* **ID** ="rocky".
* **ID_LIKE** ="rhel centos fedora".
* **VERSION_ID** ="10.1".
* **PLATFORM_ID** ="platform:el10".
* **PRETTY_NAME** ="Rocky Linux 10.1 (Red Quartz)".
* **ANSI_COLOR** ="0;32".
* **LOGO** ="fedora-logo-icon".
* **CPE_NAME** ="cpe:/o:rocky:rocky:10::baseos".
* **HOME_URL** ="https://rockylinux.org/".
* **VENDOR_NAME** ="RESF".
* **VENDOR_URL** ="https://resf.org/".
* **BUG_REPORT_URL** ="https://bugs.rockylinux.org/".
* **SUPPORT_END** ="2035-05-31".
* **ROCKY_SUPPORT_PRODUCT** ="Rocky-Linux-10".
* **ROCKY_SUPPORT_PRODUCT_VERSION** ="10.1".
* **REDHAT_SUPPORT_PRODUCT** ="Rocky Linux".
* **REDHAT_SUPPORT_PRODUCT_VERSION** ="10.1".
* *Rocky Linux release 10.1 (Red Quartz)*.

* **uname:** Linux buildlab.raulvilchez.org 6.12.0-124.8.1.el10_1.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Nov 11 22:54:28 UTC 2025 x86_64 GNU/Linux

* ``/proc/cmdline``

**BOOT_IMAGE** =(hd0,gpt2)/vmlinuz-6.12.0-124.8.1.el10_1.x86_64 **root=UUID** =f9e06a5b-396a-4ba1-9861-62087e95aed2 ro crashkernel=2G-64G:256M,64G-:512M **resume=UUID** =452eef98-774f-43af-9351-d9eef341f41d console=ttyS0,115200n8

.. code-block:: bash

   Gnu C                  gcc (GCC) 14.3.1 20250617 (Red Hat 14.3.1-2)
   Clang                 
   Gnu make               4.4.1
   util-linux             2.40.2
   mount                  util-linux 2.40.2 (libmount 2.40.2: selinux, btrfs, namespaces, idmapping, fd-based-mount, statx, assert, debug)
   modutils               31
   e2fsprogs              1.47.1
   vfat                   4.2
   xfs                    6.11.0
   Linux C Library        GNU C Library (GNU libc) stable release version 2.39.
   Dynamic linker (ldd)   2.39
   Procps                 4.0.4
   iproute2               1.6.0
   iputils                20240905
   ethtool                6.15
   Sh-utils               9.5



1. Virtualización e Infraestructura de Hypervisor.
==================================================
Análisis de usuario, de los módulos cargados en el kernel

* **Módulos de Entrada/Salida Paravirtualizada (Drivers VirtIO)**:

   - virtio_blk: Controlador de almacenamiento paravirtualizado. Es el encargado de gestionar los discos virtuales asignados a la VM (como /dev/vda o /dev/vdc que aparecen en tu log). Es fundamental para el rendimiento de I/O en la VM.
   - virtio_net: Controlador de red paravirtualizado. Gestiona la interfaz de red virtual de alta velocidad.
   - net_failover/failover: Soporte para cambio transparente de interfaz (failover) cuando se usa aceleración en red o asignación directa de dispositivos (passthrough/SR-IOV) junto a una interfaz virtio_net.
   - virtio_console: Gestiona la consola serie virtualizada (/dev/hvc0 o puertos virtio-console). Permite la interacción por consola SSH/LXC sin necesidad de emular una UART física.
   - virtio_balloon: Controlador de administración dinámica de memoria (ballooning). Permite al hipervisor reclamar memoria RAM de la VM si no la está usando, o inyectarle más según las necesidades del host.
   

* **Comunicación VM-Host e Inter-Procesos (VSOCK)**:

   - vsock: Núcleo de la familia de sockets AF_VSOCK, pensada para comunicación rápida inter-proceso entre el host y las VMs sin depender de la pila de red TCP/IP tradicional.
   - vmw_vsock_virtio_transport_common: Implementación del transporte para VSOCK sobre la infraestructura de VirtIO.
   - vsock_loopback: Permite probar o utilizar comunicaciones de transporte VSOCK de manera local dentro de la propia VM.
   - vmw_vsock_vmci_transport/vmw_vmci: Controladores de infraestructura VMware (VMCI). Aunque el hipervisor subyacente es KVM, los kernels modernos los cargan por defecto por detección automática de compatibilidad.

* **Anidamiento de Virtualización y Passthrough (KVM)**

   - kvm/kvm_amd: Módulos que habilitan la virtualización acelerada por hardware. Al estar dentro de la VM, su presencia indica que la VM tiene activado Virtualización Anidada (Nested Virtualization) para procesadores AMD (en tu caso, un AMD Ryzen 5 5600). Esto permite lanzar contenedores o VMs ligeras dentro del propio entorno de pruebas.
   - ccp: Controlador para el procesador criptográfico de AMD (AMD Secure Processor / Crypto Co-processor), necesario para funciones avanzadas de seguridad o SEV (Secure Encrypted Virtualization) si el host las expone.
   - irqbypass: Módulo del kernel que optimiza el reenvío de interrupciones de hardware directamente al invitado cuando se asignan dispositivos passthrough, reduciendo la latencia de CPU.

.. admonition:: Conclusión técnica:
   
   Este grupo muestra una VM perfectamente optimizada para desarrollo y pruebas (I/O mediante KVM/VirtIO puro) y habilitada para ejecutar pruebas de LTP que requieran crear sub-entornos virtualizados gracias al soporte de virtualización anidada AMD.
   

2. Red, Firewalling y Filtrado (nftables / conntrack)
=====================================================

* **Subsistema nftables (Filtrado de Red de Nueva Generación)**

- nf_tables: El motor principal del subsistema nftables en el kernel de Linux. Reemplaza al antiguo marco de trabajo iptables, ofreciendo una ejecución de reglas mucho más eficiente basada en una máquina virtual en espacio de kernel.
- nft_chain_nat/nf_nat: Proporcionan soporte para la traducción de direcciones de red (NAT). Permiten realizar SNAT (masquerading) y DNAT (reenvío de puertos), fundamentales si la VM actúa como gateway o si corre contenedores (Docker/Podman).
- nft_fib/nft_fib_inet/nft_fib_ipv4/nft_fib_ipv6: Implementan la consulta a la base de información de reenvío (FIB / tabla de rutas) directamente desde el firewall. Permiten tomar decisiones de filtrado basadas en si un paquete proviene de una ruta válida (por ejemplo, para protección contra spoofing o comprobaciones de RPF).
- nft_reject/nft_reject_inet/nf_reject_ipv4/nf_reject_ipv6: Permiten responder a paquetes bloqueados con rechazos explícitos (enviando paquetes TCP RST o mensajes ICMP Destination Unreachable), en lugar de simplemente ignorarlos (drop).

* **Seguimiento de Conexiones y Defragmentación (netfilter)**

- nf_conntrack: Motor de seguimiento de estados de red (Connection Tracking). Mantiene el registro de todas las conexiones activas (TCP, UDP, ICMP) y sus estados (ESTABLISHED, RELATED, NEW), indispensable para firewalls con estado (stateful).
- nf_defrag_ipv4/nf_defrag_ipv6: Reensamblan fragmentos de paquetes IP antes de pasarlos por el motor de seguimiento de conexiones nf_conntrack. Garantizan que las inspecciones de firewall se realicen sobre el paquete completo.
- nfnetlink: Interfaz de comunicación entre el espacio de usuario (herramientas como nft o firewalld) y el espacio de kernel a través de sockets Netlink.
- nft_ct: Proporciona la interfaz entre el motor de seguimiento de estados del kernel (nf_conntrack) e las instrucciones/reglas de nftables. Gracias a este módulo, puedes escribir reglas en nft que tomen decisiones basadas en el estado de una conexión,


.. admonition:: Conclusión técnica:
   
   La presencia de este bloque refleja el stack estándar de firewalld en entornos RHEL/Rocky Linux 10. Para un laboratorio de pruebas LTP, contar con nftables y nf_conntrack activos es crucial para validar syscalls de red, Sockets Netlink y el comportamiento de las herramientas de filtrado bajo estrés.   

3. Sistemas de Archivos y Almacenamiento (XFS, VFAT, Device Mapper)
===================================================================

* **Sistemas de Archivos Nativos y Secundarios**

- xfs: Sistema de archivos principal y de alto rendimiento por defecto en la familia RHEL/Rocky Linux. En el entorno de laboratorio(buildlab), gestiona las particiones raíz (/), el directorio /boot y el volumen de salida de compilación (/mnt/build-output).
- fat/vfat: Soporte para el sistema de archivos FAT (FAT16/FAT32). Es esencial para que el kernel interactúe con la partición del sistema EFI (/boot/efi), garantizando el arranque en arquitecturas UEFI.

* **Subsistema de Bloques y Device Mapper**

- dm_mod: El módulo central del Device Mapper en el kernel. Proporciona el marco básico para la creación de dispositivos de bloques virtuales (como LVM, cifrado LUKS o volúmenes RAID).
- dm_mirror/dm_region_hash/dm_log: Módulos que proporcionan las capacidades de replicación y espejado (mirroring) sobre Device Mapper, permitiendo gestionar volúmenes lógicos redundantes o mantener registros de cambios en regiones de disco.
- loop: Controlador para el dispositivo loopback de almacenamiento (/dev/loop*). Permite montar archivos de imagen como si fuesen dispositivos de bloques independientes.

* **Controladores de Almacenamiento y Capa ATA**

- ahci/libahci/libata: Controladores para la interfaz Advanced Host Controller Interface (SATA). Aunque el almacenamiento principal del laboratorio va por virtio_blk, estos módulos permiten al kernel gestionar unidades de disco o unidades de CD-ROM virtuales bajo emulación SATA/IDE en QEMU.

.. admonition:: Conclusión técnica:

   Este bloque combina la máxima velocidad I/O que aporta xfs sobre VirtIO con la flexibilidad de dm_mod y loop. Esta combinación es crítica en un entorno de pruebas LTP, ya que los test de stress de almacenamiento y sistemas de archivos suelen crear dispositivos loopback y volúmenes dinámicos para verificar llamadas al sistema tipo mount, unmount, statfs o reescalado de volúmenes.  


4. Dispositivos y Emulación de Hardware en QEMU/KVM.
====================================================

* **Dispositivos del Sistema y Temporizadores**

- iTCO_wdt/iTCO_vendor_support: Controlador para el temporizador perro guardián (Watchdog Timer) del chipset Intel TCO. Permite que el sistema se reinicie automáticamente si detecta un bloqueo a nivel de kernel o espacio de usuario.
- lpc_ich: Proporciona soporte para la interfaz de bus LPC (Low Pin Count) en chipsets Intel emulados, gestionando la comunicación con dispositivos heredados como temporizadores RTC o chips super I/O.
- i2c_i801/i2c_smbus: Controladores para el bus de comunicaciones I2C / System Management Bus (SMBus). En la VM permite la lectura e inspección de métricas internas de hardware emulado.

* **Gráficos, Consola y Entrada/Salida**

- bochs: Controlador de pantalla para el adaptador gráfico estándar de Bochs/QEMU (Bchs DRM driver). Proporciona la consola gráfica frame-buffer (útil si se accede mediante consola VNC/SPICE).
- serio_raw: Proporciona acceso directo en modo raw a los puertos serie/teclado de la arquitectura PS/2.
- pcspkr: Controlador para el altavoz interno (PC speaker).
- joydev: Interfaz para dispositivos de juego (joysticks o mandos), cargada por el escaneo de dispositivos de entrada estándar.

* **Gestión Térmica y de Energía**

- intel_rapl_msr/intel_rapl_common: Framework RAPL (Running Average Power Limit) para monitorizar y limitar el consumo energético del procesador. Se expone a la VM si el hipervisor permite acceso a los registros MSR específicos.
- rfkill: 

.. admonition:: Conclusión técnica:
   
   Aunque muchos de estos controladores corresponden a subsistemas emulados por el hipervisor QEMU, su carga es vital para que el kernel gestione correctamente los temporizadores del sistema, las interrupciones avanzadas y la consola básica. Para LTP, estos módulos son necesarios para validar llamadas al sistema relacionadas con tiempo, watchdogs y manejo de eventos de entrada/salida.
   
5. Aceleración Criptográfica y Optimización en CPU.
===================================================

* Comprobación de Redundancia Cíclica (CRC) por Hardware

- crc32c_intel: Utiliza las instrucciones SSE4.2 del procesador para calcular sumas de verificación CRC32C a gran velocidad. Es un módulo crítico para el sistema de archivos XFS y la pila de red, ya que valida la integridad de los metadatos de disco y paquetes de datos en tiempo real con un consumo de CPU mínimo.
- crc32_pclmul: Emplea la instrucción PCLMULQDQ (Carry-Less Multiplication) de x86_64 para acelerar los cálculos de algoritmos CRC32 estándar.
- crct10dif_pclmul: Acelera mediante PCLMULQDQ la comprobación de integridad T10 Data Integrity Field (DIF), utilizada habitualmente en subsistemas de almacenamiento para detectar corrupción silenciosa de datos.

* Comprobación de Redundancia Cíclica (CRC) por Hardware

- ghash_clmulni_intel: Implementa la función de hash GHASH acelerada por hardware (usando PCLMULQDQ). GHASH es el bloque fundamental utilizado en el modo de cifrado AES-GCM (Galois/Counter Mode), imprescindible para túneles IPsec, conexiones TLS/SSH rápidas y cifrado de disco eficiente.

.. admonition:: Conclusión técnica:
   
   Este bloque garantiza que todas las operaciones de I/O sobre XFS y las conexiones seguras (como la propia sesión SSH o la sincronización Git con los remotos) tengan el menor overhead posible. En las pruebas de LTP, estos módulos aseguran que los test de stress de almacenamiento y red evalúen el rendimiento real del kernel y no cuellos de botella por cómputo de sumas de verificación por software.  
   
6: Servicios de Red del Kernel y Capas de Abstracción (NFS, FUSE)
=================================================================

Modules Loaded 

* **Infraestructura de Red y Almacenamiento Compartido (NFS / RPC)**

- sunrpc: Capa fundamental que implementa el protocolo RPC (Remote Procedure Call) de Sun para el kernel de Linux. Es el motor de transporte sobre el que se apoyan servicios como NFS (Network File System).
- auth_rpcgss: Proporciona el marco de seguridad GSS-API (Generic Security Services Application Programming Interface) para RPC. Permite añadir autenticación fuerte y cifrado (por ejemplo, mediante Kerberos) a las conexiones de archivos compartidos por red.

* **Sistemas de Archivos en Espacio de Usuario**

- fuse: Módulo que habilita la interfaz FUSE (Filesystem in Userspace). Permite crear e implementar sistemas de archivos completos ejecutando el código en espacio de usuario en lugar de compilarlo directamente en el kernel (muy utilizado por herramientas de contenedores, SSHFS, compresión al vuelo o montajes virtuales).

.. admonition:: Conclusión técnica:

   Este bloque proporciona las abstracciones necesarias para integrar el laboratorio con almacenamiento remoto cifrado/autenticado (NFS/Kerberos) y para ejecutar herramientas de desarrollo modernas que dependen de FUSE. En el contexto de LTP, la presencia de fuse y sunrpc habilita la ejecución de la suite de pruebas específica para llamadas al sistema de archivos virtuales y protocolos de red RPC.

-----

*Llista completa, tal como la muestra "IDcheck.sh"*

.. code-block:: bash

   Modules Loaded         rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables vfat fat intel_rapl_msr intel_rapl_common kvm_amd ccp kvm iTCO_wdt iTCO_vendor_support i2c_i801 irqbypass pcspkr bochs i2c_smbus virtio_balloon lpc_ich joydev auth_rpcgss sunrpc fuse loop nfnetlink vsock_loopback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock vmw_vmci xfs ahci libahci crct10dif_pclmul crc32_pclmul libata crc32c_intel virtio_net ghash_clmulni_intel net_failover virtio_blk failover virtio_console serio_raw dm_mirror dm_region_hash dm_log dm_mod



* **cpuinfo:**
* **Architecture:**                            x86_64
* **CPU op-mode(s):**                          32-bit, 64-bit
* **Address sizes:**                           48 bits physical, 48 bits virtual
* **Byte Order:**                              Little Endian
* **CPU(s):**                                  4
* **On-line CPU(s) list:**                     0-3
* **Vendor ID:**                               AuthenticAMD
* **Model name:**                              AMD Ryzen 5 5600 6-Core Processor
* **CPU family:**                              25
* **Model:**                                   33
* **Thread(s) per core:**                      2
* **Core(s) per socket:**                      2
* **Socket(s):**                               1
* **Stepping:**                                2
* **BogoMIPS:**                                6986.87
* **Flags:**                                   ``fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm rep_good nopl xtopology cpuid extd_apicid tsc_known_freq pni pclmulqdq ssse3 fma cx16 sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm cmp_legacy svm cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw topoext perfctr_core ssbd ibrs ibpb stibp vmmcall fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves clzero xsaveerptr wbnoinvd arat npt lbrv nrip_save tsc_scale vmcb_clean flushbyasid pausefilter pfthreshold v_vmsave_vmload vgif umip pku ospke vaes vpclmulqdq rdpid overflow_recov succor fsrm arch_capabilities``
* **Virtualization:**                          AMD-V
* **Hypervisor vendor:**                       KVM
* **Virtualization type:**                     full
* **L1d cache:**                               64 KiB (2 instances)
* **L1i cache:**                               64 KiB (2 instances)
* **L2 cache:**                                1 MiB (2 instances)
* **L3 cache:**                                32 MiB (1 instance)
* **NUMA node(s):**                            1
* **NUMA node0 CPU(s):**                       0-3
* **Vulnerability Gather data sampling:**      Not affected
* **Vulnerability Indirect target selection:** Not affected
* **Vulnerability Itlb multihit:**             Not affected
* **Vulnerability L1tf:**                      Not affected
* **Vulnerability Mds:**                       Not affected
* **Vulnerability Meltdown:**                  Not affected
* **Vulnerability Mmio stale data:**           Not affected
* **Vulnerability Reg file data sampling:**    Not affected
* **Vulnerability Retbleed:**                  Not affected
* **Vulnerability Spec rstack overflow:**      Mitigation; Safe RET
* **Vulnerability Spec store bypass:**         Mitigation; Speculative Store Bypass disabled via prctl
* **Vulnerability Spectre v1:**                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
* **Vulnerability Spectre v2:**                Mitigation; Retpolines; IBPB conditional; IBRS_FW; STIBP always-on; RSB filling; PBRSB-eIBRS Not affected; BHI Not affected
* **Vulnerability Srbds:**                     Not affected
* **Vulnerability Tsa:**                       Vulnerable: No microcode
* **Vulnerability Tsx async abort:**           Not affected

.. list-table:: Reporte de Memoria (free)
   :header-rows: 1
   :widths: 10 15 15 15 15 15 15

   * - 
     - total
     - used
     - free
     - shared
     - buff/cache
     - available
   * - **Mem:**
     - 11959840
     - 603940
     - 8002812
     - 21064
     - 3644588
     - 11355900
   * - **Swap:**
     - 2097148
     - 0
     - 2097148
     - 
     - 
     -

memory (/proc/meminfo):
-----------------------

* **MemTotal:**       11959840 kB
* **MemFree:**         8002812 kB
* **MemAvailable:**   11355900 kB
* **Buffers:**            3752 kB
* **Cached:**          3582324 kB
* **SwapCached:**            0 kB
* **Active:**           359596 kB
* **Inactive:**        3330920 kB
* **Active(anon):**     125416 kB
* **Inactive(anon):**        0 kB
* **Active(file):**     234180 kB
* **Inactive(file):**  3330920 kB
* **Unevictable:**        4000 kB
* **Mlocked:**               0 kB
* **SwapTotal:**       2097148 kB
* **SwapFree:**        2097148 kB
* **Zswap:**                 0 kB
* **Zswapped:**              0 kB
* **Dirty:**                60 kB
* **Writeback:**             0 kB
* **AnonPages:**        108268 kB
* **Mapped:**            91720 kB
* **Shmem:**             21064 kB
* **KReclaimable:**      58512 kB
* **Slab:**             125340 kB
* **SReclaimable:**      58512 kB
* **SUnreclaim:**        66828 kB
* **KernelStack:**        3352 kB
* **PageTables:**         3780 kB
* **SecPageTables:**         0 kB
* **NFS_Unstable:**          0 kB
* **Bounce:**                0 kB
* **WritebackTmp:**          0 kB
* **CommitLimit:**     8077068 kB
* **Committed_AS:**     337544 kB
* **VmallocTotal:**   34359738367 kB
* **VmallocUsed:**       19388 kB
* **VmallocChunk:**          0 kB
* **Percpu:**             1616 kB
* **HardwareCorrupted:**     0 kB
* **AnonHugePages:**     26624 kB
* **ShmemHugePages:**        0 kB
* **ShmemPmdMapped:**        0 kB
* **FileHugePages:**         0 kB
* **FilePmdMapped:**         0 kB
* **CmaTotal:**              0 kB
* **CmaFree:**               0 kB
* **Unaccepted:**            0 kB
* **Balloon:**               0 kB
* **HugePages_Total:**       0
* **HugePages_Free:**        0
* **HugePages_Rsvd:**        0
* **HugePages_Surp:**        0
* **Hugepagesize:**       2048 kB
* **Hugetlb:**               0 kB
* **DirectMap4k:**      121716 kB
* **DirectMap2M:**     4052992 kB
* **DirectMap1G:**    10485760 kB

available filesystems:
----------------------

autofs bdev bpf cgroup cgroup2 configfs cpuset debugfs devpts devtmpfs efivarfs fuse fuseblk fusectl hugetlbfs mqueue pipefs proc pstore ramfs rpc_pipefs securityfs selinuxfs sockfs sysfs tmpfs tracefs vfat xfs

mounted filesystems (/proc/mounts):
-----------------------------------

.. code-block:: bash

   /dev/vda4 / xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
   devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=5959520k,nr_inodes=1489880,mode=755,inode64 0 0
   tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev,inode64 0 0
   devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
   sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
   securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
   cgroup2 /sys/fs/cgroup cgroup2 rw,seclabel,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot 0 0
   pstore /sys/fs/pstore pstore rw,seclabel,nosuid,nodev,noexec,relatime 0 0
   efivarfs /sys/firmware/efi/efivars efivarfs rw,nosuid,nodev,noexec,relatime 0 0
   bpf /sys/fs/bpf bpf rw,nosuid,nodev,noexec,relatime,mode=700 0 0
   configfs /sys/kernel/config configfs rw,nosuid,nodev,noexec,relatime 0 0
   proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
   tmpfs /run tmpfs rw,seclabel,nosuid,nodev,size=2391968k,nr_inodes=819200,mode=755,inode64 0 0
   selinuxfs /sys/fs/selinux selinuxfs rw,nosuid,noexec,relatime 0 0
   systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=35,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=5479 0 0
   mqueue /dev/mqueue mqueue rw,seclabel,nosuid,nodev,noexec,relatime 0 0
   hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,nosuid,nodev,relatime,pagesize=2M 0 0
   debugfs /sys/kernel/debug debugfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
   tracefs /sys/kernel/tracing tracefs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
   tmpfs /run/credentials/systemd-journald.service tmpfs ro,seclabel,nosuid,nodev,noexec,relatime,nosymfollow,size=1024k,nr_inodes=1024,mode=700,inode64,noswap 0 0
   fusectl /sys/fs/fuse/connections fusectl rw,nosuid,nodev,noexec,relatime 0 0
   /dev/vda2 /boot xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
   /dev/vdc1 /mnt/build-output xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
   /dev/vdb1 /var/log xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
   /dev/vda1 /boot/efi vfat rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=ascii,shortname=winnt,errors=remount-ro 0 0
   sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
   tmpfs /run/credentials/serial-getty@ttyS0.service tmpfs ro,seclabel,nosuid,nodev,noexec,relatime,nosymfollow,size=1024k,nr_inodes=1024,mode=700,inode64,noswap 0 0
   tmpfs /run/credentials/getty@tty1.service tmpfs ro,seclabel,nosuid,nodev,noexec,relatime,nosymfollow,size=1024k,nr_inodes=1024,mode=700,inode64,noswap 0 0
   tmpfs /run/user/1001 tmpfs rw,seclabel,nosuid,nodev,relatime,size=1195984k,nr_inodes=298996,mode=700,uid=1001,gid=1001,inode64 0 0






mounted filesystems (df):
-------------------------

.. code-block:: bash

   Filesystem     Type      Size  Used Avail Use% Mounted on
   /dev/vda4      xfs        17G  4.2G   13G  26% /
   devtmpfs       devtmpfs  5.7G     0  5.7G   0% /dev
   tmpfs          tmpfs     5.8G     0  5.8G   0% /dev/shm
   efivarfs       efivarfs  256K  175K   77K  70% /sys/firmware/efi/efivars
   tmpfs          tmpfs     2.3G   17M  2.3G   1% /run
   tmpfs          tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
   /dev/vda2      xfs       960M  224M  737M  24% /boot
   /dev/vdc1      xfs       5.0G  1.8G  3.2G  36% /mnt/build-output
   /dev/vdb1      xfs       5.0G  210M  4.8G   5% /var/log
   /dev/vda1      vfat      599M  8.4M  591M   2% /boot/efi
   tmpfs          tmpfs     1.0M     0  1.0M   0% /run/credentials/serial-getty@ttyS0.service
   tmpfs          tmpfs     1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
   tmpfs          tmpfs     1.2G  4.0K  1.2G   1% /run/user/1001

* **tainted (/proc/sys/kernel/tainted):** 0
* ``AppArmor disabled``
* **SELinux status:**                 enabled
* **SELinuxfs mount:**                /sys/fs/selinux
* **SELinux root directory:**         /etc/selinux
* **Loaded policy name:**             targeted
* **Current mode:**                   enforcing
* **Mode from config file:**          enforcing
* **Policy MLS status:**              enabled
* **Policy deny_unknown status:**     allowed
* **Memory protection checking:**     actual (secure)
* **Max kernel policy version:**      33
* *no big block device was specified on commandline.*
* *Tests which require a big block device are disabled.*
* *You can specify it with option -z*
* **COMMAND:** ``/opt/ltp/bin/ltp-pan   -e -S   -a 56610     -n 56610 -p -f /tmp/ltp-V39duZpHWB/alltests -l /opt/ltp/results/LTP_RUN_ON-2026_07_30-17h_32m_32s.log  -C /opt/ltp/output/LTP_RUN_ON-2026_07_30-17h_32m_32s.failed -T /opt/ltp/output/LTP_RUN_ON-2026_07_30-17h_32m_32s.tconf``
* **INFO:** Restricted to sysconf
* **LOG File:** ``/opt/ltp/results/LTP_RUN_ON-2026_07_30-17h_32m_32s.log``
* **FAILED COMMAND File:** ``/opt/ltp/output/LTP_RUN_ON-2026_07_30-17h_32m_32s.failed``
* **TCONF COMMAND File:** ``/opt/ltp/output/LTP_RUN_ON-2026_07_30-17h_32m_32s.tconf``
* ``Running tests.......``
* *<<<test_start>>>*
* **tag** =sysconf01 stime=1785425553
* **cmdline** ="sysconf01"
* **contacts** =" "
* **analysis** =exit
* *<<<test_output>>>*
* **INFO:** ltp-pan reported some tests FAIL
* **LTP Version:** 20250130

.. code-block:: bash

   ###############################################################

            Done executing testcases.
            LTP Version:  20250130
   ###############################################################