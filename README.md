# guttew-skills

A [Claude Code](https://claude.ai/code) plugin providing workflow skills for git commits, branch creation, and GitHub and Azure DevOps pull requests.

## Skills

Skills marked **Explicit only** never run on their own; call them by name (`/name` in Claude Code, `$name` in Codex).

### `/commit`

Creates a git commit following [Conventional Commits](https://www.conventionalcommits.org/) conventions.

**Triggers:** "commit", "make a commit", "commit this", "commit my changes", `/commit`

---

### `/create-branch`

Creates a git branch following a consistent `type/kebab-case-description` naming convention.

**Triggers:** "create a branch", "make a branch", "new branch", "checkout a new branch", `/create-branch`

---

### `/pull-request`

Creates a pull request for the current branch on GitHub or Azure DevOps (auto-detected from the remote).

**Triggers:** "create a PR", "open a pull request", "make a PR", `/pull-request`

---

### `/claude-spawn-agents`

**Explicit only.** Spawns a `claude --bg` background agent per work item. Pass what to parallelize, or a ready-made item list.

---

### `/implement`

**Explicit only.** Implements a piece of work from a spec or a set of tickets.

---

### `/html-report`

**Explicit only.** Renders findings as a visual, self-contained HTML report with before/after diagrams.

## Installation

### Claude Code

```
/plugin marketplace add iFaxity/skills
/plugin install guttew-skills@guttew
```

### OpenAI Codex

```bash
codex plugin marketplace add iFaxity/skills
```

Then install `guttew-skills` from the `/plugins` browser.

### Via pnpm

```bash
pnpm dlx skills add github:iFaxity/skills
```

## Requirements

- [Claude Code](https://claude.ai/code)
- `git`
- `az` CLI (Azure DevOps extension) and/or `gh` CLI — required for `/pull-request` depending on the platform (auto-detected).

## License

[MIT](LICENSE)
