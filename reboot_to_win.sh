#!/bin/bash

# This script reboots the system into Windows

# Define the GRUB entry name for Windows
WINDOWS_ENTRY="Windows Boot Manager (on /dev/nvme0n1p1)" # Replace with exact entry from grub.cfg if different

# Check if the entry exists in GRUB configuration
if sudo grep -q "$WINDOWS_ENTRY" /boot/grub/grub.cfg; then
    echo "Setting Windows as the next boot option..."

    # Set GRUB to reboot into Windows on next boot
    sudo grub-reboot "$WINDOWS_ENTRY"
    
    if [ $? -eq 0 ]; then
        echo "System will reboot into Windows. Rebooting now..."
        sudo reboot
    else
        echo "Failed to set the boot entry. Please check permissions or entry name."
        exit 1
    fi
else
    echo "The Windows entry '$WINDOWS_ENTRY' was not found in /boot/grub/grub.cfg"
    exit 1
fi