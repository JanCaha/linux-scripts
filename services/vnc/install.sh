#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo apt install x11vnc -y

# ps -ef | grep -E 'X|Xorg'

sudo mkdir -p /root/.vnc
sudo x11vnc -storepasswd /root/.vnc/passwd

sudo cp "$SCRIPT_DIR/x11vnc.service" /etc/systemd/system/x11vnc.service

sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service

# run ok check status
sudo systemctl status x11vnc.service
sudo journalctl -u x11vnc.service -n 50
sudo journalctl -u x11vnc.service | grep -i auth
sudo x11vnc -display :0 -auth guess -nopw -connect_or_exit localhost -once 2>&1 | head -20
