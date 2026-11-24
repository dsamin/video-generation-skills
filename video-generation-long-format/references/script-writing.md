# Writing the script (`episodes/NN-slug/script.json`)

The script is the spine of the episode. The voice is recorded from it, the timeline is built from it, and every
visual beat keys off its line ids.

## Schema

```jsonc
{
  "title": "The Sydney Squeeze — why Sydney housing is sliding",
  "size": [1080, 1920],              // 9:16 reel; [1920,1080] for YouTube long-form (the default if omitted)
  "fps": 30,
  "watermark": true,                // permanent @DollarDevan attribution; required for new publications
  "captionChars": 70,                // max chars per caption chunk (reels 70; ep01 16:9 used the default 58)
  "tts": {
    "engine": "gemini", "voice": "Fenrir", "model": "gemini-2.5-pro-tts", "language": "en-US",
    "prompt": "<style prompt, see voice-google-tts.md>",
    "tempo": 1.1                     // pitch-preserved speed-up applied to raw takes
  },
  "scenes": ["hook", "fall", "price", …],   // order = playback order; "endcard" is appended automatically
  "timing": {
    "gap": 0.4, "lead": 0.6, "tail": 0.5,   // seconds between lines / before first line / after last line of a scene
    "sceneLead": { "hook": 0.9 }, "sceneTail": { "verdict": 1.2 },
    "endCard": 2.5                          // reels; long-form uses 7 (the brand end screen)
  },
  "music": { … see audio.md … },
  "lines": [
    { "id": "h1", "scene": "hook",
      "say": "In nineteen eighty-eight, someone bought this Sydney apartment for a hundred and eighteen thousand dollars.",
      "caption": "In 1988, someone bought this Sydney apartment for $118,000." },
    { "id": "h2", "scene": "hook", "gapBefore": 0.2,
      "say": "This September, it sold for one point oh seven million.",
      "caption": "This September, it sold for $1.07 million.",
      "direction": "Let the number land, then move on. Natural conversational pace, keep it moving, no long pauses." }
  ]
}
```

## Line rules

- **`say` spells numbers out; `caption` uses digits.** TTS reads words reliably ("four point three five percent",
  "one point oh seven million", "twenty twenty-two"). Viewers scan digits faster. The Vox captions color digit
  tokens red.
- **Acronyms and symbols are spelled the way they're spoken:** "A P R" or "annual percentage rate", "the
  Reserve Bank" rather than "the RBA" on first mention, "S and P five hundred", "per cent" as "percent". Keep
  the symbol form in `caption`.
- **One idea per line**, narrated by Devan ("I dug into the numbers") or spoken by the identified story character. Keep lines short: 6–25 words,
  and split anything longer.
- **Ids** are short scene-letter + number in reels (`h1`, `f2`, `b4`). In long-form use `c<chapter>-<nn>`
  (`c0-01` cold open … `c9-02` outro) so ids stay unique across 25+ scenes. Scenes reference them, so renaming an id means
  updating `scenes.js`.
- **`gapBefore`** (0.15–0.5 s) gives a beat before a punchline or a key number.
- **`direction`** is appended to the TTS prompt for that line only. Use it for delivery beats ("Let the number
  land") and for pacing fixes (see `voice-google-tts.md`). Changing it re-records that line.
- **Character dialogue:** add `tts.voices` keyed by speaker name and `"speaker": "WALT"` (for example) to the
  line. Unlabelled lines use the narrator; a misspelled speaker also falls back to it. Validate names against the
  map. Voice, prompt and optional language are character settings, not line-level `voice` overrides. See
  `voice-google-tts.md` → Character voices for the exact schema, inheritance, auditions and caching.
- **Captions** are chunked at sentence ends, then commas, then words, within `captionChars`. A chunk of ≤ 2 words
  ("affordable,") reads badly. Run `scripts/check_captions.mjs` and fix it by rewording the caption (it may paraphrase
  the speech slightly) or by adding a comma. Don't change the shared chunker.
- **Words that aren't the key content:** every number on screen must also be defensible from the fact-check.

## Structures that worked

**Default for reels — one-idea lesson arc (ep06, "How money makes money"; reels now run 61–75 s):**
`hook with the promise on frame 1 → the rule (the one difference) → watch it happen (one worked example) → name it →
why it matters (one surprising consequence) → one honest caveat → recap → one closing ask`
Five to seven beats, one comparison or picture, ~140–170 words. The longer arcs below come from the older ~2-minute
reels: use their shapes for long-form chapters, or trim them to ≤ 90 s for the rare reel that earns it.

Explainer arc (ep02, "How Inflation Works", 26 lines, ~300 words → 2:12 at tempo 1.1):
`hook → what it is → cause → mechanism → ripple/effects → the numbers → long run → why it matters → recap loop → end card`

Investigative / documentary arc (ep03, "The Sydney Squeeze", 22 lines, ~290 words → 2:16):
`cold open on one concrete example (bought $X in YEAR, sold $Y) → the turn ("but the market is sliding") → title →
the evidence, one pressure per scene (price vs income, debt, rates, stress, jobs + AI) → the evidence board (pin
everything together) → what could happen (a risk, with forecasts) → what's holding it up → verdict + one thing to
watch → sign-off`

Long-form tutorial arc (ep01, "Get Paid to Wait", 16:9, 19 lines, ~243 words):
`intro hook → concept 1 → concept 2 → mechanism → outcomes → the full system (wheel) → outro recap → end card`.
For longer videos, see the long-format skill's chapter structure.

Hook rules:
- Open on something concrete and personal within 2 s: a price, a pump display, a real sale.
- Reels: title + promise are visible on frame one while the hook plays. Long-form: a cold open may lead into the
  title and promise within the first 10 s; never add a logo intro ahead of the hook.
- End on a loop back to the hook or on one thing to watch.

## Word budget

The effective rate, including gaps and scene leads/tails at tempo 1.1 with 0.4 s gaps, is about 130 words per
minute of finished video:
- ~140–170 words → 61–75 s (the reel target; ≥ 61 s for TikTok's Creator Rewards)
- ~205 words → ~90 s (the reel ceiling)
- ~250 words → ~1:50, ~290 words → ~2:15 (long-form pacing; too long for a reel)
Measured on ep04/ep06: ~145 words per spoken minute at tempo 1.1 with 0.4 s gaps, plus the 2.5 s end card.

Serious "documentary" delivery runs slower, so budget 10–15% fewer words. At tempo 1.0 with 0.55 s gaps
(long-form), expect ~115–120 wpm overall.

Budgets count **spoken** time: leave the end card out (reels 2.5 s; long-form 7 s, the brand end screen). Raw takes
run ~140–160 wpm; gaps, scene leads and tails bring the finished-video rate down to the figures above.

Write to the budget and then measure. If the timeline runs long, **cut lines or words; never speed up the video**.
Cut the weakest supporting clause first, never the hook, a sourced number, or the balance line.

## Sign-off

Reels end on ONE closing ask: a save CTA ("Save this for the day you hit a hundred K.") or a next-concept tease — not
both (ep07: a tease after the CTA dragged). Older reels ended with a sign-off like `"Follow for more. Money, made simple."` (ep02 used "Now you know. Follow for more
money, made simple.") (direction: "Warm, easy sign-off."). Today the end card comes from the template and
`engine/brand.js`: `BRAND.tagline`, Devan waving, `BRAND.handle`, "Educational only. Not financial advice.", sources
(see `brand.md`; never hand-type the tagline or handle).

## Simple for everyone (ep08)

Asked for "simple yet beautiful storytelling… so even a regular audience with little financial knowledge
understands", the v4 rewrite that the creator approved:
- **One spoken number.** Nine numbers became one (~14%); keep real sizes/dates as small on-screen tags.
- **A picture instead of a percentage:** a countable comparison (8 new bottles hold the drink of 7; 1 brick = 4 oz, so
  8 × 7 bricks = 7 × 8 bricks). Check the arithmetic (8 × 28 = 7 × 32).
- **Define the word in plain language** the first time ("Shrink, plus inflation. Prices go up, but it's hidden in the
  size.").
- **Show the "why" as a gag, cite it on the end card** (raise the price → shoppers leave → undo → shrink → they stay).
- **A rhyme or twist as the payoff** people repeat ("On the tag, or in the bag.") — and make sure it is still true.
- **Plain action words:** "price per ounce… it shows what you really pay", not "unit price".
