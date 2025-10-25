#!/bin/bash
# /usr/local/bin/auto-sleep-check.sh
# Automatically suspend system if none of the listed processes are running for a defined time.

# === Configuration ===
PROCESS_LIST=("ffmpeg" "vlc" "transmission-daemon", "code", "konsole", "brave")
LOCKFILE="/tmp/auto-sleep.lock"
IDLE_MINUTES=30   # time threshold before sleep

# === Function ===
check_processes() {
    logger -t auto-sleep -p info "Checking running processes"
    for p in "${PROCESS_LIST[@]}"; do
        if pgrep -x "$p" >/dev/null 2>&1; then
            logger -t auto-sleep -p info "Process $p is running"
            return 0  # process running
        fi
    done
    if pgrep -f "JDownloader" >/dev/null 2>&1; then
        logger -t auto-sleep -p info "JDownloader is running"
        return 0  # JDownloader running
    fi
    return 1  # none running
}

# === Logic ===
if check_processes; then
    # Active process -> reset timer
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
        fi
    else
        # create lock to start counting idle time
        touch "$LOCKFILE"
    fi
fi
