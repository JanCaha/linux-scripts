#!/bin/bash

# Remove local worktrees whose branch was deleted on the remote.
# Requires: QGIS_SOURCES_DIR

REMOTE_NAME=""
DRY_RUN=0
AUTO_YES=0

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--remote)
            if [ -z "${2:-}" ] || [[ "$2" == -* ]]; then
                echo "❌ Error: --remote requires a value"
                exit 1
            fi
            REMOTE_NAME="$2"
            shift 2
            ;;
        -n|--dry-run)
            DRY_RUN=1
            shift
            ;;
        -y|--yes)
            AUTO_YES=1
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [-r|--remote <remote>] [-n|--dry-run] [-y|--yes]"
            echo ""
            echo "Options:"
            echo "  -r, --remote   Remote name to check (default: auto-detect)"
            echo "  -n, --dry-run  Show what would be removed without removing"
            echo "  -y, --yes      Remove without confirmation prompt"
            exit 0
            ;;
        *)
            echo "❌ Error: Unknown parameter passed: $1"
            echo "📖 Usage: $0 [-r|--remote <remote>] [-n|--dry-run] [-y|--yes]"
            exit 1
            ;;
    esac
done

if [ -z "${QGIS_SOURCES_DIR:-}" ]; then
    echo "❌ Error: Environment variable QGIS_SOURCES_DIR must be set"
    exit 1
fi

cd "$QGIS_SOURCES_DIR" || {
    echo "❌ Error: Failed to navigate to $QGIS_SOURCES_DIR"
    exit 1
}

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "❌ Error: '$QGIS_SOURCES_DIR' is not a git repository"
    exit 1
fi

# Auto-detect remote from current branch upstream, then fallback to single remote.
if [ -z "$REMOTE_NAME" ]; then
    CURRENT_BRANCH=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)
    if [ -n "$CURRENT_BRANCH" ]; then
        TRACKING_REF=$(git for-each-ref --format='%(upstream:short)' "refs/heads/$CURRENT_BRANCH")
        if [ -n "$TRACKING_REF" ]; then
            REMOTE_NAME="${TRACKING_REF%%/*}"
        fi
    fi

    if [ -z "$REMOTE_NAME" ]; then
        mapfile -t REMOTES < <(git remote)
        if [ ${#REMOTES[@]} -eq 1 ]; then
            REMOTE_NAME="${REMOTES[0]}"
        fi
    fi
fi

if [ -z "$REMOTE_NAME" ]; then
    echo "❌ Error: Could not auto-detect remote name"
    echo "📖 Please pass it explicitly, e.g.: $0 --remote origin"
    exit 1
fi

if ! git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
    echo "❌ Error: Remote '$REMOTE_NAME' does not exist"
    exit 1
fi

echo "🔄 Fetching and pruning remote-tracking branches from '$REMOTE_NAME'..."
if ! FETCH_ERR=$(git fetch "$REMOTE_NAME" --prune --quiet 2>&1); then
    echo "❌ Error: Failed to fetch/prune remote '$REMOTE_NAME'"
    if [ -n "$FETCH_ERR" ]; then
        echo "$FETCH_ERR"
    fi
    exit 1
fi

declare -a STALE_PATHS
declare -a STALE_BRANCHES

CURRENT_PATH=""
CURRENT_BRANCH=""

process_worktree() {
    if [ -z "$CURRENT_PATH" ]; then
        return
    fi

    # Skip the main worktree, detached HEAD worktrees, and local-only install branch.
    if [ "$CURRENT_PATH" = "$QGIS_SOURCES_DIR" ] || [ -z "$CURRENT_BRANCH" ] || [ "$CURRENT_BRANCH" = "install" ]; then
        return
    fi

    if ! git show-ref --verify --quiet "refs/remotes/$REMOTE_NAME/$CURRENT_BRANCH"; then
        STALE_PATHS+=("$CURRENT_PATH")
        STALE_BRANCHES+=("$CURRENT_BRANCH")
    fi
}

while IFS= read -r line; do
    if [ -z "$line" ]; then
        process_worktree
        CURRENT_PATH=""
        CURRENT_BRANCH=""
        continue
    fi

    case "$line" in
        worktree\ *)
            process_worktree
            CURRENT_PATH="${line#worktree }"
            CURRENT_BRANCH=""
            ;;
        branch\ refs/heads/*)
            CURRENT_BRANCH="${line#branch refs/heads/}"
            ;;
        *)
            ;;
    esac
done < <(git worktree list --porcelain)

# Process the last entry if output does not end with a blank line.
process_worktree

if [ ${#STALE_PATHS[@]} -eq 0 ]; then
    echo "✅ No stale worktrees found."
    exit 0
fi

echo "🧹 Found ${#STALE_PATHS[@]} stale worktree(s):"
for i in "${!STALE_PATHS[@]}"; do
    echo "  - Branch '${STALE_BRANCHES[$i]}' -> ${STALE_PATHS[$i]}"
done

if [ $DRY_RUN -eq 1 ]; then
    echo "📝 Dry run enabled. Nothing was removed."
    exit 0
fi

if [ $AUTO_YES -eq 0 ]; then
    echo ""
    read -r -p "Remove these worktrees? [y/N]: " REPLY
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        echo "ℹ️ Aborted by user."
        exit 0
    fi
fi

FAILED=0
for i in "${!STALE_PATHS[@]}"; do
    WT_PATH="${STALE_PATHS[$i]}"
    WT_BRANCH="${STALE_BRANCHES[$i]}"

    echo "🗑️ Removing worktree: $WT_PATH (branch: $WT_BRANCH)"
    if ! git worktree remove --force "$WT_PATH"; then
        echo "❌ Failed to remove worktree: $WT_PATH"
        FAILED=1
    fi
done

if [ $FAILED -eq 0 ]; then
    echo "✅ Stale worktrees removed successfully."
else
    echo "⚠️ Completed with errors while removing some worktrees."
    exit 1
fi
