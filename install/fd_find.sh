#!/bin/bash
set -euo pipefail

# Fd - find replacement
sudo apt-get install -y fd-find
ln -s "$(which fdfind)" ~/.local/bin/fd
