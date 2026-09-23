# guttew-skills

A [Claude Code](https://claude.ai/code) plugin providing workflow skills for git commits, branch creation, and GitHub and Azure DevOps pull requests.

## Skills

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

Spawns a `claude --bg` background agent per work item.

**Triggers:** "parallelize work across background agents", `/claude-spawn-agents`


## Installation

### Via Claude Code plugin command

```
/plugin install github:guttew/skills
```

### Via pnpm

```bash
pnpm dlx skills add github:guttew/skills
```

## Requirements

- [Claude Code](https://claude.ai/code)
- `git`
- `az` CLI (Azure DevOps extension) and/or `gh` CLI — required for `/pull-request` depending on the platform (auto-detected).

## License

[MIT](LICENSE)
