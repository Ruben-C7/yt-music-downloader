# Music Downloader

A simple Bash script to download audio from YouTube videos and manage metadata.

## Features

- Downloads audio in MP3 format.
- Embeds thumbnail and adds metadata.
- Allows editing of metadata after download.
- Organizes downloaded music into artist/album directories.

## Requirements

- yt-dlp: A command-line program to download videos from YouTube and other sites.
- eyeD3: A tool for working with audio files, specifically for editing ID3 tags.

## Usage

1. Clone the repository:

   ```
   git clone <repository-url>
   cd yt-music-downloader
   ```

2. Make the script executable:

   ```
   chmod +x music.sh
   ```

3. Change the Destination directory:

   ```
   sed -i '0,/^DEST_DIR=/s|^DEST_DIR=.*|DEST_DIR="/your/path/here"|' music.sh
   ```

4. Run the script with a YouTube URL:

   ```
   ./music.sh <Youtube URL>
   ```

5. Follow the prompts to edit metadata if desired.

## License

This project is licensed under the MIT License.
