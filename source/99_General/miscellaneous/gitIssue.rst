How to Open a GitHub Issue for LTP Kernel Headers Problem
============================================================

1. Navigate to LTP Issues Page
--------------------------------

- Go to: `LTP GitHub Issues <https://github.com/linux-test-project/ltp/issues>`_
- Click "New Issue"

2. Issue Title
-----------------

Use a specific, descriptive title:

.. code-block:: none

  "Kernel headers not found during ./configure on CentOS 7 (kernel 3.10)"

3. Issue Body Template
------------------------

Copy and paste this structured template:

.. code-block:: markdown

  ### Description
  When building LTP on **CentOS 7 (kernel 3.10)**, the `./configure` script fails to locate kernel headers (`mm.h`, `module.h`) even though `kernel-devel` is installed.
  I tried specifying `--with-kernel-dir` explicitly, but the headers are still not found.

  ### Steps to Reproduce
  1. Clean LTP checkout:
     ```sh
     git clone https://github.com/linux-test-project/ltp.git
     cd ltp
     ```
  2. Run configure:
     ```sh
     ./configure --with-kernel-dir=/usr/src/kernels/$(uname -r)
     ```
     *(Also tried `/lib/modules/$(uname -r)/build`)*

  ### Expected Behavior
  `./configure` should detect kernel headers and proceed with the build.

  ### Actual Behavior
  Error:
    configure: error: Kernel headers not found in /usr/src/kernels/3.10.0-1160.el7.x86_64


  ### System Details

	- **OS**: CentOS 7
	- **Kernel**: `3.10.0-1160.el7.x86_64`
	- **Kernel headers installed**:
		```sh
		rpm -q kernel-devel-$(uname -r)
		kernel-devel-3.10.0-1160.el7.x86_64
		```
	- **LTP Version**: `20150903` (also tested with latest `upstream/master`)

  ### Additional Checks
	- Headers exist at:
		```sh
		ls /usr/src/kernels/$(uname -r)/include/linux/mm.h
		```
		*(If not, where should they be?)*

  ### Question
	Is there a known workaround for CentOS 7? Am I missing a required symlink or environment variable?

4. Attach Logs (If Needed)
-----------------------------

To include configuration logs:

.. code-block:: sh

  ./configure --with-kernel-dir=... 2>&1 | tee configure.log

Then drag-and-drop ``configure.log`` into the GitHub issue.

5. Submit and Follow Up
--------------------------

- Click "Submit new issue"
- Monitor email notifications for responses
- If no reply after 3-5 days, politely bump the thread or ask on the `LTP mailing list <mailto:ltp@lists.linux.it>`_

Additional Notes
------------------

- The LTP team typically responds within a few business days
- Ensure you've:

- Installed all dependencies (``kernel-devel``, ``gcc``, ``make``)
- Verified header paths exist
- Tested with both:

  - ``/usr/src/kernels/$(uname -r)``
  - ``/lib/modules/$(uname -r)/build``

Download this file as ``ltp_issue_template.rst`` for future reference.
