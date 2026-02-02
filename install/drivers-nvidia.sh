#!/bin/bash
set -euo pipefail

# NVIDIA Drivers
# add contrib and non-free to /etc/apt/sources.list into trixie, trixie-security, trixie-updates
sudo apt install -y linux-headers-"$(uname -r)"
sudo apt install -y linux-headers-amd64
sudo apt install -y nvidia-driver

# Enable DRM modesetting for NVIDIA
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia-drm.conf

# Add nvidia modules to initramfs
echo "nvidia" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_modeset" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_drm" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_uvm" | sudo tee -a /etc/initramfs-tools/modules

# Update initramfs
sudo update-initramfs -u
