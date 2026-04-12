ifSysCollector.py - PCI Device Data Fetcher
============================================

Overview
--------
The *ifSysCollector.py* script is a Python tool designed to fetch and translate data from PCI device directories in a Linux system. It extracts information such as vendor IDs, device IDs, and class codes, and translates them into human-readable descriptions using mapping files. The script also logs extracted text and errors to a default log file (*fetcher.log*).

Features
----------
- Parses PCI IDs from a ``pci_ids.h`` file to generate vendor and class mapping files.
- Fetches data from PCI device directories in ``/sys/bus/pci/devices/``.
- Translates raw values (e.g., vendor IDs, class codes) into human-readable descriptions.
- Logs extracted text and errors to a file (``fetcher.log``).
- Handles special files (e.g., ``remove``, ``rescan``) that require root permissions.

Usage
-------
Run the script with the following command-line arguments:

.. code-block:: bash

   ./ifSysCollector.py --device-path <device_path> \
                --pci-ids <pci_ids.h> \
                --vendor-map <vendor_map_output> \
                --class-map <class_map_output>

Arguments
-----------
- ``--device-path``: Path to the PCI device directory (e.g., ``/sys/bus/pci/devices/0000:00:XX.x``).
- ``--pci-ids``: Path to the *pci_ids.h* file containing PCI vendor and device IDs.
- ``--vendor-map``: Output path for the vendor ID mapping file.
- ``--class-map``: Output path for the class code mapping file.

Output
--------
- **Mapping Files**: The script generates two mapping files:

  - Vendor ID mapping file (e.g., ``vendor_out``).
  - Class code mapping file (e.g., ``class_out``).

- **Log File**: The script logs extracted text and errors to *fetcher.log* in the current working directory.

- **Terminal Output**: The script prints a summary table of the fetched PCI device data to the terminal.

Special Files
---------------
The script skips the following special files that require root permissions:

- ``remove``: Used to remove the PCI device from the system.
- ``rescan``: Used to rescan the PCI bus.
- ``reset``: Used to reset the PCI device.
- ``enable``: Used to enable or disable the PCI device.
- ``driver_override``: Used to override the default driver binding.
- ``resource``: Contains the device's resource allocations.
- ``rom``: Contains the device's Option ROM.
- ``config``: Contains the device's PCI configuration space.
- ``msi_bus``: Controls MSI (Message Signaled Interrupts).
- ``msi_irqs``: Lists the MSI IRQs assigned to the device.
- ``numa_node``: Specifies the NUMA node associated with the device.
- ``d3cold_allowed``: Controls whether the device is allowed to enter the D3cold power state.

Note on Output Handling
-------------------------
The script prints the fetched PCI device data to the terminal (standard output, ``fd1``). However, this output is not strictly necessary since all relevant information is logged to *fetcher.log*. If terminal output is not needed, you can redirect it to ``/dev/null``:

.. code-block:: bash

   ./ifSysCollector.py --device-path <device_path> \
                --pci-ids <pci_ids.h> \
                --vendor-map <vendor_map_output> \
                --class-map <class_map_output> > /dev/null

This will suppress the terminal output while still saving the logs to *fetcher.log*.

Example
---------
To fetch data from a PCI device and generate mapping files:

.. code-block:: bash

   ./ifSysCollector.py --device-path /sys/bus/pci/devices/0000:00:18.0 \
                --pci-ids pci_ids.h \
                --vendor-map vendor_out \
                --class-map class_out

This will:

1. Parse ``pci_ids.h`` and generate *vendor_out* and *class_out* mapping files.
2. Fetch and translate data from the specified PCI device directory.
3. Log extracted text and errors to *fetcher.log*.
4. Print a summary table of the fetched data to the terminal.

Dependencies
--------------
- Python 3.x
- Linux system with PCI device directories (``/sys/bus/pci/devices/``).

License
---------
This script is provided under the MIT License. See the LICENSE file for details.
