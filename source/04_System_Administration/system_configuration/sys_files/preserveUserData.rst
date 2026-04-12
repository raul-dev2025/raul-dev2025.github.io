Preserving ``/home/userData`` and ``/usr/src/vdo`` During System Reinstallation
===============================================================================

Objective
------------
- Safely update/reinstall the OS while keeping ``/home/userData`` and ``/usr/src/vdo`` intact.
- Ensure neither disk mounts automatically on the fresh system without manual intervention.

Pre-Installation Steps
-------------------------

1. Backup Critical Information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- **Partition UUIDs and Mount Points**:
  .. code-block:: bash

     sudo blkid | grep -E "sdb1|nvme0n1"
     sudo cat /etc/fstab | grep -E "userData|vdo"

- **VDO Configuration** (if applicable):
  .. code-block:: bash

     sudo vdo list
     sudo vdo status --name=<vdo_volume_name>
     sudo cat /etc/vdoconf.yml # (if exists)

2. Disable Automatic Mounting
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- Comment out entries in ``/etc/fstab`` to prevent auto-mounting:
  .. code-block:: bash

     sudo cp /etc/fstab /etc/fstab.backup
     sudo sed -i '/userData\|vdo/s/^/#/' /etc/fstab

During OS Installation
-------------------------
- **Partitioning Mode**: Select *Manual/Custom* partitioning.
- **Avoid Formatting**:
  - Do **not** format ``/dev/sdb1`` (``userData``) or ``/dev/nvme0n1`` (VDO).
- **LVM Handling**:
  - Preserve ``/dev/sda3`` (LVM Physical Volume) if ``centos-home`` or ``centos-root`` are modified.

Post-Installation Steps
--------------------------

1. Restore Mounts
~~~~~~~~~~~~~~~~~~~~
- Edit ``/etc/fstab`` with UUIDs (use ``blkid`` to verify):
  .. code-block:: text

     # /home/userData (sdb1)
     UUID=<sdb1_UUID> /home/userData ext4 defaults,noauto 0 2
     # /usr/src/vdo (VDO)
     /dev/mapper/vdo /usr/src/vdo xfs defaults,noauto 0 2

- Test mounts manually:
  .. code-block:: bash

     sudo mount /home/userData
     sudo mount /usr/src/vdo

2. Reconfigure VDO (if needed)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- Install the ``vdo`` package (if missing):
  .. code-block:: bash

     sudo dnf install vdo

- Recreate VDO volume (if not detected):
  .. code-block:: bash

     sudo vdo create --name=vdo --device=/dev/nvme0n1 --vdoLogicalSize=2T
     sudo mount /dev/mapper/vdo /usr/src/vdo

Verification
---------------
- Confirm data integrity:
  .. code-block:: bash

     ls -l /home/userData/ /usr/src/vdo/
     df -h | grep -E "userData|vdo"

Key Notes
------------
- **Use UUIDs**: Always reference disks by UUID in ``/etc/fstab`` for reliability.
- **``noauto``**: Prevents automatic mounting at boot.
- **VDO Post-Setup**: If the installer lacks VDO support, manually install and reconfigure post-install.




Data Preservation Plan for '/home/userData' and '/usr/src/vdo'
----------------------------------------------------------------

Before performing a system update or fresh installation, take these steps to preserve data on the special mounts:

1. Documentation of Current Setup
------------------------------------
- Record current partition scheme: ``lsblk -f``
- Note mount points in ``/etc/fstab`` related to:
  - ``/home/userData`` (sdb1)
  - ``/usr/src/vdo`` (vdo device)
- Document VDO configuration: ``vdo list`` and ``vdo status``

2. Backup Critical Configuration
-----------------------------------
- Backup these files:
  - ``/etc/fstab``
  - ``/etc/vdoconf.yml`` (or equivalent VDO config)
  - Any udev rules for persistent device naming

3. Data Safety Measures
--------------------------
- For /home/userData (sdb1):
  - Optionally create backup: ``rsync -av /home/userData/ /path/to/backup/``
  - Note filesystem type: ``blkid /dev/sdb1``

- For VDO volume:
  - Stop any services using the volume
  - Check VDO health: ``vdostats --human-readable``
  - Consider backing up critical data from ``/usr/src/vdo``

4. Preparation for New System
-------------------------------
- Physically disconnect sdb and nvme0n1 during installation if paranoid
- After installation:
  - Reconnect drives
  - Recreate VDO configuration if needed
  - Restore mount points in ``/etc/fstab``
  - Verify permissions on ``/home/userData``

5. Verification Steps
------------------------
- Check data integrity after remounting
- Verify VDO volume is properly recognized
- Test access to user data

Important Notes
------------------
- The disks sdb and nvme0n1 should NOT be selected for formatting during installation
- VDO configuration may need to be reinstalled on fresh OS
- UUIDs in fstab may need updating if filesystems are recreated
