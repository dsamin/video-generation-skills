#!/bin/sh
# bootstrap.sh <new-project-dir>
# Seeds a new video project from the reference repo (engine, tools, templates, brand art, playbook), installs Node + Python deps
# and checks ffmpeg / Playwright. Source repo: $VIDEO_SERIES_REPO (default ~/Projects/Video-Series).
# Never copies credentials: TTS reads the Google key from GOOGLE_APPLICATION_CREDENTIALS (see voice-google-tts.md).
set -e
DEST="$1"; SRC="${VIDEO_SERIES_REPO:-$HOME/Projects/Video-Series}"
[ -n "$DEST" ] || { echo "usage: bootstrap.sh <new-project-dir>" >&2; exit 1; }
[ -d "$SRC/engine" ] || { echo "reference repo not found at $SRC (set VIDEO_SERIES_REPO)" >&2; exit 1; }
mkdir -p "$DEST/episodes" "$DEST/tools" "$DEST/docs" "$DEST/out"
cp -R "$SRC/engine" "$DEST/"
# brand art + the end screen episodes preload (never channel/source/: personal photos)
mkdir -p "$DEST/channel" && cp "$SRC"/channel/*.js "$SRC"/channel/*.html "$DEST/channel/" && cp -R "$SRC/channel/brand" "$DEST/channel/"
cp "$SRC"/tools/*.mjs "$SRC"/tools/*.py "$SRC"/tools/*.sh "$DEST/tools/"
for T in "$SRC"/episodes/_template*; do cp -R "$T" "$DEST/episodes/"; done
cp "$SRC/package.json" "$DEST/"
cp "$SRC/docs/PLAYBOOK.md" "$DEST/docs/"
[ -d "$SRC/tests" ] && cp -R "$SRC/tests" "$DEST/"
printf 'node_modules/\ntools/.venv/\ntools/models/\nout/\nepisodes/*/audio/\n*.log\n.DS_Store\n__pycache__/\n' > "$DEST/.gitignore"
cd "$DEST"
npm install --silent
npx playwright install chromium >/dev/null 2>&1 || echo "note: run 'npx playwright install chromium'"
python3 -m venv tools/.venv && tools/.venv/bin/pip -q install google-cloud-texttospeech soundfile numpy
command -v ffmpeg >/dev/null || echo "WARNING: ffmpeg not on PATH (brew install ffmpeg)"
[ -n "$GOOGLE_APPLICATION_CREDENTIALS" ] || [ -f "$HOME/.config/google-tts/credentials.json" ] || \
  echo "WARNING: no Google credentials found; see references/voice-google-tts.md §1"
echo "ready: $DEST  (reference episodes to study: $SRC/episodes/0*/)"
echo "next: cp -r episodes/_template episodes/01-slug   (or _template-16x9 for long-form) && export EP=episodes/01-slug"
