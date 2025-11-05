Setting Up a VM to Boot with a Copied Kernel
===========================================

This guide explains how to copy the running kernel on a Linux VM and configure the VM to boot using the copied kernel.

Prerequisites
-------------
- A Linux-based virtual machine (e.g., Ubuntu, CentOS, or Debian).
- Root or sudo access on the VM.
- Basic familiarity with Linux commands and bootloader configuration.

Step 1: Identify the Running Kernel
-----------------------------------
1. Check the currently running kernel version:

   .. code-block:: bash

      uname -r

   Example output: `5.15.0-83-generic`

2. Locate the corresponding kernel files in `/boot`:

   .. code-block:: bash

      ls /boot/vmlinuz-$(uname -r)
      ls /boot/initrd.img-$(uname -r)
      ls /boot/config-$(uname -r)
      ls /boot/System.map-$(uname -r)

Step 2: Copy the Kernel Files
-----------------------------
1. Create a directory to store the copied kernel files:

   .. code-block:: bash

      sudo mkdir -p /boot/copied_kernel

2. Copy the kernel files to the new directory:

   .. code-block:: bash

      sudo cp /boot/vmlinuz-$(uname -r) /boot/copied_kernel/vmlinuz-copied
      sudo cp /boot/initrd.img-$(uname -r) /boot/copied_kernel/initrd.img-copied
      sudo cp /boot/config-$(uname -r) /boot/copied_kernel/config-copied
      sudo cp /boot/System.map-$(uname -r) /boot/copied_kernel/System.map-copied

Step 3: Update the Bootloader (GRUB)
------------------------------------
1. Open the GRUB configuration file for editing:

   .. code-block:: bash

      sudo nano /etc/default/grub

2. Add a new menu entry for the copied kernel. Append the following to the file:

   .. code-block:: bash

      menuentry 'Copied Kernel' {
          set root='hd0,msdos1' # Adjust based on your disk partition
          linux /boot/copied_kernel/vmlinuz-copied root=/dev/sda1 # Adjust root partition
          initrd /boot/copied_kernel/initrd.img-copied
      }

   Replace `hd0,msdos1` and `/dev/sda1` with the appropriate disk and partition details for your system.

3. Save and exit the editor.

4. Update GRUB to apply the changes:

   .. code-block:: bash

      sudo update-grub # For Debian/Ubuntu
      sudo grub2-mkconfig -o /boot/grub2/grub.cfg # For CentOS/RHEL

Step 4: Reboot and Select the Copied Kernel
-------------------------------------------
1. Reboot the VM:

   .. code-block:: bash

      sudo reboot

2. During boot, access the GRUB menu (usually by pressing `Shift` or `Esc`).
3. Select the "Copied Kernel" entry to boot using the copied kernel.

Step 5: Verify the Booted Kernel
--------------------------------
1. After booting, verify that the VM is running the copied kernel:

   .. code-block:: bash

      uname -r

   The output should match the kernel version you copied.

Step 6: Test the Kernel
-----------------------
1. Run tests or workloads to ensure the copied kernel functions as expected.
2. If issues arise, you can reboot and select the original kernel from the GRUB menu.

Conclusion
----------
You have successfully copied the running kernel and configured the VM to boot using the copied kernel. This setup is useful for testing and validating kernel behavior in a controlled environment.

For advanced use cases, consider using tools like `kexec` for faster kernel switching or creating custom kernel builds for testing.
