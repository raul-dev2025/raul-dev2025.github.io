PCIe Symobls
==============


In the context of PCI Express (PCIe) and the Linux kernel, **MMCFG** stands for *Memory-Mapped Configuration Space*. It refers to the mechanism used by the PCIe specification to access the configuration space of PCIe devices.


What is MMCFG?
----------------

* PCIe devices have a *configuration space*, which is a set of registers used to configure and control the device.
* In traditional PCI, the configuration space is accessed using I/O ports (e.g., ``CONFIG_ADDRESS`` and ``CONFIG_DATA`` ports).
* In PCIe, the configuration space is accessed via ``memory-mapped I/O (MMIO)``. This is called the *MMCFG (Memory-Mapped Configuration)* mechanism.
* The MMCFG region is a portion of the system's physical memory address space reserved for accessing PCIe configuration space. The base address of this region is typically defined in the system's ACPI tables (e.g., the `MCFG` table).


How MMCFG Works
-----------------

1. The firmware (e.g., *BIOS* or *UEFI*) provides the base address of the MMCFG region in the ACPI ``MCFG`` table.
2. The operating system (e.g., Linux kernel) uses this base address to map the PCIe configuration space into its virtual address space.
3. The kernel can then access the configuration space of PCIe devices by reading from or writing to specific memory addresses within the MMCFG region.


MMCFG in the Linux Kernel
---------------------------

In the Linux kernel, MMCFG support is enabled by the following configuration option:

.. code-block:: C

	CONFIG_PCI_MMCONFIG

* This option enables the use of the memory-mapped configuration space for PCIe devices.
* It is typically enabled by default in modern kernels, as most systems use PCIe and rely on MMCFG for configuration space access.


Why MMCFG is Important
------------------------

* MMCFG provides a faster and more efficient way to access PCIe configuration space compared to the legacy PCI mechanism.
* It is essential for systems with PCIe devices, as it allows the kernel to discover, configure, and manage these devices during boot and runtime.

If you're debugging or working with PCIe devices in the Linux kernel, you might encounter references to MMCFG in logs or code related to PCIe initialization and configuration. For example, during boot, the kernel might log the MMCFG base address and the size of the MMCFG region.

