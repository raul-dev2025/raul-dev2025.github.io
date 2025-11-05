How to Limit CPU Computation Consumption for Builds and Compilation
==================================================================

This guide provides strategies to limit CPU usage for CPU-intensive processes like **compilation** or **builds**.

1. Limit Parallel Jobs
-----------------------
Many build systems and compilers allow you to control the number of parallel jobs, which directly affects CPU usage.

- **For** ``make``:
  Use the ``-j`` flag to specify the number of parallel jobs::

    make -j2 # Limits to 2 parallel jobs

  Dynamically limit based on the number of CPU cores::

    make -j$(nproc --ignore=2) # Uses all but 2 CPU cores

- **For** ``cmake`` **or** ``ninja``:
  Use the ``-j`` flag similarly::

    ninja -j2 # Limits to 2 parallel jobs

- **For** ``gcc`` **or** ``clang``:
  Use ``-j`` with ``lto`` (Link-Time Optimization)::

    gcc -flto=2 -o my_program my_program.c

2. Use ``nice`` and ``renice``
------------------------------
Lower the priority of the build process to reduce its CPU impact on other tasks.

- Start the build with ``nice``::

    nice -n 10 make -j$(nproc)

- Adjust the priority of an ongoing build process::

    renice 10 -p <PID>

3. Limit CPU Cores with ``taskset``
-----------------------------------
Restrict the build process to specific CPU cores to reduce overall CPU usage.

- Example: Limit the build to 2 CPU cores (e.g., cores 0 and 1)::

    taskset -c 0,1 make -j2

4. Use ``cpulimit``
-------------------
Dynamically limit the CPU usage of the build process to a specific percentage.

- Example: Limit ``make`` to 50% CPU::

    cpulimit -l 50 -e make

5. Control System-Wide CPU Usage
---------------------------------
If you're running builds in a shared environment, you can use system-wide tools to limit CPU usage.

- **Using** ``cgroups`` **(Linux):**
  Create a control group and limit CPU usage for the build process::

    cgcreate -g cpu:/buildgroup
    echo 100000 > /sys/fs/cgroup/cpu/buildgroup/cpu.cfs_quota_us # Limit to 10% CPU
    echo <PID> > /sys/fs/cgroup/cpu/buildgroup/tasks

- **Using Docker:**
  If you're running the build in a Docker container, limit CPU usage::

    docker run --cpus="1.5" <image_name> # Limit to 1.5 CPU cores

6. Throttle I/O and CPU Together
--------------------------------
Build processes often involve heavy I/O operations. Use tools like ``ionice`` to prioritize I/O and reduce overall system load.

- Example::

    ionice -c 3 nice -n 10 make -j$(nproc)

7. Pause and Resume Builds
--------------------------
If you need to temporarily free up CPU resources, you can pause and resume the build process.

- Pause a process::

    kill -STOP <PID>

- Resume a process::

    kill -CONT <PID>

8. Use Build System-Specific Options
------------------------------------
Some build systems have built-in options to limit resource usage.

- **For** ``bazel``**:**
  Use the ``--local_cpu_resources`` flag::

    bazel build --local_cpu_resources=2 //my:target

- **For** ``gradle``:
  Use the ``--max-workers`` flag::

    ./gradlew build --max-workers=2

9. Monitor and Adjust
---------------------
Use monitoring tools to observe CPU usage and adjust limits as needed.

- **Linux:**
  Use ``htop``, ``top``, or ``glances`` to monitor CPU usage.
- **Windows:**
  Use Task Manager or Resource Monitor.
- **macOS:**
  Use Activity Monitor.

---

By combining these techniques, you can effectively limit CPU consumption during compilation or builds while still maintaining reasonable performance.
