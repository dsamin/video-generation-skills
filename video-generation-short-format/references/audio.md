# Music, SFX and the mix

All audio is generated or placed by code: an original, royalty-free score from `tools/synth.mjs`, SFX from the
same file, and voice plus SFX placement and mastering in `tools/mix.mjs`.

## The score (`script.json` → `"music"`)

```jsonc
"music": {
  "bpm": 84,                         // ep01 80 (lo-fi), ep02 96 (playful), ep03 84 (documentary)
  "drumsIn": "fall",                 // a scene id (its start) or "line:<id>" (that line's start)
  "drumsOut": "line:v3",             // drums stop here (the sign-off breathes)
  "darkFrom": "board", "darkTo": "verdict",   // minor "dark" chords + lower pad for the serious stretch
  "lead": "piano",                   // "rhodes" (ep01 default) | "marimba" (ep02) | "piano" (ep03) | "musicbox" (ep04)
  "bassIn": "line:s2",               // optional: bass enters here on its own, before the drums (a score that builds);
                                     // with "musicbox" the arp also plays quarter notes until bassIn, eighths after
  "drums": "pulse",                  // "lofi" (ep01) | "light" (ep02: kick/snare/shaker) | "pulse" (ep03: heartbeat + clock tick)
  "bright": [[33,[45,48,52,57]], [29,[45,48,53,57]], [36,[48,52,55,60]], [31,[47,50,55,59]]],  // [bass MIDI, chord tones] per bar
  "dark":   [[38,[50,53,57,62]], [33,[45,48,52,57]], [40,[44,47,52,56]], [29,[45,48,53,57]]],
  "resolve": [33,[45,48,52,57,64]]   // the end-card chord
}
```

**Set every marker** (`drumsIn`, `drumsOut`, `darkFrom`, `darkTo`) to scene ids or `line:<id>` values that exist in
this episode. The synth's built-in defaults name ep01's scenes (`shares`, `decay`, `outcomes`), so a new episode that
leaves one out fails with `music: no scene shares`. Both templates ship a complete block.

Mood presets:
- **Playful explainer:** 96 bpm, marimba, light drums; bright = C–G–Am–F (I–V–vi–IV); dark = Am–F–G–Em.
- **Documentary / investigative:** 84 bpm, piano, pulse; bright = Am–F–C–G (i–VI–III–VII); dark = Dm–Am–E–F.
- **Lo-fi long-form:** 80 bpm, rhodes, lofi; bright = Fmaj7–Em7–Dm7–Cmaj7; dark = Am7–Fmaj7.
- **Story / fable ("the score compounds"):** 92 bpm, musicbox, light drums; sparse music box alone → `bassIn` at the turn
  → drums later → minor under the setback → drumsOut at the reveal. SFX added for it: `crunch` (snow impact),
  `rewind` (tape rewind), `plop` (snow landing).
- **Film score (ep07, `"style": "film"`):** a sectioned cinematic bed from `tools/score-film.mjs` instead of the looping
  layers. `music.sections` = [{ at: marker, chords: [[bass, tones]…], energy, energyTo?, piano: intro|sparse|flow|hold,
  strings?, bass?, bells?, pulse?, trem?, ring? }] — each section runs to the next marker, its bar grid restarts there
  (rubato), and energy drives string brightness/level, piano velocity and the high octave. `music.hits` = [{ at, off?,
  swell: seconds, boom }] land a riser + soft timpani on story beats. Markers accept `line:<id>@fraction` so a hit can
  land on a word. Felt piano + warm strings + light sub (85 Hz high-pass) + celesta, hall reverb, no drums or crackle.
  Keep the old `drumsIn/…` markers present (the legacy layers still run before the film bed replaces them).
- **Chalkboard lesson:** 84 bpm, rhodes, lofi, bright C–G–Am–F. SFX `chalk` (scratchy taps) on each write-on and
  `erase` (felt rub) on each wipe.

The synth also layers a detuned pad, a bass on beat pairs, an arpeggio with ping-pong delay, vinyl crackle, and a
small Schroeder reverb. Music is normalized to −10 dBFS peak before the mix. **Re-run `npm run synth` whenever the
timeline changes**; `mix.mjs` refuses stale music.

## SFX library (`audio/sfx/*.wav`)

`pop whoosh coin tick thud thunder bonk rustle splash snip ding type stamp pin tear string`

What each one is for:
- **Every scene change:** `rustle`, or `tear` with a tear transition; ep01 used `whoosh`.
- **Paper pieces springing in:** a soft `rustle` or `pop`.
- **Titles and tags:** `pop`. Stat cards landing: `thud`. Counter running: a `tick` run (8–14 ticks), then `ding`.
- **Typewriter strips:** a `type` burst (one per character at ~26/s, gain ~0.3).
- **Stamps:** `stamp`. Pins: `pin`. Strings drawing: `string`.
- **Scissors:** `snip`. Money: `coin`. Liquids: `splash`. Storms: `thunder`, used sparingly.

`cues(timeline)` in scenes.js returns `[{t, name, gain}]` in global seconds. The mixer applies `0.22 × gain`, so
~0.3–0.9 is the useful range.

To add an SFX: append a new `sfx('name', seconds, x => …)` line **after** the existing ones. They share one seeded
noise stream, so inserting earlier would change the older sounds. Then prove old episodes' wavs are byte-identical.

## The mix (`npm run mix`)

Music level: `script.mix.musicGain` (default 0.9). The creator found 0.9 overpowering on ep10; 0.56 (≈ −4 dB) was right.

**`"mix": {"smooth": true}` (ep17+, on in both templates).** Fixes the "little jumps" the creator heard on ep17:
- 5 ms fade-in / 60 ms fade-out on every take, length-preserving (timeline and picture stay valid). Gemini stops
  about half its takes mid-phoneme ("evenin–"), which chops at the line end.
- The music stays ducked through pauses under 1 s. The dip starts 0.3 s ahead and releases only after the voice
  stops; the old duck swelled the bed ~7.7 dB in every 0.45 s gap, then dropped it as the next line began.
- A look-ahead peak limiter (5 ms look-ahead, 80 ms release) sets peaks 1 dB under TP after loudnorm's gain, so
  loudnorm is always linear. It throws if not. ep17 needed less than 1 dB on 96% of loud 10 ms windows and at
  most 4.7 dB.
Off (older episodes): the mix is byte-identical to before (proven on ep17's mix.wav).

1. Places each voice line at its timeline start, leveled to the **median line loudness**.
2. Ducks the music to ~0.32 under the voice.
3. Places SFX cues.
4. Two-pass `loudnorm=I=-16:TP=-1.5:LRA=11`, then AAC 192 kbps at 48 kHz, muxed with `-c:v copy` and `+faststart`.
   **loudnorm only stays linear if true peak + (−16 − measured I) ≤ TP.** A voice-led mix with spiky takes (ep17:
   18 dB peak-to-loudness) silently falls back to *dynamic* mode, which rides the gain (+1.6…+9.6 dB on ep17): music
   swells in pauses and dips on every plosive, heard as small "jumps". The mixer now warns when that happens.
5. Writes `NN-slug.srt` (same chunking and timing as the burned captions) and `NN-slug-thumbnail.png` (a frame 0.3 s
   after the first line).

**Targets** (`sh tools/verify.sh NN-slug`):
- −16 LUFS integrated
- true peak ≤ −1 dBFS
- audio length equal to video length within ~0.07 s of AAC padding

## Checking audio without ears

The creator listens; you can't. Before reporting, still check:
- `ffmpeg -i audio/music.wav -lavfi showspectrumpic=s=1200x400:scale=log:fscale=log spec.png` shows sections as
  visible texture changes: drums in and out, the dark stretch, the resolve.
- `ebur128` loudness on music and on the final mix.
- The speaking rate per line (`check_wpm.py`).
- No gain riding: decode the final's audio and the `-mix.wav` and compare 50 ms RMS. The ratio should be flat
  (ep17 after the fix: +5.3 dB ± 0.3). If it wanders, loudnorm went dynamic.
- Take edges: the last 10 ms of a take within ~20 dB of its speech level is a chopped ending (39/79 on ep17).

Say plainly in the report that music and SFX were **not verified by ear**.
