#!/bin/bash
set -euo pipefail

DEVICE_MAC="EA:6C:87:DD:F3:96"

is_device_trusted() {
    bluetoothctl info "$DEVICE_MAC" | grep -Fq "Trusted: yes"
}

bluetoothctl power on

echo "🔌 Disconnecting headphones if they are connected"
bluetoothctl disconnect "$DEVICE_MAC"
bluetoothctl remove "$DEVICE_MAC"

echo "🤝 Pairing headphones"
bluetoothctl pair "$DEVICE_MAC"

if is_device_trusted; then
    echo "✅ Device $DEVICE_MAC is already trusted"
else
    echo "🔐 Trusting device $DEVICE_MAC"
    bluetoothctl trust "$DEVICE_MAC"
fi

bluetoothctl connect "$DEVICE_MAC"

echo "🟢 Bluetooth headphones reconnected: $DEVICE_MAC"
