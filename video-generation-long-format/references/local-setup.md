# Local setup (configure for your machine)

This file was machine-specific in the original; it is now a template. Fill in your own values, and keep any
credentials outside the repo.

| What | Your value |
|---|---|
| Reference repo (engine, tools, episodes, playbook) | `<path to your video engine repo>` (see the root README) |
| Google Cloud project | `<your-project-id>` with the Text-to-Speech API enabled |
| Service account | `<name>@<your-project-id>.iam.gserviceaccount.com` with a role that can call Text-to-Speech |
| Key file | `<path outside any repo>/credentials.json`. Never read it into context, print it, copy it, or commit it. Point `GOOGLE_APPLICATION_CREDENTIALS` at it. |
| Python venv | `tools/.venv` in the engine repo |
| Node / ffmpeg / Playwright | Node, ffmpeg, Playwright with Chromium, fontsource fonts in `node_modules/@fontsource` |
| Git | Build episodes on feature branches; leave them uncommitted until asked |

To confirm which Google identity is active without exposing the key:

```bash
python3 -c "import json,os;d=json.load(open(os.path.expanduser('<path>/credentials.json')));print(d['project_id'],d['client_email'])"
```
