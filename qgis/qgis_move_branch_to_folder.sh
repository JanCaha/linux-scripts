#!/bin/zsh
SCRIPT_DIR=$(dirname "$0")

# Check if first argument is provided
if [ -z "$1" ]; then
    echo "❌ Error: Branch name is required"
    echo "📖 Usage: $0 <branch_name>"
    exit 1
fi

BRANCH="$1"

cd $QGIS_SOURCES_DIR

# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    echo "✅ Branch '$BRANCH' already exists"
else
    echo "🚀 Creating branch '$BRANCH'"
    git checkout -b "$BRANCH"
    git checkout master
fi

# Or check first:
if [ ! -d "$QGIS_WORKTREE_FOLDER" ]; then
    echo "🚀 Creating worktree folder: $QGIS_WORKTREE_FOLDER"
    sudo mkdir -p "$QGIS_WORKTREE_FOLDER"
    sudo chown -R $USER:$USER "$QGIS_WORKTREE_FOLDER"
fi

echo "🚀 Adding git worktree for branch '$BRANCH' in folder '$QGIS_WORKTREE_FOLDER/$BRANCH'"
git worktree add "$QGIS_WORKTREE_FOLDER/$BRANCH" "$BRANCH"

# copy build directory to the new worktree (if available)
if [ -d "$QGIS_SOURCES_DIR/build" ]; then
    echo "📦 Copy build folder to new worktree"
    cp -a "$QGIS_SOURCES_DIR/build" "$QGIS_WORKTREE_FOLDER/$BRANCH/"
    CMAKE_CACHE_FILE="$QGIS_WORKTREE_FOLDER/$BRANCH/build/CMakeCache.txt"
    if [ -f "$CMAKE_CACHE_FILE" ]; then
        echo "🧹 Remove stale CMakeCache.txt from copied build"
        rm "$CMAKE_CACHE_FILE"
    fi
else
    echo "ℹ️ No build folder found at '$QGIS_SOURCES_DIR/build'"
fi

# copy necessary files to the new worktree
echo "📂 Copy files not part of the git repository to the new worktree"
cp -r ./.vscode "$QGIS_WORKTREE_FOLDER/$BRANCH/"
cp -r $SCRIPT_DIR/CMakePresets.json "$QGIS_WORKTREE_FOLDER/$BRANCH/CMakePresets.json"