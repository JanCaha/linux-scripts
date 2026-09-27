#!/bin/bash
set -euo pipefail

conn=$(nmcli -t -f NAME,TYPE connection show --active | awk -F: '$2=="802-3-ethernet"{print $1; exit}')

if [[ -z "$conn" ]]; then
    logger -t wake-on-lan -p err "No active ethernet connection found, cannot enable Wake-on-LAN"
    exit 1
fi

nmcli connection modify "$conn" 802-3-ethernet.wake-on-lan magic

iface=$(nmcli -t -f GENERAL.DEVICES connection show "$conn" | cut -d: -f2)
ethtool -s "$iface" wol g || true

logger -t wake-on-lan -p info "Wake-on-LAN (magic packet) enabled on connection '$conn' (device '$iface')"
