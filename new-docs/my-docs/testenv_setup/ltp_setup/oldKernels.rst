Working with Older Kernel Versions on CentOS 7: Challenges and Solutions
======================================================================

Introduction
--------------

When developing or testing kernel-related code on CentOS 7 systems, working with older kernel versions presents unique challenges. This document outlines solutions specifically validated on CentOS 7.9 (Final).

Challenges with Older Kernels on CentOS 7
------------------------------------------

1. **Header Availability Issues**

   - Missing headers in default installations
   - Version mismatches between installed headers and running kernel
   - Deprecated interfaces in newer kernel-devel packages

2. **Toolchain Compatibility**

   - CentOS 7's default GCC 4.8.5 may be too old/new for certain kernels
   - SELinux context requirements for system headers
   - Potential need for Developer Toolset (devtoolset) packages

3. **Dependency Management**

   - Requires ``kernel-devel`` package matching running kernel version
   - Potential conflicts with ``elfutils-libelf-devel`` versions
   - EPEL repository often needed for additional dependencies

Case Study: LTP Build System Header Missing Issue
---------------------------------------------------

The Problem
~~~~~~~~~~~~~~

On CentOS 7.9, the LTP build system failed because:

- Required kernel headers were missing (``syscall.h`` not found)
- Installed ``kernel-devel`` package didn't match running kernel version
- Build system expected legacy header locations

CentOS 7 Solution Approach
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Verify and Install Correct Headers**

   .. code-block:: bash

      # Check running kernel version
      uname -r
      # Install matching headers
      sudo yum install kernel-devel-$(uname -r)
      # Install base development tools
      sudo yum groupinstall "Development Tools"
      sudo yum install elfutils-libelf-devel

2. **Header Linking Workaround**

   .. code-block:: bash

      # Create necessary symbolic links
      cd /usr/include/asm && sudo ln -sf ../asm-generic/unistd.h unistd.h
      # Verify SELinux context
      sudo restorecon -v /usr/include/asm/unistd.h

3. **Validation**

   .. code-block:: bash

      # Verify headers are accessible
      ls -l /usr/include/asm/unistd.h
      # Check build environment
      make --version
      gcc --version

Best Practices for CentOS 7
----------------------------

1. **Environment Isolation**

   - Use ``yum history`` to track changes
   - Consider Docker containers with CentOS 7 base image

2. **Version Management**

   - Maintain multiple kernel-devel RPMs in local repository
   - Use ``yum versionlock`` to prevent unwanted updates

3. **Documentation**

   - Record exact kernel and package versions
   - Document all symbolic links created

4. **Cleanup Procedures**

   .. code-block:: bash

      # Remove symbolic links
      sudo rm -f /usr/include/asm/unistd.h
      # Verify system integrity
      sudo rpm --verify kernel-devel

CentOS 7 Specific Notes
------------------------

- Tested on CentOS 7.9 with kernel versions 3.10.0-1160 through 3.10.0-1160.76.1
- Requires EPEL repository for some dependencies::

    sudo yum install epel-release
- For newer toolchains::

    sudo yum install centos-release-scl
    sudo yum install devtoolset-9

Conclusion
-----------

Working with older kernels on CentOS 7 requires careful version management and understanding of RHEL-based system conventions. The presented solution provides a stable foundation for LTP development while maintaining system integrity.

Version History
----------------

- 2023-11-15: Initial version validated on CentOS 7.9.2009
- 2023-11-16: Added devtoolset and EPEL notes
