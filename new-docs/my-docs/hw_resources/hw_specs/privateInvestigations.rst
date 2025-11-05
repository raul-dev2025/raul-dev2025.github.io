Investigating Device 18 (0000:00:18.x)
========================================

Objective
-----------
The goal of this exercise is to investigate the most populated address, specifically device 18 (0000:00:18.x), and gather all available information about it. Since we do not have a ``pci_watcher`` implemented yet, we will rely on system interfaces such as ``/sys`` and ``/proc`` to extract the necessary details.

Step 1: Identify the Device in ``/sys``
------------------------------------------
The ``/sys`` filesystem provides a hierarchical view of devices, including PCI devices. For device ``0000:00:18.x``, we can explore the corresponding directory in ``/sys``.

Path to Device 18 in ``/sys``:
-------------------------------
::

   /sys/bus/pci/devices/0000:00:18.x

Replace ``x`` with the function numbers (0 through 7) to explore each function of device 18.

Step 2: Gather Information from ``/sys``
----------------------------------------
Here are the key files and directories to inspect for each function of device 18:

1. **Vendor and Device IDs**:

   - File: ``vendor``
   - File: ``device``
   - These files contain the vendor ID and device ID in hexadecimal format. For example:
     - ``vendor`` might contain ``0x1022`` (AMD).
     - ``device`` might contain a specific device ID for the host bridge.

2. **Class Code**:

   - File: ``class``
   - This file contains the device class code, which indicates the type of device (e.g., host bridge, PCI bridge, etc.).

3. **Configuration Space**:

   - File: ``config``
   - This binary file contains the raw PCI configuration space for the device. Tools like ``lspci -xxxx`` or ``hexdump`` can be used to inspect it.

4. **Resource Allocation**:

   - File: ``resource``
   - This file contains the memory and I/O resources allocated to the device.
   - Files: ``resource0``, ``resource1``, etc.
     - These files represent the actual memory or I/O regions allocated to the device.

5. **Driver Information**:

   - Symlink: ``driver``
   - This symlink points to the driver currently bound to the device (if any).

6. **Power Management**:

   - Directory: ``power/``
   - Contains information about the device's power state (e.g., ``control``, ``runtime_status``).

7. **Device-specific Attributes**:

   - Directory: ``device/``
   - Contains device-specific attributes and configuration options.

Step 3: Gather Information from ``/proc``
-------------------------------------------
The ``/proc`` filesystem provides additional system-wide information. For PCI devices, the following files are particularly useful:

1. **PCI Device List**:

   - File: ``/proc/bus/pci/devices``
   - This file lists all PCI devices in the system, along with their bus, device, function, and resource information.

2. **Interrupts**:

   - File: ``/proc/interrupts``
   - This file lists interrupt usage across the system. Look for entries related to device 18 to determine if it uses interrupts.

3. **I/O Memory and Ports**:

   - File: ``/proc/ioports``
   - Lists I/O port ranges used by devices.
   - File: ``/proc/iomem``
   - Lists memory ranges used by devices.

Step 4: Investigate Device 18 Functions
-----------------------------------------
Since device 18 has multiple functions (0 through 7), we need to investigate each one individually. Here's how we can approach it:

1. **Function 0 (0000:00:18.0)**:

   - Check ``vendor``, ``device``, and ``class`` to confirm it's a host bridge.
   - Inspect ``resource`` to see memory and I/O allocations.
   - Check if a driver is bound to it (``driver`` symlink).

2. **Function 1 (0000:00:18.1)**:

   - Repeat the same steps as above.
   - Compare the ``class`` and ``resource`` files to see if it differs from function 0.

3. **Functions 2-7 (0000:00:18.2 - 0000:00:18.7)**:

   - Investigate each function similarly.
   - Look for differences in ``class``, ``resource``, and driver binding.

Step 5: Use Tools to Extract Information
------------------------------------------
To make this process easier, we can use tools like ``lspci``, ``setpci``, and ``hexdump`` to extract and interpret information.

1. ``lspci``:

   - Command: ``lspci -v -s 0000:00:18.x``
   - This will show detailed information about the device, including its class, vendor, device ID, and resource allocation.

2. ``setpci``:

   - Command: ``setpci -s 0000:00:18.x``
   - This allows us to read and write directly to the PCI configuration space.

3. ``hexdump``:

   - Command: ``hexdump -C /sys/bus/pci/devices/0000:00:18.x/config``
   - This will dump the raw PCI configuration space for inspection.

Step 6: Analyze the Findings
------------------------------
Once we've gathered all the information, we can analyze it to determine:

- The exact role of each function of device 18.
- Whether the device is a host bridge, PCI bridge, or something else.
- How the device is configured (memory ranges, interrupts, etc.).
- Whether the device is properly initialized and bound to a driver.

Example Investigation for Function 0 (0000:00:18.0):
------------------------------------------------------
1. **Check Vendor and Device IDs**:

   - ``cat /sys/bus/pci/devices/0000:00:18.0/vendor`` → ``0x1022`` (AMD).
   - ``cat /sys/bus/pci/devices/0000:00:18.0/device`` → ``0x1450``.

2. **Check Class Code**:

   - ``cat /sys/bus/pci/devices/0000:00:18.0/class`` → ``0x060000`` (Host bridge).

3. **Check Resource Allocation**:

   - ``cat /sys/bus/pci/devices/0000:00:18.0/resource`` → Memory ranges and I/O ports.

4. **Check Driver Binding**:

   - ``ls -l /sys/bus/pci/devices/0000:00:18.0/driver`` → Symlink to the bound driver (if any).

Next Steps:
-------------
- Repeat the above steps for all functions of device 18 (0000:00:18.0 through 0000:00:18.7).
- Compare the findings to understand the purpose of each function.
- Document the results and share them for further analysis.

Let me know if you need help with specific commands or interpreting the data!
