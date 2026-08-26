---
name: claude-spawn-tickets
description: Spawn a background agent per ready ticket from a to-tickets breakdown. Use when the user wants to parallelize ticket work.
argument-hint: "which tickets or breakdown to spawn, if not all of them"
disable-model-invocation: true
---

Look at the conversation for a ticket breakdown to parallelize. The argument can narrow which tickets; if it's unclear which breakdown or tickets to use, ask rather than guess before continuing.

A ticket is ready when everything in its "Blocked by" list is done. Spawn only ready tickets.

For each one, build an item whose prompt just tells the agent to read that ticket by path or issue reference and do the work — nothing copied from the ticket itself. Call the Skill tool for `claude-spawn-agents` with the resulting item list and let it handle confirmation, worktrees, and spawning.

This skill only reads tickets — never publish, close, or edit one.
