Tracking Untracked Files Without Staging Them
=============================================

To track untracked files in a Git repository without staging them, follow these steps:

1. **Add the Untracked Files to the Index Temporarily**
   Use the ``git add`` command with the ``--intent-to-add`` (or ``-N``) option. This tells Git to track the file but does not stage its content. The file will appear as "modified but unstaged" in the status.

   .. code-block:: bash

      git add --intent-to-add <file>

   For example, if you have an untracked file named ``example.txt``, you would run:

   .. code-block:: bash

      git add --intent-to-add example.txt

2. **Check the Status**
   After running the above command, check the status using:

   .. code-block:: bash

      git status

   The file will now appear under "Changes not staged for commit" (modified but unstaged).

3. **Optional: Untrack the File Later**
   If you decide you no longer want to track the file, use ``git rm --cached`` to stop tracking it:

   .. code-block:: bash

      git rm --cached <file>

   This will remove the file from the index but keep it in your working directory.

Example Workflow
----------------

1. Suppose you have an untracked file ``newfile.txt``.
2. Run:

   .. code-block:: bash

      git add --intent-to-add newfile.txt

3. Check the status:

   .. code-block:: bash

      git status

   Output:

   .. code-block:: text

      On branch main
      Changes not staged for commit:
        (use "git add <file>..." to update what will be committed)
        (use "git restore <file>..." to discard changes in working directory)
              modified: newfile.txt

Now the file is tracked but not staged, and it shows up as "modified but unstaged" in the status.

This approach is useful when you want to track changes to a file without committing it immediately.
