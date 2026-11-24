---
name: video-generation-short-format
description: Use when making a vertical 9:16 explainer, Reel, TikTok or YouTube Short starring Devan. Create a finished video from reference study and fact-checking through Google Gemini-TTS narration or character voices, canvas animation, score, captions and upload files. For landscape YouTube videos, use video-generation-long-format.
---

# Video generation — short format (Reels / TikTok / Shorts)

This skill makes a finished 9:16 explainer reel, 61–75 seconds long (90 s at most), entirely in code. The creator (Devan) gives
a topic and usually a reference video link. You deliver a voiced, captioned, scored video plus titles and a
description. The method is the one behind Episode 02 ("How Inflation Works"), which the creator approved in full, and
Episode 03 ("The Sydney Squeeze", Vox documentary style).

The engine lives in the reference repo `~/Projects/Video-Series`: canvas renderer, style kits, TTS, synth, mixer.
Work inside it (new episodes go in `episodes/NN-slug/`). For a different project, seed a copy with
`scripts/bootstrap.sh <dir>`. Its `docs/PLAYBOOK.md` is the living house style; if it disagrees with this skill, the
playbook wins.

**Running the bundled scripts:** they live in this skill's `scripts/` folder (in the repo also at `skills/shared/scripts/`). Run them from the repo root, e.g. `node <skill-dir>/scripts/check_captions.mjs episodes/NN-slug`, `python3 <skill-dir>/scripts/check_wpm.py episodes/NN-slug`, `sh <skill-dir>/scripts/deliver.sh NN-slug 15.6 portrait`. `<skill-dir>` is the base directory shown when the skill loads (e.g. `~/.claude/skills/video-generation-short-format` or `~/.codex/skills/video-generation-short-format`).

Read `references/lessons.md` first. It is short and holds every correction the creator has made. The channel is
**Dollar Devan** (@dollardevan, "Money, made simple."). `references/brand.md` covers what goes on the end card,
captions and copy, and cross-posting. Take the name, handle and tagline from `engine/brand.js`; never type them by
hand.

## Host tools and authorization

Use the host's web tools and subagent tools for research and reviews. Share local style frames and previews through
its file-sharing tool, or absolute file links and image/video embeds when none is available. Save research and
review notes in the repo spec directory as they land. Existing approval to build covers the approved design;
ask at a check-in only for an unresolved design decision. Update cross-session memory only when the user explicitly
asks; project lessons and shared references remain the workflow record.

## Channel rules (set 2026-09-28 from the channel's analytics)

Every reel is built to this shape:
- **Lane:** everyday money concepts, explained simply, for a US audience (compounding, inflation, fees, the rule of
  72, emergency funds, index funds…). If a brief is outside the lane (another country's market or pension system,
  an advanced trading strategy), say so in the check-in, propose an in-lane angle, and build the original only if
  the creator confirms it.
- **One idea:** write the video's single sentence before the script (e.g. "the earnings earn too"). One comparison or
  picture carries it; every beat serves that sentence.
- **Frame one:** at frame 0 the title and the promise (with its key number) are already on screen over motion. Counters
  and labels appear only once they mean something. The cover comes from these first seconds.
- **Explore looks (2026-09-29):** there is no signature look. The creator wants to explore different styles, so
  pick the one that fits the idea or build a new kit, and offer 2–3 style options (proven kits plus at least one new
  direction) with a recommendation at the storyboard check-in. A reference means its look *and* animation: build
  that, never an older look re-lit in its colours (ep08: "looks very similar to the past videos… I want bold new
  ideas"). What stays constant across looks, and carries the brand: Devan's silhouette (quiff, black shades, teal θ
  hoodie) in the first 1–2 s, the frame-one title + promise, burned-in captions, and the end card with
  `BRAND.handle`.
- **Simple for everyone:** explain for a viewer with little financial background: one spoken number, one picture,
  countable units over percentages (8 bottles hold the drink of 7; 1 brick = 4 oz), jargon defined in plain words
  ("shrink, plus inflation: prices going up"), a memorable closing line ("on the tag, or in the bag") (ep08).
- **No abrupt changes:** every change of scene or world gets a designed 0.5–0.9 s transition; a glitch or flash
  over a hard cut is not a transition (ep08).
- **Ending:** one closing ask — a save CTA or a next-concept tease ("Next up: what melts a snowball?"), never both —
  then a short end card (≤ 2.5 s) with the tagline, `BRAND.handle` and the disclaimer (ep07; the template draws it).
- **Cadence and posting:** plan in batches of 5–7. Upload the same finished video natively to each app (the master to
  Shorts, its `-upload` copy to Reels and TikTok; never a downloaded TikTok or Short), with our embedded `@DollarDevan` handle on every future video (creator approved 2026-10-13; `references/brand.md`). Aim for **61 s or longer**: TikTok's Creator
  Rewards counts only videos over 1 minute (a tiny idea may run shorter, knowing it won't earn there).

## House defaults for reels

| | Default |
|---|---|
| Format | 1080×1920, 30 fps, `"size": [1080, 1920]` |
| Length | **61–75 s target, 90 s ceiling** (≥ 61 s so TikTok's Creator Rewards counts it; Instagram recommends ≤ 3 min). A very simple idea can run 45–60 s, but then it earns nothing on TikTok. Length comes from the number of beats, never from talking faster. (Replaces the old ~2:00 default.) |
| Words | ~140–170 spoken words for 61–75 s (≤ ~205 for 90 s), 10–16 lines, 5–7 scenes, one idea (ep04/ep06 measured ~145 words per spoken minute) |
| Style | **Code-drawn motion graphics** (creator, 2026-10-21: no generated images unless asked by name) built with the motion harness in `references/motion-quality-bar.md`. **No fixed look — explore.** Pick the kit that fits the idea or build a new one; offer 2–3 options at the check-in. A reference link sets the look and motion (e.g. **toy-cinema world-hops**, ep08, `engine/toy.js`). Proven kits: **Paper cutout** for friendly explainers. **Night collage** (ep04) for stories. **Chalkboard** (ep06) for clarity-first lessons. **Felt miniature** (ep07) for warm short films. **Vox documentary collage** for investigative, "documentary" or "Vox" briefs. **Watercolour** (ep05) for hand-painted/watercolour references. Ink-and-hatch only on request. See `references/styles.md`. |
| Mascot | Devan (quiff, shades, teal θ hoodie). Paper style: walks and points. Vox style: halftone cutout that springs in and points; no lip-sync. |
| Voice | Gemini-TTS `Fenrir` narrator, `gemini-2.5-pro-tts`, `tempo: 1.1`, genre-specific prompt. Approved character dialogue uses `tts.voices` + line `speaker`; see `references/voice-google-tts.md`. |
| Timing | gap 0.4, lead 0.6, tail 0.5–0.7, `gapBefore` 0.15–0.5 on punchlines, endCard 2.5 (ep07) |
| Captions | Always burned in. Strip centered at y 1352, `captionChars: 70`, ≤ 2 lines. Numbers as digits in `caption`, as words in `say`. |
| Safe zones | titles y 300–520 (Instagram feed/grid crops); hero y 250–1180; Devan's feet at 1196–1240; nothing important at x > 960 or y > 1420 |
| Transitions | Every scene/world change has one, 0.5–0.9 s, styled after where it's going (tile flip, mosaic, pencil wipe, tape roll, brick build, match-cut zoom, pan, drop, tear…); continuous beats draw from global time. Checked with `scripts/cutcheck.sh` (0 hard cuts unless intended). See `references/scene-building.md` → Transitions. |
| Music | Playful: marimba + light drums at 96 bpm. Documentary: piano + pulse at 84 bpm, minor. See `references/audio.md`. |
| End card | After ONE closing ask (save CTA or "Next up: …" tease, not both): a ≤ 2.5 s card with `BRAND.tagline`, Devan waving, `BRAND.handle`, "Educational only. Not financial advice.", sources (`episodes/_template` draws the handle from `engine/brand.js`) |
| Deliverables | master, `-upload`, `-preview` (720p, < 30 MB, the one sent to the phone), cover, `.srt`, contact sheet, 3–5 titles, a casual description |

## Workflow

Make a todo for each step. Steps 3–4 run subagents in the background; keep working while they run.

1. **Orient.** Read `references/lessons.md` and the repo's `docs/PLAYBOOK.md` and `tasks/lessons.md`. Check
   `git status`: another session may be editing other episodes, so leave their files alone. Check disk with `df -h`,
   since renders need headroom.
2. **Brief.** The creator dictates, so expect filler words and mangled terms ("walk style" = "Vox style").
   Extract the topic, angle, reference link, length and any must-include items (e.g. "examples of real home
   purchases", "AI impact"). List your interpretations and assumptions; they go into the check-in. Check the brief
   against the channel lane, write the video's one sentence, and pick the length target (61–75 s unless the idea is
   tiny). Plan it for a general audience: one spoken number, a countable picture, plain-word definitions.
3. **Reference.** First grep the repo for the link (`grep -rl "<status id>" docs episodes`); it may already be
   analyzed (ep02's and ep03's references are in their specs). Otherwise run
   `scripts/fetch_reference.sh <link> <scratchpad>/ref` downloads the video, writes contact sheets
   and prints any quoted prompt pack. Read the sheets and write style notes, then choose or plan a style kit.
   **The reference sets the look and the animation**: its rendering, signature device, camera language and
   transitions (pull a 6–10 fps strip around each of its cuts). "Use this format / these colours" never means the
   house look with a new palette. → `references/reference-videos.md`
4. **Research, then fact-check.** Launch 2 parallel research agents on primary sources, with today's date, a
   request for concrete examples and counter-evidence, **each told the other's scope**, and a budget of about 6–10
   lookups each. Check the brief's premise against the data. Draft the script in the scratchpad, then run the adversarial
   fact-check agent. Apply every FIX, most SOFTENs, and its balance suggestion. Note upcoming data releases that
   could date the video (release calendars are in the reference). Draft `script.json` in the scratchpad and run
   `node <skill-dir>/scripts/check_captions.mjs <scratchpad>/script.json`. → `references/research-factcheck.md`
5. **Design check-in.** Present the storyboard (template below): format, style, Devan's treatment,
   voice, music, framing, the scene table, and dating risks. If the design is not already approved, wait for the
   creator's yes; a "continue" or "go ahead" counts. Existing approval covers implementation of that design.
6. **Scaffold.** Work on a feature branch. `cp -r episodes/_template episodes/NN-slug`. Write `script.json`
   (→ `references/script-writing.md`) and a short spec in `docs/superpowers/specs/<date>-<slug>-design.md`. Put the
   plan in `tasks/todo.md`. Install any new fonts with `npm i -D @fontsource/<family>`.
7. **Voice.** Run `EP=episodes/NN-slug npm run tts` in the background. **Always set `EP`**: the npm scripts default
   to ep01, so a bare `npm run tts` re-voices it. Then run `check_wpm.py`. Retake anything over 200
   or under 120 wpm with a `direction`. The checker reads raw takes only: also measure final WAV rates after tempo,
   keeping both within the pacing bar. Run `npm run timeline`. If the total is over the target (hard ceiling 90 s), cut beats, lines or words;
   never raise the tempo past 1.1 or speed up the video. → `references/voice-google-tts.md`
8. **Engine changes (only if needed).** Before touching shared engine code, record pixel hashes of fixed frames
   from every older episode (`tools/stills.mjs … --out <dir>` + `shasum`) and hashes of a re-synth of an older
   episode. Add the new kit, transition or synth option beside the old ones. Afterwards, prove the hashes still
   match.
9. **Shot list, then style frames (new or reference-driven look).** Write the state-list shot list first
   (`motion-quality-bar.md` → Spec before code). Before building every scene, render 4–8 stills from the
   actual kit (frame one, the hero beat, each distinct world), score them with the critic rubric (3 rounds, every
   score 8+), and log the rounds. For a reference-driven look, get an independent
   art review against reference stills (light, volume, staging, set dressing) before all scenes. Share them through the host, so the creator can
   redirect cheaply (ep08 was redirected twice; both times stills would have caught it before a render).
10. **Scenes.** Build `scenes.js` with the motion harness: springs and `track()` from `engine/anim.js` for anything
   with mass, no banned defaults, something new every 2–4 s. If several agents or sessions build in parallel, write
   `ANIMATION_GUIDE.md` first. Key beats to the voice with `at()` / `atW()`; measure actual word offsets for key beats
   (`atW` only estimates them) and re-measure after retakes. Loop: `tools/stills.mjs $EP
   <scene:offset>… --sheet`, read the sheet, fix, repeat. Walk the review checklist, run
   `node <skill-dir>/scripts/check_captions.mjs $EP`, and check every seam: `node tools/stills.mjs $EP $(python3
   <skill-dir>/scripts/seams.py $EP) --sheet` — each pair must match (no jump cuts). Design a transition for every
   change of world/layout and review it as 5 stills through its window. Every number drawn on a prop must match the
   state at that moment (ep08's tag said 3.9¢/oz on the 32 oz bottle; it was 3.4¢ until the shrink).
   → `references/scene-building.md`, `references/styles.md`
11. **Audio.** Run `EP=… npm run synth` (again whenever the timeline changes). Sanity-check the music with a
    spectrogram and loudness. → `references/audio.md`
12. **Render.** Turn on `"motionBlur": { "sub": 4 }` in `script.json` if the camera or big shapes move fast (×4
   render time). `node tools/render.mjs $EP --check` must match on all probes, plus 2–3 frames that use filters,
    blur, pixelation or halftones (render twice, compare hashes). Keep ≥ 2 GB free (`df -h`; ep08 fell to 161 MB). Then run `npm run render` in the background (about 10 min for 75 s; roughly 8 s per rendered second). Meanwhile, send the user
    a storyboard sheet (one still per scene) and update the playbook.
13. **Mix and verify.** Run `npm run mix` and `sh tools/verify.sh NN-slug`. Targets: −16 LUFS, peak ≤ −1 dBFS,
    A/V delta ≤ ~0.07 s. Read the contact sheet and the tail sheet. Run `sh <skill-dir>/scripts/cutcheck.sh NN-slug
    0.25 <planned transition times…>` and read `out/NN-slug-cuts.jpg`: 0 unintended hard cuts, every transition
    visibly progressing over its frames. Run `sh <skill-dir>/scripts/critique-sheets.sh out/NN-slug.mp4 <fast-move
    times…>` and hand the sheets to a fresh critic agent for the 1–10 rubric (`motion-quality-bar.md`). Patch-render any broken range instead of
    re-rendering everything. → `references/render-deliver.md`
14. **Deliver.** Run `sh <skill-dir>/scripts/deliver.sh NN-slug <cover-seconds> portrait` and send the preview
    (reels come out at 7–12 MB, under the 30 MB phone limit). Write the report
    (template below) with titles and description. The description ends with `COPY.video.footer` and one 3-tag set from
    `COPY.video.hashtagsByTopic` (`engine/brand.js`; → `references/brand.md`). Record new lessons in the repo's playbook, `tasks/lessons.md` and
    `skills/shared/references/lessons.md` (then `sh skills/install.sh`), and update cross-session memory only when explicitly requested. Commit only if asked. Remind the creator to post the same video to all three (the master to Shorts, the `-upload` copy to Reels and TikTok)
    platforms, and to share swipe-away %, average view duration, % viewed to the end, rewatches and shares after
    ~48 h; record what they show in `tasks/lessons.md`.

## Storyboard check-in template

```
## Episode NN: "<Title>" (9:16 reel, target <61–75> s, <N> words)
**Brief, as I read it:** topic, angle, reference, length, must-haves, and how you resolved garbled words.
**One sentence:** the single idea every beat serves.  **Lane:** in lane, or off lane + the in-lane angle you propose.
**Frame one:** what is on screen at 0 s (title, promise, key number, motion) — this is also the cover.
**Premise check:** what the brief assumed vs what the data says (e.g. "not a record: $1.26T vs the $1.28T peak").
**What the data says:** 2–4 verified headline facts (and whether they change the story).
**Look:** <style> — surface, palette, type, motion (1–3 lines). If a reference is attached: what you take from it
(rendering, signature device, camera, transitions) — not just its colours.
**Transitions:** one per scene/world change, named (e.g. "tile flip from the send button", "brick build").
**Devan:** <treatment>.  **Voice:** Fenrir 1.1× with a <genre> prompt.  **Music:** <preset>.
| # | Scene | What he says (short) | What you see |
|---|---|---|---|
| 1 | Hook | … | … |
…
**Framing:** neutral; risks shown as risks, with sources; one balance line.
**Engine work:** new files / additive changes, and how all older episodes stay pixel-identical.
**Dating risks:** each scheduled release that could outdate a spoken number, with its exact date.
**Heads-up:** anything odd found (other sessions' changes, disk).
**Questions:** 1–3 decisions for the creator, each with your recommended default.
```

## Report template (after delivery)

- What was made: length, style, voice. The preview has been sent.
- Checks with real numbers: loudness, peak, A/V delta, determinism probes, regression hashes, `cutcheck.sh` hard-cut
  count. Say what was **not**
  verified (music and SFX by ear).
- Fact-check summary (claims checked, wording fixed) and **dating risks with exact dates**, with an offer to re-voice
  and patch.
- File paths in `out/`. Git state.
- 3–5 titles (one recommended) and the description, following the social-copy rules in
  `references/render-deliver.md`.

## Bundled files

| File | Read when |
|---|---|
| `references/lessons.md` | Always, first |
| `references/brand.md` | Always: name/handle/tagline source, end card, copy footer + hashtags, cross-posting, channel art |
| `references/pipeline.md` | Architecture, why it's built this way, commands, performance, rebuilding elsewhere |
| `references/reference-videos.md` | The user gives a link or asks for a look |
| `references/research-factcheck.md` | Any factual topic (always for money or economics) |
| `references/script-writing.md` | Writing `script.json` and structuring the arc |
| `references/voice-google-tts.md` | Google Cloud setup, prompts, pacing retakes |
| `references/styles.md` | Choosing or building a visual style kit |
| `references/scene-building.md` | Writing `scenes.js`, layout, the stills review checklist |
| `references/audio.md` | Music presets, SFX, mix targets |
| `references/render-deliver.md` | Render, verify, patch, deliverables, social copy |
| `references/motion-quality-bar.md` | Before storyboarding and before sign-off: critic loop (storyboard → full-film → verification), the motion grammar, the measured bar, audio rules, and the motion harness (springs, state-list shot list, ANIMATION_GUIDE, motion blur, the 1–10 critic rubric) |
| `references/local-setup.md` | Machine setup: repo path, Google project, service account, key location |
| `scripts/fetch_reference.sh` | Pull an X/Twitter reference: video, contact sheets, quoted prompt text |
| `scripts/check_wpm.py` | Speaking rate per take, with retake flags |
| `scripts/check_captions.mjs` | Orphaned or over-long caption chunks |
| `scripts/seams.py` | Stills times for the frame pair on each side of every scene boundary (jump-cut check) |
| `scripts/cutcheck.sh` | Hard-cut detector on the rendered video + 10 fps strips around cuts and planned transitions |
| `scripts/frozen-time.sh` | Near-frozen time and every hold ≥ 0.6 s in a render (run beside `cutcheck.sh`) |
| `scripts/critique-sheets.sh` | Contact (2 fps), phone (360 px) and 12-frame strip sheets for the critic rubric; `LOOP=1` adds a loop-seam check |
| `scripts/deliver.sh` | Upload copy, 720p preview (< 30 MB check), cover |
| `scripts/chapters.mjs` | Chapter timestamps (mostly for long-form) |
| `scripts/bootstrap.sh` | Seed a new project from the reference repo |

The Google service-account key is never copied into this skill, a repo, a prompt or chat. See
`references/voice-google-tts.md` → Security.
