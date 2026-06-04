---
name: commit
description: Creates a git commit following Conventional Commits conventions. Use when the user says "commit", "make a commit", "commit this", "commit my changes", or invokes /commit.
---

# Commit

## Process

1. Run `git status` and `git diff --staged` in parallel.
2. If nothing is staged, inspect unstaged changes and ask which files to stage (or infer from context). Stage them, then re-read the diff.
3. If the diff mixes unrelated concerns — different modules, mixed commit types with no coupling, or separate subsystems — propose groupings and draft all commit messages upfront. Show them together and ask the user to confirm or adjust before committing any of them. Once approved, execute each commit in order. Skip this for small diffs (≤ ~5 files) or naturally layered changes (a fix across multiple files, a feature spanning frontend + backend).
4. Derive a commit message:
   - **Format:** `<type>(<scope>): <description>` — imperative mood, lowercase, no trailing period.
   - **Types:** `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`, `perf`, `build`, `ci`, `revert`. Append `!` for breaking changes.
   - **Scope:** kebab-case from the changed file paths (feature/module folder). Follow CLAUDE.md if it defines scopes. Omit only for truly cross-cutting changes.
   - **Header:** aim for ~50 chars, hard max 72. Drop articles and abbreviate before wrapping.
   - **Body:** include unless the change is trivial. Explain *what* and *why*, not *how*, in prose — no bullet points or lists. Blank line between header and body; wrap at 72 chars.
5. Show the proposed message, confirm with the user, then commit via HEREDOC. (Skip confirmation if messages were already approved in step 3.)

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <description>

<body>
EOF
)"
```

## Rules

- Never use `--no-verify` or `--no-gpg-sign`.
- Never amend a pushed commit.
- Never commit secrets (`.env`, `appsettings.Local.json`, credentials, private keys).
- If a pre-commit hook fails, fix the issue and create a **new** commit — do not amend.
- Do not push unless the user explicitly asks.
