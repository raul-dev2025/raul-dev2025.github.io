LTP Configuration Debugging Analysis
======================================

Flex (Lex) Error Resolution
-----------------------------

- **Issue**: Linker error ``undefined reference to yywrap`` due to missing Flex library (``-lfl``).
- **Resolution**: Configure script auto-detected and added ``-lfl`` to linker flags::

    configure:4221: gcc -o conftest -DDISABLE_DMAPI conftest.c -lfl >&5
    configure:4221: $? = 0 # Success!

- **Action**: Ensure ``flex-devel`` is installed (verified in logs).

Missing Headers
-----------------

Critical Missing Headers
~~~~~~~~~~~~~~~~~~~~~~~~~~

+----------------------+-------------------------------------------+-----------------------------------+----------------------------------+
| Header | Error | Impact | Fix |
+======================+===========================================+===================================+==================================+
| ``dmapi.h`` | ``fatal error: dmapi.h: No such file`` | DMAPI tests disabled. | Install ``xfsprogs-devel``. |
+----------------------+-------------------------------------------+-----------------------------------+----------------------------------+
| ``linux/module.h`` | ``fatal error: linux/module.h: Not found``| Kernel module tests skipped. | Install ``kernel-devel``. |
+----------------------+-------------------------------------------+-----------------------------------+----------------------------------+
| ``sys/jfsdmapi.h`` | JFS-specific tests disabled. | Rarely required. | Ignore if JFS not used. |
+----------------------+-------------------------------------------+-----------------------------------+----------------------------------+

Successful Header Checks
~~~~~~~~~~~~~~~~~~~~~~~~~~

- Core headers found:

  - ``pthread.h``, ``libaio.h``, ``sys/epoll.h``
  - ``openssl/sha.h``, ``sys/prctl.h``

Kernel Headers Path Issue
---------------------------

- **Error**::

    /usr/src/kernels/3.10.0-1160.118.1.el7.x86_64/include/linux/module.h:9:24: fatal error: linux/list.h: No such file or directory

- **Root Cause**: Kernel headers missing or mislinked.
- **Fix**::

    sudo yum install kernel-devel-$(uname -r)
    ln -s /usr/src/kernels/$(uname -r) /usr/src/linux

Security Hardening (``_FORTIFY_SOURCE``)
------------------------------------------

- **Test Failed**::

    conftest.c:42:3: error: #error Compiling without optimizations

- **Reason**: ``_FORTIFY_SOURCE=2`` requires ``-O2`` optimizations.
- **Fix**: Re-run configure with::

    CFLAGS="-O2" ./configure [options]

Ptrace Support
----------------

- **Detected**:

  - ``sys/ptrace.h``, ``linux/ptrace.h``
  - ``struct pt_regs``

- **Missing**:

  - ``struct user_regs_struct``
  - ``struct ptrace_peeksiginfo_args``

Final Recommendations
-----------------------

1. Install missing packages::

    sudo yum install kernel-devel-$(uname -r) xfsprogs-devel libcap-devel openssl-devel

2. Re-run configure with optimizations::

    CFLAGS="-O2" ./configure --with-linux-version=$(uname -r) --with-linux-dir=/usr/src/kernels/$(uname -r)

3. Verify kernel headers::

    ls /usr/src/kernels/$(uname -r)/include/linux/module.h

4. Build LTP::

    make && sudo make install
