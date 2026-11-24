#!/bin/sh
# deliver.sh <NN-slug> <cover-seconds> [portrait|landscape]   (run from the repo root, after npm run mix)
# portrait (reels):  out/<slug>-upload.mp4 (CRF 22), out/<slug>-preview.mp4 (720p, CRF 26, AAC 128k), out/<slug>-cover.png
# landscape (long-form YouTube): out/<slug>-preview.mp4 only (960×540, CRF 30, AAC 96k: under 30 MB to ~10 min, so it
#   reaches the phone); no -upload copy or cover (YouTube only, and the thumbnail is designed). The thumbnail JPGs go
#   into the final folder instead.
set -e
N="$1"; T="${2:-3}"; O="${3:-portrait}"
[ -f "out/$N.mp4" ] || { echo "out/$N.mp4 not found (run from the repo root after npm run mix)" >&2; exit 1; }
if [ "$O" = landscape ]; then
  ffmpeg -v error -y -i "out/$N.mp4" -vf "scale=960:540" -c:v libx264 -preset slow -crf 30 -c:a aac -b:a 96k -movflags +faststart "out/$N-preview.mp4"
  MADE="out/$N.mp4 out/$N-preview.mp4"; POST="$N.mp4 $N.srt"
else
  ffmpeg -v error -y -i "out/$N.mp4" -c:v libx264 -preset slow -crf 22 -c:a copy -movflags +faststart "out/$N-upload.mp4"
  ffmpeg -v error -y -i "out/$N.mp4" -vf "scale=720:1280" -c:v libx264 -preset slow -crf 26 -c:a aac -b:a 128k -movflags +faststart "out/$N-preview.mp4"
  ffmpeg -v error -y -ss "$T" -i "out/$N.mp4" -frames:v 1 "out/$N-cover.png"
  MADE="out/$N.mp4 out/$N-upload.mp4 out/$N-preview.mp4 out/$N-cover.png"; POST="$N.mp4 $N-upload.mp4 $N-cover.png $N.srt"   # the preview is for review only
fi
for f in $MADE; do
  printf '%8.1f MB  %s\n' "$(echo "$(stat -f%z "$f" 2>/dev/null || stat -c%s "$f") / 1048576" | bc -l)" "$f"
done
# Only the files meant for posting go into out/<slug>-final/ (hard links, no extra disk). out/<slug>-video.mp4 is the
# SILENT render the mixer uses; it must never be uploaded (a creator once posted it and got a mute Short).
mkdir -p "out/$N-final"
for f in $POST; do [ -f "out/$f" ] && { ln -f "out/$f" "out/$N-final/$f" 2>/dev/null || cp -f "out/$f" "out/$N-final/$f"; }; done  # cp where the volume has no hard links
for f in "out/$N-final/$N.mp4" "out/$N-final/$N-upload.mp4"; do
  [ -f "$f" ] || continue
  ffprobe -v error -select_streams a -show_entries stream=codec_name -of csv=p=0 "$f" | grep -q . || echo "ERROR: $f has no audio track"
done
if [ "$O" = landscape ]; then
  for f in out/"$N"-yt-thumbnail-*.jpg; do [ -f "$f" ] && ln -f "$f" "out/$N-final/$(basename "$f")"; done
  echo "post from: out/$N-final/  YouTube: $N.mp4 + $N.srt. Keep the chosen thumbnail as thumbnail.jpg (drop the other) and write YOUTUBE-UPLOAD.md there."
else
  echo "post from: out/$N-final/  YouTube: $N.mp4 (master, ~10 Mbps; YouTube re-compresses, so give it the best source)  Instagram/TikTok: $N-upload.mp4"
fi
P=$(stat -f%z "out/$N-preview.mp4" 2>/dev/null || stat -c%s "out/$N-preview.mp4")
[ "$P" -lt 31457280 ] || echo "WARNING: preview is over 30 MB; raise CRF by 2 so it reaches the phone"
