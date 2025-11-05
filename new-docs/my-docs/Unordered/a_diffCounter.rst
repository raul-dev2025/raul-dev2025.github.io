How to Get a Resumed (Counter) Output Using ``diff``
==================================================

To get a resumed (counter) output when using the ``diff`` command in the command line, you can use the following options and techniques:

1. **Basic ``diff`` Output**
   ::

      diff a b

2. **Side-by-Side Output with Suppressed Common Lines**
   ::

      diff -y --suppress-common-lines a b

3. **Brief Output (Shows Only Whether Files Differ)**
   ::

      diff --brief a b

4. **Count the Number of Differences**
   To count the number of differences, pipe the output of ``diff`` to ``wc -l``:
   ::

      diff a b | wc -l

5. **Summarized Output with Counts**
   For a detailed summary, use a combination of ``diff`` and ``awk`` to count additions, deletions, and changes:
   ::

      diff a b | awk '/^</ {a++} /^>/ {d++} END {print "Additions:", a, "Deletions:", d}'

Example
-------

Suppose you have two files ``a`` and ``b``:

**File a:**
::

   line1
   line2
   line3

**File b:**
::

   line1
   line2
   line4

Running:
::

   diff a b

Output:
::

   3c3
   < line3
   ---
   > line4

To count the number of differences:
::

   diff a b | wc -l

Output:
::

   2

To get a summarized output:
::

   diff a b | awk '/^</ {a++} /^>/ {d++} END {print "Additions:", a, "Deletions:", d}'

Output:
::

   Additions: 1 Deletions: 1

This will give you a count of the number of lines that are different between the two files.
