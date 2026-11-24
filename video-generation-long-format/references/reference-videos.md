# Studying a reference video

The creator usually starts with "make one like this <link>". The link sets the **look**: palette, typography,
motion, composition and transitions. It does not set the topic or the facts. Treat the reference as a style brief.

**Look *and* animation, boldly (ep08).** "Use this format / similar colours" means build the reference's rendering,
its signature device (e.g. a prompt box that rewrites the world), its camera language and its transitions. Re-lighting
the house paper look in the reference's palette was rejected twice ("looks very similar to the past videos… I want
bold new ideas"). Build a new kit when needed, and send 4–8 style frames from it before building every scene.

## 1. Pull the video

**X / Twitter links** (most common). Use the fxtwitter API. It needs no login, and it also returns quoted posts and
X Articles:

```bash
scripts/fetch_reference.sh "https://x.com/<user>/status/<id>" <out-dir>
```

The script:
- saves `tweet.json`
- prints the post text and any quoted post or article text (prompt packs often live there)
- downloads the 720p mp4 variant
- writes contact sheets `sheet1.png`, `sheet2.png`… (one frame every 2.5 s, 4×3 tiles)

Manual equivalent:

```bash
curl -s https://api.fxtwitter.com/<user>/status/<id> | python3 -m json.tool      # media.all[].formats[] has mp4 URLs
curl -sL -o ref.mp4 "<1280x720 mp4 url>"
ffmpeg -i ref.mp4 -vf "fps=1/2.5,scale=480:-1,tile=4x3" sheet%d.png
```

**Other links.** YouTube, TikTok and Instagram need `yt-dlp` (ask before installing it). For a web page with an
embedded video, use the browser tools. The user sharing a link is permission to view it. Keep downloads in the
scratchpad, never in the repo.

Read every sheet image. For motion details (how pieces enter, cut rhythm), also pull a few consecutive frames:
`ffmpeg -ss 12 -i ref.mp4 -vf fps=6,scale=360:-1,tile=6x1 -frames:v 1 motion.png`.

## 2. Extract the style

Write down, concretely:
- **Surface / background:** e.g. "aged archival tan paper, faint map contours, newsprint scraps" or "construction
  paper sky with layered hills".
- **Palette:** 4–6 hex values; name the one accent color and what it is reserved for.
- **Typography:** headline family (condensed caps? rounded?), label style (typewriter?), caption treatment.
- **Hero treatment:** halftone photo cutouts? flat paper shapes? ink line art? Keylines, drop shadows, offset strokes.
- **Motion vocabulary:** spring/overshoot entrances, counters ticking, pins dropping, strings drawing, camera drift,
  cut rhythm (every 1–3 s?).
- **Transitions:** hard cuts, paper tears, pans, wipes, tile flips, pixel dissolves, pull-back reveals. Pull a
  6–10 fps strip around each of the reference's cuts (`ffmpeg -ss <t-0.5> -t 1 -i ref.mp4 -vf fps=8,scale=240:-1,tile=8x1`)
  and name each one. Note what is *absent* (e.g. no dissolves).
- **Composition rules:** one hero at ~70% visual weight plus 2–3 supporting pieces; the amount of text on screen.
- **Mascot fit:** how Devan should appear in this look (walking paper cutout, halftone "photo" cutout, glossy vinyl
  toy — `engine/devan-toy.js`).
- **Signature device and structure:** the one idea that makes the reference memorable (Pip: a prompt box keeps
  rewriting his world → he grabs the keyboard → pull-back to the real desk → loop). Map it onto the topic so it
  carries meaning (ep08: COMPANY HQ's edits = shrinkflation; Devan typing back = checking the unit price).
- **Format:** aspect ratio and length. The house default is still 9:16 reels or 16:9 long-form per the chosen skill,
  even if the reference differs. State the assumption in the design check-in.

If the post quotes a prompt pack (e.g. the Vox "image prompt" and "video prompt"), read it. It is a precise,
free spec of the style. Copy the palette hexes and the prohibitions ("no glossy 3D, no neon, no dissolves").

## 3. Map it onto a style kit

Check `styles.md`. If an existing kit matches (paper cutout, Vox collage, ink-and-hatch), use it. If not, build a new
kit (e.g. `engine/<style>.js` + `engine/<style>-kit.js`) following the "new style kit" recipe in `styles.md`, and
keep every engine change additive.

## Gotchas seen so far

- **Speech-to-text mangles style names.** "walk style documentary" meant **"Vox style"**. Confirm by watching the
  reference, not by guessing.
- **Reference aspect can differ.** The Vox reference was 16:9 AI-generated animation, and the episode was a 9:16 reel
  drawn in code. Say so in the check-in.
- **AI-generated references have quirks.** The Vox sample "put red strings all over the place". Copy the intended
  style (the prompt pack), not the artifacts.
