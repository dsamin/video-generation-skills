---
name: video-generation-long-format
description: Use when making a landscape 16:9 YouTube explainer, documentary, character-led story or video essay starring Devan. Create a finished video with research, chapters, Google Gemini-TTS narration or a dialogue cast, canvas styles including era walk and storybook ink, score, clean picture, SRT, thumbnails and upload files. For vertical social videos, use video-generation-short-format.
---

# Video generation — long format (YouTube, 16:9)

This skill makes a finished landscape YouTube video entirely in code: voiced, scored, captioned, with chapters and
a thumbnail. The engine lives in the reference repo `~/Projects/Video-Series`: canvas renderer, style kits, TTS,
synth and mixer. Work inside it (episodes go in `episodes/NN-slug/`), or seed another project with
`scripts/bootstrap.sh <dir>`. Episode 01 ("Get Paid to Wait", covered calls and the wheel) is the 16:9 reference:
ink-and-hatch style, 1920×1080, 7 scenes plus the end card, voiced by Fenrir at tempo 1.0. Start new episodes from
**`episodes/_template-16x9/`**, a runnable sketch-style scaffold with chapter cards, a full music block, `cN-NN` line
ids and a thumbnail.

Read `references/lessons.md` first, then the repo's `docs/PLAYBOOK.md`. If the playbook and this skill disagree,
the playbook wins. The channel is **Dollar Devan** (@dollardevan, "Money, made simple."): `references/brand.md`
covers the end screen, description footer, thumbnails and channel art. Take the name, handle and tagline from
`engine/brand.js`; never type them by hand.

**Running the bundled scripts:** they live in this skill's `scripts/` folder (in the repo also at
`skills/shared/scripts/`). Run them from the repo root:
- `node <skill-dir>/scripts/chapters.mjs episodes/NN-slug`
- `node <skill-dir>/scripts/check_captions.mjs episodes/NN-slug`
- `python3 <skill-dir>/scripts/check_wpm.py episodes/NN-slug`
- `sh <skill-dir>/scripts/deliver.sh NN-slug <cover-s> landscape`
- `sh <skill-dir>/scripts/fetch_reference.sh <url> <dir>`

`<skill-dir>` is the base directory shown when the skill loads (e.g. `~/.claude/skills/video-generation-long-format` or `~/.codex/skills/video-generation-long-format`).

## Host tools and authorization

Use the host's web tools and subagent tools for research and reviews. Share local style frames and previews through
its file-sharing tool, or absolute file links and image/video embeds when none is available. Save research and
review notes in the repo spec directory as they land. Existing approval to build covers the approved design;
ask at a check-in only for an unresolved design decision. Update cross-session memory only when the user explicitly
asks; project lessons and shared references remain the workflow record.

## Proven vs. guidance

The 16:9 pipeline is proven end to end at scale: ep01 (ink, 1920×1080) and ep16 ("The NVIDIA Story", 8:49, 9 chapters,
era-walk kit) shipped with segmented renders, a tail patch, a clean picture + `.srt`, the 7 s brand end screen,
thumbnails and an upload folder. Paper and Vox at 16:9 are still **guidance** (see below). When you learn something
new, write it into the playbook and `skills/shared/references/lessons.md`.

## House defaults for long-form

| | Default |
|---|---|
| Format | 1920×1080, 30 fps (`"size": [1920, 1080]`) |
| Attribution | Permanent `@DollarDevan` on every future video (creator approved 2026-10-13). Shared player draws it after scene effects; template sets `"watermark": true`. Reserve its upper-right safe area, check encoded frames, and keep thumbnails unmarked. See `references/brand.md` for historical rerenders. |
| Length | Whatever the topic needs, usually 5–12 min. Confirm a target in the outline. |
| Word budget | ~120 words per **spoken** minute of finished video, at tempo 1.0 with 0.55 s gaps. Exclude the end card: an 8:00 video with its 7 s end screen has ~7:50 of speech ≈ 920 words ≈ 70–80 lines ≈ 25–30 scenes. Raw takes run faster (~150 wpm); gaps and leads make up the difference. |
| Structure | cold open → title and promise → 3–6 chapters → payoff and recap → outro and end card |
| Line ids | `c<chapter>-<nn>`: `c0-01` (cold open) … `c3-07` … `c9-02` (outro). They stay unique across 25+ scenes. |
| Style | Match the reference and genre; no fixed look. Ink sketch (ep01/template), era walk (ep16, shipped), or storybook ink (`story*.js`, ep17 style frames; film in production). Paper/Vox kits need 16:9 layouts; see below and `references/styles.md`. |
| Voice | Gemini-TTS `Fenrir`, `gemini-2.5-pro-tts`, `tempo: 1.0` (1.05 if it feels slow), with the warm "YouTube creator" prompt in the template. Approved dialogue casts use `tts.voices` + line `speaker`; see `references/voice-google-tts.md`. |
| Timing | gap 0.55, lead 0.6, tail 0.8. `sceneLead` ~2.4 on each chapter's first scene (the chapter card plays there); 0.7–1.0 on diagram scenes. `sceneTail` 1.0–2.0 on dense diagrams. `gapBefore` 0.35–0.5 before dollar amounts. |
| Captions | **Clean picture + uploaded `.srt` (creator's choice, 2026-10-09):** `"burnCaptions": false` in script.json (the 16:9 template's default; the player honours it, no episode code); `npm run mix` still writes the `.srt` (upload it as YouTube captions: viewers can toggle and auto-translate, no double captions with CC). Still write captions with `captionChars` and run `check_captions.mjs` — they become the `.srt`. Burn captions into any Shorts/Reels clips cut from the video. |
| Layout | titles y 150–250; main visual y 150–850; ground line y 820. In diagram scenes Devan shrinks to the right corner (x ~1720–1760, s ~0.6). Change the composition every 5–10 s. |
| Transitions | `slide` 0.55 (page edge), `iris` 0.7 into a key prop, a page `slide` (or a styled wipe such as ep16's comic tear) into the brand end screen, never a fade: it ghosts two Devans; `pan`/`tear` in paper and Vox styles; styled world-hop transitions (tile flip, mosaic, pencil wipe, tape roll, brick build, match-cut zoom) in the toy-cinema kit. Every scene/world change gets one — no bare or glitch-only cuts; check with `scripts/cutcheck.sh`. Never crossfade the mascot unless both frames are aligned (match dissolve). |
| Music | Lo-fi (template): rhodes + lofi drums, 80 bpm, Fmaj7–Em7–Dm7–Cmaj7, one darker stretch. **Set every marker** (`drumsIn`, `drumsOut`, `darkFrom`, `darkTo`); the synth's defaults name ep01's scenes and crash elsewhere. |
| End card | **7 s brand end screen** (`timing.endCard: 7`): `channel/brand/end-screen-1080p.png`, preloaded in `setup()` and entered with a designed transition. It holds ~6 s, enough for YouTube's end-screen elements (5 s minimum). Never 15–20 s: the creator called ep16's 18 s card "lingering". The 16:9 template draws it. → `references/brand.md` |
| Deliverables | `out/NN-slug-final/` = the upload set only: master, `.srt`, `thumbnail.jpg` (the chosen variant) and `YOUTUBE-UPLOAD.md` (title, description, tags, end-screen times). Plus a phone preview (`deliver.sh … landscape` makes it 960×540 CRF 30: 25.6 MB for 8:49), 2 thumbnail variants (1280×720 JPG < 2 MB), chapters, contact sheets |

## Long-form structure

1. **Cold open (0:00–0:30):** one concrete, personal example or question that the whole video answers. No logo
   intro.
2. **Title and promise (≤ 10 s):** say what the viewer will understand or be able to do by the end.
3. **Chapters (3–6).** Each chapter:
   - opens with a chapter card drawn during its first scene's `sceneLead` (`chapterCard()` in the template), whose
     title matches the YouTube chapter list;
   - makes one idea concrete with a worked example and real numbers;
   - ends with a one-line mini-recap or an open loop into the next chapter.
4. **Payoff and recap:** tie back to the cold open, then give a 3-point recap.
5. **Outro:** one closing ask in the voice (ep16: "If you want to see whether that moat holds, subscribe."), then
   the 7 s brand end screen. The disclaimer is on it, and the sources go in the description.

`"chapters": {"<sceneId>": "Title", …}` in `script.json` feeds `scripts/chapters.mjs`. YouTube requires the first
chapter at 0:00, ≥ 3 chapters, and each ≥ 10 s.

## Workflow

Make a todo per step. Research, TTS and render run in the background; keep working while they run.

1. **Orient.** Read `references/lessons.md`, `references/brand.md`, the repo's `docs/PLAYBOOK.md` and
   `tasks/lessons.md`. Check `git status`: other sessions may be editing other episodes, so leave their files alone.
   Check `df -h` and `sysctl vm.swapusage`; a long render needs ≥ 3 GB free, and swap can eat several GB mid-render.
2. **Brief.** The creator dictates, so expect filler and mangled terms. Extract the topic, target length, style
   ("the sketch style from the covered calls video" = ink-and-hatch, ep01), must-haves (chapters, thumbnail) and
   the reference link. List your interpretations.
3. **Reference (if a link is given).** Run `scripts/fetch_reference.sh`, read the contact sheets, and write style
   notes. The reference sets the look **and** the animation (rendering, signature device, camera, transitions), not
   just the palette; build its kit rather than re-lighting the house look (ep08). → `references/reference-videos.md`
4. **Light research, then Check-in 1: the chapter outline.** Do a quick pass of about 8–12 lookups so
   the outline's claims are real, not guessed. Present: the promise, target length, cold open, chapters (title +
   the 2–4 claims each makes + rough timing), the end-screen choice, thumbnail direction, and open questions. If
   the outline is not already approved, wait for the creator's yes before paying for TTS and renders.
5. **Full research and adversarial fact-check, by chapter.** Use 2–3 research agents by chapter or domain. Draft the
   script, then run the checker (split by chapter if there are more than ~25 claims). Apply every FIX, most
   SOFTENs, and the balance suggestions. Note data releases that could date the video. Some primary sites (S&P
   SPIVA, investor.gov) return 403 to fetches: use the published PDF (`curl` it, then `pdftotext` or pypdf) or a
   reputable secondary write-up, and flag which. → `references/research-factcheck.md`
6. **Check-in 2: the storyboard, chapter by chapter** (template below). If the design is not already approved,
   wait for the creator's yes; a "continue" counts. Existing approval covers implementation of that design.
7. **Scaffold.** Work on a feature branch. `cp -r episodes/_template-16x9 episodes/NN-slug`. Write `script.json`
   (→ `references/script-writing.md`) and a short spec in `docs/superpowers/specs/<date>-<slug>-design.md`. Put the
   plan in `tasks/todo.md`. Split big episodes into `scenes/ch1.js` … imported by `scenes.js`.
8. **Voice.** 70–90 lines take ~10–18 min of API time. Run `EP=… npm run tts` in the background, then
   `check_wpm.py`. Retake takes over 200 or under 120 wpm in batches. The checker reads raw WAVs only: also measure the final
   tempo-adjusted WAV rates. Audition any character cast before the full run. Run `npm run timeline` and compare it with
   the target; cut words rather than raising the tempo. → `references/voice-google-tts.md`
9. **Engine changes (only if needed).** Before touching shared code, hash fixed frames from every older episode
   and a re-synth of one. Add new kits, layouts or synth options beside the old ones, then prove the hashes still
   match.
10. **Scenes, chapter by chapter.** Build code-drawn motion graphics with the motion harness
    (`references/motion-quality-bar.md`: springs and `track()` from `engine/anim.js`, a state-list shot list per
    chapter, no banned defaults); generated images only when the creator asks by name. When chapters are built by
    parallel agents, write `ANIMATION_GUIDE.md` first so they match. For a new or reference-driven look, first send
    4–8 style frames from the real kit, scored with the critic rubric (3 rounds, every score 8+), and let the
    creator react. For reference-driven looks, get an independent art review against reference
    stills (light, volume, staging, set dressing) before all scenes. Key beats to the voice (`at`, `atW`), measuring
    actual word offsets for key moments and re-measuring after retakes. Loop: `tools/stills.mjs $EP
    <scene:offset>… --sheet --cols 4`, read, fix. Design a transition for every scene/world change and review each as
    stills through its window. Numbers drawn on props must match the story state at that moment. Walk the review
    checklist and run `check_captions.mjs`.
    → `references/scene-building.md`, `references/styles.md`
11. **Audio.** Run `EP=… npm run synth` (every marker set; re-run when the timeline changes). Sanity-check with a
    spectrogram and loudness. If chapters need several moods, extend the synth additively (e.g. a list of dark
    ranges) and prove older episodes' music is byte-identical. → `references/audio.md`
12. **Render.** Opt into `"motionBlur": { "sub": 4 }` only for fast camera moves (×4 render time; run just those segments as
    `SUB=4 sh tools/render-seg.sh …`). `node tools/render.mjs $EP --check`, then render **in segments** with the disk watchdog:
    `sh tools/render-seg.sh $EP <from> <to> out/seg/sN.mp4` per ~2,700 frames, one after another in the background,
    then join them with ffmpeg's concat demuxer (`-c copy`). Each segment starts on a keyframe, so you can re-render
    one segment or the tail later without touching the rest. Expect ~9–10 min per minute of video (8 min ≈ 75–80
    min). If Playwright reports "Executable doesn't exist", a cache cleanup wiped its Chromium: run `npx playwright
    install chromium`. Meanwhile, build the **thumbnail**, draft the YouTube copy, and send a storyboard sheet.
13. **Mix and verify.** `npm run mix`, then `sh tools/verify.sh NN-slug`. Targets: −16 LUFS, peak ≤ −1 dBFS, A/V
    delta ≤ ~0.07 s. verify.sh's contact sheet covers only the first 108 s, so for the whole video run
    `ffmpeg -i out/NN-slug.mp4 -vf "fps=1/10,scale=320:-1,tile=8x6" -frames:v 1 out/NN-slug-contact-full.png`
    (8×6 = 48 tiles = 8 min; add `-ss` for later parts). Run `sh <skill-dir>/scripts/cutcheck.sh NN-slug 0.25
    <transition times…>` and read `out/NN-slug-cuts.jpg` (0 unintended hard cuts). Run `frozen-time.sh`: the only
    long hold should be the end screen. Run `critique-sheets.sh` per chapter and have a fresh critic score it with the
    1–10 rubric. Patch-render broken ranges and never re-render everything. To change the
    ending, follow the tail patch in `references/pipeline.md`: cut the head by frame count and verify frame hashes at
    the seam.
    → `references/render-deliver.md`
14. **Deliver.** Run `deliver.sh NN-slug <cover-s> landscape`.
    - It makes the 960×540 phone preview (< 30 MB for ~9 min) and puts the master, the `.srt` and the thumbnail JPGs
      in `out/NN-slug-final/`.
    - Name the chosen thumbnail `thumbnail.jpg` and delete the alternate from the folder.
    - Write `YOUTUBE-UPLOAD.md` there: title, description (paste-ready, no hard line breaks, chapters, sources, brand
      footer, hashtags), tags, and the end-screen window (the last ~6 s, e.g. 8:43–8:49).
    - Send the preview and the thumbnails, and write the report (below).
    - Record lessons in the playbook, `tasks/lessons.md`, `skills/shared/references/lessons.md` (then
      `sh skills/install.sh`). Update cross-session memory only when explicitly requested. Commit only if asked.

## Thumbnail and YouTube packaging

- **Thumbnail:** `episodes/NN-slug/thumbnail.js` exports `variants` and `draw(ctx, env, variant)`. `tools/thumbnail.mjs`
  calls `draw(…, 'paper')` first to read `variants`, so `draw` must accept `'paper'`. Put Devan large with a prop,
  2–4 huge words and high contrast, and keep the bottom-right corner clear for the duration badge. Leave the channel
  name and handle off the thumbnail (YouTube shows them), and keep Devan on-model: check frames grabbed from the
  video for tints or effects.
  `EP=… npm run thumbnail` writes `out/NN-slug-yt-thumbnail-<v>.png` (1920×1080) and a `.jpg` (1280×720, checked
  < 2 MB). To preview live, run `npm run serve` (port 5173) and open
  `http://localhost:5173/engine/player.html?ep=NN-slug&thumb=<v>`. Make 2 variants and let the creator pick.
- **Titles:** 3–5, ≤ 60–70 characters, concrete and personal; recommend one.
- **Description:**
  - a 1–2 sentence hook in the creator's casual voice (normal capitalization, one emoji max, ends with a question)
  - the chapters block from `chapters.mjs`
  - sources, then the brand footer `COPY.video.footer` from `engine/brand.js`, then 3 hashtags from
    `COPY.video.hashtagsByTopic`
  - paragraphs with no hard line breaks inside sentences (YouTube shows every newline)
  - 5–10 tags (YouTube's separate tags field, not hashtags)
  Upload the `.srt` as captions. In Studio's end-screen editor, put the subscribe element on the badge and two video
  elements on the WATCH NEXT panels, for the last ~6 s.
- **Channel assets:** `node tools/launch-kit.mjs --hq` rebuilds the whole kit: avatar, banner, watermark, end
  screens, Instagram highlights and stories, every profile's copy, and upload READMEs. The older `npm run
  avatar/banner/watermark` tools are superseded. → `references/brand.md`

## Paper or Vox at 16:9 (engine gap)

`paper-kit.js` (`REEL`) and `vox-kit.js` hardcode 1080×1920 layout: ground, caption y, camera center, safe x.
`VX.stage(W, H, …)` already takes a size. To use these styles at 16:9, add a `WIDE` layout additively, e.g.
`W 1920, H 1080, GROUND ~900, CAP_Y ~990, SAFE_X ~1800` (no right-edge app UI, but mind the thumbnail badge). Pass it
through `drawCaption`, `camera` and the backdrops. Keep `REEL` behavior unchanged, prove older episodes
pixel-identical, and record the constants in `references/styles.md`.

## Check-in templates

Check-in 1 (outline):
```
## Episode NN: "<Working title>" (16:9, ~M:SS)
**Promise:** one sentence.  **Cold open:** the concrete example.
| Ch | Title | Claims it will make (source status) | ~Time |
**Look / Devan / Voice / Music:** one line each.  **End screen:** yes/no.  **Thumbnail direction:** 2 ideas.
**Questions** (each with a recommended default).
```
Check-in 2 (storyboard, per chapter):
```
### Chapter N — <title> (≈ m:ss–m:ss)
| # | Scene | What he says (short) | What you see |
**Engine work / regression plan.  Dating risks.**
```

## Report (after delivery)

- What was made: length, chapters, style, voice. The preview or excerpt and the thumbnails have been sent.
- Checks with real numbers: loudness, peak, A/V delta, determinism, regression hashes. Say what was **not**
  verified (audio by ear).
- Fact-check summary and **dating risks with exact dates**, with an offer to re-voice and patch.
- File paths (`out/`), the chapters block, titles and description. Git state (uncommitted unless asked).

## Bundled files

- `references/lessons.md`: read first.
- `references/brand.md`: the channel brand (name/handle from `engine/brand.js`), end screen, copy, thumbnails, channel art.
- `references/pipeline.md`: architecture, rationale, commands, performance, patch splicing.
- `references/reference-videos.md`
- `references/research-factcheck.md`
- `references/script-writing.md`: schema, say vs caption, arcs, budgets.
- `references/voice-google-tts.md`: Google Cloud setup, prompts, retakes, security.
- `references/styles.md`: ink, paper, Vox, and a new-kit recipe.
- `references/scene-building.md`: timing helpers, layout, review checklist.
- `references/audio.md`: music presets, required markers, SFX, mix.
- `references/render-deliver.md`
- `references/local-setup.md`: Machine setup (repo, Google project, service account, key path).
- Scripts:
  - `fetch_reference.sh`, `check_wpm.py`, `check_captions.mjs`, `deliver.sh`, `chapters.mjs`
  - `cutcheck.sh`: hard-cut detector + 10 fps strips around cuts and planned transitions
  - `frozen-time.sh`: near-frozen time and every hold ≥ 0.6 s
  - `critique-sheets.sh`: contact, phone (360 px) and strip sheets for the critic rubric
  - `bootstrap.sh`: seeds a new project, including both templates.

The Google service-account key is never copied into this skill, a repo, a prompt or chat. See
`references/voice-google-tts.md` → Security.
