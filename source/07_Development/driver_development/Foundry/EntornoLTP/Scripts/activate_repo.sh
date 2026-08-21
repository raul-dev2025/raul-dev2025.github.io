#!/bin/bash
# Script actualizado para usar el Stick USB pasado como disco
echo "--- Iniciando montaje desde Stick USB ---"

mkdir -p /mnt/rocky-dvd

# Intentamos montar vdc (que es sdb1 pasado desde el host)
mount /dev/vdb /mnt/rocky-dvd && echo "[OK] Stick montado en /mnt/rocky-dvd"

dnf config-manager --set-enabled dvd-baseos dvd-appstream
echo "-------------------------------------------------------"
dnf repolist