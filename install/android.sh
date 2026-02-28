#!/bin/bash
set -euo pipefail

# Install MTP tools for Android devices
sudo apt-get install -y \
    mtp-tools \
    jmtpfs \
    gvfs-backends \
    gvfs-fuse \
    libmtp-runtime
