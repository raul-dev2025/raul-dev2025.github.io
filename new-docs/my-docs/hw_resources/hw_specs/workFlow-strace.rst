Workflow for Using ``strace`` to Trap System Calls
====================================================

When you want to trace and analyze system calls made by a process, ``strace`` is a powerful tool. Below is a step-by-step workflow for trapping system calls using ``strace``:


1. Install ``strace``
------------------------
   - Ensure ``strace`` is installed on your system. On most Linux distributions, you can install it using:
   
  .. code-block:: bash
     
     sudo apt-get install strace # For Debian/Ubuntu
     sudo yum install strace # For CentOS/RHEL
     
----


2. Basic Usage of ``strace``
--------------------------------

   - To trace all system calls made by a program, run:
   
  .. code-block:: bash
     
     strace <command>
     
     
  Example:
     
  .. code-block:: bash
     
     strace ls -l
     
  This will display all system calls made by the ``ls -l`` command.

----


3. Trap Specific System Calls
--------------------------------

   - Use the ``-e`` option to filter specific system calls. For example, to trace only ``open`` and ``read`` system calls:
   
  .. code-block:: bash
     
     strace -e trace=open,read <command>
     
     
  Example:
     
  .. code-block:: bash
     
     strace -e trace=open,read cat /etc/passwd
     
----


4. Attach to a Running Process
--------------------------------

   - If you want to trace system calls of an already running process, use the ``-p`` option with the process ID (PID):
   
  .. code-block:: bash
     
     strace -p <PID>
     
     
  Example:
     
  .. code-block:: bash
     
     strace -p 1234
   
----


5. Save Output to a File
--------------------------

   - Redirect the output of ``strace`` to a file for later analysis:
   
  .. code-block:: bash
     
     strace -o output.txt <command>
     
     
  Example:
     
  .. code-block:: bash
     
     strace -o trace.log ls -l
     
----


6. Trace System Calls with Timestamps
----------------------------------------

   - Add timestamps to the output to see when each system call occurs:
   
  .. code-block:: bash
     
     strace -tt <command>
     
     
  Example:
     
  .. code-block:: bash
     
     strace -tt ls -l
     
----


7. Trace Child Processes
---------------------------

   - Use the ``-f`` option to trace child processes spawned by the main process:
   
  .. code-block:: bash
     
     strace -f <command>
     
     
  Example:
     
  .. code-block:: bash
     
     strace -f ./my_script.sh
     
----


8. Analyze System Call Statistics
------------------------------------

   - Use the ``-c`` option to get a summary of system calls made by the program:
   
  .. code-block:: bash
     
     strace -c <command>
     
     
  Example:
     
  .. code-block:: bash
     
     strace -c ls -l
     
----


9. Advanced Filtering
------------------------

   - Combine filters to narrow down the output. For example, trace only ``open`` system calls that fail:
   
  .. code-block:: bash
     
     strace -e trace=open -e fail=open <command>
     
     
  Example:
     
  .. code-block:: bash
     
     strace -e trace=open -e fail=open cat /nonexistent_file
     
----


10. Exit on First Error
--------------------------

	- Use the ``-e`` option with `inject` to exit when a specific system call fails:
   
  .. code-block:: bash
     
     strace -e inject=open:error=ENOENT <command>
     
  
  Example:
     
  .. code-block:: bash
     
     strace -e inject=open:error=ENOENT cat /nonexistent_file

----


Example Workflow
------------------

1. Start a program and trace its system calls:

  .. code-block:: bash
   
     strace -o trace.log -tt -f ./my_program

