# Visual styles (engine kits)

These are the available looks, and none of them is the default: the creator wants to explore different styles
(2026-09-29). Pick one by matching the reference video, the genre and the idea, or build a new kit, and offer 2–3
options at the storyboard check-in. Each one is a separate
engine kit, so episodes in different styles coexist and older episodes never change. Distinguish shipped episode
references from kits demonstrated only in style frames; a developed kit is not proof of a completed film.

| Style | Files | Proven in | Use for |
|---|---|---|---|
| **Paper cutout** | `engine/paper.js`, `paper-kit.js`, `paper-props.js`, `devan-paper.js` | ep02 (9:16), approved in full | Friendly explainers: concepts, everyday money |
| **Vox documentary collage** | `engine/vox.js`, `vox-kit.js` (+ `devanHT` halftone Devan) | ep03 (9:16) | Investigative or "documentary" briefs, current affairs, markets, crises |
| **Night paper collage** | `engine/collage.js`, `collage-kit.js` (+ `devanSticker`) | ep04 (9:16) | Story / fable explainers, cozy or wintry topics, "collage" references |
| **Hand-painted watercolour** | `engine/wash.js`, `wash-kit.js` (paper Devan re-skinned via `washPiece`) | ep05 (9:16) | Gentle concept explainers, "money while you sleep"/growth topics, watercolour or hand-painted references |
| **Chalkboard lesson** | `engine/chalk.js`, `chalk-kit.js` (+ `teacher` Devan) | ep06 (9:16) | Clarity-first "teach one idea" explainers, math-y concepts, simpler re-tells of a topic |
| **Felt-miniature film** | `engine/felt.js`, `felt-kit.js` (paper Devan re-skinned via `feltPiece`, + `devanSit`, `devanBack`) | ep07 (9:16) | Warm, emotional "short film" stories (hope, patience, milestones), cozy illustrated / 3D-felt / diorama references |
| **Crayon notebook** | `engine/crayon.js`, `crayon-kit.js` (paper Devan re-skinned via `crayonPiece`, + `devanAsleep`) | ep09 (9:16) | Tender "short film" explainers narrated by a thing (the account, a coin), day → night → dawn arcs, crayon / kids'-notebook references |
| **Field guide** | `engine/field.js`, `field-kit.js` (Devan via `naturePiece` / `scanPiece`) | ep10 (9:16) | "What's hidden inside" explainers: a calm illustrated world + a navy blueprint x-ray, scan-line sweeps; naturalist / blueprint references |
| **Clay story** | `engine/clay.js`, `clay-cast.js`, `devan-clay.js` (clay Devan, envelope hero, vault clerk, `person`) | ep12 (9:16) | Character-driven story explainers narrated by a prop or character (an uncashed check), clay / stop-motion / sitcom references, anything that must *tell a story* rather than show data |
| **Cozy game** | `engine/cozy.js`, `cozy-cast.js`, `devan-cozy.js` (flat pastel vector room, HUD pills/meters/popups, original cat rig, tall shelf, cushion pile) | ep13 (9:16) | Everyday-money explainers that map to a *game with a visible hazard and a soft landing* (surprise expenses, buffers, insurance); cozy-game / flat-vector / HUD references; relatable pets and rooms |
| **Painted town** | `engine/town.js`, `town-cast.js`, `devan-town.js` (cutaway tower of ten painted shops, chalk-drawing star, painted signs, street + skyline) | ep14 (9:16) | Concepts that map to *many parallel parts of one whole* (a fund = many shops, a budget = rooms of a house), painted/gouache/storybook-town references, camera-tour explainers |
| **Ink-and-hatch sketch** | `engine/sketch.js`, `devan.js`, `props.js` | ep01 (16:9) | Whiteboard/notebook tutorials, long-form YouTube; only on request |
| **Era walk** | `engine/era.js`, `era-styles.js` | ep16 (16:9), shipped | Company/history explainers walking through years and art worlds |
| **City-pop anime** | `engine/citypop.js`, `citypop-cast.js`, `citypop-sets.js` (dancer rig, cel-anime Devan bust, tag cards) | ep24 (9:16) | Musical "day in her life" explainers, city-pop / anime music-video references; montage by skirt sweep; see the playbook's City-pop anime variant |
| **Storybook ink** | `engine/story.js`, `story-cast.js`, `story-sets.js`, `story-dress.js` | ep17 (16:9), style frames; film in production | Warm illustrated, character-led stories with dialogue, lived-in sets and physical wipes |

## Paper cutout (ep02)

- **Look:** flat construction-paper pieces with top-left-lit drop shadows (`piece(ctx, pts, {fill, depth, edge,
  shade})`) and a light cut edge. `rough()` gives hand-cut irregularity. A fiber, vignette and grain finish comes
  from `P.finish`.
- **Palette:** `P.C` — cream, kraft, ink, red, orange, mustard, teal, sea, sky, sage, grass, soil, money…
- **Type:** Chewy for titles (`hangingTitle` drops letters on strings), Fredoka for tags, Nunito 800 for captions.
- **Kit** (`paper-kit.js`):
  - `REEL = {W:1080, H:1920, GROUND:1196, CAP_Y:1352, SAFE_X:960}`
  - `dayLayer(key,{sun,clouds})`, `nightLayer(key)`, `hills`, `groundStrata`
  - `board` (pinned sheet), `popAt(lt, t0)`, `mouth(env)`, `at(env,id,f)`
  - torn-paper captions; `fonts/setup/drawCaption/post` to re-export
- **Props** (`paper-props.js`): bill (with `keep` for snipping), billScrap, basket and groceries, barrel, gasCan,
  tanker, car, truck, plane, ship, bag, box, ticket, jar, scissors, storm, building, thermometer, badge, up/down
  arrows, confetti.
- **Devan** walks and points:
  - `stroll(lt,t0,t1,x0,x1,s)` returns `{x, walk, face, moving}`.
  - `devan(ctx,x,GROUND,s,lt,{walk, armR, armL, mouth, brow, lookX, face, squash, lean, glint, hold})`.
  - `aimArm(x,y,s,face,tx,ty)` returns the arm angle to point at a target; `handPos()` gives where to draw a held
    prop.
- **Transitions:** `{type:'pan', dur:0.7}` between scenes, `fade` into the end card. Never crossfade mid-video: it
  double-exposes Devan.
- **Music:** marimba lead, light drums, 96 bpm, bright I–V–vi–IV, minor for serious beats.

## Tabletop collage (ep22)

A top-down, softly lit work table: the reference was "Vox Skill V.2" (x.com/OriSilver/status/2110390355812295018). Use it for
"secret history of an everyday thing" briefs. Full notes are in `docs/PLAYBOOK.md`, section "Tabletop collage variant (ep22)". Essentials:
- **Kit:** `engine/table.js` + `engine/table-kit.js`. `put()` gives every object a cast shadow plus a contact shadow (shadow-only
  passes, scaled by `lift`). `post` adds one warm key light at the top left. Things `drop()` in and `leave()`; nothing fades in.
- **Surfaces change per beat:** board, cream sheet, kraft folder, sand under torn-paper sea strips. Mixed media comes from
  `halftonePrint()` (keep subjects light; label prints with separate typed notes).
- **Type:** matte cut-paper Anton kickers and typewriter letter tiles; supporting notes ≥ 28 px.
- **Transitions:** `carry` (camera slides; a foreground object rides the seam), `peel`, `rollup`.
- **Process:** an independent art review of the style frames against reference stills caught the "flat vector scrapbook"
  look (no single light, no thickness, repeated filler). Fix light and shadows first; they change the read the most.

## Vox documentary collage (ep03)

Built from the "Vox style" prompt pack in x.com/seergioo_gil/status/2103634907637649647.
- **Stage:** one persistent surface for the whole video — aged archival tan (#C9BB9C) with mottling, faint
  topographic contours, a dashed lat/long grid with real coordinates of the topic's place, and newsprint scraps at
  the edges: `VX.stage(W, H, 'main', {scraps})`.
- **Palette:** tan #C9BB9C, ink #1A1A1A, grey #8C8C8C, hot red #D62E1F, mustard #D9A441 (secondary). Red is only
  for strokes, stat numbers, underlines, arrows and emphasis.
- **Type:** Anton for condensed headlines and stat numbers (`VX.headline`), Special Elite for typewriter labels
  (`VX.typeStrip` types on), Oswald 600 for captions (numbers in red).
- **Halftone cutouts:** draw the art in tones (black..white; alpha is the cut shape) and let
  `VX.cutout(key, w, h, draw, {cell, keyline, red, redOff, overlay})` screen it. You get 45° ink dots on photo paper,
  a white scissor keyline, and an offset red stroke. It is cached per key. Put crisp marks (eye bars, labels) in
  `overlay`. `red: 0` works for busy line art (e.g. a timber frame) and for photo cards (`keyline: 14` acts as the
  white border).
- **Pieces:**
  - `statCard(ctx, text, x, y, {s, size, fill, sub, minW})` — torn red card with a counter; count with
    `VX.tick(lt,t0,t1,a,b)` and format with `VX.money`.
  - `typeStrip`, `headline`, `swipe` (red underline).
  - `mapPin` (drops and wobbles once), `pushPin`, `string` (a red string that draws itself).
  - `stamp` (slams from 1.7×, multiply ink with worn specks), `eyeBar` (anonymous figures), `clipping` (newsprint
    headline card), `circleMark` (a hand-drawn red ellipse), `tape`, `card` (a torn paper card).
- **Motion:**
  - `VX.spring(lt, t0, d)` returns `{s, y, on}` — overshoot scale plus rise. Pieces never fade in.
  - `VX.exitP` slides pieces off.
  - Inside a scene, a new composition is a **hard cut on a voice beat**: `comp(lt, [0, t2, t3])`.
  - Camera: `stageCam` (≈0.8% push on the stage) plus `camera` (≈2% push and a slow drift on the foreground).
  - Between scenes, hard cuts, plus the `tear` transition at section breaks.
- **Devan:** `devanHT(ctx, x, feetY, s, lt, pose)` re-screens paper Devan as a halftone cutout every frame. His mouth
  stays closed (no lip-sync in this style). He springs in to point at the title and waves at the end. He does not
  walk.
- **Composition:** one hero at ~70% visual weight plus 2–3 supporting pieces. Short labels (1–4 words). Keep red
  sparse.
- **Music:** `lead: 'piano'`, `drums: 'pulse'` (heartbeat plus a clock tick), 84 bpm, minor progressions, darker at
  the evidence board.
- **SFX:** `type`, `stamp`, `pin`, `string`, `tear`, `thud` for stat cards, `tick` runs for counters.

### Vox investigation + floor plans (ep21)
The ep03 kit plus episode-local `plan.js` (floor plans in feet: a warm daylight wash, darkness as halftone dots, walls
that interpolate between layouts, a flashlight term) and `cast.js` (illustrative characters as halftone polaroids,
evidence tags, a case folder). Devan investigates on screen; every scene has an evidence tag; it ends on a red-string
board. Cast safeguards: ILLUSTRATIVE CHARACTER on every card, no interview styling, real quotes on their own attributed
card, cast disclosed on the end card. Transitions `floorDive` and `sheetUp` live in the episode's `transitions` export.
See the playbook's "Vox investigation + floor plans (ep21)".

## Night paper collage (ep04)

Built from the @ring_hyacinth collage reference (x.com/ring_hyacinth/status/2102986085328716066, a wordless 16:9 piece).
- **Surface:** a night sky of torn indigo paper: `nightSky(key, {moon, seed})` = gradient + strips hanging from the top
  whose torn edges show a white fibrous rim (`K.tornEdge` + `K.tornSheet`), a glowing crayon-textured paper `K.moon`,
  gold sparkles and confetti squares (`K.starfield`). Snowy ground is `K.snowBand` (torn white paper, moonlit blue
  shading, faint graph-paper `K.grid`). `mountains(key, y)` adds snow-capped peaks and a pine line (`K.pine`).
- **Palette (`K.K`):** night #121A33–#3B4C80, rim #EFE7D4, moon #F1E4C0, gold #E9B54B/#F7D680, snow #F3F1EB,
  shade #B9C6D9, ink #35261F, keyline #FBF5E6, red #C8412F.
- **Stickers:** everything in the foreground is a sticker: cream keyline, dark outline, crayon hatching (`K.crayon`),
  one soft cast shadow. Vector art uses `K.sticker(ctx, (part, pass) => …)` — `part(path, fill, opts)` is called in a
  keyline pass and an art pass, so transforms inside `draw` just work. Paper-piece art (Devan) uses the raster
  `K.liveSticker`; `devanSticker(ctx, x, feetY, s, lt, pose)` wraps it (he still walks, points and lip-syncs).
- **Characters and props:** `K.worker` (tiny hard-hat crew: walk, sit, arms, `hold: 'scoop'|'mug'`, eyes/mouth),
  `K.snowball` (rolling surface marks + gold flecks = growth), `K.signpost`, `K.debris`, `K.puff`, `K.deckChair`, `K.rock`.
- **Motion:** stories in motion rather than diagrams: rolling balls with scrolling foreground decor, smash + screen
  shake, pop-in tags on strings, hanging titles in gold/cream on the dark sky. Transitions: the new `drop` (vertical
  camera move down a hill), `tear`, `pan`, `fade` into the end card.
- **Music:** `lead: 'musicbox'` with `bassIn` so the score builds layer by layer (see audio.md).
- **Gotcha:** never call `rng()` inside an edge function passed to `tornEdge` — a fresh phase per point turns the torn
  edge into icicle spikes. Compute phases once, outside.

## Hand-painted watercolour (ep05)

Built from @mablesjoseph's code-generated watercolour short (x.com/mablesjoseph/status/2103465246014746943).
- **Washes:** `WC.wash(g, pts, color, {layers, alpha, amt, rim, blooms})` is Tyler Hobbs' method: a recursively
  deformed base polygon, then ~20 translucent deformed copies (soft, layered edges), a blurred darker rim where pigment
  pools, and `destination-out` back-run blooms. `band()` = wet-in-wet horizontal band across the frame, `blot()` = a
  blob, `foliage()` = sponge dabs. Always paint into cached layers (`P.layer`) and finish with `WC.granulate()`.
- **Paper:** `WC.makeColdPress(W, H)` (embossed value noise around grey 128) drawn with `overlay` in `post`, plus a
  soft multiply vignette and faint grain. The grain is fixed to the sheet (device space), like real paint on paper.
- **Backdrops:** `meadow(key, {mood: 'day'|'dusk'|'rain'|'gold', ground, sun, trees})` — sky bands, cloud blots,
  sponge-dab distant trees, ground washes, ink horizon, grass ticks and wildflower dabs, all cached.
- **Live pieces:** the kit's `setup` calls `P.setPieceStyle(WC.washPiece)`, so every `P.piece` (paper Devan, props)
  renders as translucent pigment slightly off-register from a thin ink line, with granulation and a pooled rim. Pieces
  with `depth < 0.3` get no ink line (drawstrings, brows). Devan keeps walking, pointing and lip-syncing.
- **Hero props:** `moneyTree(ctx, x, y, s, lt, {seed, grow, hang(i), sway, palette, leaves, shake})` (seeded model,
  grows segment by segment, foliage paints on with `paintOn`, a dozen coins on stems), `treeCoins`/`treeTips` (world
  positions for falling coins and highlights), `coin`, `jar` (coins inside, label, red strike).
- **Type:** `WC.painted()` — Caveat Brush lettering that bleeds in letter by letter with a paper halo; `WC.note()` —
  Caveat 700 labels with an optional wash chip and a self-drawing inked arrow. Captions: Nunito 800 ink on a pale wash
  strip (sprite cached per size).
- **Transition:** `brush` (0.9 s) — ~22 long tapered brush strokes in the palette sweep in from the right, cover the
  frame at the midpoint (the scene swaps underneath), and leave to the left. It is a kit transition: the episode
  re-exports `transitions` and the player calls `mod.transitions[type]`.
- **Music:** soft `piano` + `light` drums, 88 bpm, major (F–C–Dm–B♭), minor for the serious stretch, `bassIn` at the
  first concept line.
- **Gotchas:** `multiply` alone paints transparent pixels; `granulate` re-applies the original coverage with
  `destination-in` (the first version turned every sprite into a white box). Never put decoration on top of chart
  bars (leafy crowns made a 6.6× ratio read as 3×); keep data bars plain and label the top.

## Chalkboard lesson (ep06)

- **Board:** `K.board(W, H, {ledge})` — green slate with eraser haze and dust, wooden frame, a ledge with chalk sticks and
  an eraser at y 1236, a dark wall below where the captions sit (plain white Nunito 800 with a dark halo, very readable).
- **Chalk:** grainy pattern fills (`K.chalk(ctx, color)`) plus a faint dust glow. `K.line` / `K.arrow` / `K.text` write on
  by `progress`; lines are static (no boil — chalk doesn't move). `K.fill`, `K.coin`, `K.jar(…, {level})`, `K.brace`.
  Palette `K.CH`: white, yellow (the hero), blue, pink, green, orange on slate #17302A–#2A5046.
- **Devan:** `teacher(ctx, x, lt, env, {point, p, s})` — paper Devan in front of the board with a wooden pointer. Keep him
  bottom-left (x ≈ 120, s 0.85) and keep board text clear of his head (y > ~950 at x < 210).
- **Transitions:** `{type: 'wipe', dur: 0.6, overlay}` — the overlay draws `K.eraser` + `K.dust` riding the wipe edge.
- **Motion rule:** every label writes on at its word (`atW`); numbers grow in size as they grow in value.
- **Music:** rhodes + lofi at 84 bpm; SFX `chalk` on each write-on, `erase` on each wipe.

## Felt-miniature film (ep07)

Built from @ring_hyacinth's official Mid-Autumn short (x.com/ring_hyacinth/status/2103476866917290441): a felt/clay
miniature diorama lit by warm gold light, navy nights with little gold stars, and a hero seen from behind at the end.
- **Pieces:** `F.feltPiece` (installed with `P.setPieceStyle` in the kit's `setup`) gives every paper piece a soft
  contact shadow, a volumetric highlight toward the key light and a core shadow away from it, felt fibres (`overlay`
  with a seamless fibre tile) and a warm rim. Felt balls (`F.ball`, baked `pompom` sprites; `fuzz 0` for clouds/sun)
  make leaves, snow, clouds and caterpillars.
- **One world, one camera:** the ground line is world y `GY = 1200`; `camera(ctx, cy, z)` frames it above ground
  (cy 0), split (cy ~330–420) or as a deep soil cross-section (cy ~780). `world(ctx, cy, {mood, mood2, t, deep, wide})`
  draws sky + hills + soil + turf per mood (`spring summer autumn winter golden evening storm dusk night`); `wide`
  mirrors the layers so the camera can pull back below 1×. `deep` fades the lower soil in above-ground framings.
- **Growing things:** `F.branching(seed, opts)` + `F.layout` give seeded trees/roots that grow with g (0..1) and sway;
  `tree()` draws a layered felt canopy whose seasons turn ball by ball (no double exposure); `roots()` adds a warm glow
  and a travelling `pulse`; `seedling()` is the real sprout (hypocotyl hook → straightens → seed leaves open).
- **Props:** wooden `sign` (the plank flips over when its text changes — pass old text before mid-flip), `label`
  (cream felt chip with a dotted anchor), `plaque` (storybook title card; numbers auto-highlighted), `wateringCan` +
  `pour`. Devan poses beyond walk/point: `devanSit` (nap, "z"s) and `devanBack` (seen from behind, knees up).
- **Finish:** `post` = bloom (downsample → threshold → blur → screen; deterministic in the `--check` probes) → warm
  soft-light grade → vignette → grain → captions drawn LAST (film subtitles: cream Nunito on a dark felt pill, digits in
  gold) so bloom never smears them. Transitions `dip` (through warm dark) and `flare` (through gold) via
  `mod.transitions`.
- **Seasons as the clock:** cap the season rate at ~1–2 changes per second (fast sky flicker is strobe-like); for a
  growth time-lapse use spring → summer → autumn only.
- **Music:** `lead: 'guitar'` (Karplus–Strong nylon pluck, sparse quarters until `bassIn`), light drums only during
  the time-lapse. SFX `leaves chime drip wind crack`.

## Toy cinema + world-hops (ep08)

Built from the Pip short (x.com/pradeepXkapoor/status/2103099194693271874): CG-toy golden hour, a frosted teal
"describe a change…" prompt box, fast world-hops through art styles, a keyboard takeover and a pull-back reveal.
- **Kit:** `engine/toy.js` (`soft*` lit surfaces, `contact`, `layer(…, blur)` for depth of field, `scratch`, `bokeh`,
  `title3D`, `glass`, `drawCaptionToy` word-highlight captions, cinematic `finish`) + `engine/devan-toy.js` (vinyl-toy
  Devan, same pose API as paper Devan).
- **Worlds as renderers:** each world is a function of global time that draws the same beat in its own style; a
  glitch (RGB split + slices) covers every hop. 8-bit = draw at 1/6 res and upscale nearest; neon = darken the set and
  add blurred colored silhouettes as rims; VHS = chroma offset + scanlines + tracking band + OSD; pencil = the ep01 ink
  rig with grey `look` overrides.
- **Camera:** apply it to vector drawing (not to a finished bitmap) so close-ups stay crisp; letterbox bars for the
  cinematic stretch; macro insert = blurred, pushed-in copy of the frame + the key object redrawn crisp.
- **Watch:** `source-atop` on the main canvas paints over everything drawn before (use gradients or a scratch canvas);
  `Path2D.roundRect` throws on negative radii (clamp); screen-blending a whole silhouette washes it out (subtract the
  body to keep only the rim).

## Crayon notebook (ep09)

- **Reference:** @kevin_t_ngo's AI-narrated day-in-the-life short. Its signature: a quiet non-human narrator (a mint
  dot) present in every scene, and one line/dot that survives every cut (waveform → horizon → sunrise).
- **Kit:** `engine/crayon.js` — `CR` palette, `fill` (seeded wax tiles, off-register, colours in by `progress`),
  `ink`/`stroke` (boiling felt pen, `chalky` for night), `item` (fill + ink, `night`), `crayonPiece` (for
  `P.setPieceStyle`), `guides`, `ground` (hatched shadows), `dot`, `scribble`, `paperBg`, `nightBg`, `skyStrokes`,
  `hand` (type-on lettering). `engine/crayon-kit.js` — `REEL`, fonts (Mynerve, Kalam 700, Nunito 800), `setup`,
  `page(ctx, e, night)` (sets the caption colour), `drawOn`, `erase`, `titleCard`, type-on `drawCaption`, props and
  `devanCrayon` / `devanAsleep`.
- **Scene pattern:** worlds as functions of scene-local time so scenes can reuse each other's finished state; see the
  playbook section. Seams measured frame-exact: boil alone changes ~1.4 % of pixels between adjacent frames.

## Field guide (ep10)

- **Kit:** `engine/field.js` — `FG` palette + `THEMES`/`setTheme`, `flat`/`outline`/`item` (illustrated),
  `stripesSky`, `mountain`, `farHills`, `lake`, `field`, `birch`, `roundTree`, `tallGrass`, `reticle`, `measure`,
  `naturePiece`; blueprint: `bpBg`, `bpLine` (glow, progress, dash), `hexFill`, `badge`, `dial`, `gauge`, `ruler`,
  `trace1`, `sparkle`, `scanPiece`; `scanWipe`; `text` (letter-spacing, stroke). `engine/field-kit.js` — `REEL`, fonts
  (Fraunces 800/700i, Inter 600–800), field-guide caption tag, `titleCard`, `landscape(season)` (cached per theme),
  `foreground`, `blueprint(e, {gauge, dial, dialLabel, chrome})`, `ICON` set, dual-mode props (`shoebox`, `receipt`,
  `terrarium`, `paycheck`, `bill`) and `devanNature` / `devanScan`.
- **Scene pattern:** each scene is a `…World(ctx, lt, e, mode)`; a `sweep()` helper draws the new world left of the
  scan line and the previous world's finished state right of it. Seams measured: < 0.7 % of pixels change.

## Ink-and-hatch sketch (ep01, 16:9)

- **Look:** hand-drawn ink on speckled paper with pencil hatching and a line "boil" at 8 fps.
  - `shape(ctx, pts, {fill, ink, hatch})`, `line(ctx, pts, {progress})` (write-on), `text(ctx, str, x, y, {size,
    progress, halo})`, `underline`, `arrow`, `groundShadow`.
  - Textures: `makePaper()`, `makeGrain()`. Font: Caveat.
- **Devan:** `drawDevan(ctx, x, y, s, t, pose)` (engine/devan.js), lip-synced from speech envelopes
  (`env.mouth(env.t)`). Colors come from `LOOK`.
- **Layout (1920×1080):** ground line G = 820, titles at y 150–250, main visual at y 150–850, captions at baseline
  y 1036 (Caveat 60, with a halo). In diagram scenes Devan shrinks to the right corner (~x 1720–1760, s 0.6).
- **Transitions:** `slide` (with a hand-drawn page edge), `iris` (centered on a prop), a `slide` into the brand end screen (long-form).

## Recipe: a new style kit from a reference

1. Extract the style (see `reference-videos.md`) into palette tokens, fonts, surface, hero treatment, motion
   vocabulary and prohibitions.
2. Add fonts with `npm i -D @fontsource/<family>`, then list them in the kit's `fonts` export
   (`{family, file: '<pkg>/files/<pkg>-latin-<w>-normal.woff2', weight}`). The player loads them before frame 0 and
   fails loudly if one is missing.
3. Create `engine/<style>.js` for primitives (reuse `paper.js` `piece`/`rough`/`layer`/`finish` and `sketch.js`
   `rng`/`hashSeed`) and `engine/<style>-kit.js` for layout constants, `setup`, `drawCaption`, `post`, camera and a
   mascot treatment.
4. Cache static art with `P.layer(key, …)` or your own `Map` keyed by content. Seed every random choice.
5. Prove the look on 3–4 stills before building all scenes. Time a frame (aim for < 0.5 s).
6. Keep the change additive. Re-hash frames of every older episode and require an exact match.
7. Document the kit in the playbook and in this file.

## Painted town (ep14)

Painted cutaway tower, a gold star that draws chalk diagrams, one continuous world. Full notes in `docs/PLAYBOOK.md` → "Painted town variant". Essentials:
- **A town of ten parallel shops** carries "owning a slice of everything"; the camera climbs the floors, pulls out to a skyline, and the pie/jars are chalk diagrams on boards.
- **One continuous world:** camera + light + star as transitions; a soft single lightning flash (never strobe).
- **Pretend numbers disclosed on frame one; real numbers sourced and dated** in short paper notes; the end card repeats sources and a balance line.
- **Heavy to render:** `--workers 2` plus a free-disk watchdog when swap is high.

## Cozy game (ep13)

Flat pastel vectors with a soft top light, fine grain and a thin edge (`flat()`), a pale wall with a faint "+" pattern, warm planks, and a quiet game
HUD (pill, meter, pop-up). Full notes in `docs/PLAYBOOK.md` → "Cozy game variant". The essentials:
- **A game metaphor must stay true:** the cat is the surprise, the cushion pile is the fund; it still pays for damage (deflates, cracked phone), and no
  invented prices go on screen.
- **Portrait from a landscape reference:** tall shelf + couch, camera follows the fall, floor lifted so the action clears the caption band.
- **Countable picture over a percentage:** 100 owners, 63 teal; keep the counter large.
- **Keep every world's bottom clear of y ≈ 1290–1410 (captions)** and keep pop-ups out of labels (hide the label while popups play).
- **SFX that phones play:** mid-band bodies (`thud2`, `chime2`), a band-limited `crack2`; screen each new SFX.

## Clay story (ep12)

The creator's story-first pick after rejecting abstract type/data references (a Magnific AI clay sitcom). Files and rules live in
`docs/PLAYBOOK.md` → "Clay variant"; the essentials:
- **Look:** matte clay (`clay()` surface: key light, purple-tinted core shadow, warm subsurface band, inner-edge burnish,
  grain + mottle + fingerprints), lumpy superellipse silhouettes with a 12 fps boil (`clayTime(t)` once per frame), depth-of-field
  sets, light tilt-shift (`finishClay`), Fredoka clay lettering (`clayText`). Palette: teal + brass vault, cream + terracotta rooms.
- **Narrator is a character, always on screen.** A first-person prop (the envelope with a check peeking out) narrates; when the story
  leaves it, show it somewhere (ep12 used a tiny "vault cam" on the laptop screen).
- **Cached layers must be frame-independent:** `clay.layer()` freezes the boil at step 0 while it draws, otherwise `render --check`
  mismatches depending on which frame built the cache. Tile backgrounds with `periodic()` (3×3 padded, blurred, cropped) so
  pull-backs stay seamless.
- **One `draw` for all scenes**, worlds chosen from global time; transitions composite world A/B from `scratch` canvases. For a
  match-dissolve (push-in on one face, land on another) move both worlds about a *shared anchor that starts at A's face and ends at
  B's face*, so each world is the identity transform at its own end (a fixed anchor made two hard cuts, found by `cutcheck.sh`).
- **Flat rooms need a camera:** shoot interiors through a gentle zoom (~1.25) and size the mascot ~1.4 so the set fills the frame.
- **TTS pacing:** lists read as separate sentences drag (`p1` 63–70 wpm); join items with commas and add "brisk, like a shopping
  list" — measure syllables per second too (≈ 3.7 is fine for long words).


## Storybook ink (ep17, 16:9 style-frame reference)

This kit is built and demonstrated in episode 17's style frames; the episode is still in production. It matches
an illustrated reference through volume, light, staging and set dressing, not just a warm palette. For a reel,
recompose its landscape sets for portrait safe zones rather than cropping the 16:9 frame.

- **Kit:** `engine/story.js`: `SB` palette, tapered/wobbling `ink`, `paint` for soft form-shadow crescents,
  object-anchored pigment variation and rims, `hatch` within shadows following the form, `piece`, `storyPiece`
  for paper Devan, `letter` (Fraunces/Kalam), `strands`/`fur`, `cloud`, and `post` for paper tooth, warm grade
  and vignette. `layer` caches static art at boil frame zero; include every changing drawing parameter in its key.
- **Cast:** `engine/story-cast.js`: `walt` with hand targets, `steve`, `steveArms`, `callerBack`, `teller`,
  `seagull`, `devanStory` and story props. Use the shapes and acting appropriate to the brief; the ep17 characters
  are examples, not a mandatory cast.
- **Sets:** `engine/story-sets.js`: `town`, `kitchen`, `callCenter`, `bank`. `engine/story-dress.js` adds seeded
  fruit crates, flowering vines/pots, exposed stone and architectural detail. Give walls lit and shaded sides,
  use contact/cast shadows, and wash distant layers with aerial haze.
- **Transitions:** `story.js` exports `transitions` with `sheet`, `wing`, `awning`, `tumble`. Review strips through
  the full wipe and matching endpoint frames; avoid a crossfade that doubles the characters.
- **Before all scenes:** render 4–8 actual style frames, compare them side by side with the reference stills,
  and get an independent art-director review of shape/line, volume, light direction, camera/staging and set detail.
  Address concrete mismatches, then present frames under the existing storyboard approval workflow.
- **Cast voice routing:** keep Fenrir for Devan, use `tts.voices` + line `speaker` for the approved dialogue cast
  (see `voice-google-tts.md`). Measure every raw and tempo-adjusted take before keying animation.
- **Fairness:** retain fact-checked locations and realistic casting from the latest approved brief. Check
  accents, appearance, background people, props, setting and acting together. Show an antagonist's wrongdoing
  through actions and story props; avoid cultural clichés or mocking accents. An earlier neutralized design does
  not override a later approved, evidence-backed location or casting choice.

## Era walk (ep16, 16:9 long-form)

After x.com/AlchainHust/status/2106946672844845534: a kid walks left → right through worlds in different art styles,
each with a year badge, joined by styled seams; it ends at his desk with a monitor of every world. Ep16 ("The NVIDIA
Story", ~9 min) maps company history onto eras: 2026 flat desk → 1993 pop-art comic → 1999 low-poly 3D → 2006
glossy Aero → 2012 vaporwave → isometric neon "AI factory" → 8-bit scoreboard → watercolour moat → back to the desk.
- **Kit:** `engine/era.js` — one continuous track (`track(worlds)`, `compose(ctx, trk, camX, t, env)`), styled
  `SEAMS` fixed in world space (tear, tri, glass, vhs, iso, pixel, bleed, paper), `badge`/`badgeState` (flips as
  Devan crosses). Badge text = year + chapter topic ("1999 · the first GPU"), never the art-style name (the creator flagged style names as production notes); one caption style across worlds, `times(timeline)` (global `s/e/w/sc`; `w()` snaps to measured
  `onsets`), `motion()` for walk/camera segments, `bloom`, `vignette`, `grain`, and Devan skins via `devanIn(style…)`
  (`comicPiece`, `polyPiece`, `washPiece` through `P.setPieceStyle`; toy Devan for aero/vapor/iso; cozy for flat;
  the pixel world draws cozy Devan into a 1/5-size canvas). `engine/era-styles.js` holds the generic pieces: comic
  (`benday`, `panel`, `captionBox`, `bubble`, `burst`, `comicWord`), low-poly (`facet`, `polyRidge`, `fog`,
  `extruded`), Aero (`aurora`, `glossBall`, `aeroWindow`, `aeroBar`), vaporwave (`vaporSky/Sun/Grid`, `bust`,
  `exeWindow`, `vhs`), iso (`iso`, `isoBox`, `neonLine`), 8-bit (`NES`, `pixText`, `bricks`, `coin`, `heart`).
- **Every scene draws the same world from global time**; scenes only carry chapters, captions and timing, so there
  are no cuts. Each world lists stations `[sceneId, camLocal, devLocal]`; the plan walks Devan (and the camera, 0.3 s
  behind) between stations, starting ~1 s before the scene (1.6 s across a seam). A world can override when the walk
  leaves (`leaveFrom`) and its badge (`badgeAt`, e.g. the 2026 → 1993 rewind).
- **Seams only while walking, zoom 1 at every seam.** The living camera (slow ~4% push + drift at a station) eases to
  zero 0.3 s before each walk and before the end card.
- **Worlds that read back the canvas** (bloom, VHS) work because `compose` gives each world its own full-frame canvas
  at a seam; under the living camera the frame is composed at identity first, then scaled.
- **Outro:** cached thumbnails of every world (each composed at a fixed time, with Devan in it) fill the monitor
  while the outro plays. The 7 s end card is a comic tear into the brand end screen (ep16's final cut; the first cut's
  18 s thumbnail-grid card "lingered").
- **Music:** `music.leads = [[marker, lead]…]` switches the arpeggio per world (rhodes, marimba, piano, `bells`,
  `saw`, `chip`, musicbox — the last three new in ep16); older episodes are byte-identical without it.

## Holiday boutique paper (ep28)

The ep02 paper kit re-dressed for shopping and retail-psychology topics, with no shared engine edits:
- **Sets:** a blush striped wall, a scalloped rosewood/cream awning, a glowing shop window, a gold-rail interior and paper snow on global time.
- **Device:** an advent window with numbered doors. An episode-local `door` transition (exported as `transitions`) swings a full-frame numbered door shut, then open, between the "trick" scenes.
- **Brand safety:** generic products only; brand names stay in the narration and captions.

Reference: `episodes/28-limited-drops/` and the playbook's "Holiday boutique paper variant (ep28)".

## Droste infinite zoom, drawn in code (eps 30–32, 2026-10-21)

Reference: a Seedance "Droste effect / infinite zoom" clip (x.com/aimikoda/status/2112441218546205093). Per the
creator we redraw its grammar as motion graphics instead of generating painted plates: `engine/droste.js`.
- **Worlds and portals.** A reel is a chain of full-frame worlds. Each has `draw(ctx, t)`, one `portal`
  (`rect` / rounded `r` / `ellipse` / `arch`) with exactly the frame's aspect (w/h = 1080/1920), and an optional
  `frame()` that paints the rim *after* the child, hiding the seam. The child world is drawn inside the clipped
  portal at scale `portal.w / W`, recursively while it is more than ~3 px wide (`maxDepth` 3).
- **Camera.** `diveCam` zooms about the one fixed point `(x, y) / (1 − s)` that carries the portal onto the full
  frame, with scale `s^(−p)` (exponential: constant perceived speed). At p = 1 the next world is exactly full
  frame, so the next hold starts on the same pixels: every dive *is* the scene transition, with no cut.
- **Camera as one number (preferred).** `zAt(t, keys)` with keys `[[t, z], …]`, z = world index + dive progress,
  then `zToStack(z)` → `drawStack`. Holds, dives, a fast replay of the whole chain (z 6 → 12 in 4 s), and zoom-outs
  (z going down) are all just keys, and `needsBlur` is simply |dz/dt| > 0. The critic's ep30 note: a 20 s hold on one
  world after the loop was the swipe-away zone; keep the camera travelling (replay, zoom out, dive back).
- **Rims are clipped outside the portal** by `drawStack`, so nothing inside the portal pops away at a landing.
- **Schedule (older helper).** `diveState(t, dives)` turns `[{ at, dur }]` into the world index and progress, with a slow 4% push
  during holds. Key `at` to the end of the line that names the next place (dive ≈ 2.2 s, starting ~0.3 s before the
  line ends), so the new world lands as the next line starts.
- **Loop.** Index worlds cyclically; the last world's portal holds world 0, so the reel can end on frame one.
- **Rules learned on the style frames:** keep worlds vector (no cached bitmaps, no `flat()` grain inside worlds;
  grain goes on once in screen space in `post()`), or they blur and the grain balloons mid-dive. Portals must not
  move while the camera dives into them. Turn on `"motionBlur": { "sub": 4 }`. Put the frame-one title in screen
  space, not in world 0, so it doesn't zoom away with the bill. Keep Devan's feet at y 1196–1240 in each world and the
  lead subject large: the portal object (bill, window, envelope) carries the composition.
- **Zoom-outs pass through worlds in reverse (ep31).** Every number on those worlds must match the story at that
  moment: ep31's fixed-payment zoom-out first showed old months 12→1 (balance rising while payoff time fell). Make the
  worlds a function of time too (after the fix, world j shows the fixed plan's month, counting up as the camera
  pulls out). Glows must be layered strokes, never `shadowBlur` (it ignores the transform and balloons in portals).
- **"Bigger" must be drawn (ep32).** Every world fills the same frame, so a chain of growing rooms looked the same
  size until Devan and the furniture shrank per room (1.12 → 0.70) and later rooms got more stuff.
- **Three looks on one engine:** ep30 golden-hour painted vector, ep31 neon arcade (`neon.js`), ep32 candy dollhouse
  (`candy.js`). Share `engine/droste.js`; keep palettes and world styles episode-local.
- **Reference episode:** `episodes/30-been-here-before/` (flat golden-hour cozy fills + `devanCozy`).
