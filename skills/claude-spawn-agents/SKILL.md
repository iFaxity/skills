---
name: claude-spawn-agents
description: Spawn a claude --bg background agent per work item, each in its own git worktree. Use when the user wants to parallelize work across background agents.
argument-hint: "what to parallelize, or a ready-made item list"
---

The argument says what to parallelize. If it's not enough to work from, ask rather than guess before continuing.

When an item touches this repo's working tree, give it its own worktree via `EnterWorktree`, fresh off the default branch; otherwise just run it from the current directory. Exception: if the prompt itself already instructs the spawned session to create its own worktree (e.g. via `/create-branch`), don't pre-create one — spawn `claude --bg` from the current directory instead, so the session isn't creating a nested worktree inside one you already made. Every prompt must be self-contained and scrubbed of secrets, since the spawned agent won't see anything else. Name each session and worktree with the same slug.

Show the full plan — names, worktrees, prompts — and get the user's go-ahead in one pass before spawning anything.

Spawn each approved item: enter its worktree if it has one (skip this per the exception above), run `claude --bg --name "<slug>" "<prompt>"`, then `ExitWorktree(action: "keep")` if you entered one. Don't set `--permission-mode`.

Report what was spawned and where in a small table.
