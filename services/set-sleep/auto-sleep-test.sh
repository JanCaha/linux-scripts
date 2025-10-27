#!/bin/bash

JELLYFIN_URL="http://127.0.0.1:8096"
JELLYFIN_API_KEY=""

PROCESS_LIST=("ffmpeg" "vlc" "transmission-daemon" "code" "konsole" "brave")

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" >/dev/null 2>&1 && pwd -P)
source "$SCRIPT_DIR/auto-sleep-functions.sh"

jellyfin_is_playing

check_processes