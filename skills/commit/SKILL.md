---
name: commit
description: Drafts and executes git commits in Conventional Commits format. Use when the user says "commit", "make a commit", "commit this", "commit my changes", "commit everything", "let's commit", or invokes /commit.
---

## Process

1. Run `git status` and `git diff --staged` in parallel.
2. If nothing is staged, inspect unstaged changes and ask which files to stage (or infer from context). Stage them, then re-read the diff.
3. Derive the commit message/messages (rules below).
  - Include the detected agent name and model name used in the trailer. This is important for disclosure.
4. Show the proposed message/messages in order, confirm with the user, then commit via HEREDOC.

### Atomic commits

One commit = one logical change. If the subject contains "and", split it.

- **Refactors** always separate from functional changes.
- **Bug fixes** one bug = one commit, even across many files.
- **Features** one feature = one commit (or logical sub-parts).
- **Dependencies** group related, split unrelated.

Multiple files != multiple commits — a single logical change can span many files. When in doubt, split: easier to squash later than untangle a bundle. Exception: if a feature won't compile without its refactor, keep them together.

```
feat(auth): extract token validator from middleware
refactor(db): pool to singleton to fix connection exhaustion
feat(api): add /health endpoint for load balancers
```

## Message rules

**Subject line:**
- `<type>(<scope>): <imperative summary>` — `<scope>` optional
- Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`, `revert`. Append `!` for breaking changes.
- Imperative mood: "add", "fix", "remove" — not "added", "adds", "adding"
- Entire header — type, scope, description — all lowercase, no period
- ≤50 chars when possible, hard cap 72
- Scope: kebab-case from changed file paths (feature/module folder). Follow project conventions if it defines scopes. Omit only for truly cross-cutting changes.

**Body (only if needed):**
- Skip when the subject is self-explanatory.
- Add body for: non-obvious *why*, breaking changes, migration notes, security fixes, data migrations, reverting a prior commit. Never compress these into subject-only — future debuggers need the context.
- Prose — no bullets. Blank line after header, wrap at 72.

**Footer (only if needed):**
- `BREAKING CHANGE:` for each breaking change.
- Reference issues/PRs: `Refs #17, #25`.
- `Assisted-by` trailer per rules below.

Subject and body state *what* and *why*, never *how* — the diff shows how. No "This commit does X", "I", "we", "now", "currently", "As requested by", or emoji.

## Commit & trailer

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <description>

<body>

<footer>
EOF
)"
```

**Assisted-by trailer** — add it if any of the staged changes were written or edited by AI. Omit entirely only when the user authored the whole diff and just asked the agent to commit it as-is.

- Format: `Assisted-by: <agent-name>:<model-version>` (Linux kernel convention).
- `<agent-name>` = the agent/harness making the commit. Read the `ROLE` section of the system preamble — it names the harness (e.g. "Oh My Pi coding harness" → `oh-my-pi`). If there is no `ROLE` section, use the harness's own product/CLI name (e.g. "claude-code"). Format as lower-kebab-case.
- `<model-version>` = last `/`-segment of the system context `Model` field (e.g., `ollama-cloud/glm-5.2` => `glm-5.2`).
- If `Model` is missing/empty, omit the suffix: `Assisted-by: <agent-name>`.
- AI agents MUST NOT add `Signed-off-by` — only humans certify DCO.

## Rules

- Never use `--no-verify` or `--no-gpg-sign`.
- Never amend a pushed commit.
- Never commit secrets (`.env`, `appsettings.Local.json`, credentials, private keys).
- If a pre-commit hook fails, fix the issue and create a **new** commit — do not amend.
- Do not push unless the user explicitly asks.
