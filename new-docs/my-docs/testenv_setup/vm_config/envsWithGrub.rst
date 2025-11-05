Understanding ``grub2-editenv list`` Output: Saved Entry Hash
============================================================

When ``sudo grub2-editenv list`` prints a ``saved_entry`` hash, this indicates GRUB is using an **environment block file** (``grubenv``) to store persistent variables, including the default boot entry.

1. What is the ``grubenv`` File?
--------------------------------------------------
- **Location**: ``/boot/grub2/grubenv`` (or ``/boot/grub/grubenv``).
- **Purpose**: Stores GRUB environment variables that persist across reboots.
- **Key Variable**: ``saved_entry`` specifies the default menu entry (by hash/index).

2. Decoding the ``saved_entry`` Hash
--------------------------------------------------
- The value is a **hash or numeric index** referring to an entry in ``grub.cfg``.
- Example output:
  .. code-block:: bash

      saved_entry=1a2b3c4d

3. Why a Hash Instead of a Name?
--------------------------------------------------
- GRUB uses hashes to:
  - Avoid dependency on menu entry titles (which may change).
  - Ensure consistency if ``grub.cfg`` is regenerated.
- The hash is derived from the menu entry’s content (kernel paths, boot args, etc.).

4. Mapping the Hash to a Boot Entry
--------------------------------------------------
To find which menu entry the hash refers to:
1. List all menu entries with their hashes:
   .. code-block:: bash

       sudo grep -oP 'menuentry.* --id \K[^ ]+' /boot/grub2/grub.cfg

2. Cross-reference the ``saved_entry`` hash with the output.

5. Example Workflow
--------------------------------------------------
1. Check the current ``saved_entry``:
   .. code-block:: bash

       sudo grub2-editenv list

2. Find the matching menu entry:
   .. code-block:: bash

       sudo grep -B1 -- '--id 3e4567f8' /boot/grub2/grub.cfg

6. Implications for Your VM
--------------------------------------------------
- If ``grub.cfg`` lacks ``linux``/``initrd`` lines, GRUB might:
  - Use the ``saved_entry`` hash to load a **statically configured entry**.
  - Rely on **embedded paths** in ``core.img``.

7. Next Steps
--------------------------------------------------
1. Verify the ``saved_entry`` mapping.
2. Check for embedded paths in ``core.img``:
   .. code-block:: bash

       strings /boot/grub2/i386-pc/core.img | grep -iE 'linux|initrd'
3. Review ``grubenv`` for other variables.
