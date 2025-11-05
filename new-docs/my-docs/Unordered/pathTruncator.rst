Integrating Path Truncation into Read the Docs
==============================================

This guide explains how to propagate the `truncatePath` functionality into your Read the Docs (Sphinx) project. You can achieve this by either injecting custom JavaScript into the generated HTML files or modifying paths during the Sphinx build process.

Option 1: Inject Custom JavaScript into Sphinx HTML Output
---------------------------------------------------------

This approach dynamically truncates paths in the browser when the documentation is viewed.

### Steps:

1. **Create a Custom JavaScript File**
   Save the `truncatePath` function in a file named `truncator.js` inside your Sphinx project's `_static` directory (e.g., `_static/js/truncator.js`).

   .. code-block:: javascript

      // _static/js/truncator.js
      function truncatePath(path, segmentsToKeep = 2) {
          const segments = path.split('/').filter(segment => segment.length > 0);
          const truncatedSegments = segments.slice(-segmentsToKeep);
          return truncatedSegments.join('/') + '/';
      }

      // Apply truncation to all elements with a `data-path` attribute
      document.addEventListener('DOMContentLoaded', () => {
          const elements = document.querySelectorAll('[data-path]');
          elements.forEach(element => {
              const fullPath = element.getAttribute('data-path');
              const truncatedPath = truncatePath(fullPath);
              element.textContent = truncatedPath;
          });
      });

2. **Include the Script in Your Sphinx Project**
   Modify your `conf.py` file to include the custom JavaScript file in the HTML output.

   .. code-block:: python

      # conf.py
      html_static_path = ['_static'] # Ensure this points to your static files directory

      html_js_files = [
          'js/truncator.js', # Add the custom JavaScript file
      ]

3. **Mark Elements for Truncation in Your Documentation**
   In your `.rst` or `.md` files, use the `data-path` attribute to mark elements that need truncation.

   .. code-block:: rst

      .. role:: path
         :class: path

      This is a long path: :path:`/very/very/long/long/to/some/path/`.

   Alternatively, you can directly use HTML in your reStructuredText or Markdown files:

   .. code-block:: rst

      This is a long path: <span data-path="/very/very/long/long/to/some/path/">/very/very/long/long/to/some/path/</span>.

4. **Rebuild Your Documentation**
   Run the Sphinx build command to regenerate your documentation:

   .. code-block:: bash

      make html

   The generated HTML files will now include the `truncator.js` script, and paths marked with `data-path` will be truncated dynamically when viewed in a browser.

Option 2: Modify Paths During the Sphinx Build Process
------------------------------------------------------

This approach truncates paths **statically** during the build process.

### Steps:

1. **Create a Sphinx Extension**
   Write a custom Sphinx extension that processes paths in your documentation files.

   .. code-block:: python

      # truncate_paths.py
      from sphinx.util.docutils import SphinxDirective
      from docutils import nodes

      def truncate_path(path, segments_to_keep=2):
          segments = [seg for seg in path.split('/') if seg]
          truncated = '/'.join(segments[-segments_to_keep:]) + '/'
          return truncated

      class PathTruncator(SphinxDirective):
          has_content = True

          def run(self):
              raw_path = ' '.join(self.content)
              truncated_path = truncate_path(raw_path)
              node = nodes.Text(truncated_path)
              return [node]

      def setup(app):
          app.add_directive('truncate-path', PathTruncator)

2. **Add the Extension to Your `conf.py`**
   Include the custom extension in your Sphinx configuration:

   .. code-block:: python

      # conf.py
      extensions = [
          'truncate_paths', # Add your custom extension
      ]

3. **Use the Directive in Your Documentation**
   In your `.rst` files, use the `truncate-path` directive to truncate paths:

   .. code-block:: rst

      This is a long path: :truncate-path:`/very/very/long/long/to/some/path/`.

4. **Rebuild Your Documentation**
   Run the Sphinx build command:

   .. code-block:: bash

      make html

   The paths will be truncated during the build process and included in the generated HTML files.

Option 3: Use a Sphinx Post-Processing Hook
-------------------------------------------

This approach processes all paths in your documentation files after they are parsed but before they are rendered.

### Steps:

1. **Add a Post-Processing Hook in `conf.py`**
   Modify your `conf.py` to include a hook that processes paths:

   .. code-block:: python

      # conf.py
      def truncate_paths(app, doctree, docname):
          for node in doctree.traverse():
              if isinstance(node, nodes.Text):
                  if '/very/very/long/long/to/' in node.astext():
                      truncated = truncate_path(node.astext())
                      node.parent.replace(node, nodes.Text(truncated))

      def truncate_path(path, segments_to_keep=2):
          segments = [seg for seg in path.split('/') if seg]
          truncated = '/'.join(segments[-segments_to_keep:]) + '/'
          return truncated

      def setup(app):
          app.connect('doctree-resolved', truncate_paths)

2. **Rebuild Your Documentation**
   Run the Sphinx build command:

   .. code-block:: bash

      make html

   The paths will be truncated during the post-processing phase.

Summary
-------

- **Option 1** is best if you want dynamic truncation in the browser.
- **Option 2** is best if you want static truncation during the build process.
- **Option 3** is best if you want to process all paths globally during the build.

For further assistance, refer to the Sphinx documentation or reach out for help!
