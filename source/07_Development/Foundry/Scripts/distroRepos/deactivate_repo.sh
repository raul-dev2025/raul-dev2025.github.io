#!/bin/bash
# Script de Desactivación: Aislamiento del nodo GOLDEN_ROCKY10_BASE
echo "--- Cerrando infraestructura de paquetes (Sellado) ---"

# 1. Desactivar todos los repositorios para evitar intentos de conexión externa
dnf config-manager --set-disabled \* && echo "[OK] Repositorios DNF desactivados"

# 2. Desmontar el DVD/Stick (Ruta según tu archivo .repo)
if mountpoint -q /mnt/rocky-dvd; then
    umount /mnt/rocky-dvd && echo "[OK] DVD desmontado de /mnt/rocky-dvd"
fi

# 3. Limpieza profunda de metadatos y caché (Vital para el sellado de la imagen)
dnf clean all
rm -rf /var/cache/dnf/*
echo "[OK] Caché de paquetes purgada"

echo "-------------------------------------------------------"
echo "Estado final de DNF:"
dnf repolist
echo "Sistema aislado, limpio y listo para conversión a Template."