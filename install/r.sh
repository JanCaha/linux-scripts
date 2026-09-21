#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

INSTAL_SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]:-${0}}")")

# R
sudo apt-get install -y \
    r-base \
    r-base-dev

# Radian shell for R
pip3 install -U radian --break-system-packages

# R packages
Rscript $INSTAL_SCRIPT_DIR/install_packages.R

cd "$START_DIR"