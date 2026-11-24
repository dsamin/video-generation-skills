#!/bin/sh
# fetch_reference.sh <x.com/twitter status URL> [out-dir]
# Pulls a reference post via the fxtwitter API (no login): saves tweet.json, prints the post text plus any quoted
# post / X Article text (prompt packs often live there), downloads the ~720p mp4, and writes contact sheets.
set -e
URL="$1"; OUT="${2:-./ref}"
[ -n "$URL" ] || { echo "usage: fetch_reference.sh <x.com status url> [out-dir]" >&2; exit 1; }
PATH_PART=$(printf '%s' "$URL" | sed -E 's#^https?://(www\.)?(x|twitter|fxtwitter|vxtwitter)\.com/##; s#\?.*$##')
mkdir -p "$OUT"
curl -sf "https://api.fxtwitter.com/$PATH_PART" -o "$OUT/tweet.json" || { echo "fxtwitter fetch failed for $PATH_PART" >&2; exit 1; }
python3 - "$OUT" <<'PY'
import json, sys
out = sys.argv[1]
t = json.load(open(f"{out}/tweet.json"))["tweet"]
print(f"@{t['author']['screen_name']}: {t.get('text','')}\n")
q = t.get("quote")
if q:
    print(f"--- quoted @{q['author']['screen_name']}: {q.get('text','')}")
    art = q.get("article") or {}
    if art:
        print(f"--- article: {art.get('title','')}")
        for b in (art.get("content") or {}).get("blocks", []):
            if b.get("text", "").strip(): print(b["text"])
media = [m for m in (t.get("media") or {}).get("all", []) if m.get("type") in ("video", "gif")]
if not media and q: media = [m for m in (q.get("media") or {}).get("all", []) if m.get("type") in ("video", "gif")]
if not media: print("\n(no video found)"); sys.exit(0)
m = media[0]
mp4s = [f for f in m.get("formats", []) if f.get("container") == "mp4"] or [{"url": m["url"], "bitrate": 0}]
mp4s.sort(key=lambda f: f.get("bitrate", 0))
pick = next((f for f in mp4s if "1280x720" in f["url"] or "720x1280" in f["url"]), mp4s[-1])
open(f"{out}/video_url.txt", "w").write(pick["url"])
print(f"\nvideo {m.get('width')}x{m.get('height')} {m.get('duration')}s -> {pick['url'][:90]}...")
PY
if [ -f "$OUT/video_url.txt" ]; then
  curl -sL -o "$OUT/ref.mp4" "$(cat "$OUT/video_url.txt")"
  ffmpeg -v error -y -i "$OUT/ref.mp4" -vf "fps=1/2.5,scale=480:-1,tile=4x3" "$OUT/sheet%d.png"
  echo "saved: $OUT/ref.mp4 and $(ls "$OUT"/sheet*.png | wc -l | tr -d ' ') contact sheet(s): $OUT/sheet*.png"
fi
