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

# Download music (BEST QUALITY)
echo "Downloading music (Best Quality)..."
yt-dlp -x --embed-thumbnail --add-metadata -o "$TEMP_DIR/%(title)s.%(ext)s" "$URL"

# Find the file (Generic search, not just mp3)
FILE_PATH=$(find "$TEMP_DIR" -type f | head -n 1)

# In case of failure
if [ ! -f "$FILE_PATH" ]; then
    echo
    echo "Error: file not found!"
    rm -rf "$TEMP_DIR"
    exit 2
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Function to read metadata using ffprobe (works for any format)
get_meta() {
    ffprobe -v quiet -show_entries format_tags="$1" -of default=noprint_wrappers=1:nokey=1 "$FILE_PATH"
}

# Show the file
echo "Downloaded music: $FILE_PATH"
echo

# Read current metadata
cur_title=$(get_meta title)
cur_artist=$(get_meta artist)
cur_album=$(get_meta album)

# Show the metadata
echo "Actual metadata:"
echo "Title: $cur_title"
echo "Artist: $cur_artist"
echo "Album: $cur_album"
echo

# Ask if want to change
read -p "Do you want to change the metadata? (s/N): " edit

# If want edit
if [[ "$edit" =~ ^[sS]$ ]]; then

    # Ask the new metadata
    read -p "Title [$cur_title]: " title
    read -p "Artist [$cur_artist]: " artist
    read -p "Album [$cur_album]: " album

    # Use defaults if empty
    title=${title:-$cur_title}
    artist=${artist:-$cur_artist}
    album=${album:-$cur_album}
    
    echo
    echo "Updating metadata..."
    
    # Create temp file for ffmpeg output
    TEMP_OUT="$TEMP_DIR/temp_tagged.$EXT"
    
    # Change metadata using ffmpeg (Universal for opus, m4a, mp3)
    ffmpeg -y -v error -i "$FILE_PATH" \
        -metadata title="$title" \
        -metadata artist="$artist" \
        -metadata album="$album" \
        -c copy "$TEMP_OUT"

    # Replace original with tagged file
    mv "$TEMP_OUT" "$FILE_PATH"
    
    echo "Metadata changed!"
    echo

    # Update variables for folder creation
    final_artist="$artist"
    final_album="$album"

else
    # Keep original metadata for folders
    final_artist="$cur_artist"
    final_album="$cur_album"
fi

# Sanitize variables for folder names (remove empty spaces/bad chars if needed, optional)
# For now, using raw values as per original script logic but handling empty cases
if [ -z "$final_artist" ]; then final_artist="Unknown Artist"; fi
if [ -z "$final_album" ]; then final_album="Unknown Album"; fi

# Move to the final directory
FINAL_DIR="$DEST_DIR/$final_artist/$final_album/"

echo
echo "Moving to $FINAL_DIR..."

mkdir -p "$FINAL_DIR"
mv "$FILE_PATH" "$FINAL_DIR"

# Delete the temp dir
rm -rf "$TEMP_DIR"

echo "Finished! Music moved to $FINAL_DIR"