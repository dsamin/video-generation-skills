#!/usr/bin/env node
// node check_captions.mjs <episode-dir | path/to/script.json>
// Flags orphaned caption chunks (<= 2 words that are a fragment: they start lowercase or end on , : ; —) and
// over-long chunks, using the engine's own chunker and the script's captionChars. Works on a draft script.json
// anywhere (e.g. the scratchpad): the engine is found two levels above an episode dir, else in $VIDEO_SERIES_REPO,
// else in ~/Projects/Video-Series.
import { readFileSync, existsSync, statSync } from 'node:fs';
import { resolve, join, dirname } from 'node:path';
import { homedir } from 'node:os';
import { pathToFileURL } from 'node:url';
const arg = resolve(process.argv[2] || '.');
const scriptPath = statSync(arg).isDirectory() ? join(arg, 'script.json') : arg;
const candidates = [join(dirname(scriptPath), '..', '..', 'engine', 'captions.js'),
  process.env.VIDEO_SERIES_REPO && join(process.env.VIDEO_SERIES_REPO, 'engine', 'captions.js'),
  join(homedir(), 'Projects', 'Video-Series', 'engine', 'captions.js')].filter(Boolean);
const engine = candidates.find(f => existsSync(f));
if (!engine) { console.error('engine/captions.js not found; set VIDEO_SERIES_REPO'); process.exit(2); }
const { chunkCaption } = await import(pathToFileURL(engine).href);
const script = JSON.parse(readFileSync(scriptPath, 'utf8'));
const max = script.captionChars || 58;
let bad = 0;
for (const l of script.lines) {
  for (const c of chunkCaption(l.caption, max)) {
    const orphan = c.split(/\s+/).length <= 2 && (/^[a-z]/.test(c) || /[,:;—]$/.test(c));
    if (orphan || c.length > max) { bad++; console.log(`${l.id}: ${JSON.stringify(c)}`); }
  }
}
console.log(bad ? `${bad} caption chunk(s) to fix (captionChars ${max})` : `captions OK (captionChars ${max})`);
process.exit(bad ? 1 : 0);
