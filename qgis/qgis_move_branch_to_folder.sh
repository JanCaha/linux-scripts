#!/bin/zsh

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
    sudo mkdir -p "$QGIS_WORKTREE_FOLDER"
    sudo chown -R $USER:$USER "$QGIS_WORKTREE_FOLDER"
fi

git worktree add "$QGIS_WORKTREE_FOLDER/$BRANCH" "$BRANCH"

# copy necessary files to the new worktree
echo "📂 Copy files not part of the git repository to the new worktree"
cp -r ./.vscode "$QGIS_WORKTREE_FOLDER/$BRANCH/"
cp -r ./CMakePresets.json "$QGIS_WORKTREE_FOLDER/$BRANCH/CMakePresets.json"