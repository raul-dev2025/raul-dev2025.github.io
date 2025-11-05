Splitting Files into Smaller Hunks for Staging
==============================================

To split a file into smaller, more granular hunks for staging using Git's interactive mode, you can use the ``git add -p`` (or ``git add --patch``) command. This allows you to interactively select which changes to stage, even within a single file. If the default splitting isn't fine-grained enough, you can manually edit the hunks to stage specific parts of the file (e.g., a list of headers or individual functions).

Steps to Split and Stage Smaller Hunks
--------------------------------------

1. **Start Interactive Staging**
   Run the following command to start interactive staging:

   .. code-block:: bash

      git add -p <file>

   Replace ``<file>`` with the path to your file.

2. **Review the Hunks**
   Git will show you the first hunk of changes. It will look something like this:

   .. code-block:: text

      diff --git a/file.txt b/file.txt
      index 1234567..89abcde 100644
      --- a/file.txt
      +++ b/file.txt
      @@ -1,5 +1,7 @@
      +Header 1
      +Header 2
      +Header 3
       Function A() {
           // Some code
       }

   Git will prompt you with options like:

   .. code-block:: text

      Stage this hunk [y,n,q,a,d,e,?]?

3. **Manually Split the Hunk**
   If the hunk is too large and you want to split it further, type ``s`` (split). Git will attempt to split the hunk into smaller, more manageable parts.

4. **Edit the Hunk Manually**
   If splitting (``s``) doesn’t give you the granularity you need, type ``e`` (edit). This will open the hunk in your default text editor, allowing you to manually edit which lines to stage.

   - In the editor, delete the lines you **don’t** want to stage.
   - Keep the lines you **do** want to stage.
   - Save and close the editor.

   For example, if you only want to stage the list of headers, you might edit the hunk to look like this:

   .. code-block:: text

      # Manual hunk edit mode
      +Header 1
      +Header 2
      +Header 3

5. **Stage the Edited Hunk**
   After editing, Git will stage only the lines you kept in the hunk.

6. **Repeat for Other Hunks**
   Git will continue showing you the remaining hunks. Repeat the process for each hunk until you’ve staged all the desired changes.

Example Workflow
----------------

Suppose you have a file ``example.txt`` with the following content:

.. code-block:: text

   Header 1
   Header 2
   Header 3
   Function A() {
       // Code for Function A
   }
   Function B() {
       // Code for Function B
   }

1. Start interactive staging:

   .. code-block:: bash

      git add -p example.txt

2. Git shows the first hunk:

   .. code-block:: text

      @@ -1,5 +1,8 @@
      +Header 1
      +Header 2
      +Header 3
       Function A() {
           // Code for Function A
       }

3. Type ``e`` to edit the hunk.
4. In the editor, delete the lines related to ``Function A``:

   .. code-block:: text

      # Manual hunk edit mode
      +Header 1
      +Header 2
      +Header 3

5. Save and close the editor. Git will stage only the headers.
6. Git will show the next hunk (if any). Repeat the process for ``Function A`` or ``Function B`` as needed.

Tips for Better Granularity
---------------------------

- Use ``s`` (split) first to see if Git can automatically split the hunk into smaller parts.
- Use ``e`` (edit) for full control over which lines to stage.
- If you make a mistake, you can always reset the staging area with ``git reset <file>`` and start over.

This approach gives you fine-grained control over staging changes, even within a single file. It’s particularly useful when working with files that contain multiple logical changes (e.g., headers, functions, or configuration blocks).
