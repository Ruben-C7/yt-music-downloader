# High Quality Music Downloader

A Bash script to download audio from YouTube videos in the **best available quality** (Opus, M4A, etc.) and manage metadata for media servers like Jellyfin and Navidrome.

## Features

- **Best Quality Download:** Automatically selects the highest quality audio format available (no forced MP3 conversion).
- **Universal Metadata:** Adds/Edits metadata (Title, Artist, Album) compatible with MP3, M4A, Opus, and FLAC.
- **Media Server Ready:** Tags are optimized for Jellyfin, Navidrome, and other players.
- **Organization:** Moves downloaded music into `Artist/Album` directories.
- **Thumbnails:** Embeds the video thumbnail as the album cover.

## Requirements

You need to have the following installed on your system:

- **yt-dlp**: To download the audio.
- **ffmpeg**: To process audio and write metadata to various formats.

### Installation of requirements (Ubuntu/Debian):

```bash
sudo apt update
sudo apt install yt-dlp ffmpeg
```

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

   **IMPORTANT:** Always wrap the URL in quotes "" if it contains special characters like &

   ```
   ./music.sh <Youtube URL>
   ```

5. Follow the prompts to edit metadata if desired.

## License

This project is licensed under the MIT License.
