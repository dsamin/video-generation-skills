#!/bin/sh
# cutcheck.sh <NN-slug> [threshold=0.25] [extra times...]
# Finds hard cuts in the rendered picture (out/<slug>-video.mp4, else the master) with ffmpeg's scene detector, then
# writes a 10 fps strip (±0.45 s) around every detected cut and every extra time you pass (e.g. your planned
# transitions), stacked into out/<slug>-cuts.jpg for review. Captions are included, so a caption change alone never
# trips it (scores stay far below the threshold). 0 detected cuts = no jump cuts left; any hit must be an intended cut.
# Usage from the repo root:  sh <skill-dir>/scripts/cutcheck.sh 08-shrinkflation 0.25 5.9 13.8 16.7
set -e
SLUG="$1"; TH="${2:-0.25}"
[ -n "$SLUG" ] || { echo "usage: cutcheck.sh <NN-slug> [threshold] [extra times...]" >&2; exit 1; }
shift; [ $# -gt 0 ] && shift
VID="out/$SLUG-video.mp4"; [ -f "$VID" ] || VID="out/$SLUG.mp4"
[ -f "$VID" ] || { echo "no video at out/$SLUG-video.mp4 or out/$SLUG.mp4" >&2; exit 1; }
TMP=$(mktemp -d)
CUTS=$(ffmpeg -hide_banner -i "$VID" -vf "select='gt(scene,$TH)',showinfo" -f null - 2>&1 | grep -oE "pts_time:[0-9.]+" | cut -d: -f2)
N=$(printf '%s\n' "$CUTS" | grep -c . || true)
echo "hard cuts above scene score $TH: $N"
[ "$N" -gt 0 ] && printf '  %ss\n' $CUTS
i=0
for T in $CUTS "$@"; do
  S=$(python3 -c "print(max(0, $T - 0.45))")
  ffmpeg -v error -y -ss "$S" -t 0.9 -i "$VID" -vf "fps=10,scale=180:-1,tile=9x1" -frames:v 1 "$TMP/$(printf '%03d' $i).png"
  i=$((i + 1))
done
if [ "$i" -gt 0 ]; then
  python3 - "$TMP" "out/$SLUG-cuts.jpg" <<'PY'
import glob, sys
from PIL import Image
fs = sorted(glob.glob(sys.argv[1] + '/*.png'))
ims = [Image.open(f) for f in fs]
w = max(i.size[0] for i in ims); h = sum(i.size[1] for i in ims) + 6 * len(ims)
s = Image.new('RGB', (w, h)); y = 0
for i in ims: s.paste(i, (0, y)); y += i.size[1] + 6
s.save(sys.argv[2], quality=85)
print(f"strips ({len(ims)} rows, 10 fps, ±0.45 s): {sys.argv[2]}")
PY
fi
rm -rf "$TMP"
