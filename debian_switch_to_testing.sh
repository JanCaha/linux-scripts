#!/usr/bin/bash
set -euo pipefail

# Ensure we are root
if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Get current Debian codename
CURRENT_CODENAME=$(lsb_release -cs)

echo "Current Debian codename: $CURRENT_CODENAME"
echo "Switching APT sources to: testing"

# Backup sources.list
cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d-%H%M%S)

# Replace codename with 'testing'
sed -i "s/\b${CURRENT_CODENAME}\b/testing/g" /etc/apt/sources.list

# Remove stable-security entries (not valid for testing)
sed -i '/security.debian.org/d' /etc/apt/sources.list

echo "APT sources updated."
echo "Running apt update..."
apt update

echo "Running full upgrade..."
apt full-upgrade -y

echo "Upgrade complete."
echo "A reboot is strongly recommended."
