#!/usr/bin/env node
// node chapters.mjs <episode-dir> — YouTube chapter list from timeline.json.
// Titles come from script.json "chapters": { "<sceneId>": "Chapter title", ... }; a chapter runs until the next
// titled scene. Without that map, every scene becomes a chapter titled by its id. YouTube needs the first chapter at
// 0:00, at least 3 chapters, and each at least 10 s long.
import { readFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
const ep = resolve(process.argv[2] || '.');
const tl = JSON.parse(readFileSync(join(ep, 'timeline.json'), 'utf8'));
const script = JSON.parse(readFileSync(join(ep, 'script.json'), 'utf8'));
const names = script.chapters || Object.fromEntries(tl.scenes.filter(s => s.id !== 'endcard').map(s => [s.id, s.id]));
const fmt = t => { const s = Math.floor(t), h = Math.floor(s / 3600), m = Math.floor(s / 60) % 60, ss = String(s % 60).padStart(2, '0'); return h ? `${h}:${String(m).padStart(2, '0')}:${ss}` : `${m}:${ss}`; };
const marks = tl.scenes.filter(s => names[s.id]).map(s => ({ t: s.start, title: names[s.id] }));
if (!marks.length || marks[0].t > 0.5) marks.unshift({ t: 0, title: 'Intro' });
marks[0].t = 0;
const warn = [];
marks.forEach((m, i) => { const next = marks[i + 1]?.t ?? tl.total; if (next - m.t < 10) warn.push(`"${m.title}" is ${(next - m.t).toFixed(1)}s (< 10s)`); });
if (marks.length < 3) warn.push('fewer than 3 chapters (YouTube ignores the list)');
console.log(marks.map(m => `${fmt(m.t)} ${m.title}`).join('\n'));
if (warn.length) console.error('\nWARN: ' + warn.join('; '));
