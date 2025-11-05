Common Files and Directories in ``/sys/bus/pci/devices/0000:00:XX.x``
-------------------------------------------------------------------

- ``class``
  - Contains the device class code in hexadecimal format (e.g., ``0x060000`` for a host bridge).

- ``device``
  - Contains the device ID in hexadecimal format (e.g., ``0x1450``).

- ``vendor``
  - Contains the vendor ID in hexadecimal format (e.g., ``0x1022`` for AMD).

- ``config``
  - A binary file containing the raw PCI configuration space for the device.

- ``resource``
  - Contains the memory and I/O resources allocated to the device.

- ``resource0``, ``resource1``, etc.
  - Represent the actual memory or I/O regions allocated to the device.

- ``driver``
  - A symlink to the driver currently bound to the device (if any).

- ``irq``
  - Contains the interrupt number assigned to the device.

- ``local_cpus``
  - Lists the CPUs that are local to the device.

- ``local_cpulist``
  - Similar to ``local_cpus``, but in a human-readable format.

- ``numa_node``
  - Indicates the NUMA node associated with the device.

- ``enable``
  - A file that can be used to enable or disable the device (write ``1`` to enable, ``0`` to disable).

- ``broken_parity_status``
  - Indicates whether the device has reported broken parity.

- ``msi_bus``
  - Indicates whether MSI (Message Signaled Interrupts) is enabled for the device.

- ``msi_irqs``
  - Lists the MSI interrupts assigned to the device.

- ``power/``
  - A directory containing power management-related files:
    - ``control``: Controls the device's power state.
    - ``runtime_status``: Shows the current runtime power state of the device.
    - ``wakeup``: Indicates whether the device can wake the system from sleep.

- ``subsystem/``
  - A symlink to the PCI subsystem directory.

- ``uevent``
  - Used to trigger uevents for the device.

- ``firmware_node/``
  - A directory containing firmware-related information for the device.

- ``remove``
  - Writing ``1`` to this file removes the device from the system.

- ``rescan``
  - Writing ``1`` to this file triggers a rescan of the PCI bus.

- ``reset``
  - Writing ``1`` to this file resets the device.

- ``rom``
  - Contains the device's ROM (if available).

- ``sriov_numvfs``
  - Used to configure the number of Virtual Functions (VFs) for SR-IOV-capable devices.

- ``sriov_totalvfs``
  - Indicates the total number of Virtual Functions (VFs) supported by the device.

- ``ari_enabled``
  - Indicates whether ARI (Alternative Routing-ID Interpretation) is enabled for the device.

- ``d3cold_allowed``
  - Indicates whether the device is allowed to enter the D3cold power state.

- ``dma_mask_bits``
  - Indicates the DMA mask bits supported by the device.

- ``consistent_dma_mask_bits``
  - Indicates the consistent DMA mask bits supported by the device.

- ``modalias``
  - Contains the device's modalias string, used for module autoloading.

- ``iommu_group/``
  - A directory containing information about the IOMMU group the device belongs to.

- ``iommu/``
  - A directory containing IOMMU-related information for the device.

- ``devspec/``
  - A directory containing device-specific information (if available).

- ``acpi_index``
  - Contains the ACPI index of the device (if applicable).

- ``label``
  - Contains a human-readable label for the device (if available).

- ``physfn/``
  - A symlink to the physical function of an SR-IOV-capable device (if applicable).

- ``virtfn0/``, ``virtfn1/``, etc.
  - Symlinks to the virtual functions of an SR-IOV-capable device (if applicable).

- ``driver_override``
  - Allows overriding the default driver binding for the device.

- ``pcie_flr_retrain``
  - Used to trigger a Function Level Reset (FLR) and retrain the PCIe link.

- ``pcie_replay_count``
  - Indicates the number of replay attempts on the PCIe link.

- ``pcie_link_width``
  - Indicates the current width of the PCIe link.

- ``pcie_link_speed``
  - Indicates the current speed of the PCIe link.

- ``pcie_bus_peer2peer``
  - Indicates whether peer-to-peer communication is enabled on the PCIe bus.

- ``pcie_aer/``
  - A directory containing AER (Advanced Error Reporting) information for the device.

- ``pcie_aspm/``
  - A directory containing ASPM (Active State Power Management) information for the device.

- ``pcie_aspm_l1ss/``
  - A directory containing L1 Substate ASPM information for the device.

- ``pcie_aspm_ltr/``
  - A directory containing LTR (Latency Tolerance Reporting) information for the device.

- ``pcie_aspm_power/``
  - A directory containing power-related ASPM information for the device.

- ``pcie_aspm_policy/``
  - A directory containing ASPM policy information for the device.

- ``pcie_aspm_state/``
  - A directory containing ASPM state information for the device.

- ``pcie_aspm_supported/``
  - A directory containing information about supported ASPM states for the device.

- ``pcie_aspm_control/``
  - A directory containing ASPM control information for the device.

- ``pcie_aspm_capability/``
  - A directory containing ASPM capability information for the device.

- ``pcie_aspm_status/``
  - A directory containing ASPM status information for the device.

- ``pcie_aspm_config/``
  - A directory containing ASPM configuration information for the device.

- ``pcie_aspm_debug/``
  - A directory containing debug information for ASPM.

- ``pcie_aspm_disable/``
  - A file used to disable ASPM for the device.

- ``pcie_aspm_enable/``
  - A file used to enable ASPM for the device.

- ``pcie_aspm_force/``
  - A file used to force ASPM settings for the device.

- ``pcie_aspm_l1ss_control/``
  - A file used to control L1 Substate ASPM for the device.

- ``pcie_aspm_l1ss_status/``
  - A file containing L1 Substate ASPM status for the device.

- ``pcie_aspm_l1ss_capability/``
  - A file containing L1 Substate ASPM capability information for the device.

- ``pcie_aspm_l1ss_config/``
  - A file containing L1 Substate ASPM configuration information for the device.

- ``pcie_aspm_l1ss_debug/``
  - A file containing debug information for L1 Substate ASPM.

- ``pcie_aspm_l1ss_disable/``
  - A file used to disable L1 Substate ASPM for the device.

- ``pcie_aspm_l1ss_enable/``
  - A file used to enable L1 Substate ASPM for the device.

- ``pcie_aspm_l1ss_force/``
  - A file used to force L1 Substate ASPM settings for the device.

- ``pcie_aspm_l1ss_supported/``
  - A file containing information about supported L1 Substate ASPM states for the device.

- ``pcie_aspm_l1ss_control/``
  - A file used to control L1 Substate ASPM for the device.

- ``pcie_aspm_l1ss_status/``
  - A file containing L1 Substate ASPM status for the device.

- ``pcie_aspm_l1ss_capability/``
  - A file containing L1 Substate ASPM capability information for the device.

- ``pcie_aspm_l1ss_config/``
  - A file containing L1 Substate ASPM configuration information for the device.

- ``pcie_aspm_l1ss_debug/``
  - A file containing debug information for L1 Substate ASPM.

- ``pcie_aspm_l1ss_disable/``
  - A file used to disable L1 Substate ASPM for the device.

- ``pcie_aspm_l1ss_enable/``
  - A file used to enable L1 Substate ASPM for the device.

- ``pcie_aspm_l1ss_force/``
  - A file used to force L1 Substate ASPM settings for the device.

- ``pcie_aspm_l1ss_supported/``
  - A file containing information about supported L1 Substate ASPM states for the device.
