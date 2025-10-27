#!/bin/bash
# /usr/local/bin/auto-sleep-check.sh
# Automatically suspend system if none of the listed processes are running for a defined time.

# === Configuration ===
PROCESS_LIST=("ffmpeg" "vlc" "transmission-daemon" "code" "konsole" "brave")
LOCKFILE="/tmp/auto-sleep.lock"
IDLE_MINUTES=30   # time threshold before sleep
JELLYFIN_URL="http://127.0.0.1:8096"
JELLYFIN_API_KEY=""

# === Functions ===
# Source shared functions from the same directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/auto-sleep-functions.sh"

# === Logic ===
if check_processes || jellyfin_is_playing; then
    # Active process or Jellyfin playback -> reset timer
    rm -f "$LOCKFILE"
    exit 0
else
    # No active process
    if [[ -f "$LOCKFILE" ]]; then
        last=$(stat -c %Y "$LOCKFILE")
        now=$(date +%s)
        elapsed=$(( (now - last) / 60 ))
        if (( elapsed >= IDLE_MINUTES )); then
            rm -f "$LOCKFILE"
            logger -t auto-sleep -p info "No activity for $elapsed minutes -> suspending..."
            systemctl suspend
        else
            logger -t auto-sleep -p info "Inactive for $elapsed minutes -> not yet suspending..."
        fi
    else
        # create lock to start counting idle time
        touch "$LOCKFILE"
    fi
fi
