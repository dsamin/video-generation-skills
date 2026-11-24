# Video generation skills

Two agent skills that capture an end-to-end method for making explainer videos in code: reference study,
fact-checking, script, Google Gemini-TTS narration, canvas animation, a synthesized score, deterministic render,
mix, and upload-ready deliverables.

- `video-generation-short-format/`: 9:16 Reels, TikTok and YouTube Shorts (61–75 s, 90 s ceiling)
- `video-generation-long-format/`: 16:9 YouTube long-form (chapters, thumbnails, SRT)

Each folder is self-contained: `SKILL.md`, `references/` (method docs), and `scripts/` (checks, render verification,
delivery helpers).

## Install

Copy or symlink a skill into your agent's skills folder, for example for Claude Code:

```bash
mkdir -p ~/.claude/skills
cp -R video-generation-short-format ~/.claude/skills/
cp -R video-generation-long-format ~/.claude/skills/
```

## What you also need

The skills describe a **video engine repo** (canvas renderer, style kits, TTS, synth and mixer) that is not included
here. The skills point to it with `~/Projects/Video-Series` and with `VIDEO_SERIES_REPO` in `scripts/bootstrap.sh`.
Use your own engine repo, or adapt the paths.

Google Text-to-Speech needs a service-account key. Create one in your own Google Cloud project, store it outside any
repo, and set `GOOGLE_APPLICATION_CREDENTIALS` to its path. Never commit or paste a key. See
`references/voice-google-tts.md` and `references/local-setup.md`.

## Before you publish your own copy

Run a secret scan (e.g. `gitleaks detect`) on any copy you share, and fill in `references/local-setup.md` with your own
values. This repo ships with no keys, account IDs or personal machine paths.
