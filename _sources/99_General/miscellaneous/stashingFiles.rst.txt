Stashing Files Independently in Git
=====================================

To stash each modified file independently in Git, you have several options:

Method 1: Interactive Stash
-----------------------------

.. code-block:: bash

   git stash push -p

This command will:

1. Show each change (hunk) interactively
2. Ask if you want to stash it (y/n)
3. Allow splitting changes further (s)
4. Let you quit the process (q)

Method 2: Stash by File Path
------------------------------

For each file you want to stash separately:

.. code-block:: bash

   git stash push -m "stash message" -- path/to/file

Example:

.. code-block:: bash

   git stash push -m "stashed config.js" -- src/config.js
   git stash push -m "stashed styles" -- src/styles.css

Method 3: Temporary Commits (Alternative)
-------------------------------------------

1. Add and commit each file separately:

   .. code-block:: bash

      git add file1.txt
      git commit -m "temp commit for file1"
      
      git add file2.txt
      git commit -m "temp commit for file2"

2. When restoring:

   .. code-block:: bash

      git reset HEAD~2 # undo the last 2 commits but keep changes

Managing Stashes
------------------

- List stashes: ``git stash list``
- View stash contents: ``git stash show -p stash@{n}``
- Apply stash: ``git stash apply stash@{n}``
- Drop stash: ``git stash drop stash@{n}``

.. note::

   Stashing files independently creates multiple stash entries. Use descriptive messages for easier management.
   
----
   
**Stashing Files Independently in Git 1.8**
---------------------------------------------

For Git version 1.8 (released 2012-10-21), the stash functionality is more limited. Here are the approaches:

Method 1: Interactive Stash (Available)
-----------------------------------------

.. code-block:: bash

   git stash --keep-index -p

This works similarly to newer versions:

1. Shows changes interactively
2. Prompts for each hunk (y/n/s/q)

Method 2: Stash by File (Alternative)
---------------------------------------

Git 1.8 doesn't support direct path-based stashing. Instead:

1. Create patches for each file:

   .. code-block:: bash

      git diff -- path/to/file > file.patch

2. Revert the changes:

   .. code-block:: bash

      git checkout -- path/to/file

3. Later, apply the patch:

   .. code-block:: bash

      git apply file.patch

Method 3: Temporary Commits
-----------------------------

Same as newer versions:

.. code-block:: bash

   git add file1.txt
   git commit -m "temp commit for file1"
   
   git add file2.txt
   git commit -m "temp commit for file2"

Then later:

.. code-block:: bash

   git reset HEAD~2

Important Notes for Git 1.8
-----------------------------

- The modern ``git stash push`` syntax isn't available (use ``git stash save``)
- No path-based stashing (``git stash -- <path>`` not supported)
- Interactive mode (``-p``) is your best option
- Consider upgrading if you frequently need this functionality

.. warning::

   Git 1.8 reached end-of-life in 2014. Many modern features won't be available.
