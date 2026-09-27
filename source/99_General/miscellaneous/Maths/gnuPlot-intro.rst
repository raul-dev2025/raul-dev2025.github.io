GNUPlot Example: Plotting Mathematical Functions in Linux
=========================================================

This guide demonstrates how to use GNUPlot to visualize mathematical functions in a Linux environment.

Installation
--------------

Install GNUPlot using your package manager:

.. code-block:: bash

   # Debian/Ubuntu
   sudo apt update
   sudo apt install gnuplot

   # Fedora/RHEL
   sudo dnf install gnuplot

   # Arch Linux
   sudo pacman -S gnuplot

Basic Plot Example (Sine Wave)
--------------------------------

1. Launch GNUPlot:

   .. code-block:: bash

      gnuplot

2. Enter the following commands in the GNUPlot prompt:

   .. code-block:: gnuplot

      set title "Sine Wave Example"
      set xlabel "x"
      set ylabel "sin(x)"
      plot sin(x) with lines title "y = sin(x)"

   This will display an interactive plot of the sine function.

Saving the Plot to a File
---------------------------

To save the plot as a PNG image:

.. code-block:: gnuplot

   set terminal png
   set output "sine_wave.png"
   plot sin(x) with lines title "y = sin(x)"

The file ``sine_wave.png`` will be created in the current directory.

Multiple Functions Example
----------------------------

Plot both sine and cosine functions:

.. code-block:: gnuplot

   set title "Trigonometric Functions"
   set xlabel "x"
   set ylabel "y"
   set xrange [-2*pi:2*pi]
   plot sin(x) with lines title "sin(x)", cos(x) with lines title "cos(x)"

Script-Based Plotting
-----------------------

1. Create a script file (e.g., ``plot_script.gp``):

   .. code-block:: gnuplot

      set terminal png
      set output "math_plot.png"
      set title "Quadratic Function"
      set xlabel "x"
      set ylabel "y"
      plot x**2 with lines title "y = x^2"

2. Execute the script:

   .. code-block:: bash

      gnuplot plot_script.gp

3D Plot Example
-----------------

Generate a 3D surface plot:

.. code-block:: gnuplot

   set terminal png
   set output "3d_plot.png"
   splot sin(x)*cos(y) with pm3d title "sin(x)*cos(y)"

Viewing the Plot
------------------

- **GUI Environment**: GNUPlot will display the plot in a new window.
- **Terminal/SSH**: Save the plot as an image (PNG/PDF) and transfer it for viewing.

Notes
-------

- Replace ``x**2`` with any mathematical function (e.g., ``exp(x)``, ``log(x)``).
- Use ``set xrange [min:max]`` and ``set yrange [min:max]`` to adjust axes.
