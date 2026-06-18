#!/usr/bin/env bash

# Keep track of failed builds
FAILED_FOLDERS=()

# Check if at least one argument is provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <folder1> [folder2 ...]"
    exit 1
fi

# Iterate over all provided arguments
for folder in "$@"; do
    if [ -d "$folder" ]; then
        echo "============================================================"
        echo "Building in directory: $folder"
        echo "============================================================"
        
        # Run cmake in a subshell to cleanly handle directory changes
        if (
            cd "$folder"
            cmake --workflow build-for-testing
        ); then
            echo "Successfully built in $folder"
        else
            echo "Error: Build failed in $folder. Moving to the next folder..."
            FAILED_FOLDERS+=("$folder")
        fi
        echo
    else
        echo "Warning: Directory '$folder' does not exist. Skipping."
    fi
done

echo "============================================================"
if [ ${#FAILED_FOLDERS[@]} -eq 0 ]; then
    echo "Completed building all specified folders successfully."
else
    echo "Finished, but the following folders failed to build:"
    for failed in "${FAILED_FOLDERS[@]}"; do
        echo "  - $failed"
    done
    exit 1
fi
