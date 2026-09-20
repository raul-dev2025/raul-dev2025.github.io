Confirming Bootloader and Kernel Loading with UUID
====================================================

The fact that both ``/proc/cmdline`` and ``dmesg | grep -i boot`` show the same **UUID** for the storage media confirms that the kernel and initramfs are being loaded from the correct storage device. This UUID corresponds to the VM's disk, as verified by ``/dev/disk/by-uuid/``.

Key Points from the UUID
--------------------------------------------------

1. **UUID in** ``/proc/cmdline``:

   - The kernel command line (``/proc/cmdline``) includes the ``root=UUID=<uuid>`` parameter, which specifies the root filesystem by its UUID.
   - This ensures that the kernel mounts the correct partition as the root filesystem during boot.

2. **UUID in** ``dmesg``:

   - The `dmesg` output shows the same UUID during the boot process, confirming that the kernel successfully identified and mounted the root filesystem.

3. **Verification with** ``/dev/disk/by-uuid/``:

   - The UUID matches the VM's disk, as confirmed by `/dev/disk/by-uuid/`. This eliminates any ambiguity about the storage device being used.

Next Steps
--------------------------------------------------

Now that we’ve confirmed the UUID and storage device, let’s focus on determining **how the kernel and initramfs are being loaded** and **which bootloader is in use**.

1. **Check the Bootloader**:

   - Since the system is booting in BIOS mode (not EFI), the most likely bootloader is **GRUB**.
   - Inspect the MBR for GRUB or other bootloaders:

     .. code-block:: bash

         sudo dd if=/dev/vda bs=512 count=1 | strings

   - Check GRUB configuration files in ``/boot/grub/`` or ``/boot/grub2/``:

     .. code-block:: bash

         ls /boot/grub2/
         cat /boot/grub2/grub.cfg

   - Check for custom GRUB entries in ``/etc/grub.d/40_custom``:

     .. code-block:: bash

         cat /etc/grub.d/40_custom

2. **Analyze** ``/proc/cmdline``:

   - The kernel command line (``/proc/cmdline``) provides critical information about how the kernel and initramfs are loaded.
   - Look for parameters like `BOOT_IMAGE=`, ``initrd=``, and ``root=UUID=<uuid>``.

3. **Verify Kernel and Initramfs Files**:

   - Ensure the kernel and initramfs files exist in ``/boot/``:

     .. code-block:: bash

         ls /boot/

   - Look for files like ``vmlinuz-<version>`` and ``initrd.img-<version>``.

4. **Check for Network Boot (PXE)**:

   - If the kernel and initramfs are not found locally, check for PXE configurations:

     .. code-block:: bash

         ls /var/lib/tftpboot/
         ls /srv/tftp/
         dmesg | grep -i pxe

Summary of Findings
--------------------------------------------------

1. **UUID Confirmation**:

   - The UUID in ``/proc/cmdline`` and ``dmesg`` matches the VM's disk, confirming the correct storage device is being used.

2. **Bootloader**:

   - The most likely bootloader is GRUB, but we need to confirm this by inspecting the MBR and GRUB configuration files.

3. **Kernel and Initramfs**:

   - The kernel and initramfs are being loaded as specified in ``/proc/cmdline``.
   - Verify that the files exist in ``/boot/``.

4. **Network Boot (PXE)**:

   - If the kernel and initramfs are not found locally, check for PXE configurations.
