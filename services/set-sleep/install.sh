#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy files
sudo cp "$SCRIPT_DIR/auto-sleep-check.sh" /usr/local/bin/auto-sleep-check.sh
sudo cp "$SCRIPT_DIR/auto-sleep-functions.sh" /usr/local/bin/auto-sleep-functions.sh
sudo cp "$SCRIPT_DIR/auto-sleep-test.sh" /usr/local/bin/auto-sleep-test.sh
sudo chmod +x /usr/local/bin/auto-sleep-check.sh


sudo cp "$SCRIPT_DIR/auto-sleep.service" /etc/systemd/system/auto-sleep.service
sudo cp "$SCRIPT_DIR/auto-sleep.timer" /etc/systemd/system/auto-sleep.timer


sudo systemctl daemon-reload
sudo systemctl restart auto-sleep.service
sudo systemctl enable --now auto-sleep.timer