# Research and adversarial fact-check

Every number in a money or economics video is checked against a primary source before anything is voiced.
In every episode so far, the fact-checker found claims that were wrong or overstated. Examples: "slowed to a crawl"
became "nearly stopped"; "faster than the last downturn" became "a faster start than the 2022 downturn"; "thousands
of jobs" was only true combined, so it became "about 3,600 job cuts worldwide"; AMP was listed as a "big four bank".

## 1. Research (parallel subagents, background)

Split the topic into 2 independent domains, one agent each (e.g. "housing + rates" and "economy + jobs + AI").
Tell each agent the **other agent's scope** so they don't fetch the same releases, and give each a budget of
about 6–10 lookups. Before studying the topic's reference link, grep the repo (`docs/`, `episodes/*/`) for it: it
may already be analyzed.
Your training data may be stale. Tell the agents today's date and have them search for the latest releases.

Prompt skeleton:

```
Today is <date>. I'm scripting a ~<N>-minute explainer on <topic> for <audience>. I need a fact sheet of CURRENT
numbers from primary sources where possible (<list: central bank, statistics bureau, regulators, index providers>).
Use the host's web search/fetch tools; search for the latest releases (<recent months>) rather than relying on memory.

Find, each with value + exact period + source name + URL:
1. <metric> …
…
N. Concrete, sourced examples (<e.g. specific home purchases: bought for $X in YEAR, sold for $Y>). Say plainly
   when an example is weakly sourced.
N+1. Forecasts, including ones that DISAGREE with the main narrative (balance).

Rules: prefer primary sources; give the exact period for every number; flag conflicts and anything unverified;
do NOT guess numbers. Output a compact markdown fact sheet grouped by item with a Confidence (high/med/low) note
per item, under ~1,200 words. Also write it to <scratchpad>/research-<domain>.md.
```

Tips:
- Ask for **concrete examples**: a real property sale, a real company's layoffs, a real price at the pump. Hooks
  built on one concrete example beat abstract stats.
- Ask for **counter-evidence**. It gives the video credibility and keeps it neutral.
- If a session restarts mid-research, resume the same agents with the host's agent tools when available. Save
  findings and reviews into `docs/superpowers/specs/` as they land; keep downloaded media in scratch storage.
- **Check the brief's premise.** Creators dictate from memory: "record credit-card balances" turned out to be
  $1.26T, just under the $1.28T record. Report that in the check-in ("Premise check") and write the true version.
  Never voice a false premise.
- **Blocked sites:** some primary sites (spglobal.com SPIVA, investor.gov) return 403 to fetches. Download the
  published PDF (`curl -L -o x.pdf …`, then `pdftotext` or pypdf) or use a reputable secondary write-up, and flag
  which you used.
- Note the **next data releases** (central-bank meeting, CPI, index update). They decide how long the video stays
  true.

## 2. Draft the script, then run the adversarial check

Write the draft to the scratchpad (spoken text, captions, and bracketed on-screen labels with the numbers they
show), then launch a checker:

```
You are an adversarial fact-checker for a short documentary-style social video about <topic>. Today is <date>.
VERIFY against live primary sources with the host's web search/fetch tools; do not rely on memory.
Script: <path>. Research notes (leads, not truth): <paths>.
For EVERY factual claim (spoken lines, captions, AND on-screen labels) give a verdict:
PASS | FIX (wrong or misleading; give corrected short, speakable wording) | SOFTEN (defensible but overstated; give
softer wording). Be especially hard on: <the 8–14 riskiest claims, listed>.
Also flag: anything that reads as financial advice, non-neutral framing, omissions that make the piece look
selective, and claims that will date because of <upcoming releases>.
Output: a compact table claim | verdict | evidence (source + URL + period) | suggested wording, then a list of exact
line edits. Under ~900 words. Also write it to <scratchpad>/factcheck.md.
```

Apply every FIX. Apply SOFTENs unless one kills the line's meaning, and tell the user which you skipped. Add
the balance clause the checker suggests; in ep03 it added "new investor tax rules" beside rates.

## Release calendars (for dating risks; verify the page before quoting a date)

| Market | Release | Where |
|---|---|---|
| US | FOMC rate decisions | federalreserve.gov/monetarypolicy/fomccalendars.htm |
| US | CPI | bls.gov/schedule/news_release/cpi.htm |
| US | Jobs report (Employment Situation) | bls.gov/schedule/news_release/empsit.htm |
| US | Consumer credit (G.19) | federalreserve.gov/releases/g19/ |
| US | Household debt and credit (quarterly) | newyorkfed.org/microeconomics/hhdc |
| US | Gasoline prices (weekly) | eia.gov/petroleum/gasdiesel/ |
| AU | RBA board meetings | rba.gov.au/schedules-events/ |
| AU | ABS (CPI, Labour Force, GDP) | abs.gov.au/release-calendar |
| AU | Cotality home values | the Home Value Index, published on the first business day of each month |

## 3. Rules that always apply

- **Neutral on conflicts and politics.** Show storm clouds and a closed route, never combat. Present forecasts as
  forecasts, and name who made them.
- **Downturns and crises:** show what the data shows, frame what might come next as a *risk* with sources, and
  include one line on what's holding things up. The creator asked for "dire" framing in ep03. The fix was to show the
  downturn as fact (it was real), not to overstate what comes next.
- **Label periods on screen** ("year to June", "Feb–Aug 2026") so the video stays true after new releases.
- **Arithmetic you derive** (e.g. repayments) goes on screen with its assumptions: "$1M variable loan · 30 yrs ·
  5.50% → 6.25%".
- **End card (reels):** "Educational only. Not financial advice." plus a sources line (2 lines max at ~22 px).
  Long-form lists sources in the description; its end screen says "Sources in the description".
- **Dating risk:** if a scheduled release could change a spoken number within days of publishing, tell the user
  the exact date and offer a two-line re-voice plus patch render.
