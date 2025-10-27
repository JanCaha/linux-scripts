#!/bin/bash
# /usr/local/bin/auto-sleep-check.sh
# Automatically suspend system if none of the listed processes are running for a defined time.

# === Configuration ===
PROCESS_LIST=("ffmpeg" "vlc" "transmission-daemon" "code" "konsole" "brave")
LOCKFILE="/tmp/auto-sleep.lock"
IDLE_MINUTES=30   # time threshold before sleep
JELLYFIN_URL="http://127.0.0.1:8096"
JELLYFIN_API_KEY=""

# === Function ===
check_processes() {
    logger -t auto-sleep -p info "Checking running processes"
    # test processes
    for p in "${PROCESS_LIST[@]}"; do
        if pgrep -x "$p" >/dev/null 2>&1; then
            logger -t auto-sleep -p info "Process $p is running"
            return 0  # process running
        fi
    done
    
    # special case for JDownloader (java process)
    if pgrep -f "JDownloader" >/dev/null 2>&1; then
        logger -t auto-sleep -p info "JDownloader is running"
        return 0  # JDownloader running
    fi

    return 1  # none running
}

jellyfin_is_playing() {
    [[ -z "$JELLYFIN_API_KEY" ]] && return 1
    
    local url="$JELLYFIN_URL/Sessions?ActiveWithinSeconds=300"
    local json
    json=$(curl -fsS --connect-timeout 2 --max-time 4 \
        -H "X-Emby-Token: $JELLYFIN_API_KEY" "$url" 2>/dev/null) || return 1

    # If jq finds at least one matching session (playing or paused), return 0
    if echo "$json" | jq -e '.[] | select(.NowPlayingItem != null) |
                                select(.PlayState != null) |
                                select(
                                    (.PlayState.IsPaused != null) or
                                    ((.PlayState.PlaybackStatus // "") == "Playing") or
                                    ((.PlayState.PlaybackStatus // "") == "Paused")
                                )' >/dev/null 2>&1; then
        logger -t auto-sleep -p info "Jellyfin playback active"
        return 0
    else
        return 1
    fi
}

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
