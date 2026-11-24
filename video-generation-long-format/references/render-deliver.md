# Render, verify, deliver

## Render

1. **Disk check:** `df -h /System/Volumes/Data` (macOS) or `df -h .`. Leave ≥ 2 GB for a reel and
   ≥ 3 GB for long-form. On Devan's Mac the standing cleanup policy allows deleting regenerable caches (uv, npm, bun,
   Xcode DerivedData, codex-runtimes) with a log line in `~/cleanup-log.txt`. Ask before anything else.
2. **Determinism:** `node tools/render.mjs $EP --check`. All 4 probes must match. If the style renders anything
   animated through pixel readback (e.g. halftone Devan), also render 2–3 such frames twice with `stills.mjs` and
   compare hashes.
3. **Full render in the background:** `EP=$EP npm run render > out/NN-render.log 2>&1` (5 workers, progress every
   150 frames). It runs at ~3.5 fps for 1080×1920 or 1920×1080, so 2:15 takes ~20 min and 10 min takes ~90 min.
4. While it renders: update the playbook and notes, draft social copy, and send the user a storyboard sheet
   (`stills.mjs … --sheet --cols 6`, one frame per scene).
5. **Long renders (long-form) go in segments:** `sh tools/render-seg.sh $EP <from> <to> out/seg/sN.mp4 [workers=2]
   [min-free-MB=1500]` renders one frame range and stops cleanly when free disk drops below the floor (an emergency stop; still start
   with the ≥ 2 GB / ≥ 3 GB headroom above) (swap from other
   apps grew to 9–15 GB during ep16 and once filled the disk). Run ~2,700-frame segments one after another, check each
   frame count, then `ffmpeg -f concat -safe 0 -i list.txt -c copy out/NN-slug-video.mp4`.
6. **"Executable doesn't exist at …/ms-playwright/…":** a cache cleanup removed Playwright's Chromium. Run
   `npx playwright install chromium` (~100 MB) and render again.

## Verify

```bash
EP=$EP npm run synth       # if the timeline changed since the last synth
EP=$EP npm run mix
sh tools/verify.sh NN-slug # specs, A/V delta, loudness, contact sheet (1 frame / 3 s, 6×6)
```

Read the contact sheet. The default grid covers 108 s. For long-form, sheet the whole video with
`ffmpeg -i out/NN-slug.mp4 -vf "fps=1/10,scale=320:-1,tile=8x6" -frames:v 1 out/NN-slug-contact-full.png`
(48 tiles = 8 min; add `-ss` for later parts). For a reel's tail past 108 s, run
`ffmpeg -ss 106 -i out/NN-slug.mp4 -vf "fps=1/2,scale=400:-1,tile=8x2" -frames:v 1 tail.png`.

If one scene needs fixing, patch-render just that frame range and splice it in (see `pipeline.md`). Check the splice
boundaries: extract frames a−1, a, b−1 and b.

## Deliverables (in `out/`)

| File | How |
|---|---|
| `NN-slug.mp4` | master from `mix.mjs` (video CRF 17) |
| `NN-slug-upload.mp4` | `ffmpeg -i master -c:v libx264 -preset slow -crf 22 -c:a copy -movflags +faststart` |
| `NN-slug-preview.mp4` | reels: `-vf scale=720:1280 -crf 26 -b:a 128k`; 16:9: `-vf scale=960:540 -crf 30 -b:a 96k` (8:49 → 25.6 MB); **must be < 30 MB** to reach the phone |
| `NN-slug-cover.png` | `ffmpeg -ss <title moment> -i master -frames:v 1` (title and hero visible) |
| `NN-slug.srt` | written by mix |
| `NN-slug-contact.png` | written by verify.sh |
| YouTube thumbnail (long-form) | `EP=$EP npm run thumbnail` → `-yt-thumbnail-<variant>.png` (1920×1080) + `.jpg` (1280×720, < 2 MB) |

`scripts/deliver.sh NN-slug <cover-seconds> [portrait|landscape]` makes the preview and prints the sizes.
- **portrait:** also makes the upload copy and the cover. Reel previews come out at 7–12 MB.
- **landscape:** makes the 960×540 phone preview (fits under 30 MB to ~10 min) and copies the YouTube thumbnail JPGs
  into the final folder. It skips the `-upload` copy and the cover: a 16:9 long video goes to YouTube only, and its
  thumbnail is designed.

`deliver.sh` also hard-links the postable files into **`out/NN-slug-final/`** and checks that each has an audio track.
Point the creator there, and name the file per platform.
- Reels: the master (YouTube Shorts), `-upload` (Instagram Reels and TikTok), the cover (each app's cover picker) and
  the `.srt` (optional YouTube captions). The preview stays in `out/`: it is for review, not posting.
- Long-form: the master, the `.srt` and the thumbnails. Keep the chosen one as `thumbnail.jpg`, then add
  `YOUTUBE-UPLOAD.md` (title, paste-ready description, tags, end-screen window) so the folder is exactly what gets
  uploaded. **YouTube (Shorts and long-form): the master**, ~10 Mbps,
above YouTube's ~8 Mbps 1080p recommendation; YouTube re-compresses, and halftone and fine textures survive better
from a sharp source. **Instagram and TikTok: the `-upload` copy** (~4 Mbps; they compress hard anyway, and it's quicker
to upload from a phone). `out/NN-slug-video.mp4` is the **silent** picture-only render the mixer uses, and it must never
be posted: ep03 was uploaded to YouTube from it and played mute (YouTube reported loudness −9986 dB, i.e. silence).

Send the **preview** with whatever file-sharing tool the host has (Claude Code desktop: `SendUserFile` with display `render`). If there is none, give the path. Send a storyboard or
contact sheet earlier so the user can follow along.

## Social copy

Titles: give 3–5 options and recommend one. Make them personal and concrete, like the hook: "This Sydney flat cost
$118K in 1988. It just sold for $1.07M", "Why my gas tank suddenly costs $20 more".
Put the topic keyword people search for (e.g. "dividends", "compounding explained") in every title, near the start
(within ~40 characters), in Title Case.

Description, written as if typed on a phone:
- normal sentence capitalization (the creator found all-lowercase untidy, ep05), short sentences, everyday words ("like a year", "basically")
- at most one emoji
- end with a question to the viewer
- no polished phrases ("in a nutshell", "the sneaky part is", "dive into")
- keep the facts unchanged
- on a separate line: `sources: …`, then the brand footer `COPY.video.footer` from `engine/brand.js` ("Money, made
  simple. Follow @dollardevan." + "For general education, not personal financial advice."), then one 3-tag set from
  `COPY.video.hashtagsByTopic` (Instagram caps posts at 5; skip #fyp/#viral; never political tags)
- no line breaks inside a sentence (platforms show every newline)

Posting: the same finished video goes natively to all three (YouTube Shorts: the master; Instagram Reels and TikTok:
its `-upload` copy): retain our embedded `@DollarDevan` attribution on every future video (creator's decision,
2026-10-13); never use a downloaded TikTok or Short with another platform's watermark. Verify the handle in encoded
opening, middle, transition and end-card frames, clear of captions and platform controls. Thumbnails remain unmarked.
Reels run ≥ 61 s (TikTok Creator Rewards). See `brand.md`. After ~48 h, ask
the creator for swipe-away %, average view duration, % viewed to the end, rewatches and shares, and note what they
suggest in `tasks/lessons.md`.

Long-form YouTube also needs:
- a chapters block (`00:00 Intro` …; `scripts/chapters.mjs`)
- a 1–2 sentence hook paragraph
- the sources list (the end screen says "Sources in the description")
- 5–10 tags for YouTube's tags field (separate from the 3 hashtags)
- the end-screen window: the last ~6 s, on the brand end screen's badge and panels

## Final report to the user

Keep it short:
- what was made (length, style, voice)
- the checks with their actual numbers: loudness, peak, A/V delta, determinism, regression hashes
- what was **not** verified (audio by ear)
- dating risks, with exact dates
- git state: uncommitted unless they asked for a commit
- where the files are
- titles and description

Report outcomes faithfully. If something failed or was skipped, say so.

## Cut check and disk guard (ep08)

- After `verify.sh`, run `sh <skill-dir>/scripts/cutcheck.sh NN-slug 0.25 <planned transition times…>`. It reports
  frames whose ffmpeg scene score exceeds the threshold (hard cuts) and writes 10 fps strips (±0.45 s) around them
  and the times you pass to `out/NN-slug-cuts.jpg`. Ship with 0 unintended hard cuts. Patch-render only the fixed
  ranges (`--from/--to`; same length: the overlay splice, changed length or a tail: the frame-count splice, both in
  `pipeline.md`) and prove the splice is frame-exact by hashing frames on both sides of each seam.
- Keep ≥ 2 GB free through render → mix → deliver; ep08 dropped to 161 MB during the final render. Delete your own
  review stills (`out/stills-*`) and scratch clips first, then the approved cache sweep, and log it.
