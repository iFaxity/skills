---
name: html-report
description: Render findings as a visual, self-contained HTML report with before/after diagrams.
disable-model-invocation: true
---

# HTML Report

[HTML-REPORT.md](HTML-REPORT.md) is the format: scaffold, card anatomy, diagram patterns, style, tone. Follow it exactly; it is the single source of truth for how the report looks.

## Process

1. **Shape the findings into candidates.** One candidate per finding, each with files, a one-sentence problem, a one-sentence solution, wins, a recommendation strength, and a before/after worth drawing. Done when every finding the user asked about maps to exactly one candidate, and you have picked the top recommendation.
2. **Render.** Read [HTML-REPORT.md](HTML-REPORT.md) and build the file from its scaffold. Done when every section of the format is present (header with legend, one `<article>` per candidate, top recommendation) and every candidate has its before/after diagram.
3. **Write and open.** Resolve the temp dir from `$TMPDIR`, falling back to `/tmp` (`%TEMP%` on Windows). Write to `<tmpdir>/<topic>-report-<timestamp>.html` so each run gets a fresh file and nothing lands in the repo. Open it (`xdg-open` on Linux, `open` on macOS, `start` on Windows) and give the user the absolute path.

## Vocabulary

Resolve the vocabulary before writing any prose; the format's tone rules apply to whichever one you land on.

1. **Project glossary.** If the repo has a `GLOSSARY.md` (or `CLAUDE.md`/`AGENTS.md` points to one), use its terms exactly for domain nouns.
2. **`/codebase-design`.** If that skill is available and the report is about architecture, use its glossary for structural nouns (module, interface, seam, depth…). Combines with a project glossary rather than replacing it.
3. **Neither.** No enforced glossary. Use the terms the project already uses in code, docs, and commit history, and keep each term consistent across the whole report.
