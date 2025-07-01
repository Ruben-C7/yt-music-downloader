#!/bin/bash

# Verify the arguments
if [ -z "$1" ]; then
    echo "Use like: $0 <Youtube URL>"
    exit 1
fi

# Define variables
URL=$1
TEMP_DIR="/tmp/music"
DEST_DIR="/srv/cloud/ruben/Musicas"

# Create (if doesn't exist) the temp directory
mkdir -p "$TEMP_DIR"

# Download mp3 file
echo "Downloading music..."
yt-dlp -x --audio-format mp3 --embed-thumbnail --add-metadata -o "$TEMP_DIR/%(title)s.%(ext)s" "$URL"

# Find the mp3 file
FILE_PATH=$(find "$TEMP_DIR" -type f -iname "*.mp3" | head -n 1)

# In case of failure
if [ ! -f "$FILE_PATH" ]; then
    echo
    echo "Error: file not found!"
    rm -rf "$TEMP_DIR"
    exit 2
fi

# Show the file
echo "Downloaded music: $FILE_PATH"
echo

# Show the metadata
echo "Actual metadata:"
eyeD3 "$FILE_PATH" | grep "^title"
eyeD3 "$FILE_PATH" | grep "^artist"
eyeD3 "$FILE_PATH" | grep "^album"
echo

# Ask if want to change
read -p "Do you want to change the metadata? (s/N): " edit

# If want edit
if [[ "$edit" =~ ^[sS]$ ]]; then

    # Ask the new metadata
    read -p "Title: " title
    read -p "Artist: " artist
    read -p "Album: " album
    echo
    # Change the metadata
    eyeD3 --title "$title" --artist "$artist" --album "$album" "$FILE_PATH" > /dev/null
    echo "Metadata changed!"
    echo

    # Show the new metadata
    echo "Final metadata: "
    eyeD3 "$FILE_PATH" | grep "^title"
    eyeD3 "$FILE_PATH" | grep "^artist"
    eyeD3 "$FILE_PATH" | grep "^album"

# If don't want edit
else
    artist=$(eyeD3 "$FILE_PATH" | grep "artist:" | head -n 1 | awk -F ': ' '{print $2}' | xargs)
    album=$(eyeD3 "$FILE_PATH" | grep "album:" | head -n 1 | awk -F ': ' '{print $2}' | xargs)
fi

# Move to the final directory
FINAL_DIR="$DEST_DIR/$artist/$album/"

echo
echo "Moving to $FINAL_DIR..."

mkdir -p "$FINAL_DIR"
mv "$FILE_PATH" "$FINAL_DIR"

# Delete the temp dir
rm -rf "$TEMP_DIR"

echo "Finished! Music moved to $FINAL_DIR"