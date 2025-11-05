Introduction to GNUPlot for Mathematical Visualization
========================================================

What is GNUPlot?
------------------

GNUPlot is a command-line-driven graphing utility for Linux (and other OSes) that enables dynamic visualization of mathematical functions, datasets, and 3D surfaces. It supports:

- 2D/3D plotting
- Multiple functions on the same graph
- Script automation
- Export to PNG, PDF, SVG, etc.

Starting GNUPlot
------------------

Launch GNUPlot in your Linux terminal:

.. code-block:: bash

   gnuplot

Clearing the Screen
---------------------

To clear the GNUPlot console (not the plot window):

.. code-block:: gnuplot

   !clear # Linux/macOS
   !cls # Windows

Basic Example: Plotting a Function
------------------------------------

Plot a simple quadratic equation:

.. code-block:: gnuplot

   reset # Clears all previous settings
   plot x**2 + 3*x - 5 title "Quadratic Function"

Handling Multiple Operations
------------------------------

GNUPlot executes commands sequentially. To avoid clashes when plotting multiple calculus operations:

1. **Explicit Parentheses**: Always group operations.

   .. code-block:: gnuplot
   
      plot (sin(x)/x) * exp(-x**2)

2. **Temporary Variables**: Use ``set`` for complex expressions.

   .. code-block:: gnuplot
   
      set dummy t
      parametric = "plot sin(t),cos(t)"
      eval parametric

3. **Reset Between Plots**: Prevent variable/function collisions.

   .. code-block:: gnuplot
   
      reset
      plot integral(sin(x)*exp(x))

Key Notes
-----------
- **Clashing Operations**: Functions like ``sum``, ``integral``, and ``derivative`` may conflict if not properly scoped. Use ``reset`` between unrelated plots.
- **Persistent Variables**: Defined variables (e.g., ``a=5``) remain active until manually unset or reset.
- **Thread Safety**: GNUPlot is single-threaded; concurrent instances require separate sessions.

Advanced Example: Multiple Calculus Operations
------------------------------------------------

.. code-block:: gnuplot

   reset
   f(x) = sin(x) / x
   set title "Function and its Derivative"
   plot f(x) title "f(x)", \
        (f(x+0.01) - f(x))/0.01 title "Numerical Derivative"

Output Options
----------------

To save plots without displaying them:

.. code-block:: gnuplot

   set terminal png
   set output "plot.png"
   replot # Repeats the last plot command
   !feh plot.png # View in Linux (requires feh)

Conclusion
------------

GNUPlot provides powerful mathematical visualization while requiring careful handling of operational scope. Always use ``reset`` when switching between unrelated tasks.
