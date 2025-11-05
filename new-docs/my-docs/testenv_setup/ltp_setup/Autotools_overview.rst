Overview of Autotools Primary Concepts
========================================

Autotools is a suite of programming tools (autoconf, automake, libtool) designed to make source code packages portable across Unix-like systems. Here are its core concepts:

Primary Components
---------------------

1. **Autoconf** - Generates ``configure`` scripts that check system features
2. **Automake** - Creates portable ``Makefile.in`` templates from ``Makefile.am`` files
3. **Libtool** - Manages the creation of static and shared libraries portably

Workflow
----------

1. Developer writes:

   * ``configure.ac`` (input for autoconf)
   * ``Makefile.am`` (input for automake)
   
2. Running ``autoreconf`` generates:

   * ``configure`` script
   * ``Makefile.in`` templates
   
3. End user runs:

   * ``./configure`` → generates ``Makefile``s
   * ``make`` → builds the software
   * ``make install`` → installs the software

Frequently Used Variables
----------------------------

Project Information Variables (set in configure.ac)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* ``AC_INIT([package], [version], [bug-report])`` - Initializes package info
* ``AC_CONFIG_SRCDIR([file])`` - Identifies project location
* ``AC_CONFIG_HEADERS([config.h])`` - Sets up config header
* ``AC_CONFIG_FILES([Makefile dir/Makefile])`` - Specifies output files

Build Control Variables (often set before running configure)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* ``CC`` - C compiler to use (e.g., ``CC=gcc``)
* ``CFLAGS`` - C compiler flags
* ``CXX`` - C++ compiler
* ``CXXFLAGS`` - C++ compiler flags
* ``LDFLAGS`` - Linker flags
* ``LIBS`` - Libraries to link against
* ``CPPFLAGS`` - C preprocessor flags (-I, -D options)
* ``prefix`` - Installation prefix (/usr/local by default)
* ``exec_prefix`` - Architecture-dependent files prefix
* ``bindir`` - User executables directory
* ``libdir`` - Library files directory
* ``includedir`` - Header files directory
* ``datarootdir`` - Read-only architecture-independent data root

Automake Variables (set in Makefile.am)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* ``bin_PROGRAMS`` - Programs to install in bindir
* ``lib_LIBRARIES`` - Libraries to install in libdir
* ``include_HEADERS`` - Headers to install in includedir
* ``SOURCES`` - Source files for a target
* ``CFLAGS``, ``CXXFLAGS`` - Package-specific flags
* ``LDADD`` - Additional linker flags for a target
* ``SUBDIRS`` - Subdirectories to process recursively
* ``EXTRA_DIST`` - Additional files to include in distribution
* ``BUILT_SOURCES`` - Generated sources needed before compilation
* ``TESTS`` - Test programs to run with ``make check``

Commonly Used Macros
~~~~~~~~~~~~~~~~~~~~~~~

* ``AC_PROG_CC`` - Check for C compiler
* ``AC_PROG_CXX`` - Check for C++ compiler
* ``AC_CHECK_LIB`` - Check for library presence
* ``AC_CHECK_HEADER`` - Check for header presence
* ``AC_PATH_PROG`` - Check for program in PATH
* ``AC_MSG_CHECKING``/``AC_MSG_RESULT`` - User feedback during configure
* ``AM_INIT_AUTOMAKE`` - Initialize automake
* ``PKG_CHECK_MODULES`` - Check for pkg-config modules

Autotools provides a robust, portable build system that handles platform differences automatically, though it has a steep learning curve. The variables listed above are the most commonly used to control the build process.
