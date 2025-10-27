#!/bin/env bash

# Shared functions for auto-sleep scripts

log() {
  # Usage: log level message...
  local level=${1:-info}; shift || true
  if command -v logger >/dev/null 2>&1; then
    echo "$*" | logger -t auto-sleep -p "$level" 
  else
    # Fallback to stderr
    printf '[auto-sleep][%s] %s\n' "$level" "$*" >&2
  fi
}

# Determine if a Jellyfin Sessions JSON indicates any active or paused playback
jellyfin_json_has_playback() {
  local json_input="$1"
  if command -v jq >/dev/null 2>&1; then
    echo "$json_input" | jq -e '.[]
      | select(.NowPlayingItem and .PlayState and (
          (.PlayState.IsPaused != null) or
          (["Playing","Paused"] | index(.PlayState.PlaybackStatus // ""))
        ))' >/dev/null 2>&1
  else
    # Basic fallback: look for NowPlayingItem and either IsPaused or PlaybackStatus
    echo "$json_input" | grep -q '"NowPlayingItem"' \
      && echo "$json_input" | grep -Eq '"IsPaused":(true|false)|"PlaybackStatus":"(Playing|Paused)"'
  fi
}

# Query Jellyfin API for active/paused playback
jellyfin_is_playing() {
  [[ -z "${JELLYFIN_API_KEY:-}" ]] && return 1
  local base_url="${JELLYFIN_URL:-http://127.0.0.1:8096}"
  local url="$base_url/Sessions?ActiveWithinSeconds=300"
  local json
  json=$(curl -fsS --connect-timeout 2 --max-time 4 \
    -H "X-Emby-Token: $JELLYFIN_API_KEY" "$url" 2>/dev/null) || return 1

  if jellyfin_json_has_playback "$json"; then
    log info "Jellyfin playback active"
    return 0
  fi
  return 1
}

# Check if any guarded processes are running (uses global PROCESS_LIST)
check_processes() {
  log info "Checking running processes"
  local p
  for p in "${PROCESS_LIST[@]}"; do
    if pgrep -x "$p" >/dev/null 2>&1; then
      log info "Process $p is running"
      return 0
    fi
  done

  # special case for JDownloader (java process)
  if pgrep -f "JDownloader" >/dev/null 2>&1; then
    log info "JDownloader is running"
    return 0
  fi

  return 1
}
