# Pipeline architecture and engineering rationale

The whole video is code. A deterministic canvas renderer draws each frame from a time value. Gemini-TTS voices a
script. A synthesizer writes the score and sound effects. ffmpeg assembles the result. Nothing is hand-edited in a
timeline app, so every video can be re-cut, re-voiced and re-rendered from source.

Reference implementation: `~/Projects/Video-Series` (the author's machine). Its `docs/PLAYBOOK.md` and `CLAUDE.md` are the
living versions of these notes. When a detail here and the repo disagree, the repo wins.

## Contents
1. Data flow
2. Directory layout
3. Why it is built this way
4. Commands
5. Performance and cost numbers
6. Building the same thing elsewhere

## 1. Data flow

```
reference link ──► contact sheets + style notes ─┐
topic brief ──► research agents ──► fact-check ──┤
                                                  ▼
                                  episodes/NN-slug/script.json   (lines, scenes, timing, music, tts)
                                                  │
                     tools/tts.py ──► audio/vo/raw/<id>.wav (untouched takes)
                                  ──► audio/vo/<id>.wav (tempo-adjusted), durations.json, envelopes.json
                                                  │
                   tools/timeline.mjs ──► timeline.json (every line's start/end, every scene's start/dur)
                                                  │
     episodes/NN-slug/scenes.js  draw(ctx, lt, env) per scene, keyed to line times; cues() for SFX
                                                  │
     engine/player.html + player.js ──► window.renderFrame(t)  (headless Chromium via Playwright)
                                                  │
     tools/stills.mjs  (review frames) ──► tools/render.mjs (5 workers ─► ffmpeg segments ─► concat)
                                                  │                         out/NN-slug-video.mp4
     tools/synth.mjs ──► audio/music.wav + audio/sfx/*.wav   (from timeline + script.music)
                                                  │
     tools/mix.mjs ──► places VO + SFX cues, ducks music, levels lines, loudnorm −16 LUFS, muxes
                   ──► out/NN-slug.mp4, out/NN-slug.srt, out/NN-slug-thumbnail.png
                                                  │
     deliverables: -upload.mp4, -preview.mp4 (720p), -cover.png, -contact.png, titles + description
```

## 2. Directory layout

```
engine/            renderer + style kits (shared by all episodes)
  player.html/js   loads an episode, exposes renderFrame(t); transitions: cut, pan, slide, iris, fade, tear
  timeline.js      buildTimeline(script, durations, timing) → lines/scenes with absolute times
  captions.js      chunkCaption(text, maxChars) + captionAt(timeline, t)
  anim.js          clamp, lerp, seg, tw, ease.{in,out,inOut,outBack,outElastic}, hop, pop, qbez
  sketch.js        ink-and-hatch style (ep01) + rng(seed), hashSeed(...)
  devan.js         ink Devan mascot + LOOK colors + mouthAt()
  paper.js         paper-cutout primitives (piece, rough, tag, cutText, hangingTitle, layer cache, finish)
  paper-kit.js     9:16 paper reel kit (REEL layout, sky/hills/strata, board, captions, post)
  paper-props.js   generic paper props (bill, barrel, car, truck, building, thermometer, arrows, confetti…)
  devan-paper.js   paper Devan: devan(), stroll(), aimArm(), handPos()
  vox.js           Vox collage primitives (stage, halftone cutout, statCard, typeStrip, pins, strings, stamps…)
  vox-kit.js       Vox reel kit (fonts, captions with red numbers, camera, stageCam, devanHT)
tools/
  tts.py           Kokoro (local) or Gemini-TTS (cloud) per line, cached, tempo via ffmpeg atempo
  timeline.mjs     script.json + durations.json → timeline.json
  stills.mjs       render chosen frames (seconds or scene:offset) to PNGs, --sheet tiles them
  render.mjs       parallel deterministic render; --check determinism probe; --from/--to/--out patching
  synth.mjs        procedural score (pad, bass, lead, drums) + SFX library
  mix.mjs          voice/SFX placement, ducking, leveling, loudness, mux, SRT, thumbnail
  thumbnail.mjs    renders an episode's thumbnail.js variants (YouTube 16:9 thumbnails)
  verify.sh        stream specs, A/V length delta, loudness, contact sheet
  launch-kit.mjs   channel art + profile copy kit from engine/brand.js (avatar/banner/watermark.mjs are superseded)
episodes/
  _template/       copy this to start an episode (scenes.js + script.json)
  NN-slug/         script.json, scenes.js, timeline.json, audio/ (generated, gitignored)
out/               renders and deliverables (gitignored)
```

## 3. Why it is built this way

- **Voice first, visuals keyed to the voice.** Scenes never use fixed times except for short entrances at a scene's
  start. Every beat is `at(env, 'lineId', fraction)` or `atW(env, 'lineId', 'word')`. When a line is re-recorded, the
  timeline rebuilds and every visual re-times itself, with no manual re-sync.
- **Scenes stretch to fit their lines.** `buildTimeline` lays each scene out as lead + lines (with gaps) + tail. The
  voice is never cut off, and pacing is tuned in `script.json` `timing`, not in the animation.
- **Determinism.** `renderFrame(t)` is a pure function of `t`. Randomness comes from seeded `rng()`. Static art is
  cached in offscreen canvases (`layer()`, `VX.cutout()`) but never depends on render order. Fonts load before the
  first frame. `render.mjs --check` renders the same frames in two pages with different histories and compares
  hashes. Determinism is what makes parallel workers and patch re-renders possible.
- **Speed changes happen in the pipeline, never on the final video.** Voice tempo is applied to the raw takes
  (`tts.tempo`, pitch preserved), and gaps are tuned in `timing`. Speeding up the finished mp4 would warp the music,
  SFX and animation.
- **Review stills before a render.** A full 2-minute render costs ~20 minutes. `tools/stills.mjs … --sheet` costs
  ~0.4 s per frame. Every layout bug so far was caught in stills.
- **Additive engine changes only.** Episodes share the engine. A new style, transition or synth option is added
  beside the old ones with defaults unchanged, then proven with pixel hashes: render the same frames of every older
  episode before and after, and require an exact match. Re-synthesizing an old episode must give byte-identical wavs.
  New SFX are appended after existing ones because they share one seeded rng stream.
- **One config file per episode.** `script.json` holds size, fps, voice, timing, music and every line. A new
  episode is mostly writing that file plus `scenes.js`.
- **Cache everything expensive.** A TTS take is keyed by text + voice + model + prompt + direction, so only changed
  lines are re-synthesized. Raw takes are kept, so tempo can be retuned without new API calls.
- **Fact-check like a newsroom.** Finance and economics scripts get primary-source research plus an adversarial
  checker (it found real errors in every episode). Sources go on the end card (reels) or in the description (long-form); "not financial advice" is always
  shown.

## 4. Commands

**Always set `EP`.** The npm scripts default to `episodes/01-covered-calls-wheel`, so a bare `npm run tts` or
`npm run render` would re-voice or re-render ep01. Templates: `episodes/_template` (9:16 paper reel) and
`episodes/_template-16x9` (16:9 sketch long-form with chapter cards and a thumbnail).

```bash
export EP=episodes/NN-slug
EP=$EP npm run tts            # voice (only changed lines are re-synthesized)
EP=$EP npm run timeline       # prints scene starts/durations and total
node tools/stills.mjs $EP hook:3 fall:9.5 120.4 --sheet    # review frames → out/NN-slug-stills.png
EP=$EP npm run synth          # music + sfx (re-run whenever the timeline changes)
node tools/render.mjs $EP --check                          # determinism probe (4 frames, 2 pages)
EP=$EP npm run render         # full render (run in the background; ~20 min per 2 min of 1080×1920)
EP=$EP npm run mix            # final mp4 + srt + thumbnail
sh tools/verify.sh NN-slug    # specs, A/V delta, loudness, contact sheet
npm test                      # timeline + captions unit tests
```

Patch one range without a full re-render (frames a..b; offset = a/30):

```bash
node tools/render.mjs $EP --from a --to b --out out/patch.mp4
ffmpeg -i out/NN-slug-video.mp4 -itsoffset <a/30> -i out/patch.mp4 \
  -filter_complex "[0:v][1:v]overlay=eof_action=pass:enable='between(n,a,b-1)'" \
  -c:v libx264 -crf 17 -pix_fmt yuv420p out/NN-slug-video-new.mp4
mv out/NN-slug-video-new.mp4 out/NN-slug-video.mp4 && EP=$EP npm run mix
```

Check the splice by extracting frames a−1, a, (a+b)/2, b−1 and b from the final video.

**Tail patch: a changed ending, or a new total length (ep16's 18 s → 7 s end card).** If no scene before the change
moves (diff the old and new `timeline.json`), keep the head as is and re-render only from a keyframe to the end:

```bash
ffprobe -v error -select_streams v:0 -skip_frame nokey -show_entries frame=pts_time -of csv=p=0 \
  -read_intervals 440%460 out/NN-slug-video.mp4          # find a keyframe k/30 (segment starts are keyframes)
sh tools/render-seg.sh $EP k N out/tail/tail.mp4          # N = the new timeline's frame count
ffmpeg -i out/NN-slug-video.mp4 -frames:v k -c copy out/tail/head.mp4   # by FRAME COUNT: -t k/30 kept 2 extra frames
printf "file 'head.mp4'\nfile 'tail.mp4'\n" > out/tail/list.txt
ffmpeg -f concat -safe 0 -i out/tail/list.txt -c copy out/NN-slug-video.mp4
```

Verify: the frame count equals N, and the frames k−1 and k hash the same as in the old video
(`ffmpeg -v error -i F -vf "select=eq(n\,K)" -vsync 0 -frames:v 1 -f rawvideo - | shasum` for each file F and frame K) (rendering is
deterministic, so the seam is invisible). Then re-run `npm run synth` and `mix` for a new length. For a picture-only
change (same timeline), you can instead put the already-verified audio on the new picture:
`ffmpeg -i out/NN-slug-video.mp4 -i out/NN-slug.mp4 -map 0:v -map 1:a -c copy`.

## 5. Performance and cost numbers (Mac mini, 5 workers)

- A 1080×1920 frame takes ~0.35 s in stills and renders at 3.5–3.6 fps: 4,093 frames took 1,163 s.
- A 1920×1080 frame costs about the same. Plan ~9–10 min of render per minute of video.
- Halftone cutouts are cached per key. A live halftone Devan costs ~20 ms per frame.
- Gemini-TTS takes ~5–10 s per line (22 lines ≈ 2–3 min) and retries with backoff on quota errors.
- Output sizes for 2:16 at 1080×1920: master (CRF 17) 100–170 MB, where halftone detail inflates it. Upload copy
  (CRF 22) 38–64 MB. 720p preview (CRF 26) 7–12 MB.
- Disk: keep ≥ 2 GB free for a reel and ≥ 3 GB for long-form (swap from other apps can take several GB mid-render). Check `df -h` first; this machine has run out before.

## 6. Building the same thing elsewhere

To use this in another project or tool:
1. Run `scripts/bootstrap.sh <new-dir>` from this skill. It copies the engine, tools and template from the
   reference repo, installs npm and Python deps, and checks ffmpeg and Playwright.
2. If the reference repo is unavailable, rebuild the minimum from this spec:
   - A player page that loads `scenes.js` and exposes `renderFrame(t)`.
   - The timeline builder described in §3.
   - Playwright screenshots piped into ffmpeg.
   - tts.py as described in `voice-google-tts.md`.
   - A mixer that places VO at line starts, ducks music, and runs ffmpeg `loudnorm=I=-16:TP=-1.5:LRA=11` (two-pass).
   Keep the same `script.json` schema so these references still apply.
