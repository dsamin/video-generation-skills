# Lessons from every episode (01–16) and the brand launch

These come from the creator's corrections and from bugs caught in review. Read them before starting.

## From the creator (preferences)

- **`out/` is on an external drive, and the browser cache can vanish (eps 45–46, 2026-11-01).** `out/` is a symlink to `/Volumes/<external-drive>/…`. With the drive unmounted, `stills --sheet`, `render` and `mix` all fail, and a finished master is out of reach. Run `ls /Volumes` before rendering. A disk cleanup also deleted `~/Library/Caches/ms-playwright`, so the renderer died with "Executable doesn't exist". Run `npx playwright install chromium` (about 95 MB) and retry.
- **three.js is not installed (ep46, 2026-11-01).** `node_modules/three` is missing, which also breaks ep25's import of it. A three.js episode vendors a pinned build (`three.module.min.js` + `three.core.min.js` + LICENSE) in its own `vendor/` folder and imports it relatively. Run `render --check` to prove it's deterministic.
- **Re-run `synth` after adding `cues()` (eps 45–46, 2026-11-01).** The score reads SFX cues from `scenes.js` at synth time. If music is synthesized before the builder exports `cues()`, the mix is silent at every transition. Synth last, after `scenes.js` is final.
- **Rhyming verse slows Fenrir (ep43, 2026-10-30).** A "measured" storybook-verse prompt gave 91–118 wpm on most couplets and 83 s of speech (over the 90 s cap with gaps). Prompt verse as "natural, flowing storytelling pace, keep it moving; a light landing on each rhyme", and budget about 175 words of verse for an ~89 s reel.
- **A caption edit makes the music stale (ep41, 2026-10-30).** Re-running `timeline` after a caption-only change made `music.wav` older than `timeline.json`, and `npm run mix` refused to run inside a chained background job, so the old master stayed in `out/`. After any `timeline` run, re-run `synth` before `mix`, and check the master's timestamp (or pull a frame) before you deliver.
- **Never start renders with a bare `&` (ep41/42, 2026-10-30).** A render chain launched with `&` inside a foreground shell kept running unseen. A later render then failed on port 5174 (EADDRINUSE) while the stale chain overwrote the outputs. Launch long renders only through the host's background-task mechanism, and check `lsof -iTCP:5174` before starting another.
- **Check every hidden prop against every pre-reveal framing (ep40, 2026-10-30).** In a reveal built as one world, moving the fan, the rod or a box flap for a later shot leaked it into the hook or clue framing. A flap that only made sense on the box also "floated" in later close-ups. After any set change, render one still per framing (hook, push, clue, wide, each close-up) and look for the hidden props.
- **Word cues: hyphenated numbers split (ep39, 2026-10-30).** `atW('m3', 'five')` matched "thirty-five" before "five hundred", so the $500 note appeared 4 s early. Pass the occurrence index (`atW(id, 'five', 1)`) whenever a cue word can sit inside a number.
- **A page curl's flap must be narrower than a mirror fold (ep39, 2026-10-30).** Reflecting the peeled corner fully across the fold covered the whole old page, and the curl read as "lands on a blank page". Compress the reflection to about 0.38× and shade it from the fold, so the old page stays visible beyond the flap.
- **Verify critic timing claims with real frames (ep39/ep40, 2026-10-30).** Blind critics working from 2 fps sheets reported a lap that "never happens", a frozen die and a hidden prop number. Extracted frames showed all three were working. Pull the exact frames with ffmpeg before acting on a timing claim. Their size and clutter notes were right every time.

- **TTS can drop the one word a fact-check added (ep37, 2026-10-29).** Gemini read "Miss just the ten best days" as "…the ten days", which undoes the FIX that made the hook true. After every voice run, read the Whisper transcript from the episode's `align.py` and check that each fact-critical word is there; retake with a direction that stresses the word.
- **A flash needs a visible cause (ep37, 2026-10-29).** Lightning timed to the voice while the camera was underwater flashed the whole frame with no bolt in view; the critic read each one as a cut. Only flash when the source is on screen, and let it decay over ≥ 0.3 s.
- **An iris that grows over the hero is a pop (ep37, 2026-10-29).** A cream moon disc opening for the end card covered Devan in one frame. A torn sheet that slides up from the bottom covers him progressively and reads as paper.
- **Forked builders can't spawn critics (ep38, 2026-10-29).** A forked agent that built a whole reel scored its own frames because it couldn't start a subagent. The main session runs the independent builder ≠ judge critic, then sends the findings back to the builder.
- **Light that pops is a cut (ep33, 2026-10-27).** A flashlight beam that switches off in one frame registers as a hard cut in `cutcheck.sh`. Fade light sources over ≥ 0.3 s and walk characters out of frame rather than removing them. One continuous camera through a single world (push, crane, push into a screen) makes every scene change a designed move.
- **Ticked checklists read as "found one" (ep34, 2026-10-27).** A tick beside a problem question ("Sticker on the barcode?") reads as the problem being present. Word ticked rows as passes ("No sticker on barcode") even when the voice asks the questions.
- **Renders under memory pressure (2026-10-27).** With swap nearly full, a stills run can hang silently. Test one frame first, render one episode at a time with `--workers 3`, and chain the next render behind the first.

- **Code-drawn motion graphics, not generated images (2026-10-21).** For the Droste/infinite-zoom trio the creator stopped a Gemini plate test: "I don't want to use Gemini for this… these are going to be motion graphics… focus on how Claude would do it." Default to code-drawn motion graphics (canvas, springs, the motion harness in `motion-quality-bar.md`) even when a reference is painted or AI-generated: take its *grammar* (camera, device, pacing, loop) and redraw it as motion design. Use generated art only when the creator asks for it by name.

- **Painted references need painted art (ep29, 2026-10-20).** Three rounds of hand-coded style frames for an AI-illustration reference (detailed feminine face, painterly street) were rejected: "the shopper looks weird", "rework her hair and face to look more feminine", "not like the reference". The creator approved once the plates and character were generated with Gemini (`gemini-3-pro-image`, Vertex AI; pipeline in the playbook's "Gemini-painted Ink Street variant") and only the motion stayed in code. Superseded as a default on 2026-10-21 (see above): offer the generated-art route only when the creator asks for it. When feedback is vague ("more changes"), ask with concrete options rather than guessing.


- **Permanent attribution on future videos (2026-10-13).** Embed `@DollarDevan` in both landscape and vertical
  exports through the shared player. Both templates enable it; new scripts default on. This supersedes the earlier
  no-corner-logo policy. The YouTube Studio badge alone is insufficient. Reserve the mark's safe area and verify
  encoded phone-size frames, including transitions and end cards. Historical scripts keep explicit opt-outs only
  for reproducing finished masters and bounded repairs; new editions must enable the mark and render fully.

- **Short-form endings (ep09).** Open on the most intriguing line (a mystery voice: "I've never spent a dollar."), end
  on the emotional line, and put the one closing ask on screen ("save this for payday") instead of speaking a tease
  after it.

- **Reels are 61–75 s, 90 s at most (2026-09-28; 61 s minimum since 2026-10-09 for TikTok's Creator Rewards).** After an analytics review (53.5% swiped away, four Shorts in four
  different audience clusters), the creator chose: one lane (everyday money concepts, US), one idea per video, the
  promise on frame one, one closing ask at the end, batches of 5–7 and cross-posting. This replaces the earlier
  "around two minutes" default for reels; long-form is unchanged. (A "one signature look: paper cutout" rule from
  the same review was dropped on 2026-09-29; see the next lesson.)

- **Explore looks, no fixed style (2026-09-29).** The creator removed the one-look rule: "I want to explore and do
  different styles of video." Pick the style that fits each idea, or build a new kit, and offer 2–3 style options
  (proven kits plus at least one new direction) with a recommendation at the storyboard check-in. Send 4–8 style
  frames before building every scene of a new look. Keep Devan, the frame-one promise, captions and the end card
  constant so the channel still reads as one series.

- **Pace depends on format.** Ep02's first cut (0.7 s gaps, voice at 1.0×, 2:36) felt slow for Reels. The approved
  reel pace is voice `tempo: 1.1`, 0.4 s gaps (length: 61–75 s since 2026-09-28/10-09). Ep01's opposite complaint ("rushed") came from a robotic
  Kokoro voice plus 0.3 s gaps. Voice quality changes how pace feels.
- **Change speed in the pipeline, never on the finished video.** Speeding up the mp4 warps the music, SFX and
  animation.
- **"Don't rush; cut if needed."** (Said when reels ran ~2 min; the target is now 61–75 s.) Cut words and lines to fit;
  don't compress delivery.
- **Hand over only postable files, in their own folder.** The creator uploaded `out/03-sydney-squeeze-video.mp4`
  (the silent render) as "the master" and the Short played mute. Deliver from `out/NN-slug-final/` and name the
  exact file to post.
- **Social copy must sound human.** A polished description read as AI-written. Write like someone typing on a phone.
- **Ep02 was loved in full:** graphics, script, voice, pacing. Its method is the default; deviate only when the
  brief asks.
- **Show the storyboard before building.** The creator approves the design and storyboard in chat, and a short "go"
  or "continue" counts as approval of the presented plan.
- **Devan stays on-model across styles.** Quiff, shades, teal θ hoodie. In the Vox style he became a halftone
  cutout rather than disappearing.
- **Hook-first story reels (ep04; ~1:45 then, 61–75 s now).** Asked "what's crisp and engaging?", the creator approved moving the
  most counter-intuitive payoff into the first 5 s as an open loop ("a crew that quit after 10 years makes an even
  bigger one"), cutting the weakest scene, and keeping numbers on screen from the start ("no jargon" ≠ no numbers).
  Also: a year counter that runs through the story, a new beat every 3–4 s, and a last shot that matches the first.
- **One idea, one picture (ep04 → ep06).** A viewer found ep04 hard to follow: too many metaphors and sub-stories (crew,
  scoops, scale, cutaway, two-crew race, a real person, a quote). The re-tell kept one comparison (two jars) and a lesson
  arc: hook question → the rule → watch it happen → name it → why it matters → honest caveat → one-line recap. Before
  scripting, write the video's single sentence ("the earnings earn too"); cut anything that isn't that sentence.
- **Orient in the first 2 s (ep04 review).** A cold viewer didn't learn what the video was until the title at ~11 s, and
  a "YEAR 30" counter showed before years meant anything. Fix: burn the title + a one-line promise ("$100 a month →
  ~$120,000 in 30 years") over the moving opening frame (not a static card that delays the motion), bring counters in
  only once they mean something, and take the cover from that titled first second.
- **End on the CTA; don't stack a tease after it (ep07).** Ep04's review asked for a next-concept tease instead of
  "follow for more", but in ep07 a "Next up: …" line after "Save this for the day you hit $100K" dragged the ending. One
  closing ask only: the save CTA (or the tease, if there's no CTA), then a ≤ 2.5 s end card with the disclaimer.
- **No jump cuts (ep07 review).** "The transition is not right, it just jumps over and feels like a cut" (tree → storm).
  Seven seams had jumps: a title popping off, tags vanishing, a flash-to-white, Devan teleporting between poses, a sunny
  sky swapping for a storm. Fix pattern: start each scene from the last frame, fade labels out, run ambient motion on
  global time, move the camera instead of cutting, and check boundary frame pairs (`seams.py`) before rendering.
- **Music should score the story, not loop (ep07).** The creator asked for a better score than a looping plucked-guitar
  arpeggio with light drums. The film score (`music.style: "film"`, `tools/score-film.mjs`) sets chords, energy and
  piano pattern per section, swells into the story's turning points and resolves on the last line.
- **The creator speaks through speech-to-text.** Expect filler ("uh") and mangled terms ("walk style" = "Vox
  style"). Resolve them from context and the reference link, and state your interpretation.

- **Autonomous builds still get a review panel (ep07).** Asked to "research, get an opinion from another set of agents,
  converge, then build without input", the method that worked: 2 research agents (numbers; craft/metaphor) → draft →
  3 parallel reviewers (adversarial fact-check, retention editor, story/clarity + cold-viewer role-play) → v2 →
  one convergence reviewer (LOCK / LOCK-WITH-EDITS, re-verifies new numbers) → build. The creator's locked lines
  were changed only where the numbers made them false, and each change is reported.
- **A metaphor must map honestly, scene by scene (ep07).** "For seven years nothing grows" was false ($393 of growth in
  year 1), and "the math flips at $100K" was really year ~10 / $173K. State the mapping once (water = money in, roots =
  what you put in, tree = market growth) and check every visual against it: a label on the wrong part, a prop set down
  (implies you stopped investing) or a shoot that vanishes can all say something false.

- **"Make it in this format / these colours" means the reference's look AND animation (ep08, 2026-09-28).** A
  paper-cutout build re-lit in the reference's golden palette got "looks very similar to the past videos… I want
  different graphics and animation styles… bold new ideas." Twice. When a reference is attached, build its rendering
  style, camera language and signature device (here: CG-toy lighting, a prompt box that rewrites the world, fast
  world-hops, a keyboard takeover, a pull-back reveal), not the house look with a new palette. Send 4–8 style frames
  from the new kit early, before building every scene, so the creator can redirect cheaply.

- **Simple for everyone (ep08).** The creator wants "simple yet beautiful storytelling in a short compact time" that a
  viewer with little financial knowledge understands: one spoken number, a countable picture, plain-word definitions,
  a memorable closing line. See `script-writing.md` → Simple for everyone.
- **A glitch isn't a transition (ep08).** World-hops as hard cuts behind a 0.3 s glitch felt "abrupt and not done
  well". Give every change of world its own 0.6–0.9 s transition in the destination's style (tile flip, mosaic,
  pencil wipe, tape roll, brick build, match-cut zoom), and replace in-world cross-fades with moves (slide, shrink).
  Review transitions as 10 fps strips (±0.45 s) of the rendered video, not only single stills.

## From review (bugs that happened)

- A prop's number didn't match the story state: the shelf tag said 3.9¢/oz on the 32 oz bottle before it shrank
  (3.4¢ → 3.9¢ was right) — ep08. Check every drawn number against the beat it appears in.
- The disk fell to 161 MB during a final render (ep08); clean review stills before rendering.

- Two Devans on screen during a `pan` (ep28): each set drew its own Devan, so the incoming one appeared beside the outgoing one. Keep the incoming set's Devan off-set while the pan runs (`if (lt < tr.dur) return`), then walk him in.
- 36% near-frozen time in a paper reel with static interior sets (ep28): wrap every scene in a slow living camera (zoom ~1.03 ± 0.01, sway ±10 px on global time) plus drifting motes; `frozen-time.sh` fell to 0%.
- A backwards scale (the heavier side must go down).
- A Gulf map drawn freehand read as a river; redraw maps from real coordinates.
- Orphaned caption words ("waterway:", "affordable,").
- Crossfades double-exposed Devan, so the `pan` and `tear` transitions were added.
- Coins crowded the jar beat; clear old props before the next beat.
- A source note appeared before its chart.
- Arm pops where a walk ended and pointing began.
- A stat card hid the chart drop it described.
- A peak label collided with the chart title.
- A red circle struck through the text it highlighted.
- A card's sub-label was wider than its card.
- A typewriter strip was still typing when its scene cut.
- A stamp covered a headline.
- The dominoes were offset by half a card width (center vs edge) and overlapped Devan.
- ~3 s of near-empty frame while the voice talked about something not shown yet.
- Captions read `timeline.json`, not `script.json`: re-run `npm run timeline` after caption edits.
- A zoom-out on a full-frame backdrop exposed blank margins; zoom only the foreground, or use a bigger backdrop.
- A random phase inside a torn-edge function made the sky strips look like icicles (ep04).
- Balance scales must tip fully to the heavier side, like a real one (a 7% difference looked level).
- A white box around every watercolour sprite: `multiply` compositing paints transparent pixels (ep05); restore
  coverage with `destination-in`.
- Decorations on chart bars distort the ratio (a leafy crown on each bar made 6.6× look like 3×, ep05); keep bars plain.
- ~3.5 s of a near-empty chart while the voice read the setup (ep05); start the first bar as the chart appears.
- Gemini returned a 20 s take for "Follow for more." (9 wpm): always run `check_wpm.py`; retake with "Say only these words, then stop."

## Process

- **Measure every take's speaking rate.** Gemini drifts 84–283 wpm. Serious prompts drift slow.
- **Fact-check adversarially, every time.** It found real errors in every episode.
- **Stills before renders.** Every layout bug was caught in stills sheets.
- **Additive engine changes + pixel-hash regression** of every older episode, and byte-identical synth output.
- **Background agents can be cut off by a session restart.** Resume them with the host's agent tools when available.
  Persist research and reviews into the repo spec directory as they land; scratchpads can disappear (ep15).
- **Other sessions may be editing the same repo at the same time** (ep01 was being re-voiced during ep03). Don't touch
  another episode's files, and don't revert changes you didn't make.
- **Always set `EP=`.** npm scripts default to ep01; a bare `npm run tts` re-voices it.
- **Briefs can carry false premises** ("record balances" was just below the record). Check them and say so.
- **Check disk before rendering.** The machine hit 410 MB free once. In ep04 swap from other apps ate 7 GB in 20 min
  (1.4 GB left): re-render only the changed frame ranges (`--from/--to --out`, 3 workers), prove the untouched middle
  is identical by re-hashing `--check` probe frames, then splice with ffmpeg `trim` + `concat` (the length may change). For a changed ending, use the frame-count tail
  patch in `pipeline.md`.
- **zsh doesn't word-split `$var`**: `for r in "0 540 p1"; do set -- $r` passes one argument. Write the calls out.
- **Commit only when asked.** Episode work has been left uncommitted on a feature branch until the user asks.
- **Scheduled data releases** (central bank, CPI) can outdate a spoken number days after publishing. Give the user
  the exact date and offer a quick re-voice plus patch render.
- **Run synth regressions on scratch copies, compared per file.** Re-running `synth.mjs` in an older episode's folder
  overwrites its audio and adds new SFX files there (ep07). Copy `script.json` + `timeline.json` to the scratchpad, run
  the old and new synth there, and `cmp` each file; an aggregate hash over `sfx/*.wav` mismatches when the file list differs.
- **The disk-cleanup sweep deletes `~/Library/Caches/ms-playwright`.** If stills fail with "download new browsers", run
  `npx playwright install chromium` (~100 MB).
- **zsh: pass a list of still times as `${=T}`**, or the whole list arrives as one argument (NaN time).

- **Compounding math (ep09).** Annual return r → monthly i = (1+r)^(1/12) − 1 (r/12 overstates: $262K vs $247K for
  $100/mo × 40 yrs at 7%). A real return means today's dollars only if deposits rise with prices. Match cadence words
  to the math ("every month", not "every payday": most US workers are paid biweekly).
- **Tempo 1.1 even for soft, tender reads (ep09).** A 1.0 "short film" read felt slow to the creator; 1.1 fixed it
  (71.5 → 66.5 s). Don't go above 1.1: the voice starts to sound rushed and processed.
- **Bold but true hooks (ep10).** Push the hook as far as the facts allow, then stop: "(almost) never taxes", not
  "never touches"; "tax-free, three times", not "the only". Check what an average includes before quoting it.
- **Alternates vs the original (ep10).** When asked for bolder colours, render 2–3 palettes beside the original and
  give an honest comparison; the creator may (and did) keep the calmer original.
- **Topic word on frame one (ep10).** Put the subject itself in the opening title ("HSA: …", bold/highlighted), not only
  the benefit. Keep bold claims true with a small on-screen footnote rather than a hedge word in the headline.
- **Music level (ep10).** The film score overpowered the voice at the old fixed gain. `script.mix.musicGain` (default
  0.9) — use ~0.55–0.65 for talk-heavy reels.

- **Measure voice after tempo as well as before it (ep11).** A raw take below 200 wpm can exceed 200 after the required 1.1 tempo. Check both raw and final WAV durations; retake individual lines with a concrete breath/phrase direction until both pass. Do not raise tempo or change the approved words to hide a pacing problem.
- **Check reveal motion at quarter intervals (ep11).** An offscreen pencil edge already has lead-in distance. Adding an ease-in/ease-out on top left the first and last quarter of a 0.8 s wipe apparently frozen. Linear travel gave visible progression at every sample. Review 0%,25%,50%,75%,100%, then the actual seam pair.
- **A majority claim needs the right population (ep11).** “Most workers miss the full match” was unsupported. Separate eligible nonparticipants, participants below the cap, and plan sponsors; do not turn a dated subgroup statistic into a current universal headline. Label a sample match formula as an illustration.

- **Give each short one visual hierarchy (ep11 creator revision).** Separate the topic/promise, the hero illustration, and captions. Review at phone size. Remove repeated fine print and unrelated unspoken math; keep necessary conditions in the claim or the spoken explanation. Use the lower frame for a larger hero and a clean caption band, vary compositions, and animate the consequence being narrated (missed match, unvested money leaving). Request an independent encoded-video review before calling the revision finished.

- **Recover interrupted frame ranges before rerendering (ep11 v2).** A disk-guard stop can leave finalized, decodable worker MP4s. Verify each segment with ffprobe and a full decode, preserve source hashes and known starting indices, render only missing half-open frame ranges, concatenate in original order, and include recovery joins in cutcheck. Keep the same free-space floor and reduce workers; never guess which frames survived.

- **A callback must earn its runtime (ep11 ending correction).** The creator removed the repeated “my paycheck is not the whole story / the match is part of the pay” recap. When the picture has already made the point, finish the useful explanation, keep one brief visual CTA, and go straight to the end card. Do not repeat the opening merely to close a loop.

## From episode 12 (clay look, unclaimed property)

- **Story-first looks win (2026-10-01).** Shown 12 reference clips from a muse.ai board, the creator rejected the abstract type/data
  ones as "not interesting to tell a story" and picked a clay sitcom clip. Offer a character-led option; keep the narrator on screen.
- **Trace headline numbers to the primary publisher.** "$70 billion unclaimed" was a 2023 press estimate NAUPA does not publish;
  the fact-check replaced it with "billions", "roughly 1 in 7 Americans" and the typical claim (~$100). Put only verified figures in the
  frame-one title.
- **Third-party boards mislabel references** (every clip was a 6 s preview of a longer original, the first did not match its
  description): sample frames before accepting a board's claims.
- **Cached layers must be frame-independent** (boil frozen at step 0) or `render --check` mismatches by build order.
- **Match-dissolve anchors must be the identity at both ends** or the transition's first/last frame jumps (`cutcheck.sh` catches it).
- **Measure pace in syllables as well as words; join list items with commas** so TTS does not drag.
- **Batch fixes into one patch render and prove the splice** (≈2/255 vs a fresh still).
- **Flat vector looks need world-level motion** (ep13 measured 60% near-frozen with only character animation): slow living camera
  (envelope 0 where a match transition expects the base camera), rolling wave on repeated sprites, shine sweeps, slow end-card push.
  Patch-render four 5-s sample windows and run `frozen-time.sh` before a full render.
- **Keep world bottoms clear of the caption band (y ≈ 1290–1410)** and keep pop-ups out of labels; show no price the voice doesn't say
  ("-$$$", not "-$").
- **Background waits use a done-file** (`touch` at the end), not `pgrep` or a guessed output name.
- **Key hero beats to measured word times** (`ofs(line, s)` from an RMS envelope of the take), not `atW` (character-proportional, 0.4–0.9 s off
  in long lines); check a critic's timing claim against the audio before acting. The caption chunker splits after "U.S." (write "US").
- **Check swap, not just free disk, before a heavy render** (`sysctl vm.swapusage`); ep14's 4-worker render filled the disk through swap. Use
  `--workers 2` and a free-space watchdog; clear regenerable caches first.
- **Source notes: claim large, source small, ≤ 3 lines**, shown 3–4 s; the end card holds the full sources and a balance line.

## From episode 15 (rooftop summer, credit score)

- **Persist research and reviews in the repo spec as they land**; the session scratchpad was wiped mid-session (ep15).
- **A push into a prop is one camera** (the close-up = the wide set zoomed about the prop), not a dissolve between two sets; pad backdrops past the edges.
- **Shares need straight sides**: area-true bands on a dome still misread by width; use a straight-sided layered glass/bar (height = share).
- **Short Gemini lines drift fast**: add "about 150 words per minute" + an ellipsis pause in `say`; re-measure.
- **Turns need frames** (0.26 s squash-flip, not a one-frame pose swap); **hold a payoff picture ≥ 1 s**; keep the hook's joke prop above the captions.
- **A cold script editor helps**, but drop callbacks that repeat the hook (ep11 rule) and re-fact-check every reworded line before voicing.

## From episode 16 (era walk, NVIDIA long-form)

- **"Review this script" before a script exists:** write the full v1 from the approved outline, give it to a cold
  editor agent, then merge with judgement (keep human beats and definitions the editor trims; take its structure,
  tension and open-loop fixes) and report what was and wasn't taken. Re-fact-check every reworded line.
- **Popular founder stories can be backwards:** "Sega invested $5M after Jensen admitted the chip was wrong" — the IPO
  prospectus shows the $5M in July 1995, before; afterwards Sega paid in full anyway. Use the filing.
- **Fiscal years ≠ calendar years in spoken comparisons** ("FY2020–23" ≈ 2019 through 2022). Say the calendar span.
- **A station-based explainer freezes:** sample four 5-s windows before the full render; a living camera (zoom
  breathing + clamped glide, eased to identity before walks/seams) took 71–96% near-frozen to 0%.
- **Swap can fill the disk mid-render even at 7 GB free:** render long videos in watchdog-guarded segments
  (`render-seg.sh`), and never trust measurements taken while the disk was full (they read as frozen).
- **Don't put the creator's email in request headers** (SEC EDGAR asks for a contact; use a placeholder).

## From the brand launch and ep16's final cut (2026-10-09 → 10-12)

- **The channel is Dollar Devan (@dollardevan, "Money, made simple.")**, after Ink & Income (taken by a same-concept
  channel), Money Made Simple (generic) and others were researched. Read `brand.md`, and import every name, handle
  and tagline from `engine/brand.js`; never hardcode them. Old names in the repo (`channel/watermark.js` "Ink &
  Income") are history.
- **Long-form end cards: 7 s, not 15–20 s.** The creator called ep16's 18 s card "lingering". Ship a designed
  transition into the brand end screen, which holds ~6 s, enough for YouTube's 5 s end-screen minimum. Sources go in
  the description.
- **The end-screen badge shows Devan's face, sized under the subscribe element.** A dead "SUBSCRIBE" word does
  nothing where the buttons don't render. A Devan bigger than the element leaves doubled hair and ears around it.
- **Avatar without "$".** At 36–64 px it turned into a green blob beside the hair, and the name already says money.
- **Thumbnails:** no channel name or handle (YouTube shows both), and Devan must be on-model. ep16's tower
  thumbnail caught him green mid power-up.
- **Descriptions:** no hard line breaks inside sentences. A draft wrapped at 120 columns would show broken lines on
  YouTube.
- **Shortening a finished video:** if the timeline diff shows only the end moved, re-render from a keyframe and cut the
  head with `-frames:v k -c copy`. A `-t` cut kept 2 frames past the keyframe, and the join would have duplicated
  them.
- **When you replace a span of code, print it first.** Replacing "from an old comment down to a later line" once
  deleted the channel name, tagline and badge ring that sat between them. A full-frame check caught it; a cropped
  check wouldn't have.
- **Cache cleanups can delete Playwright's Chromium** (`~/Library/Caches/ms-playwright`, needed for every render),
  even though the policy keeps it. On "Executable doesn't exist": `npx playwright install chromium`.

## From episode 17 (storybook ink, shipped 2026-10-13)

- **Reference fidelity includes light and set dressing.** A palette/line match still read flat. Use per-shape form
  shadows, shadow-only hatching that follows the form, object-anchored pigment, lit/shaded walls, cast shadows,
  aerial haze and lived-in detail. Get an independent art-director comparison against reference stills before all
  scenes; `styles.md` documents the new `story*.js` kit.
- **Fairness includes the whole scene.** Check casting, accents, props, background people, settings and acting.
  Retain evidence-backed geography and realistic casting from the latest approved design (ep17's later decision
  restores an Indian caller and Noida evening setting). Show wrongdoing through actions and props, without cultural
  clichés or mocking accents; do not turn an earlier shared-palette remedy into a universal ban on naming places.
- **Character voices use a speaker map.** `tts.voices` + line `speaker` selects the cast; a per-line `voice` does
  not. Unknown speaker keys silently use the narrator, so check the map. Narration stays Fenrir; audition the
  approved characters, measure raw/final pacing, and re-measure visual beats after retakes.
- **Parallel chapter builders work with a written brief.** Storyboard + builder brief + shared `common.js` + one file
  per builder, started on a provisional timeline; render finished chapter ranges while others are still building;
  the integrator reviews stills and sends back clipped-word and count-mismatch fixes. Use `stills.mjs --port`.
- **TTS robustness.** Cache persists per take and the tempo step retries (gRPC + ffmpeg SIGTRAP). Pace short or
  closing lines with spoken-only ellipses or by splitting the line; directions alone often fail.
- **Disk during long builds.** Caches regrow within hours; sweep before each render block and drop render segments
  after joining the silent master. Maps of India fade out the contested north.


## From episode 18 production (2026-10-12)

- **ASR uncertainty is not a confirmed spoken mistake.** Keep independent recognition separate from approved-text alignment; tie caches to final WAV hashes and document unresolved differences. Do not call automated verification a listening review.
- **Final SRT comes after mixing.** The mixer overwrites subtitles. Apply episode-local orphan repairs and measured boundaries afterward, preserving every approved word and labeling fallback timings.
- **Low motion needs visual judgment.** Inspect actual decoded frames before treating a detector hit as frozen. A blank worksheet benefits from narrative setup props; keep factual quantities locked to their spoken cues.
- **Patch only the bounded scene.** Use original keyframes around the revised scene, exact frame counts, copied head/tail frame hashes, and a final full decode. Preserve the audio only when the timeline and cues are unchanged.
- **Audio "jumps" (ep17):** loudnorm silently falls back to dynamic mode when true peak + (−16 − I) > TP. It rides
  the gain audibly, swelling music in pauses and dipping on plosives. Gemini stops about half its takes mid-phoneme,
  and the old duck swelled the music 7.7 dB in every short gap. Set `"mix": {"smooth": true}` (on in the templates):
  it adds take micro-fades, a held duck and a look-ahead limiter, and the mixer throws if loudnorm can't stay linear.
  Verify with a flat final/mix gain ratio, not just LUFS and peak (`references/audio.md`).

- **Geometric styling must preserve sparse facial geometry (ep18, 2026-10-13).** Every-third-vertex reduction collapsed a five-point talking mouth to a diagonal stroke, leaving its tongue detached. Preserve small authored polygons and regression-test mouth area/upper-lip anchoring across speech levels. Inspect encoded facial motion in each style, including transitions; static composition reviews missed this defect. A bounded picture patch preserved all untouched frames and original AAC bytes.

### Woodblock reel production (ep20, 2026-10-13)

- Large title swaps need a physical clipped move; crossfading co-located words creates unreadable ghost letters.
- Reuse the exact destination world inside a zooming miniature and its full scene. Match callback start transforms before adding camera motion.
- Static print texture is not motion. Check an encoded low-resolution full-film proxy early, then repeat frozen-time on the final MP4.
- Reject TTS additions using independent transcription, even when pacing looks plausible. Avoid quoting other script lines in global acting prompts. Report spoken-only punctuation changes, and regenerate alignment after every accepted retake.
- Keep word/caption alignment episode-local and hash-bound to final WAVs. Rejoin all caption groups to prove the approved text is intact; export the same timings to SRT after the shared mixer runs.
- Append-only SFX proof uses the current dirty-file snapshot, not HEAD; compare all pre-existing WAVs on scratch episode copies.

- **Motion proxies must preserve the master pixels (ep20).** A 360p MJPEG intermediary falsely reported 2% near-frozen while the encoded master measured 42%. JPEG noise and repeated resizing changed the metric. Use full-resolution lossless PNG transport for the 10 fps proxy, match the final encode, and apply the metric downscale only once. Final encoded-master frozen-time remains the acceptance evidence. Fix camera/world motion, never add noise to satisfy the detector.

### Vox investigation with a cast (ep21, 2026-10-14)

- **"Add characters… investigative… introduce the Devan character" (ep21).** After a straight Vox storyboard, the creator asked for characters and an investigation led by Devan (speech-to-text: "walk style" = Vox style, "the event character" = the Devan character). Make Devan the on-screen investigator (case file, evidence tags, flashlight, evidence-board verdict) and give the explanation to a small illustrative cast with their own Gemini voices; keep the facts and length budget unchanged.
- **Invented witnesses need safeguards.** An "investigation" with made-up people can read as real interviews. Label every card ILLUSTRATIVE CHARACTER, drop interview styling (mic, REC meter, dateline), never let a character claim first-hand experience, put a real quote on its own attributed card (never under an invented face), and name the cast as illustrative on the end card and in the description. A "case closed" stamp over a live safety debate overclaims; stamp the client's question instead ("mystery solved").
- **Anchor beats on unique phrases.** A word that appears twice in a line ("reach both… both sides") made `atW` fire on the first one and snapped the homes in early. Use measured Whisper onsets (episode `align.py` → `onsets.js`) and a phrase that occurs once.

## From episode 22 (tabletop collage, barcode)

- **Topic slate before script (2026-10-15).** Asked to "find an interesting everyday topic" for a reference format, the
  creator picked from a vetted slate (microwave, bottled water, barcode, price tag), then asked for "an experiment script".
  Two fact-checked variants (pure history vs history + money twist) let them choose. Check repeats first: ep18 and ep20 had
  already told the credit-card and pay-later histories.
- **A style-frame art review against reference stills pays off.** v1 read as a "flat vector scrapbook template": no single
  key light, no object thickness, repeated filler props, and text too small for a phone. One top-left key light plus
  shadow-only cast and contact shadows changed the read the most. Then came surfaces that vary by beat (board, cream,
  kraft, sand), halftone photo prints for mixed media, and matte cut-paper type.
- **Halftone kills small text.** Store names screened into a halftone print turned to mud. Keep halftone subjects light and
  put their labels on separate typed notes.
- **A drifting light is not motion.** The first render measured 22% near-frozen with a 2.0 s hold, despite a slow camera push
  and a drifting light pool (the metric barely registers either, which is right). The fix was real motion: a "living"
  document-camera float in the kit camera (kept in sync with `camMap` for carried objects), plus per-beat motion in the
  holds (beam sweeps, a swinging shelf tag, a typing terminal, staggered drops).
- **Swap eats the disk mid-session.** Free space fell from 11 GB to 3 GB before the first render and to 2 GB after it,
  as swap grew to 10.7 GB. Sweep the policy-approved caches first, log them, render with 2 workers and a free-space watchdog.

## From episode 23 (companion reel in the tabletop kit)

- **A sequel's cover must still look new.** Same kit is fine, but change the title card's paper and ink, the hero's scale and
  Devan's side; the art review caught ep23's first cover reading as ep22's.
- **Fold, don't speed up.** Each scene boundary costs lead + tail − gap (≈ 0.7 s). Folding a short hook into the next scene with
  an in-scene page peel, trimming `gapBefore`s and moving a place name from the voice to an on-screen note took 77.5 s to 75.0 s.
- **Re-check reused props.** ep22's checkout carried an unsourced "LANE 3", a "10 STICKS" wrapper beside a "GUM 10PK" receipt
  and a soup can in a real brand's red-over-white. Override with episode-local variants.
- **Check raw take tails.** The mixer's 60 ms fade did not hide takes that stop 28–38 dB under peak; a 160 ms raised-cosine fade
  on the raw take (length unchanged) did.
- **Render in chunks when the disk is tight.** Six 1-worker frame chunks written to separate files survive a watchdog stop and
  make patch re-renders trivial; `~/.cache/codex-runtimes` can regrow 1.5 GB mid-render.

## From episode 24 (city-pop anime, cost per wear)

- **A music-video reference can carry a narrated explainer (2026-10-16).** The creator picked cost per wear for an AI-made
  city-pop anime music video. The fit came from the reference's structure: a day-in-her-life montage became the maths (one skirt
  sweep = one wear, the tag ticks down). Keep the voice out for a few seconds and let a counter fill the caption band.
- **Two art-review rounds before the build.** v1 (GO WITH FIXES, gated) called the first frames flat-vector mobile-game
  art; v2 (ONE MORE PASS) found joint rings, layout overflows and grey dappled light. Set the expectation plainly: procedural
  canvas gets a city-pop poster / fashion-illustration figure, not hand-drawn anime acting.
- **Rim light on a union path draws inner rings.** Stroking every sub-path of a `union` of limbs put a ring at each joint.
  Keep rim light for single paths.
- **Comparisons must keep their unit.** "Fifteen dollars a wear. More than her dress." could be heard as $15 > $100. The
  convergence fact-check changed it to "Her dress? Two." Re-check every line an editor rewords.
- **Floor-level cameras magnify the near floor.** Blur and darken the floor below the caption band (depth of field) instead of
  letting a texture smear across the bottom of the frame.
- **Disk:** the approved cache sweep (uv, codex-runtimes, `~/Library/Caches` minus `ms-playwright`) took 1.9 GB free to 4.8 GB
  before the render; swap had reached 13 GB.

## From the barcode hit (ep22 analytics, 2026-10-17)

- **Everyday object + surprising claim, as title = frame one = first line.** "The Barcode Has No Price in It" took ~60× the
  views per day of the channel's next-best Short at the same slot and length; "Explained"/finance-term titles were the weakest.
  Lead with a thing everyone touches and the twist, let the money lesson arrive inside, end on something to do. Public counts
  only so far; confirm with Studio stayed-to-watch and traffic sources (`docs/youtube-audits/2026-10-17-barcode-learnings/`).
- **Post a hit's companion while it is being distributed**, with the hit as its YouTube related video.

- **Ep25: creator approval outweighs a technical/art pass (2026-10-18).** A deterministic painted Three.js diorama passed independent review, but the creator rejected the pictures: "Less words and more action and style and infographics," then "Make it colorful too." Replace the composition and rendering language, not just its palette. Use large flat vector character actions, actual hand/prop contact, countable mechanisms and distinct bright scene palettes. Retain required factual conditions but avoid duplicating the narration in plaques. Only the later colorful T4 candidate received "Proceed."

- **Ep25 motion verification (2026-10-18): measure the whole film early.** A good still-frame pass hid 37% near-frozen time. Purposeful paycheck/check delivery, hands reaching and operating controls, record inspection and typing reduced the final encoded film to 10%, with no ordinary hold over 0.6s. Use slow feature pushes to support those actions, not to substitute for them. Read measured onset data through a static import so browser rendering and Node audio-cue generation use the same timing.

- **Ep26: check vendor defaults before locking a hook (2026-10-18).** The brief's "20% isn't 20%" (tip on price + tax) proved a 15¢ merchant setting; Square's documented $1/$2/$3 small-order buttons gave a countable true hook (on a $4 coffee the middle button is 50%). Report a moved premise at the check-in.

- **Ep27 workshop teardown (2026-10-19): match the reference's density, not just its palette.** The first stills had the right worlds (bench, lamp, navy dive) but read as clip-art: small heroes in empty navy, flat fills. The art review fixed it with frame-filling heroes cropped by the frame, a dim mechanism behind and a blurred one in front, engraved metal on every metal part, real gear meshing, and a cover that shows the promise as a picture (3 different code slips). Get the independent art review on real style frames before building every scene.

- **Ep27 tooling traps (2026-10-19).** In zsh, `for b in "1 2 3"; do cmd $b` passes ONE argument (no word splitting): the stills tool then rendered t = NaN and failed in `createPattern`. Use `${=b}` or one call with all times. Fixing real nondeterminism: canvas `setLineDash` guides broke frame-0 `render --check` (≤ 8/255 on ~200 px); drawing dashes as segments fixed it. Locate a determinism diff by rendering the frame fresh vs after another frame and mapping the changed pixels.

- **Ep27 iris pop (2026-10-19).** An iris portal eased with a cubic in/out grew from a small circle to full frame in about 3 frames, and `cutcheck` flagged it as a hard cut. Use geometric growth (constant zoom per frame) driven by linear progress, then patch-render only the transition frames.

- **Never-resting camera in calm kits (ep33, 2026-10-24).** The Vox kit's `camera()` eases in and out over each scene, so it
  parks at both ends: ep33's first render measured 26% near-frozen with 1.3–1.7 s holds at scene edges and reading beats
  (bar: ≤ ~15%, no hold > 0.7 s). Fix: an episode camera with a linear 5–6% push, a linear drift and a slow ±0.3° sway
  (`episodes/33-gift-card-drain/scenes.js` → `cam`), and re-aim any zoom transition at the shifted end-frame position.
  Run `frozen-time.sh out/NN-slug.mp4` (it takes the video path, not the slug) on the first render.
- **Critic before the second render (ep33).** A fresh critic on the first render's sheets caught type too small at 360 px
  (tags and labels at 28–30 px), Devan absent for ~60 s, a static hook board and the title strip touching the handle
  chip. Batch every fix into one re-render. Minimum ~36–40 px for words the viewer must read; keep a small Devan on
  screen in the middle scenes.
- **Tooling (2026-10-24).** zsh doesn't word-split `$T`: pass a built list of stills times as `${=T}` (otherwise every
  time becomes NaN and the page throws in `finish`). `align.py` needs Whisper: run it with Homebrew's
  `/opt/homebrew/Cellar/openai-whisper/*/libexec/bin/python` (the system and pyenv Pythons don't have it).
- **Honest glass sizes (ep34).** For bracket glasses, make heights proportional to bracket widths (12,400 · 38,000 ·
  55,300) and carry the small raise as countable unit cubes ($100 each); a $600 sliver of water in a $55,300 glass is
  invisible, so the cubes are the countable picture.

- **Second critic round catches what the first fix missed (ep34, 2026-10-26).** Round 1 caught a picture/narration
  mismatch: four "$400" cubes drawn above the $50,400 line said the money spilled. Fix: the cubes melt into the 12% glass,
  which rises exactly to the line. Round 2 caught cubes flying across labels and 26 px must-read notes; labels now step
  aside while the cubes fly, and notes are at least 32 px. Re-score after every fix round, not just the first.
- **Playwright's browser can vanish (2026-10-26).** A disk cleanup removed `~/Library/Caches/ms-playwright`; renders
  then fail at `browserType.launch`. Fix: `npx playwright install chromium`.
- **Cached layers must not capture per-frame state (ep35, 2026-10-28).** A `TY.layer` holding clay shapes baked in the
  clay boil step of whichever frame built it first, so one frame differed by seek order. `render --check` passed; only an
  opposite-order stills probe caught it. Cache clay with `CL.layer`, and always probe filter/clay frames in two orders.
- **A world-hop reel re-renders the character, not just the palette (ep35).** Three critic rounds scored tint-only worlds
  low; switching Devan's rig per world (clay / paper / ink / watercolour pass) was the single biggest lift.
- **Charts must report one year-end (ep36, 2026-10-28).** A smoothly moving dot drifted from its yearly labels, meter and date stamp: the critic saw "16B" on the dot beside a "14.2B" label. Draw the line smoothly, but pin the dot and every printed number to the last year-end reached. Place labels where the line isn't yet, ahead of the dot, or behind it when a year is wide.
- **Charts and props freeze once drawn (ep36).** The first render was 29% near-frozen, with a 3.1 s hold, after every element finished animating. A per-shot linear ~6% push (anchored high so top slams don't hit the meter) fixed it: 3%, longest hold 0.5 s. Run `frozen-time.sh` on the first render, not just at sign-off.

## From episodes 47–48 (knit world, wood joinery; 2026-11-06)

- **Name the cause→effect device before building a "material world".** The knit reel had the reference's look but not its idea (critic: 30%) until knitting needles, fed by a strand from a shrinking yarn ball, worked each row and cloth knitted row by row. The hook went from 3 to 7.
- **Gemini can invent whole sentences.** Two takes came back about 27 s long with invented commentary. `check_wpm.py` showed about 15 wpm and Whisper showed the added text. Retake with "Say only these exact words, then stop. Add nothing."
- **Check closing lines against earlier claims.** "The ships didn't last" contradicted "still floats", said 40 s earlier, so it became "The shipbuilding didn't last."
- **Metaphor honesty for company histories.** A thread is the family, with a knot at each handover. A bought business is a sewn-on patch. Debt is weight (wedges bow a beam), never a support being pulled. Ownership is keys handed over. Show only what each company built, and keep its sign on its own workshop.
- **Phone-size shape check.** At 360 px, critics read waist stubs and a domed head with a rolled band as rude shapes. Look for them in close-ups.
