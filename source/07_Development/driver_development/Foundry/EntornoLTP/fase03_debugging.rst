=====================================================
Fase 3: Entorno de Depuración, Trazado y Métricas BPF
=====================================================

.. sectionauthor:: Raul Vilchez Ruiz

Resumen de la Fase
==================

En esta fase se despliega la suite de depuración, análisis de rendimiento y trazado del núcleo en la VM ``buildlab``. El objetivo es proporcionar al usuario ``builder`` herramientas de observabilidad sin conceder acceso completo de superusuario, abarcando desde inspección tradicional (GDB, perf, trace-cmd) hasta trazado dinámico mediante eBPF (bpftool y bcc-tools).

Objetivos Técnicos
==================

1. Verificación e instalación de herramientas de depuración e inspección de rendimiento.
2. Despliegue de herramientas de trazado eBPF en espacio de usuario.
3. Delegación de privilegios de trazado a través de ``/etc/sudoers.d/builder-kernel``.

Herramientas Desplegadas
========================

.. list-table:: Herramientas Desplegadas
   :widths: 20 30 50
   :header-rows: 1

   * - Herramienta
     - Paquete / Ruta
     - Propósito
   * - GDB
     - `gdb`
     - Depuración estática de binarios y símbolos
   * - perf
     - `perf`
     - Perfilado de eventos del subsistema hardware/kernel
   * - trace-cmd
     - `trace-cmd`
     - Interfaz de usuario para ftrace en espacio kernel
   * - bpftool
     - `bpftool`
     - Inspección y manipulación de mapas/programas eBPF
   * - bcc-tools
     - `/usr/share/bcc/tools/`
     - Colección de scripts de trazado sobre eBPF

Configuración y Delegación (sudoers)
=====================================

Para permitir la inspección del núcleo por parte del usuario sin privilegios, se amplían las reglas en ``/etc/sudoers.d/builder-kernel``:

.. code-block:: bash

   builder ALL=(ALL) NOPASSWD: /usr/sbin/insmod, /usr/sbin/rmmod, /usr/bin/dmesg, /usr/sbin/modinfo, /usr/bin/kmod-sign-file, /usr/bin/perf, /usr/bin/trace-cmd, /usr/sbin/bpftool

Validación de Utilidades
========================

Las herramientas han quedado validadas en el entorno ``buildlab`` mostrando alineación directa con el núcleo en ejecución:

.. code-block:: bash

   perf version 6.12.0-124.8.1.el10_1.x86_64
   trace-cmd version 3.3.1
   bpftool v7.6.0 (libbpf v1.6)