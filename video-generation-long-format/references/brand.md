# Channel brand: Dollar Devan

The channel is **Dollar Devan**, **@dollardevan** on YouTube, TikTok and Instagram, tagline **"Money, made simple."**
(chosen 2026-10-09 after name and handle research in the repo's `docs/branding/`). Devan, the mascot, is the host.
The YouTube channel name is "Dollar Devan", the same as the handle. Only Instagram's searchable name field adds a
keyword: "Dollar Devan | Money Explained".

## One source of truth: `engine/brand.js`

`BRAND` holds `name`, `handle`, `tagline`, `site`, `colors` and `fonts`. `COPY` holds every profile field, the video
footer and the topic hashtags, each checked against its platform limit. Never type the name, handle or tagline into
an episode, tool or document by hand. Import them instead:

```js
import { BRAND } from '../../engine/brand.js';        // in episodes/NN-slug/scenes.js
E.text(ctx, BRAND.handle, 540, 1252, { size: 48 });    // the reel template's end card already does this
```

A rename is one edit in `engine/brand.js`, followed by `node tools/launch-kit.mjs --hq`.

## Inside every video

| | Reels / Shorts / TikTok | Long-form YouTube (16:9) |
|---|---|---|
| End card | ≤ 2.5 s: tagline, Devan waving, `BRAND.handle`, disclaimer, sources (`episodes/_template`) | **7 s** (`timing.endCard: 7`): the brand end screen `channel/brand/end-screen-1080p.png`, preloaded in `setup()` and entered with a designed transition (ep16: a comic tear) |
| What the end card holds | one closing ask comes *before* it (spoken, or on screen as in ep09) | name, tagline, handle, Devan's face in the subscribe badge, two WATCH NEXT panels, and "Educational only, not financial advice · Sources in the description" |
| Embedded attribution | `@DollarDevan` throughout every new video, drawn by the shared player; reserve the upper-left safe area | `@DollarDevan` throughout every new video, drawn by the shared player; reserve the upper-right safe area. Keep the separate YouTube Studio badge enabled too |
| Captions | burned in | clean picture + uploaded `.srt` |

**Creator-approved change, 2026-10-13:** permanent attribution now applies to all future videos in both formats,
superseding the earlier no-corner-logo policy. `BRAND.watermarkHandle` supplies the exact display spelling
`@DollarDevan`. The shared player draws it after scene effects and captions, including transitions and end cards,
so it remains fixed and readable; thumbnails use their separate unmarked drawing path. Keep the mark small,
with a translucent dark backing for contrast, and clear of titles, faces, captions and platform controls.

Both templates set `"watermark": true`; the player also defaults new scripts to enabled when the field is absent.
Existing episode scripts 01–19 explicitly use `false` solely to reproduce their finished historical pictures and
bounded repairs. When adapting an old episode into a **new video or newly branded edition**, set it to `true` and
render the complete picture; never splice watermarked patches into an unmarked master. Do not disable it in a
new publication unless the creator explicitly requests a clean version. Archive copies may be kept separately.

The embedded handle travels with ordinary copied footage but does not prevent cropping, blurring or removal.
The separate Studio watermark is a player overlay, not a substitute for embedded attribution. Before delivery,
inspect encoded opening, middle, transition and end-card frames at phone size in both bright and dark scenes.

YouTube end-screen elements need at least 5 s, which is why the end screen holds about 6 s after its transition.
Don't hold a card for 15–20 s: the creator called ep16's 18 s end card "lingering". The subscribe badge shows
Devan's face inside 74% of the subscribe element's radius, so the native element (the profile picture, also Devan)
covers it completely. A larger Devan leaves doubled hair and ears around the element's edge.

The art style rotates per episode, so these elements carry the brand across looks:
- Devan's silhouette (quiff, black shades, teal θ hoodie) on screen in the first 1–2 s
- the frame-one title + promise for reels; long-form may cold-open, with title + promise within 10 s
- the end card with the handle
- the permanent `@DollarDevan` attribution on every new video

## Copy

- **Description:** the episode's own hook, then the chapters (long-form), then sources, then `COPY.video.footer`
  ("Money, made simple. Follow @dollardevan." / "For general education, not personal financial advice.").
- **Hashtags:** one set of 3 from `COPY.video.hashtagsByTopic`: `general`, `saving`, `credit`, `investing` or
  `companyStories`.
- Write description paragraphs with no line breaks inside a sentence; YouTube shows every newline.
- Bios and profile fields: `COPY.youtube`, `COPY.tiktok`, `COPY.instagram`. The kit's `COPY.md` lists them with
  their character counts.

## Thumbnails and covers

- Leave the channel name and handle off thumbnails; YouTube prints both under every thumbnail. Make the title and
  Devan large.
- Keep Devan on-model. A frame grabbed from the video can carry an effect: ep16's tower thumbnail caught him green
  mid power-up. Check skin, hoodie and shades before offering it.
- On 9:16 covers, keep text below y 300: Instagram's 4:5 feed crop and 3:4 grid crop start around y 240–285.
- For a quick title card, use the kit's offline `templates/cover-editor.html`: type a title, export a thumbnail or a
  vertical cover.

## Channel art and profiles

- `node tools/launch-kit.mjs --hq` builds `out/dollardevan-upload-kit-<date>-hq/` and a zip. Add `--replace` to
  rebuild today's kit.
  - Contents: per-platform folders (avatar, banner, watermark, end screens, Instagram highlight covers and three
    Start-here stories), `COPY.md`, upload READMEs, a brand sheet, and checks in `reference/`.
  - It also refreshes `channel/brand/end-screen-1080p.png`, the copy episodes use.
  - Upload from the newest kit, and delete older kits when asked.
- Avatar: the comic Devan (`channel/pfp.js`, variant `comic`), with no "$". At 36–64 px a "$" turns into a green
  blob beside his hair, and the name already says money.
- Art sources:
  - `channel/comic-brand.js`: banner, watermark, end screen, highlight covers
  - `channel/launch-collateral.js`: stories, covers, vertical end card
  - `channel/pfp.js`: avatar

## Cross-posting reels

Upload the same finished video natively to each app: the master to YouTube Shorts, its `-upload` copy to Instagram and
TikTok. Never use a downloaded TikTok or Short. Make reels **61 s or
longer**, since TikTok's Creator Rewards counts only videos over 1 minute, and keep them **≤ 3 min**, the limit
Instagram recommends. Stagger the uploads on the same day.
