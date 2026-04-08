Involuntary Directory Removal
===============================

In Linux, there are several mechanisms you can use to warn users about the potential risks of *involuntary directory removal*. Here are a few approaches:


1. **Alias for** ``rm`` **Command**

   You can create an alias for the ``rm`` command that warns users before deleting directories. Add the following to your shell configuration file (e.g., ``.bashrc``, ``.zshrc``):


  Example:
  
  .. code-block:: bash
  
     alias rm='rm -i'


This will prompt the user for confirmation before deleting any file or directory. However, this is not specific to directories.
To make it directory-specific, you could create a custom function:

  .. code-block:: bash
   
		 rm() {
			   for arg in "$@"; do
			       if [ -d "$arg" ]; then
			           echo "Warning: You are about to remove a directory: $arg"
			           read -p "Are you sure? (y/n) " confirm
			           if [ "$confirm" != "y" ]; then
			               echo "Aborted."
			               return 1
			           fi
			       fi
			   done
			   command rm "$@"
		 }


   Add this to your shell configuration file, and it will warn users before deleting directories.

----


2. **Using** ``chattr`` **to Make Directories Immutable**

   You can use the ``chattr`` command to make directories immutable, preventing them from being deleted accidentally:

   .. code-block:: bash
   
			sudo chattr +i /path/to/directory
   

   This will make the directory immutable, and even the root user won't be able to delete it without first removing the immutable flag:

   .. code-block:: bash
   
			sudo chattr -i /path/to/directory
   

   This is a strong measure but may not be practical for all use cases.

----


3. **Custom Script for Directory Deletion**

   Create a custom script for directory deletion that includes warnings and checks. For example:

	.. code-block:: bash
   
		 #!/bin/bash

		 if [ -z "$1" ]; then
		     echo "Usage: safe_rmdir <directory>"
		     exit 1
		 fi

		 if [ -d "$1" ]; then
		     echo "Warning: You are about to remove the directory: $1"
		     read -p "Are you sure? (y/n) " confirm
		     if [ "$confirm" == "y" ]; then
		         rm -r "$1"
		         echo "Directory removed."
		     else
		         echo "Aborted."
		     fi
		 else
		     echo "Error: $1 is not a directory."
		 fi
   

   Save this script as ``safe_rmdir``, make it executable (``chmod +x safe_rmdir``), and place it in a directory in your ``PATH``. Encourage users to use this script instead of ``rm -r``.


----

4. **Using** ``rm -I`` **for Interactive Prompts**

   The ``rm`` command has an ``-I`` option that provides a single prompt before removing more than three files or when removing recursively. This is less intrusive than ``-i`` but still provides some protection:

	.. code-block:: bash
   
		 rm -I -r /path/to/directory
   

   You can alias ``rm`` to always include ``-I``:

   .. code-block:: bash
   
   		alias rm='rm -I'
   

----

5. **Filesystem-Level Protections**

   If you have control over the filesystem, you can use tools like ``btrfs`` or ``zfs`` to create snapshots of directories. This won't prevent deletion, but it allows you to recover deleted directories easily.


----

6. **Audit and Monitoring Tools**

   Use tools like ``auditd`` to monitor file and directory deletions. While this won't prevent deletions, it can log them and alert administrators:

   .. code-block:: bash
   
   		sudo auditctl -w /path/to/directory -p wa -k dir_deletion
   

   This will log any write or attribute changes to the directory, including deletions.

----


7. **Educate Users**

   Sometimes the best mechanism is education. Make sure users understand the risks of using commands like ``rm -r`` and encourage them to double-check paths before executing such commands.

By combining these approaches, you can significantly reduce the risk of involuntary directory removal.
