.. _pci_functions:

PCI Functions Reference
=======================

This document provides a reference for various PCI-related functions and macros in the Linux kernel.

Structures
----------

.. c:type:: struct pci_dev

   Represents a PCI device within the kernel.

.. c:type:: struct pci_driver

   Represents a PCI driver.

.. c:type:: struct pci_device_id

   Represents a PCI device ID.

Macros
------

.. c:macro:: PCI_DEVICE(vendor, device)

   Creates a ``pci_device_id`` structure that matches specific vendor and device IDs.

   :param vendor: Specific vendor ID that supports the driver.
   :type vendor: __u32
   :param device: Specific device ID that supports the driver.
   :type device: __u32

.. c:macro:: PCI_DEVICE_CLASS(device_class, device_class_mask)

   Creates a ``pci_device_id`` structure that matches specific PCI class.

   :param device_class: Specific device class that supports the driver.
   :type device_class: __u32
   :param device_class_mask: Specific device mask that supports the driver.
   :type device_class_mask: __u32

.. c:macro:: MODULE_DEVICE_TABLE(pci, structListAlias)

   Exports the ``pci_device_id`` structure to user space to allow hotplug and module loading.

   :param pci: Driver or module.
   :param structListAlias: Hardware device. Specific driver alias definition (e.g., ``intel_*``, ``amd_*``).

Functions
---------

.. c:function:: int pci_register_driver(struct pci_driver *drv)

   Registers a PCI driver with the kernel.

.. c:function:: int pci_module_init(struct pci_driver *drv)

   Initializes a PCI module.

.. c:function:: int pci_unregister_driver(struct pci_driver *drv)

   Unregisters a PCI driver from the kernel.

.. c:function:: struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device, struct pci_dev *from)

   Searches the device list for a specific device.

.. c:function:: struct pci_dev *pci_find_device_reverse(unsigned int vendor, unsigned int device, const struct pci_dev *from)

   Searches the device list in reverse for a specific device.

.. c:function:: struct pci_dev *pci_find_subsys(unsigned int vendor, unsigned int device, unsigned int ss_vendor, unsigned int ss_device, const struct pci_dev *from)

   Searches the device list for a specific subsystem.

.. c:function:: struct pci_dev *pci_find_class(unsigned int class, struct pci_dev *from)

   Searches the device list for a specific class.

.. c:function:: struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device, struct pci_dev *from)

   Searches the device list for a device with a specific signature.

.. c:function:: struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device, unsigned int ss_vendor, unsigned int ss_device, struct pci_dev *from)

   Searches the device list for a subsystem with a specific signature.

.. c:function:: struct pci_dev *pci_get_slot(struct pci_bus *bus, unsigned int devfn)

   Retrieves a device from a specific slot.

.. c:function:: int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val)

   Reads a byte from a PCI configuration register.

.. c:function:: int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val)

   Reads a word from a PCI configuration register.

.. c:function:: int pci_user_read_config_dword(struct pci_dev *dev, int where, u32 *val)

   Reads a double word from a PCI configuration register.

.. c:function:: int pci_user_write_config_byte(struct pci_dev *dev, int where, u8 *val)

   Writes a byte to a PCI configuration register.

.. c:function:: int pci_user_write_config_word(struct pci_dev *dev, int where, u16 *val)

   Writes a word to a PCI configuration register.

.. c:function:: int pci_user_write_config_dword(struct pci_dev *dev, int where, u32 *val)

   Writes a double word to a PCI configuration register.

.. c:function:: int pci_enable_device(struct pci_dev *dev)

   Enables a PCI device.

.. c:function:: unsigned long pci_resource_start(struct pci_dev *dev, int bar)

   Retrieves the start address of a PCI resource.

.. c:function:: unsigned long pci_resource_end(struct pci_dev *dev, int bar)

   Retrieves the end address of a PCI resource.

.. c:function:: unsigned long pci_resource_flags(struct pci_dev *dev, int bar)

   Retrieves the flags of a PCI resource.
