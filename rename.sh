#!/bin/bash

# Check if argument is provided
if [ -z "$1" ]; then
    echo "Use like: $0 /path/to/directory"
    exit 1
fi

# Check if the directory exists
if [ ! -d "$1" ]; then
    echo "Error: Directory not found: $1"
    exit 2
fi

# Recursively find all .mp3 files
find "$1" -type f -iname "*.mp3" | while IFS= read -r mp3file; do

    # Extract artist and title using eyeD3
    artist=$(eyeD3 "$mp3file" | grep "artist:" | head -n1 | cut -d':' -f2- | xargs)
    title=$(eyeD3 "$mp3file" | grep "title:" | head -n1 | cut -d':' -f2- | xargs)

    # Skip files with missing metadata
    if [ -z "$artist" ] || [ -z "$title" ]; then
        echo "Skipping (missing metadata): $mp3file"
        continue
    fi

    # Sanitize filename
    safe_artist=$(echo "$artist" | tr '/\\:*?"<>|' '_')
    safe_title=$(echo "$title" | tr '/\\:*?"<>|' '_')
    new_name="${safe_artist} - ${safe_title}.mp3"

    # Build full path
    dir=$(dirname "$mp3file")
    new_path="$dir/$new_name"

    # Rename if needed
    if [ "$mp3file" != "$new_path" ]; then
        if [ -e "$new_path" ]; then
            echo "Skipping (file already exists): $new_path"
        else
            echo "Renaming: $mp3file -> $new_path"
            mv "$mp3file" "$new_path"
        fi
    fi
done
