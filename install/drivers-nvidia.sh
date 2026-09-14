#!/bin/bash
set -euo pipefail

# NVIDIA Drivers for Debian testing
# Ensure non-free repositories are enabled for trixie / Debian testing.
CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")

sudo tee /etc/apt/sources.list.d/debian-testing.sources >/dev/null <<EOF
Types: deb
URIs: http://deb.debian.org/debian
Suites: ${CODENAME} ${CODENAME}-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://security.debian.org/debian-security
Suites: ${CODENAME}-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

sudo apt update
sudo apt install -y linux-headers-"$(uname -r)" dkms build-essential
sudo apt install -y nvidia-driver firmware-misc-nonfree

# Enable DRM modesetting for NVIDIA
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia-drm.conf

# Add nvidia modules to initramfs
echo "nvidia" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_modeset" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_drm" | sudo tee -a /etc/initramfs-tools/modules
echo "nvidia_uvm" | sudo tee -a /etc/initramfs-tools/modules

# Update initramfs
sudo update-initramfs -u
