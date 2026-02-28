#!/bin/bash
set -euo pipefail

# Joplin
cd /tmp
wget -O joplin_install.sh https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh
bash joplin_install.sh --allow-root