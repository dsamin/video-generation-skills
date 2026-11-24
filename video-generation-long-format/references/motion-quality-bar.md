# Motion quality bar and the critic loop (from the motion-video-kit review, 2026-10-01)

Source: a public Claude skill for launch-style business films (`github.com/echris6/motion-video-kit`, MIT; written for
HTML/GSAP/Three.js and AI footage, which we do not use). We take its *process and rules*, not its toolchain. Everything we make
is already deterministic canvas code with no AI footage, so its "label AI imagery" rule does not apply to us.

## The critic loop (adopt as-is, scaled to reels)
1. **Builder ≠ judge.** A fresh agent critiques the *encoded MP4* (frames it extracts itself, dense windows at every transition,
   frame-diff and loudness it measures). Never hand it your reasoning or a list of what you fixed.
2. **Gates:** storyboard critic (before building: chronology, truth, filler beats, is the idea clear on mute?) → style-frame look
   (creator) → full-film critic → verification critic (new agent, checks each prior item FIXED / PARTLY / STILL PRESENT and hunts
   regressions, ends SHIP or ONE MORE PASS). Fixes create new defects; a verification round is part of "done".
3. **Fix the largest gap first**, batch fixes into one patch render, keep a ledger (round → findings → change → measured result).
4. Build critic prompts from the gates and measurements above. The external kit's `critic-prompts.md` is optional
   inspiration when available; it is not bundled or required to run this loop.

## Motion grammar for 9:16 reels (the six rules, translated)
1. The foreground becomes the transition (a title, prop or shape carries across the cut; no empty gap).
2. One persistent actor with a stable identity (our narrator prop/character).
3. Density from hierarchy: one primary move, supporting staggers, tiny tertiary detail, all overlapping.
4. Change speed: readable target → fast exit → slowing arrival (ease into landings, leave quickly).
5. Within a continuous scene, an intentional matched cut can work when subject, scale, direction and material
   match and motion continues. Scene/world changes still use designed transitions; log intended cuts for the critic
   and detector rather than treating a bare world cut as an exception.
6. Show cause → effect (a button produces a state, a scan produces a result).
Composition: lead subject fills ~60–85% of the frame on feature beats (no small card in a big empty field); vary scale (macro →
wide → overhead → UI close-up → type impact); one or two reading targets at a time; name 3 "signature transformations" you can
describe without effect names.

## Measured bar (adjusted for narrated reels)
| Check | Kit target | Ours |
|---|---|---|
| Frozen time (`sh scripts/frozen-time.sh out/NN-slug.mp4`) | ≤ ~1 s per 30 s, no hold > 0.6 s except the CTA | Narrated reels are calmer: aim for no hold > 0.7 s and no more than ~15% near-frozen; give every reading hold a slow 3–5% push |
| Loudness | −14 punchy / −16 calm, true peak ≤ −1 dBFS | −16 LUFS, ≤ −1 dBFS (unchanged) |
| Dynamics | LRA ≥ ~3 LU energetic; 1.5–3 calm | report LRA |
| Effects vs music | ~+4 dB in each effect's own band; nothing poking out | spot-check key SFX against `music.wav` |
| SFX shape | reject rumble > 50% below 150 Hz, highs > 40% above 6 kHz, whooshes > 0.8 s | screen synth SFX before a new episode (below) |
| Text | WCAG AA contrast on settled text; frame 0 is a finished composition; equal spacing and aligned edges in lists; no text collisions mid-transition | |
| Determinism | same frame from different seek orders is identical | `render --check` + opposite-order stills |
| Mute test | a first-time viewer can say what it is about and what to do next with the sound off | captions are burned in; also check the *pictures* tell the story |

## Audio rules worth keeping
- Music matched to the viewer, kept well under the effects; one short, soft, rumble-free whoosh per real transition; clean UI
  sounds only on real actions; repeated sounds consistent; a music-only fallback to isolate complaints; change one thing per round.
- **Phones cannot play sub-150 Hz.** Synth hits that are pure sub (our `thud`, `stamp`) vanish on a phone speaker: add a 1–2 kHz
  transient and a 150–300 Hz body. Keep chimes short (our `chime` is 1.85 s).

## Calibration on episode 12 (62 s, finished)
- Frozen time: 13.8 s near-frozen (22%) but scattered; longest hold 0.7 s; five holds of 0.6–0.7 s (4.8, 6.5, 13.1, 19.8, 22.4 s).
  Calm and acceptable for a narrated reel; the cheap upgrade is a slow push on the "1 IN 7", $100 and door holds.
- SFX screen (kit script): `thud` 98% and `stamp` 94% of energy below 150 Hz → boomy on phones; `chime` 1.85 s → long; `whoosh`,
  `pop`, `tick`, `type`, `coin`, `ding`, `bonk`, `rustle`, `tear` pass. To fix in a new variant (do not alter old episodes' audio).

## The motion harness (from "How to build a motion design studio with Opus 5.5", 2026-10-21)

Source: x.com/0xMovez/status/2104216919033192746, a 12-step course distilled from the September 2026 wave of
code-rendered motion films. Its thesis: "The prompt is 10% of the video. The other 90% is the harness." Our engine
already has the seek(t) core (`renderFrame(t)` in the player, headless Chromium, ffmpeg, `--check` for determinism).
These are the pieces we added or adopted. The creator wants every reel built this way: code-drawn motion design,
not generated images (lessons, 2026-10-21).

**Banned defaults** (the "AI video" giveaways): a centered title on a gradient; everything fading in; corner labels
and frame borders; glow on UI chrome; generic particle bursts; dead time. Captions, the frame-one title card and the
`@DollarDevan` mark are house elements, not corner labels.

**Springs, not curves.** For anything with mass, use the closed-form springs in `engine/anim.js`: `spring(t, k, d)`,
the `SPRING` presets (`snappy` UI and leading edges · `default` cards and camera · `heavy` big type, lockups, no
overshoot · `playful` mascots and stickers, visible overshoot), and `track(t, keys)` for any value with several
targets (a cursor, a counter, a container's width, a camera). `track` adds one spring per change, so motion never
restarts and frame N needs no history. Keep `tw()`/`ease` for wipes, fades and linear-feeling moves. Two edges on
different springs (lead `snappy`, trail `default`) make an indicator stretch.
**Morphing containers:** one shape that never cuts and changes size, radius and fill from state to state reads as
expensive. Content inside enters after the morph starts and leaves before the next one (`swapAlpha`).
**Infinite zooms and loops:** `zoomExp(t, ratio, period)` gives constant perceived speed at any depth; `loopT`
wraps time, and a loop needs the last frame to equal the first, positions *and* velocities.
**Beat grid:** we synthesize the score, so the grid is known. `snapBeat(t, bpm)` puts state changes on beats and big
moments on downbeats. The voice still leads: snap a visual hit only when it moves less than ~0.15 s from its word.
**Seeded noise only:** `rng(seed)` (mulberry32), never `Math.random` in a frame.
**Motion blur (opt-in):** `"motionBlur": { "sub": 4, "shutter": 0.5 }` in `script.json` (or `render.mjs --sub 4`)
renders 4 subframes over the last half of each frame interval and averages them. Static frames stay sharp. It costs
×sub render time, so use it where the camera or big shapes move fast (zooms, whips, drops). Fast 30 fps moves
without it strobe. Export `needsBlur(t)` from `scenes.js` (true while the camera moves) and the renderer captures held
frames once instead of ×sub: ep30's full blur pass took ~45 min; with `needsBlur` most of the reel renders at 1×.
**Scaled text gotcha:** never cache text to a bitmap and then scale it; draw text at its final scale every frame,
or it goes soft in zooms.
**Something new every 2–4 s,** a primary move every beat, and a visual payoff every 3–5 s.

### Spec before code: the state list
For a reel, write `docs/superpowers/specs/<date>-<slug>-shotlist.md` before `scenes.js`: every shot with its time
span from the timeline, its *states* (what each element is at the start and end), camera, on-screen text, the
transition out, and SFX. Morph and zoom pieces get a state list ("bill → oval → café → register drawer → …"), not a
vibe. Show it at the storyboard check-in.

### Parallel builders share an ANIMATION_GUIDE
When episodes or chapters are built by several agents or sessions at once, write `ANIMATION_GUIDE.md` first (in the
shared kit's folder or the spec dir): palette hex values, type, line weights, spring presets per element class, the
transition grammar, Devan's construction, the caption and safe zones, and banned looks. Every builder reads it
before coding, so the pieces look like one series.

### Score the frames (critic rubric)
Render sheets with `scripts/critique-sheets.sh <video> <fast-move times…>` (2 fps contact sheet, 360 px phone
sheet, 12-frame strips). The critic is "a harsh motion director, not a proud author" and scores 1–10 on:
**hook in the first 2 s · readability at 360 px · motion quality (springs, no dead frames) · variety (new thing
every 2–4 s) · composition (lead subject 60–85% of frame) · brand accuracy (Devan, captions, end card) · sound
sync.** It lists the 3 biggest problems with timestamps, hunting for: text overlapping during swaps, anything sliding
instead of easing, corner labels or frame borders, a centered-on-gradient shot, blurry scaled text, a dead beat,
and a stutter at a loop seam. Fix the 3, patch-render only the affected seconds, re-score. Log each round in
`docs/superpowers/specs/<date>-<slug>-review-log.md`. Minimum 3 rounds on style frames, and ship only when every
score is 8 or more. This rubric runs inside the builder ≠ judge gates above.
