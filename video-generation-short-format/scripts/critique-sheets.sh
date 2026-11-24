#!/bin/sh
# critique-sheets.sh — the three sheets a critic looks at before scoring a render (from the 2026-10-21 motion course).
#   sh critique-sheets.sh <video.mp4> [strip-time ...]
# Writes next to the video:
#   <name>-contact.jpg  2 frames per second, 6 across: pacing, dead beats, "something new every 2-4 s"
#   <name>-phone.jpg    1 frame per second at 360 px wide: is every label and caption readable on a phone?
#   <name>-strip-T.jpg  12 consecutive frames from T-0.1 s: pops, overlaps and text collisions in fast moves
#   <name>-loop.mp4     the video twice back to back, only with LOOP=1: watch the seam of a looping reel
set -e
V="$1"; shift || true
[ -f "$V" ] || { echo "usage: sh critique-sheets.sh <video.mp4> [strip-time ...]" >&2; exit 1; }
B="${V%.*}"
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$V")
ROWS=$(python3 -c "import math; print(max(1, math.ceil($DUR * 2 / 6)))")
PROWS=$(python3 -c "import math; print(max(1, math.ceil($DUR / 6)))")
ffmpeg -v error -y -i "$V" -vf "fps=2,scale=180:-1,tile=6x$ROWS" -frames:v 1 "$B-contact.jpg"
ffmpeg -v error -y -i "$V" -vf "fps=1,scale=360:-1,tile=6x$PROWS" -frames:v 1 "$B-phone.jpg"
for T in "$@"; do
  S=$(python3 -c "print(max(0, $T - 0.1))")
  ffmpeg -v error -y -ss "$S" -i "$V" -vf "scale=240:-1,tile=12x1" -frames:v 1 "$B-strip-$T.jpg"
done
[ "${LOOP:-0}" = 1 ] && ffmpeg -v error -y -stream_loop 1 -i "$V" -c copy "$B-loop.mp4"
echo "sheets: $B-contact.jpg $B-phone.jpg${1:+ + strips}"
