#!/bin/bash
set -euo pipefail

# Install GitHub CLI
cd /tmp
GH_VERSION=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
wget https://github.com/cli/cli/releases/download/$GH_VERSION/gh_${GH_VERSION#v}_linux_amd64.deb
sudo dpkg -i gh_${GH_VERSION#v}_linux_amd64.deb