#!/bin/zsh
SCRIPT_DIR=$(dirname "$0")

CREATE_FROM_MASTER=0

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m | --master)
            CREATE_FROM_MASTER=1
            shift
            ;;
        -*)
            echo "❌ Error: Unknown parameter passed: $1"
            exit 1
            ;;
        *)
            BRANCH="$1"
            shift
            ;;
    esac
done

# Check if branch is provided
if [ -z "${BRANCH:-}" ]; then
    echo "❌ Error: Branch name is required"
    echo "📖 Usage: $0 [-m|--master] <branch_name>"
    exit 1
fi

# Check if required environment variables are set
if [ -z "${QGIS_SOURCES_DIR:-}" ] || [ -z "${QGIS_WORKTREE_FOLDER:-}" ]; then
    echo "❌ Error: Environment variables QGIS_SOURCES_DIR and QGIS_WORKTREE_FOLDER must be set"
    exit 1
fi

cd "$QGIS_SOURCES_DIR" || {
    echo "❌ Error: Failed to navigate to $QGIS_SOURCES_DIR"
    exit 1
}

BRANCH_EXISTS=0
# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    echo "✅ Branch '$BRANCH' already exists"
    BRANCH_EXISTS=1
else
    if [ $CREATE_FROM_MASTER -eq 0 ]; then
        echo "🚀 Creating branch '$BRANCH' from current HEAD"
        git branch "$BRANCH"
    else
        echo "🚀 Branch '$BRANCH' will be created from master"
    fi
fi

# Or check first:
if [ ! -d "$QGIS_WORKTREE_FOLDER" ]; then
    echo "🚀 Creating worktree folder: $QGIS_WORKTREE_FOLDER"
    sudo mkdir -p "$QGIS_WORKTREE_FOLDER"
    sudo chown -R $USER:$USER "$QGIS_WORKTREE_FOLDER"
fi

if [ -d "$QGIS_WORKTREE_FOLDER/$BRANCH" ]; then
    echo "❌ Error: Worktree directory '$QGIS_WORKTREE_FOLDER/$BRANCH' already exists!"
    exit 1
fi

echo "🚀 Adding git worktree for branch '$BRANCH' in folder '$QGIS_WORKTREE_FOLDER/$BRANCH'"
if [ $BRANCH_EXISTS -eq 0 ] && [ $CREATE_FROM_MASTER -eq 1 ]; then
    echo "Creating new branch '$BRANCH' from master..."
    git worktree add -b "$BRANCH" "$QGIS_WORKTREE_FOLDER/$BRANCH" master
else
    git worktree add "$QGIS_WORKTREE_FOLDER/$BRANCH" "$BRANCH"
fi

# copy necessary files to the new worktree
echo "📂 Copy files not part of the git repository to the new worktree"
VS_CODE_DIR="$QGIS_WORKTREE_FOLDER/$BRANCH/.vscode"
mkdir -p "$VS_CODE_DIR"
cp -r "$SCRIPT_DIR/vscode/." "$VS_CODE_DIR/"
cp -r "$SCRIPT_DIR/CMakePresets.json" "$QGIS_WORKTREE_FOLDER/$BRANCH/CMakePresets.json"
