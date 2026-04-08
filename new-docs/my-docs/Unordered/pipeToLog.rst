What Happens When You Pipe a Build Process to ``less``: Processor Impact
=========================================================================

When piping a build process (e.g., ``make``, ``gcc``, or ``npm run build``) to ``less``, the processor handles the workload as follows:

1. CPU Utilization & Process Scheduling
-----------------------------------------

- The build process and ``less`` run **concurrently**, connected via a pipe (``|``).
- The **CPU splits time** between:

  - The build process (generating output).
  - ``less`` (displaying/outputting the data).
  
- If the build is **CPU-intensive** (e.g., compiling code), the system prioritizes it, while ``less`` mostly waits for input (unless scrolling/searching).

2. Buffering & I/O Impact
---------------------------

- Stdout is **line-buffered** when printing to a terminal but **fully buffered** when piped.

  - Build tools (e.g., ``gcc``, ``make``) may **buffer output in chunks**, causing slight delays in display.
  - Output appears slower, but actual build speed remains unchanged.
- If ``less`` reads slowly (e.g., manual scrolling), the build process may **block temporarily** when the pipe buffer fills.

3. Memory Usage
-----------------
- The pipe uses a **fixed-size buffer** (typically 64KB on Linux).

  - If ``less`` doesn’t read fast enough, the build process pauses until buffer space frees.
  - No significant extra memory is used unless ``less`` loads an extremely large log (rare for builds).

4. Multi-core Systems
-----------------------

- On multi-core CPUs:

  - The build process and ``less`` can run on **separate cores**, minimizing interference.
  - Parallel builds (e.g., ``make -j4``) still utilize multiple cores; ``less`` merges their output.

5. Performance Overhead
-------------------------

- Piping to ``less`` adds **negligible CPU overhead** (only copying data between processes).
- The main cost is **latency**: output appears in chunks due to buffering.

Key Takeaways
---------------

- The **processor runs the build at full speed**, but output delivery may feel delayed.
- For **long builds**, piping to ``less`` has almost no performance penalty.
- For **short builds**, starting ``less`` may introduce minor overhead.

Example: Parallel Build with Paging
-------------------------------------

.. code-block:: bash

   make -j8 2>&1 | less -R # Uses 8 cores, pipes output to less

- The ``-j8`` flag ensures parallel compilation across 8 cores.
- ``less`` displays output as it arrives, with minimal CPU impact.
