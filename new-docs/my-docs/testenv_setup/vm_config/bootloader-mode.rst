Determine Boot Mode and Bootloader
==================================

Before proceeding with bootloader configuration, it is crucial to determine the architecture and boot mode of the VM. Let’s clarify this step by step.

Step 1: Determine the Architecture
--------------------------------------------------

The architecture of the VM (x86, x86_64, ARM, etc.) can be determined using the following command:

.. code-block:: bash

    uname -m

- If the output is ``x86_64``, the VM is running on a 64-bit x86 architecture.
- If the output is ``i386`` or ``i686``, the VM is running on a 32-bit x86 architecture.
- Other outputs like ``aarch64`` indicate ARM architecture.

Step 2: Determine the Boot Mode (BIOS vs. UEFI)
--------------------------------------------------

The presence of the ``/boot/loader`` directory suggests that **systemd-boot** (formerly gummiboot) might be in use, which is typically associated with UEFI booting. However, since the ``/boot/efi`` directory is empty, this could indicate one of the following scenarios:

1. **UEFI Boot with systemd-boot**:

   - The ``/boot/loader`` directory is used by systemd-boot, which is a UEFI bootloader.
   - Even if ``/boot/efi`` is empty, the UEFI bootloader might be installed elsewhere (e.g., on the EFI System Partition (ESP) mounted at a different location).

2. **Legacy BIOS Boot with GRUB**:

   - The presence of ``/boot/grub2`` suggests GRUB is being used, which is common for BIOS booting.
   - The ``/boot/loader`` directory might be a leftover or misconfiguration.

To confirm the boot mode, you can check the following:

Check for UEFI Boot
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the following command to check if the system is booted in UEFI mode:

.. code-block:: bash

    ls /sys/firmware/efi

- If the directory exists, the system is booted in UEFI mode.
- If the directory does not exist, the system is likely booted in BIOS (legacy) mode.

Check for systemd-boot Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the system is booted in UEFI mode, check if systemd-boot is the active bootloader:

.. code-block:: bash

    bootctl status

- If systemd-boot is installed, this command will display details about the bootloader, including the boot mode (UEFI) and the installed entries.

Step 3: Verify the Bootloader in Use
--------------------------------------------------

Based on the above checks, you can determine the bootloader in use:

1. **If UEFI and systemd-boot are confirmed**:

   - The bootloader is systemd-boot, and the configuration files are located in ``/boot/loader/entries/``.
   - You should add your custom kernel entry as a new ``.conf`` file in ``/boot/loader/entries/``.

2. **If BIOS and GRUB are confirmed**:

   - The bootloader is GRUB, and the configuration files are located in ``/boot/grub2/``.
   - You should add your custom kernel entry to ``/etc/grub.d/`` and regenerate ``grub.cfg``.

Step 4: Proceed Based on Bootloader
--------------------------------------------------

Once you’ve confirmed the bootloader, you can proceed as follows:

For systemd-boot (UEFI)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Create a new ``.conf`` file in ``/boot/loader/entries/``:

   .. code-block:: bash

       sudo nano /boot/loader/entries/copied_kernel.conf

2. Add the following content (adjust paths as needed):

   .. code-block:: ini

       title Copied Kernel
       version Copied Kernel
       linux /boot/copied_kernel/vmlinuz-copied
       initrd /boot/copied_kernel/initrd.img-copied
       options root=/dev/sda1

3. Reboot the system, and the new entry should appear in the boot menu.

For GRUB (BIOS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Create a custom entry in ``/etc/grub.d/``:

   .. code-block:: bash

       sudo nano /etc/grub.d/40_custom

2. Add the following content (adjust paths as needed):

   .. code-block:: bash

       menuentry 'Copied Kernel' {
           set root='hd0,msdos1'
           linux /boot/copied_kernel/vmlinuz-copied root=/dev/sda1
           initrd /boot/copied_kernel/initrd.img-copied
       }

3. Make the file executable:

   .. code-block:: bash

       sudo chmod +x /etc/grub.d/40_custom

4. Regenerate the GRUB configuration:

   .. code-block:: bash

       sudo grub2-mkconfig -o /boot/grub2/grub.cfg

5. Reboot the system, and the new entry should appear in the GRUB menu.

Summary of Steps
--------------------------------------------------

1. Determine the architecture using ``uname -m``.
2. Check the boot mode using ``ls /sys/firmware/efi`` and ``bootctl status``.
3. Verify the bootloader (systemd-boot or GRUB).
4. Add the custom kernel entry based on the bootloader.
