#!/usr/bin/env python3
"""check_wpm.py <episode-dir> — speaking rate of every raw TTS take (tempo 1.0) with retake flags.
Uses only the standard library (the takes are 16-bit PCM WAVs written by tools/tts.py)."""
import json, sys, wave
from pathlib import Path

ep = Path(sys.argv[1] if len(sys.argv) > 1 else ".")
script = json.loads((ep / "script.json").read_text())
tempo = float((script.get("tts") or {}).get("tempo", 1.0))
total = 0.0
for l in script["lines"]:
    f = ep / "audio" / "vo" / "raw" / f"{l['id']}.wav"
    if not f.exists():
        print(f"{l['id']:5} (no take yet)"); continue
    with wave.open(str(f)) as w:
        d = w.getnframes() / w.getframerate()
    total += d
    wpm = len(l["say"].split()) / d * 60
    flag = "  <- too fast: add a slower direction" if wpm > 200 else "  <- dragging: add 'Natural conversational pace, keep it moving'" if wpm < 120 else ""
    print(f"{l['id']:5} {d:6.2f}s {wpm:4.0f} wpm{flag}")
print(f"raw speech {total:.1f}s -> {total / tempo:.1f}s at tempo {tempo}")
