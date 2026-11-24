#!/usr/bin/env python3
"""seams.py <episode-dir> [extra-seconds ...] — print stills times for the frame pair on each side of every scene
boundary (last frame of the old scene, first frame of the new one), plus any extra in-scene switch points you pass.
Feed the output to tools/stills.mjs --sheet and check that each pair matches:
  node tools/stills.mjs $EP $(python3 seams.py $EP) --sheet --cols 8
(zsh: wrap as ${=$(...)} or use a variable with ${=T})."""
import json, sys
ep = sys.argv[1]
tl = json.load(open(f"{ep}/timeline.json"))
fps = tl.get("fps", 30)
pts = [s["start"] for s in tl["scenes"][1:]] + [float(x) for x in sys.argv[2:]]
out = []
for t in sorted(pts):
    f = round(t * fps)
    out += [f"{(f - 1) / fps:.3f}", f"{(f + 1) / fps:.3f}"]
print(" ".join(out))
