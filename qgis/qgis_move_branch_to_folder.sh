#!/bin/bash

# Check if first argument is provided
if [ -z "$1" ]; then
    echo "Error: Branch name is required"
    echo "Usage: $0 <branch_name>"
    exit 1
fi

BRANCH="$1"

cd ~/QGIS

# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    echo "Error: Branch '$BRANCH' already exists"
    exit 1
fi

MAIN_FOLDER="/QGIS"

# Or check first:
if [ ! -d "$MAIN_FOLDER" ]; then
    sudo mkdir -p "$MAIN_FOLDER"
    sudo chown -R $USER:$USER "$MAIN_FOLDER"
fi

git checkout -b "$BRANCH"
git checkout master

git worktree add "$MAIN_FOLDER/$BRANCH" "$BRANCH"

# copy necessary files to the new worktree
cp -r ./build-qt "$MAIN_FOLDER/$BRANCH/"
cp -r ./.vscode "$MAIN_FOLDER/$BRANCH/"
cp -r ./CMakePresets.json "$MAIN_FOLDER/$BRANCH/CMakePresets.json"