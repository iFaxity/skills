---
name: claude-spawn-agents
description: Spawn a claude --bg background agent per work item. Use when the user wants to parallelize work across background agents.
argument-hint: "what to parallelize, or a ready-made item list"
---

The argument says what to parallelize. If it's not enough to work from, ask rather than guess before continuing.

Spawn each item from the current directory — don't create worktrees yourself. If an item needs isolation, its prompt should tell the spawned session to set up its own (e.g. via `/create-branch`), since a skill's own instructions don't count as the explicit go-ahead `EnterWorktree` requires. Every prompt must be self-contained and scrubbed of secrets, since the spawned agent won't see anything else. Name each session with a short, readable slug that says what the work is at a glance (e.g. `fix-login-redirect`), never just a work item ID like `wi-1234`; an ID may be included alongside the description.

Show the full plan — names, prompts — and get the user's go-ahead in one pass before spawning anything.

Spawn each approved item: run `claude --bg --name "<slug>" "<prompt>"`. Don't set `--permission-mode`.

Report what was spawned in a small table.
