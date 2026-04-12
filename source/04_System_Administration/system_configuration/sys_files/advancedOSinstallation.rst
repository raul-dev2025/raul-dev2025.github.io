How to Preserve `/home` and VDO During OS Reinstallation
=========================================================

Objective
------------

Perform a fresh OS installation using Anaconda while preserving:

1. The existing ``os-home`` LVM partition (mounted at ``/home``).
2. The VDO volume on the ``nvme`` disk (mounted at ``/path/to/vdo``).
3. All other partitions (``/boot/efi``, ``/boot``, ``os-root``, ``os-swap``) may be overwritten.

Steps
--------

1. **Boot into Anaconda Installer**

   - Boot from installation media (USB/DVD).
   - Start the Anaconda installer.

2. **Select Manual Partitioning**

   - Choose **Manual** or **Custom** partitioning mode.

3. **Configure Partitions**

   - **EFI System Partition** (``sdx1``):
   
     - Reformat as ``fat32``.
     - Set mount point to ``/boot/efi``.
     
   - ``/boot`` **Partition** (``sdx2``):
   
     - Reformat as ``ext4`` or ``xfs``.
     - Set mount point to ``/boot``.
     
   - **LVM Volume Group** (``sdx3``):
   
     - ``os-root``: Reformat (``ext4``/``xfs``) and assign to ``/``.
     - ``os-swap``: Set as ``swap``.
     - ``os-home``: **Do not reformat**. Assign to ``/home`` and check "Preserve data".
     
   - **VDO Volume** (``nvme``):
   
     - If detected: Assign to ``/path/to/vdo`` **without reformatting**.
     - If not detected: Ignore (will configure post-install).

4. **Complete Installation**

   - Verify partition changes before proceeding.
   - Confirm that only ``os-home`` and VDO are preserved.

5. **Post-Installation Steps**

   - If VDO was not configured during install:
   
     - Manually mount the VDO volume:
     
       .. code-block:: bash

         sudo vdo start --name=vdo-name
         sudo mount /dev/mapper/vdo-name /path/to/vdo

     - Add to ``/etc/fstab``:
     
       .. code-block:: none

         /dev/mapper/vdo-name /path/to/vdo xfs defaults,_netdev 0 0

     - Enable the VDO service:
     
       .. code-block:: bash

         sudo systemctl enable --now vdo

Important Notes
------------------

- **Backup data** before proceeding, even when preserving ``/home``.
- Anaconda may not fully support VDO configuration. Manual setup might be required.
- Ensure LVM volume group names (e.g., ``os``) do not conflict with the new OS.
