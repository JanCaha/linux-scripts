#!/bin/bash
source /etc/os-release

# Wine
sudo apt install --install-recommends winehq-stable

# Dosbox and Mame
sudo apt install -y \
    mame \
    dosbox