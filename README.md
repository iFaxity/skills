# guttew-skills

A [Claude Code](https://claude.ai/code) plugin providing workflow skills for git commits and Azure DevOps pull requests.

## Skills

### `/commit`

Creates a git commit following [Conventional Commits](https://www.conventionalcommits.org/) conventions.

**Triggers:** "commit", "make a commit", "commit this", "commit my changes", `/commit`

---

### `/pull-request`

Creates an Azure DevOps pull request for the current branch.

**Triggers:** "create a PR", "open a pull request", "make a PR", `/pull-request`

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
- `az` CLI (Azure DevOps extension) — required only for `/pull-request`

## License

[MIT](LICENSE)
