Enabling the Boot Menu During Boot
==================================

If the VM is booting "hands-off" (i.e., the boot menu does not appear during boot), you can enable the boot menu by modifying the bootloader configuration. The steps depend on whether the system is using **GRUB** (for BIOS or UEFI) or **systemd-boot** (for UEFI).

Step 1: Determine the Bootloader
--------------------------------------------------

Follow the steps in the previous section to determine whether the system is using **GRUB** or **systemd-boot**.

Step 2: Enable the Boot Menu
--------------------------------------------------

**For GRUB (BIOS or UEFI)**

1. Edit the GRUB configuration file:

   .. code-block:: bash

       sudo nano /etc/default/grub

2. Modify the following parameters to ensure the boot menu appears:

   - Set ``GRUB_TIMEOUT`` to a value greater than 0 (e.g., ``GRUB_TIMEOUT=5``) to display the menu for 5 seconds.
   - Ensure ``GRUB_HIDDEN_TIMEOUT`` is either commented out or set to 0.
   - Set ``GRUB_TIMEOUT_STYLE`` to ``menu`` to always show the menu.

   Example configuration:

   .. code-block:: bash

       GRUB_TIMEOUT=5
       GRUB_HIDDEN_TIMEOUT=0
       GRUB_TIMEOUT_STYLE=menu

3. Save the file and regenerate the GRUB configuration:

   .. code-block:: bash

       sudo grub2-mkconfig -o /boot/grub2/grub.cfg

4. Reboot the system. The GRUB boot menu should now appear during boot.

**For systemd-boot (UEFI)**

1. Edit the systemd-boot configuration file:

   .. code-block:: bash

       sudo nano /boot/loader/loader.conf

2. Add or modify the following parameters to ensure the boot menu appears:

   - Set ``timeout`` to a value greater than 0 (e.g., ``timeout 5``) to display the menu for 5 seconds.
   - Set ``console-mode`` to ``auto`` or a specific resolution if needed.

   Example configuration:

   .. code-block:: ini

       timeout 5
       console-mode auto

3. Save the file and reboot the system. The systemd-boot menu should now appear during boot.

Step 3: Temporarily Access the Boot Menu
--------------------------------------------------

If you only need to access the boot menu once (e.g., for testing), you can interrupt the boot process:

- For **GRUB**: Press ``Shift`` (for BIOS) or ``Esc`` (for UEFI) during boot to bring up the menu.
- For **systemd-boot**: Press ``Space`` during boot to bring up the menu.

Step 4: Verify the Changes
--------------------------------------------------

After making the changes, reboot the system and verify that the boot menu appears. If the menu does not appear, double-check the configuration files and ensure the correct bootloader is being used.

Summary
--------------------------------------------------

1. Determine the bootloader (GRUB or systemd-boot).
2. Modify the configuration file to enable the boot menu:

   - For GRUB: Edit ``/etc/default/grub`` and regenerate ``grub.cfg``.
   - For systemd-boot: Edit ``/boot/loader/loader.conf``.

3. Reboot the system and verify the boot menu appears.

**Note:** The boot menu operates independently of wether the system is running in graphical mode or text mode, so the absence of an X server does not affect this process.

