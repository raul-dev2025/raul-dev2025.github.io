Viewing Stashed Changes in Git
=============================

You can inspect the content of a stashed change in Git using the following commands:

1. Show Summary of Latest Stash
-------------------------------
.. code-block:: bash

   git stash show

2. Show Full Diff of Latest Stash
---------------------------------
.. code-block:: bash

   git stash show -p

3. Show Specific Stash (if multiple exist)
------------------------------------------
First, list all stashes:

.. code-block:: bash

   git stash list

Then view a specific stash (e.g., ``stash@{1}``):

.. code-block:: bash

   git stash show -p stash@{1}

4. View Actual File Content (Not Just Diff)
-------------------------------------------
To examine the actual file content:

.. code-block:: bash

   git stash apply --index

This applies the stash to your working directory. To undo:

.. code-block:: bash

   git reset --hard
   git stash drop # optional: removes the stash from stack

**Important Notes**:

- Use ``git stash apply`` cautiously as it modifies your working directory.
- The ``-p`` flag shows patch format (full diff).
- Stashes are referenced as ``stash@{n}`` where n is the stash index.
