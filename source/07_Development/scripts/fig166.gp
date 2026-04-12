# Set terminal/output
set terminal png
set output "fig_16_6_dashed.png"

# Set equal aspect ratio and labels
set size ratio -1
set xlabel "x"
set ylabel "y"
#set title "Fig. 16-6: Definición de seno y coseno"

# Axis ranges (first quadrant only)
set xrange [-1:1.5]
set yrange [0:1.5]
set grid
set zeroaxis

# Disable legend
unset key

# Define angle θ (e.g., 45 degrees)
theta = 105
theta_rad = theta * pi / 180 # Convert to radians

# Draw axes
set arrow 1 from 0,0 to 1.5,0 nohead lt rgb "black" # x-axis
set arrow 2 from 0,0 to 0,1.5 nohead lt rgb "black" # y-axis

# Label points O, A, B
set label "O (0,0)" at -0.29,0.05
set label "A (1,0)" at 1.05,0.15
set label sprintf("B (cosθ, sinθ)", cos(theta_rad), sin(theta_rad)) at cos(theta_rad)+0.1, sin(theta_rad)+0.1

# Lines OA (blue) and OB (red)
set arrow 3 from 0,0 to 1,0 lt rgb "blue" lw 2
set arrow 4 from 0,0 to cos(theta_rad), sin(theta_rad) lt rgb "red" lw 2

# Angle θ (green arc)
set object 1 circle at 0,0 size 0.2 arc [0:theta] fillcolor rgb "green" fillstyle transparent solid 0.2

# --- NEW: Dashed projection lines ---
x_arc(t) = 1 * cos(t)
y_arc(t) = 1 * sin(t)

set parametric
set angle degrees
set samples 100
plot [t=0:theta] x_arc(t), y_arc(t) with lines lt 3 lw 1.5


## re-draw axes co cover arc ends. X and y respectively
#set arrow 1 from 0,0 to 1.5,0 lt -1 lw 1
#set arrow 2 from 0,0 to 0,1.5 lt -1 lw 1
replot

## Plot (empty plot to force drawing)
#plot NaN notitle
