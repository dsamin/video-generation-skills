# Voiceover with Google Gemini-TTS

The house voice is **Gemini-TTS `Fenrir`** on model **`gemini-2.5-pro-tts`**, called through Google Cloud
Text-to-Speech, with a natural-language style prompt. The creator picked it from directed samples. Kokoro (local,
free) was ep01's first voice and felt robotic, so keep it only as an offline fallback.

## Contents
1. One-time Google Cloud setup
2. How `tools/tts.py` calls it
3. Style prompts that worked
4. Pacing: measure, then retake
5. Tempo, caching, leveling
6. Choosing or auditioning voices
7. Character voices
8. Security

## 1. One-time Google Cloud setup

1. Create or choose a GCP project with **billing linked** (Gemini-TTS is a paid API).
2. Enable **Cloud Text-to-Speech API** (`texttospeech.googleapis.com`) and **Vertex AI API**
   (`aiplatform.googleapis.com`). Gemini voices run through Vertex, so the second API is required.
3. Create a **service account**, grant it **Vertex AI User** (`roles/aiplatform.user`, shown in the console as
   "Agent Platform User"), and create a **JSON key**.
4. Store the key **outside any repo**, e.g. `~/.config/google-tts/credentials.json`, and point
   `GOOGLE_APPLICATION_CREDENTIALS` at it. `tts.py` defaults to that path.
5. Python: `python3 -m venv tools/.venv && tools/.venv/bin/pip install google-cloud-texttospeech soundfile numpy`
   (versions in use: google-cloud-texttospeech 2.37, soundfile 0.14, numpy 2.4). ffmpeg must be on PATH.

Machine-specific values (project id, service-account email, key path) are in `local-setup.md`.

Common failures:
- `PERMISSION_DENIED` / `403`: the aiplatform API is disabled, or the service account lacks `roles/aiplatform.user`.
- `BILLING_DISABLED`: relink billing on the project (it happened once, 2026-09-25).
- Quota or `RESOURCE_EXHAUSTED`: `tts.py` retries 6 times with 10 s, 20 s, … backoff.

## 2. How `tools/tts.py` calls it

```python
from google.cloud import texttospeech as tts
client = tts.TextToSpeechClient()                      # reads GOOGLE_APPLICATION_CREDENTIALS
prompt = " ".join(p for p in [cfg["prompt"], line.get("direction", "")] if p)
audio = client.synthesize_speech(
    input=tts.SynthesisInput(text=line["say"], prompt=prompt),
    voice=tts.VoiceSelectionParams(language_code="en-US", name="Fenrir", model_name="gemini-2.5-pro-tts"),
    audio_config=tts.AudioConfig(audio_encoding=tts.AudioEncoding.LINEAR16, sample_rate_hertz=24000),
).audio_content
```

Per line it:
1. Trims leading and trailing silence (keeping a 40 ms tail).
2. Writes the untouched take to `audio/vo/raw/<id>.wav`.
3. Derives `audio/vo/<id>.wav` with `ffmpeg -af atempo=<tempo>` (pitch preserved).
4. Records `durations.json`.
5. Writes `envelopes.json`: per-frame loudness at 30 fps, which drives Devan's mouth in styles that lip-sync.

Run it with `EP=episodes/NN-slug npm run tts`, or `--only <id>` for one line.

## 3. Style prompts that worked

Warm explainer (ep02, reels; approved):
> You are Devan, a friendly young creator explaining money on TikTok. Speak warmly and naturally, with genuine energy
> and curiosity, like you're talking to a good friend. Relaxed, unhurried pace. Let key numbers land with a tiny
> pause. Never sound like an announcer or a robot.

Investigative documentary (ep03, Vox style):
> You are Devan, a young creator narrating a short investigative money documentary. Speak like a thoughtful, curious
> investigator talking to a friend: calm, serious and clear, with quiet intensity, never dramatic. Relaxed, unhurried
> pace. Let key numbers land with a tiny pause. Never sound like an announcer, a news anchor or a robot.

YouTube long-form (ep01 re-voice):
> You are Devan, a warm, upbeat YouTube creator explaining something you genuinely love to a friend. Sound natural
> and conversational, with a smile in your voice and real energy, but keep a relaxed, unhurried pace. Pause for a beat
> before each dollar amount so it lands. Never sound like an announcer or a robot.

Keep Fenrir as Devan's narrator voice; change its style prompt to fit the genre. Character-led stories may use an
approved cast of distinct voices (section 7), while narration keeps the default.

## 4. Pacing: measure, then retake

Gemini's pacing drifts between takes: 84–283 wpm in ep02, 102–213 wpm in ep03. Always measure:

```bash
python3 <skill-dir>/scripts/check_wpm.py episodes/NN-slug   # raw takes only, at tempo 1.0
```

- **Over ~200 wpm (rushed):** add `"direction": "Take your time here, a thoughtful beat."`
- **Under ~120 wpm (dragging):** add `"direction": "Natural conversational pace, keep it moving, no long pauses."`
  Serious or documentary prompts produce many slow takes. ep03's first pass ran 2:36 and was brought to 2:16 by
  re-taking 13 lines and cutting 3 clauses.
- **List lines** ("Heavy debt. Higher rates. Softer jobs.") come out slow. Use "Brisk and deliberate, just a short
  beat between items" or "Steady, natural conversational pace. Keep it moving; list the items quickly".
- **Beware overcorrection:** "Take your time" turned a 213 wpm take into 112 wpm, and "Measured, natural pace" landed
  at 177.

Only lines whose `say`, `direction`, voice, model or prompt changed are re-synthesized. Each retake is one API call.
Aim for every line between ~120 and ~200 wpm at tempo 1.0. Also measure the final `audio/vo/<id>.wav` after tempo:
words / actual WAV duration × 60. `check_wpm.py` checks raw files only; its total/tempo estimate is not a final-take
measurement. A 190 wpm raw take can exceed 200 at 1.1×. Retake the line rather than changing approved words or
raising the tempo to mask the problem.

## 5. Tempo, caching, leveling

- **Tempo:** reels use `tempo: 1.1`, which the creator approved as the right speed for Shorts/Reels. Long-form
  used 1.0. Tempo is re-derived from raw takes, so changing it costs no API calls.
- **Cache:** `audio/vo/cache.json` maps line id → sha1(`say` | engine tag (engine, voice, model, prompt) |
  direction).
- **Leveling:** takes vary by several dB (6.7 dB spread in ep02). `mix.mjs` levels each line to the median loudness
  before ducking the music, so there's no need to fix volume in TTS.

## 6. Choosing or auditioning voices

Samples from the voice search are in the repo's `out/voice-samples/`:
- undirected: Achird, Umbriel, Charon, Puck, Algieba, Iapetus
- directed: Puck, Achird, **Fenrir**, Sadachbia, Umbriel

To audition, synthesize the same 2–3 lines per voice with the same prompt, send the mp3s to the user, and let them
pick. Other Gemini voices exist (e.g. Kore, Aoede, Charon); list them with the API if needed.

## 7. Character voices

`tools/tts.py` supports a Gemini cast through `tts.voices` and each line's `speaker`; a line-level `voice` field
does not select a character. Define the map once in `script.json`:

```json
{
  "tts": {
    "engine": "gemini", "voice": "Fenrir", "model": "gemini-2.5-pro-tts",
    "language": "en-US", "prompt": "Devan narrates warmly and naturally.", "tempo": 1.0,
    "voices": {
      "WALT": { "voice": "Algenib", "prompt": "Warm, grounded grandfather; never cartoonish." },
      "STEVE": { "voice": "Puck", "language": "en-IN", "prompt": "Natural customer-service delivery; light, unexaggerated Indian English." }
    }
  },
  "lines": [
    { "id": "c0-01", "scene": "hook", "say": "The phone rang.", "caption": "The phone rang." },
    { "id": "c0-02", "scene": "hook", "speaker": "WALT", "say": "Who is this?", "caption": "Who is this?" },
    { "id": "c0-03", "scene": "hook", "speaker": "STEVE", "say": "I'm calling about your refund.", "caption": "I'm calling about your refund." }
  ]
}
```

Named settings merge with the global TTS settings; `direction` still appends to the selected character's prompt.
Lines with no speaker, or an unknown speaker, fall back to the narrator. Check every intended character's
`speaker` against the map before voicing so a typo does not silently use Fenrir. Tempo applies to all speakers.
The cache uses the selected voice/model/prompt/direction and non-default language; changing a character's settings
retakes its affected lines without re-voicing unrelated narrator lines. Changing tempo reuses raw takes.

Audition a few representative lines per character before the full run, using the approved acting brief. The
episode 17 cast (Walt/Algenib, Steve/Puck, robocall/Kore) is an example, not a required cast for every story.
Choose accents and locations from the approved, fact-checked story; never exaggerate an accent for a joke.

## 8. Security

- Never print, paste, commit or copy the JSON key. Read it only through the client library. To confirm which
  account is in use, print only `project_id` and `client_email`.
- Never copy `.env` or credential files between projects. Each project points `GOOGLE_APPLICATION_CREDENTIALS` at
  the key's single location.
- Keep credentials out of PR descriptions, commit messages and skill files.
