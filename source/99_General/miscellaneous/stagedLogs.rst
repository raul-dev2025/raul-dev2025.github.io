Viewing the Log of Staged Changes in Git
=======================================

To view the log of changes that are staged (to be committed) in Git, you can use the ``git diff`` command with the ``--cached`` option. This shows the differences between the staging area (index) and the last commit.

Command to View Staged Changes
------------------------------

.. code-block:: bash

   git diff --cached

This will display the changes that are staged and ready to be committed. The output will look similar to a standard ``git diff``, showing additions (``+``) and deletions (``-``) for each file.

Example Output
--------------

.. code-block:: diff

   diff --git a/example.txt b/example.txt
   index 1234567..89abcde 100644
   --- a/example.txt
   +++ b/example.txt
   @@ -1,5 +1,7 @@
   +Header 1
   +Header 2
   +Header 3
    Function A() {
        // Some code
    }

Additional Options
-----------------

1. **View Staged Changes for a Specific File**
   If you only want to see the staged changes for a specific file, you can specify the file path:

   .. code-block:: bash

      git diff --cached <file>

   Example:

   .. code-block:: bash

      git diff --cached example.txt

2. **View a Summary of Staged Changes**
   If you want a summary of which files are staged (without the detailed diff), use:

   .. code-block:: bash

      git status

   This will show a section like:

   .. code-block:: text

      Changes to be committed:
        (use "git restore --staged <file>..." to unstage)
              modified: example.txt

3. **View Staged Changes in a Compact Format**
   Use the ``--stat`` option to see a summary of changes:

   .. code-block:: bash

      git diff --cached --stat

   Example output:

   .. code-block:: text

      example.txt | 3 +++
      1 file changed, 3 insertions(+)

4. **View Staged Changes with Color**
   If you want colored output for better readability, use:

   .. code-block:: bash

      git diff --cached --color

Notes
-----

- The ``--cached`` option is synonymous with ``--staged`` in newer versions of Git. You can use either:

  .. code-block:: bash

     git diff --staged

- If no changes are staged, running ``git diff --cached`` will produce no output.

This command is useful for reviewing what will be included in your next commit before actually committing the changes.
