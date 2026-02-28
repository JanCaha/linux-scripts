#!/bin/bash
set -euo pipefail

# Install Redshift
sudo apt-get remove -y redshift-gtk
rm -f ~/.config/redshift.conf
sudo apt-get install -y redshift
