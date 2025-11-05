List of Symbols
=====================


Text Formatting
---------------
- ``*``: Asterisk for emphasis (italic or bold)
- ``**``: Double asterisk for strong emphasis (bold)
- `````: Backtick for inline code or literals
- ``=``: Equals sign for underlining titles
- ``-``: Hyphen for bullet points or underlining subtitles
- ``#``: Hash symbol for numbered lists
- ``::``: Double colon for literal blocks
- ``|``: Vertical bar for substitution references
- ``..``: Double dot for comments or directives
- ``[]``: Square brackets for hyperlinks or citations

Code Recognition
----------------

- ``.. code-block:: language``: Directive for syntax-highlighted code blocks.

  Example:
  
  .. code-block:: python
  
     def hello():
         print("Hello, world!")

- ``::``: Double colon for literal blocks (unhighlighted code).

  Example::
  
     This is a literal block of text or code.


Links and References
--------------------

- ```.. _label:```: Define a target for internal references.
  Example::
     .. _my_target:
     This is a target for internal references.

- ```label_```: Reference a target using an underscore.

  Example::
     See my_target_ for more details.

- `````text <url>``__``: Inline hyperlink.
  Example::
     Visit `Google <https://www.google.com>`__.

- ```.. image:: path/to/image.png```: Directive for embedding images
  Example::
     .. image:: logo.png
        :alt: Alternative text
        :width: 200px

- ```.. figure:: path/to/image.png```: Directive for figures with captions
  Example::
     .. figure:: diagram.png
        :alt: Diagram description
        :width: 300px

        This is a caption for the figure.

Tables
------

- ``.. table::``: Directive for creating tables

  Example::
  
  .. table:: Sample Table
     :widths: auto

        +---------+---------+
        | Header 1| Header 2|
        +=========+=========+
        | Row 1 | Data 1 |
        +---------+---------+
        | Row 2 | Data 2 |
        +---------+---------+
