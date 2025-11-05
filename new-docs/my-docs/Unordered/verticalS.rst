Vertical Space in reStructuredText
===================================

In reStructuredText (reST), there is no specific directive exclusively for adding vertical space. However, you can achieve vertical spacing using a combination of techniques, such as **blank lines**, **comments**, or **substitution definitions**. Below are the common methods to add vertical space in reST.

1. Using Blank Lines
--------------------

The simplest way to add vertical space is by inserting blank lines between paragraphs or sections. Each blank line creates a small vertical gap in the rendered output.

Example:
::

   This is the first paragraph.

   This is the second paragraph, separated by a blank line.

2. Using Comments
-----------------

You can use comments (``..``) to create larger vertical gaps. Since comments are ignored by the parser, multiple comment lines can act as vertical spacing.

Example:
::

   This is the first paragraph.

   ..
      This is a comment used to create vertical space.
   ..
      Adding multiple comment lines increases the gap.

   This is the second paragraph, with extra vertical space above it.

3. Using Substitution Definitions
---------------------------------

You can define a substitution for vertical space using raw HTML (if your output format supports it, such as HTML or PDF). This method is more advanced and requires enabling raw HTML in your reST configuration.

Example:
::

   .. |vspace| raw:: html

      <div style="margin-bottom: 2em;"></div>

   This is the first paragraph.

   |vspace|

   This is the second paragraph, with custom vertical space.

4. Using Raw LaTeX (for PDF Output)
-----------------------------------

If you are generating PDF output (e.g., with Sphinx and LaTeX), you can use raw LaTeX to add vertical space.

Example:
::

   .. raw:: latex

      \vspace{2cm}

   This is the first paragraph.

   .. raw:: latex

      \vspace{1cm}

   This is the second paragraph, with custom vertical space.

5. Using CSS (for HTML Output)
------------------------------

If your output format is HTML, you can use raw HTML with inline CSS to add vertical space.

Example:
::

   .. raw:: html

      <div style="margin-bottom: 50px;"></div>

   This is the first paragraph.

   .. raw:: html

      <div style="margin-bottom: 30px;"></div>

   This is the second paragraph, with custom vertical space.

6. Using Admonitions (Indirect Spacing)
--------------------------------------

Admonitions (e.g., ``.. note::``, ``.. warning::``) inherently add vertical space around them. You can use an empty admonition to create spacing.

Example:
::

   This is the first paragraph.

   .. note::
      This note adds vertical space around it.

   This is the second paragraph, with vertical space added by the note.

Summary of Methods
------------------

+-------------------------+-----------------------------------+-------------------------------------------------------------------------+
|         Method          |            Use Case               |                            Example                                      |
+=========================+===================================+=========================================================================+
|     **Blank Lines**     | Simple spacing between paragraphs |          Add one or more blank lines between paragraphs.                |
+-------------------------+-----------------------------------+-------------------------------------------------------------------------+
|      **Comments**       |           Larger gaps             |        Use multiple ``..`` comment lines to create vertical space.      |
+-------------------------+-----------------------------------+-------------------------------------------------------------------------+
| **Substitution + HTML** |   Custom spacing in HTML output   |         Define a substitution with raw HTML for precise control.        |
+-------------------------+-----------------------------------+-------------------------------------------------------------------------+
|     **Raw LaTeX**       |   Custom spacing in PDF output    |                 Use ``\vspace{}`` in raw LaTeX blocks.                  |
+-------------------------+-----------------------------------+-------------------------------------------------------------------------+
|   **Raw HTML + CSS**    |   Custom spacing in HTML output   |             Use raw HTML with inline CSS for precise control.           |
+-------------------------+-----------------------------------+-------------------------------------------------------------------------+
|    **Admonitions**      |          Indirect spacing         |   Use an admonition (e.g., ``.. note::``) to add space around content.  |
+-------------------------+-----------------------------------+-------------------------------------------------------------------------+

Recommendation
--------------

- For simple spacing, use **blank lines** or **comments**.
- For precise control in HTML output, use **raw HTML with CSS**.
- For PDF output, use **raw LaTeX**.
- Avoid overusing vertical space, as it can make the document harder to read. Use it sparingly and only when necessary.
