#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
 
"$SCRIPT_DIR/wake_on_lan.sh"

remmina -c /home/cahik/.local/share/remmina/group_vnc_quick-connect_192-168-0-106-5900.remmina