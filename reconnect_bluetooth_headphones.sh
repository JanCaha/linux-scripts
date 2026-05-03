#!/bin/bash
set -euo pipefail

DEVICE_MAC="EA:6C:87:DD:F3:96"
SCAN_TIMEOUT_SECONDS="30"

is_device_available() {
    bluetoothctl devices | grep -Fqi "$DEVICE_MAC"
}

bluetoothctl power on

echo "🔌 Disconnecting headphones if they are connected"
bluetoothctl disconnect "$DEVICE_MAC" 
bluetoothctl remove "$DEVICE_MAC"

if is_device_available; then
    echo "✅ Device $DEVICE_MAC is already available"
else
    echo "🔎 Starting Bluetooth scan for headphones"
    bluetoothctl scan on
    sleep "$SCAN_TIMEOUT_SECONDS"
    if ! bluetoothctl scan off; then
        echo "⚠️ Warning: failed to stop discovery; continuing." >&2
    fi
    echo "⏱️ Scan finished"
fi

if ! is_device_available; then
    echo "❌ Device $DEVICE_MAC was not found during scan." >&2
    echo "🎧 Put headphones in pairing mode and run the script again." >&2
    exit 1
fi

echo "✅ Device $DEVICE_MAC is available"
echo "🤝 Pairing headphones"
bluetoothctl pair "$DEVICE_MAC"
bluetoothctl trust "$DEVICE_MAC"
bluetoothctl connect "$DEVICE_MAC"

echo "🟢 Bluetooth headphones reconnected: $DEVICE_MAC"