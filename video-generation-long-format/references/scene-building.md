# Building scenes (`episodes/NN-slug/scenes.js`)

A scene is `draw(ctx, lt, env)`. `lt` is seconds since the scene started, and `env` carries `L` (this scene's
line times), `scene` (`{id, start, dur}`), `script`, `timeline`, `t` (global time), `mouth(t)`, and the kit's
textures. The module exports `scenes` (`{id: {draw, transition?}}`), `cues(timeline)` for SFX, and re-exports
`fonts, setup, drawCaption, post` from the style kit.

## Timing: key everything to the voice

```js
const at = (env, id, f = 0) => env.L[id].start + env.L[id].dur * f;          // f through line id (scene-local)
function wordFrac(line, word) {                                                  // character-proportional estimate
  const i = line.say.indexOf(word);
  if (i < 0) throw new Error(`"${word}" not in line ${line.id}`);                // typos fail loudly in stills
  return i / line.say.length;
}
const atW = (env, id, word) => at(env, id, wordFrac(env.script.lines.find(l => l.id === id), word));
```

- Start an effect slightly before its word (`atW(...) - 0.1`) so it lands as the word is heard.
- Only scene-entrance moves (a hero springing in at 0.1–0.2 s) use fixed times.
- `atW` is a character-position estimate, not a measured word onset. For a beat that must land on a specific
  word, measure the take (listen and/or inspect a 10 ms RMS envelope) and use its actual offset from the line
  start. Re-measure after retakes or tempo changes; keep cues on the same measured times.
- `cues(timeline)` uses the same helper on the global timeline (`timeline.lines` include `say`), so SFX stay
  synced after retakes. Keep `cues` in the same file and mirror each visual beat.

## Motion vocabulary

- **Entrances:** `popAt(lt, t0)` (paper) or `VX.spring(lt, t0, 0.45)` → `{s, y, on}`, with overshoot, scale and a
  small rise. Stagger groups by 0.12–0.2 s.
- **Counters:** `tick(lt, t0, t1, a, b)`, rounded for display. Add a `tick` SFX run and a `ding` or `thud` on landing.
- **Progressive drawing:** chart lines `p = tw(lt, t0, t1)`, strings, swipes and circle marks all take a 0..1
  progress.
- **Compositions inside a scene:** `const k = comp(lt, [0, t2, t3])` switches layouts on voice beats as hard cuts.
  That is cleaner than exit animations and matches documentary cut rhythm: a new composition every 3–6 s in
  reels, every 5–10 s in long-form.
- **Walks (paper Devan):** `stroll()`. Start pointing only **after** the walk ends:
  `armR: moving ? 0.18 : lerp(0.18, aimArm(...), tw(lt, tEnd, tEnd + 0.4))`. Pointing mid-walk makes the arm pop.
- **Transitions:** set per scene (`transition: {type, dur}`) — `pan` 0.7, `drop` 0.6 (vertical: the next set rises from
  below, e.g. going down a hill), `wipe` 0.6 (hard left-to-right; add `overlay(ctx, e, lt)` to draw the wiping object,
  e.g. a board eraser), `tear` 0.45, `slide` 0.55, `iris` 0.7,
  `fade` 0.6 (reel end card: the template keeps Devan on the same spot in the outro and the card, so the fade reads
  as a match dissolve; long-form slides into the brand end screen). Default is a cut. Never crossfade two scenes that both show the mascot.

## Layout and safe zones

**9:16 (1080×1920):**
- titles: y 300–520 (Instagram's feed and grid crops start around y 240–285)
- main visual: y 250–1180
- Devan's feet: 1196–1240
- caption strip: centered y 1352 (clear of the Reels/TikTok bottom UI)
- below y 1420: decoration only
- important content: x < 960, because the right-edge app buttons cover it

**16:9 (1920×1080):**
- titles: y 150–250
- main visual: y 150–850
- ground line: 820
- captions: baseline y 1036
- keep the bottom-right corner clear in thumbnails (the duration badge covers it)

## Accuracy in pictures

- **Charts:** build series from the reported numbers. Endpoints, peaks and totals must match the sources. In-between
  points may be smoothed; label the source and period on the chart ("Cotality index · Aug 2025 – Aug 2026").
- **Maps:** draw from real lon/lat coordinates. A freehand Gulf map read as a river.
- **Physics and metaphors must point the right way:** the heavier side of a scale goes down; a falling line falls.
- **Anonymous people:** use black eye bars and no real faces. Institutions can be depicted generically with a
  typed label ("RESERVE BANK OF AUSTRALIA"), but no logos. Clipping cards are generic newsprint, never a real
  outlet's masthead.

## The stills loop (do this after every batch of scene work)

```bash
node tools/stills.mjs $EP hook:1.2 hook:15.5 fall:3 price:5.5 --sheet [--cols 4] [--out <dir>]
```

Read the sheet image, fix, repeat. Useful probes:
- each scene's first second (empty frames)
- just after each key word
- mid-transition (`scene:0.2`)
- the last second (typing still running at the cut?)

**Review checklist** (every item went wrong at least once):
- Metaphors point the right way (scales, arrows, charts).
- Diagrams read at phone size; maps come from real coordinates.
- No caption chunk is a lonely word ("affordable,") — run `scripts/check_captions.mjs`.
- Nothing appears before its beat (a source note before its chart).
- Nothing overlaps: tags vs Devan's head, a stat card hiding the data it describes, a stamp covering a headline, a
  circle striking through text, props covering Devan.
- A card's sub-label fits inside the card.
- Typewriter strips finish typing before the scene cuts (raise `cps` or start earlier).
- No arm pop where a walk ends and pointing begins.
- At most ~1.5 s of an empty or near-empty frame (ep03's rates card sat empty ~3 s; a typed CPI label fixed it).
- Offset math: know whether your helper's `x` is a center or an edge (the dominoes were half a card off).
- Timeline JSON is stale after script edits: re-run `npm run timeline`, because captions read from `timeline.json`.
- Every number drawn on a prop matches the story state at that moment (ep08: the tag read 3.9¢/oz on the 32 oz
  bottle before the shrink; correct was 3.4¢ → 3.9¢ after).
- Every change of scene, world or layout has a designed transition (below); nothing changes on a single frame
  unless it's an intended hard cut, and no in-world layout change is a plain cross-fade (slide/shrink it instead).

## Performance

- Cache static backgrounds and art (`layer`, `cutout`); draw only what moves.
- Time frames in the stills output (ms per frame). ~350 ms per 1080×1920 frame renders at ~3.5 fps.
- Per-frame pixel work (halftone of an animated figure) is fine if it's limited to the element's box. Never
  process the whole frame.

## Seamless editing (ep07 review)

The creator flagged places where the film "just jumps over and feels like a cut". Every hard change must be motivated
or hidden. Rules:
- **Each scene starts from the previous scene's last frame.** Same camera (cy, z, focus), same props, same Devan pose and
  position, same sign text, same sky; then ease into the new scene's framing. Hand state across with shared constants
  or small helpers (e.g. a `napping()` drawn at the end of one scene and the start of the next).
- **Ambient motion runs on global time** (`env.t`), not scene-local `lt`: tree sway, breathing, rain, drops, motes.
  Local time restarts at 0 on every scene, so anything oscillating on `lt` jumps at the seam.
- **Labels and panels fade out before the scene ends** (`1 - seg(lt, env.scene.dur - 0.5, env.scene.dur - 0.05)`).
- **Pose changes happen on screen** (a squash "plop" into a seat) or under a strong light flash (lightning); never a
  bare jump. Don't crossfade Devan (double exposure).
- **Complementary skies change by a top-down sweep, not a cross-fade** (`world(…, {sweep: true})`): gold ↔ blue at 50%
  goes grey (saturation 93 → 33 measured).
- **Prefer camera moves to cuts** inside a scene (wide → push in → tilt down), with one keyframed camera path.
- A `dip` through dark is fine between chapters of time; a flash to white reads as a cut.
- **Check:** `node tools/stills.mjs $EP $(python3 <skill-dir>/scripts/seams.py $EP <switch-times…>) --sheet --cols 8`
  renders the frame pair on each side of every boundary; each pair must match.

## Transitions (ep08 review)

The creator called world changes "abrupt and not done well": they were hard cuts hidden behind a 0.3 s glitch. A glitch,
flash or fade over a cut is decoration, not a transition. Rules:
- **One per change, 0.5–0.9 s, styled after where it's going.** The ep08 catalog (`episodes/08-shrinkflation/scenes.js`
  → `TRANSITIONS`): `tiles` (the frame flips over in a wave of tiles from the UI element that caused the change — the
  reference's own move), `mosaic` (pixelate up, land in 8-bit), `pencil` (a pencil rides a diagonal wipe and draws the
  sketch world in), `tape` (VHS roll + tracking tears + static at the switch), `build` (the new world stacks up brick by
  brick from the bottom), `zoom` (push into the mascot's face and match-dissolve into the next shot). Earlier kits:
  `pan`, `drop`, `tear`, `wipe`, `iris`, `slide`, watercolour `brush`, felt `dip`/`flare`.
- **Implementation:** draw world A and world B for the same `t` into two `scratch` canvases, then composite with the
  effect (`p` = progress 0..1). Draw the UI (prompt box, labels that persist) and captions on top so they stay steady.
- **Midpoints:** where one world swaps for the other (mosaic peak, tape roll), blend A→B over ~20% of the window and
  mask it (static, max blockiness); a single-frame swap still reads as a cut.
- **Match cuts:** align the subject first (same screen position and scale in both frames), then dissolve; a dissolve
  while the faces are still misaligned double-exposes the mascot.
- **Timing:** start the transition on the action that causes it (the send button, the glitch), finish before the next
  line's key word, and move effects that must be seen (a product shrinking) to after the transition ends.
- **Check:** 5 stills through each window (`0.1 0.3 0.5 0.7 0.9`), then after rendering
  `sh <skill-dir>/scripts/cutcheck.sh NN-slug 0.25 <transition times…>` — 0 unintended hard cuts, and every strip in
  `out/NN-slug-cuts.jpg` visibly progressing.
