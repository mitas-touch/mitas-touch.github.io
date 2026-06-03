#!/usr/bin/env bash
# Convert MiTaS .mov sources to web-friendly MP4 (H.264 + AAC, faststart).
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
command -v ffmpeg >/dev/null || { echo "Install ffmpeg: brew install ffmpeg"; exit 1; }

convert() {
  local input="$1"
  local output="$2"
  local crf="${3:-23}"
  echo "→ $output"
  ffmpeg -y -i "$input" \
    -c:v libx264 -crf "$crf" -preset medium -pix_fmt yuv420p \
    -c:a aac -b:a 128k -movflags +faststart \
    "$output"
}

mkdir -p static/videos

convert static/mitas_video.mov static/videos/mitas_teaser.mp4 23

convert static/robot_videos/gear_mitas.mov static/robot_videos/gear_mitas.mp4 23
convert static/robot_videos/board_mitas.mov static/robot_videos/board_mitas.mp4 26
convert static/robot_videos/lamp_install_mitas.mov static/robot_videos/lamp_install_mitas.mp4 23
convert static/robot_videos/lightbulb_mitas.mov static/robot_videos/lightbulb_mitas.mp4 23
convert static/robot_videos/keyinlock_mitas.MOV static/robot_videos/keyinlock_mitas.mp4 23

echo "Done."
