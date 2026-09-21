#!/usr/bin/env bash
set -uo pipefail

QGIS_MAIN_DIR="${QGIS_MAIN_DIR:-$HOME/QGIS}"
QGIS_INSTALL_DIR="${QGIS_INSTALL_DIR:-/QGIS/install}"

if [ ! -d "$QGIS_MAIN_DIR" ]; then
    echo "Error: QGIS main directory '$QGIS_MAIN_DIR' does not exist."
    exit 1
fi

# Discover all worktrees (main checkout + linked worktrees) for the QGIS repo
mapfile -t FOLDERS < <(git -C "$QGIS_MAIN_DIR" worktree list | awk '{print $1}')

if [ "${#FOLDERS[@]}" -eq 0 ]; then
    echo "Error: no worktrees found for '$QGIS_MAIN_DIR'."
    exit 1
fi

# Ported from git_merge_upstream_function in settings/.zshrc (stray `exit 1`
# before the fetch/merge logic there is dead/debug code and is intentionally
# not replicated here).
merge_upstream() {
    echo "Starting merge with upstream..."

    local use_stash=0

    if git diff --quiet && git diff --cached --quiet; then
        echo "No local changes detected."
        use_stash=1
    fi

    if [ "$use_stash" -eq 1 ]; then
        echo "Stashing changes..."
        git stash
    fi

    echo "Fetching and merging upstream changes..."
    git fetch upstream

    local upstream_branch="master"
    if ! git rev-parse --verify upstream/master >/dev/null 2>&1; then
        upstream_branch="main"
        echo "master branch not found, using main instead."
    fi

    git merge "upstream/$upstream_branch"
    local merge_status=$?

    if [ "$use_stash" -eq 1 ]; then
        echo "Applying stashed changes..."
        git stash pop
    fi

    echo "Merge from upstream complete."
    return $merge_status
}

FAILED_FOLDERS=()

for folder in "${FOLDERS[@]}"; do
    if [ -d "$folder" ]; then
        echo "============================================================"
        echo "Building in directory: $folder"
        echo "============================================================"

        if [ "$folder" = "$QGIS_INSTALL_DIR" ]; then
            if (
                cd "$folder"
                merge_upstream && cmake --workflow release_opt_no_tests_install
            ); then
                echo "Successfully built in $folder"
            else
                echo "Error: Build failed in $folder. Moving to the next folder..."
                FAILED_FOLDERS+=("$folder")
            fi
        else
            if (
                cd "$folder"
                cmake --workflow build-for-testing
            ); then
                echo "Successfully built in $folder"
            else
                echo "Error: Build failed in $folder. Moving to the next folder..."
                FAILED_FOLDERS+=("$folder")
            fi
        fi
        echo
    else
        echo "Warning: Directory '$folder' does not exist. Skipping."
    fi
done

echo "============================================================"
if [ "${#FAILED_FOLDERS[@]}" -eq 0 ]; then
    echo "Completed building all QGIS worktrees successfully."
else
    echo "Finished, but the following folders failed to build:"
    for failed in "${FAILED_FOLDERS[@]}"; do
        echo "  - $failed"
    done
fi

# Skip the sleep prompt entirely if the user is actively using the machine
# (any local session not marked idle by the desktop's idle detection).
user_is_active() {
    local session
    for session in $(loginctl list-sessions --no-legend 2>/dev/null | awk '{print $1}'); do
        local idle_hint
        idle_hint=$(loginctl show-session "$session" -p IdleHint --value 2>/dev/null)
        if [ "$idle_hint" = "no" ]; then
            return 0
        fi
    done
    return 1
}

if user_is_active; then
    echo "User appears active, skipping sleep prompt."
else
    read -t 10 -p "Go back to sleep? [Y/n] " -r SLEEP_REPLY
    echo
    if [[ "$SLEEP_REPLY" =~ ^[Nn] ]]; then
        echo "Staying awake."
    else
        echo "Going back to sleep."
        systemctl suspend
    fi
fi

if [ "${#FAILED_FOLDERS[@]}" -ne 0 ]; then
    exit 1
fi
