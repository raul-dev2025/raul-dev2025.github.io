Understanding Directory Permission Strings
===========================================

When you change the group ownership and permissions of a directory (e.g., ``/usr/src/k-ver/include``), the permission string displayed by ``ls -ld`` will reflect these changes. Here’s how to interpret the permission string:

1. **File Type**:
   - The first character indicates the type of file:
     - ``d``: Directory
     - ``-``: Regular file
     - ``l``: Symbolic link

2. **Permissions**:
   - The next 9 characters represent permissions for the owner, group, and others:
     - ``r``: Read permission
     - ``w``: Write permission
     - ``x``: Execute permission (for directories, this means the ability to enter the directory).

3. **Owner and Group**:
   - The owner and group are displayed after the permissions.

4. **Example Permission Strings**:
   - Default permissions (before changes):

     .. code-block:: text

        drwxr-xr-x 2 root root 4096 Oct 10 12:34 /usr/src/k-ver/include

   - After changing group ownership:

     .. code-block:: text

        drwxr-xr-x 2 root developers 4096 Oct 10 12:34 /usr/src/k-ver/include

   - After granting group read permissions:

     .. code-block:: text

        drwxr-xr-x 2 root developers 4096 Oct 10 12:34 /usr/src/k-ver/include

   - After removing execute permissions for the group:

     .. code-block:: text

        drwxr--r-x 2 root developers 4096 Oct 10 12:34 /usr/src/k-ver/include
