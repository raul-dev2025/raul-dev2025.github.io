Check Headers
==============

1. **Can** ``AC_CHECK_HEADERS`` **be defined more than once in** ``configure.ac`` **?**
   Yes, ``AC_CHECK_HEADERS`` can be used multiple times in ``configure.ac``. Each call to ``AC_CHECK_HEADERS`` checks for the presence of the specified headers and defines preprocessor macros (e.g., ``HAVE_HEADER_H``) if the headers are found. For example:

   .. code-block:: m4

      AC_CHECK_HEADERS([dmapi.h ifaddrs.h libaio.h])
      AC_CHECK_HEADERS([mm.h linux/module.h])

   This is perfectly valid and allows you to organize the checks logically or add new checks without modifying existing ones.

2. **Explanation of** ``--with-kernel`` **or similar options**;

   In the *confFlags.log* file you provided, there are two relevant options for specifying kernel-related paths:

   - ``--with-linux-version=VERSION``: This option allows you to specify the Linux kernel version for which the LTP (Linux Test Project) should be configured. This is useful if you are building kernel modules or tests that depend on a specific kernel version.

   - ``--with-linux-dir=DIR`` : This option allows you to specify the path to the kernel development directory (e.g., ``/usr/src/k-ver``). This directory typically contains the kernel headers and source files needed for building kernel modules or tests.

   For example, if your kernel headers are located in ``/usr/src/k-ver``, you can run:

   .. code-block:: bash

      ./configure --with-linux-dir=/usr/src/k-ver

   This tells the ``configure`` script to look for kernel headers in ``/usr/src/k-ver/include`` instead of the default locations like ``/usr/include``.

3. **Explanation of** ``AC_MSG_CHECKING`` **and** ``AC_MSG_RESULT``;
   These are Autoconf macros used to provide user-friendly output during the configuration process.

   - ``AC_MSG_CHECKING([for header search paths])``:
     This macro prints a message to the user indicating what the script is currently checking. In this case, it will print:

     .. code-block:: text

        checking for header search paths...

   - ``AC_MSG_RESULT([$CPPFLAGS])``:
     This macro prints the result of the check. It takes a single argument, which is typically a variable or value. In this case, it will print the value of ``$CPPFLAGS``, which contains the preprocessor flags (e.g., ``-I`` include paths). For example, if *CPPFLAGS* is set to ``-I/usr/src/k-ver/include``, the output will look like:

     .. code-block:: text

        checking for header search paths... -I/usr/src/k-ver/include

   Together, these macros provide feedback to the user about the search paths being used for header files. This is useful for debugging or verifying that the correct paths are being used.

4. **How to use** ``CPPFLAGS`` **to specify custom include paths**,
i59
   If you want to ensure that the *configure* script searches for headers in ``/usr/src/k-ver/include``, you can set the ``CPPFLAGS`` environment variable before running ``configure``:

   .. code-block:: bash

      export CPPFLAGS="-I/usr/src/k-ver/include"
      ./configure

   This adds ``/usr/src/k-ver/include`` to the list of directories where the preprocessor will look for header files.

5. **Modifying** ``configure.ac`` **to handle custom paths,**
   If you want to modify ``configure.ac`` to handle custom paths or provide better feedback, you can add the following:

   .. code-block:: m4

      # Check for custom header paths
      AC_MSG_CHECKING([for header search paths])
      AC_MSG_RESULT([$CPPFLAGS])

      # Check for specific headers
      AC_CHECK_HEADERS([dmapi.h mm.h linux/module.h sys/jfsdmapi.h], [], [
        AC_MSG_WARN([Required headers not found. Ensure kernel headers are installed.])
      ])

	This will:
		- Print the header search paths being used.
		- Check for the required headers.
		- Print a warning if any headers are missing.

**Summary**

- ``AC_CHECK_HEADERS`` can be used multiple times in ``configure.ac``.
- Use ``--with-linux-dir`` to specify the kernel headers directory.
- ``AC_MSG_CHECKING`` and ``AC_MSG_RESULT`` provide user-friendly output during configuration.
- Set ``CPPFLAGS`` to add custom include paths for header searches.

