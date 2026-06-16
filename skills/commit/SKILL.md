---
name: commit
description: Creates a git commit following Conventional Commits conventions. Use when the user says "commit", "make a commit", "commit this", "commit my changes", "commit everything", "let's commit", or invokes /commit.
---

# Commit

## Process

1. Run `git status` and `git diff --staged` in parallel.
2. If nothing is staged, inspect unstaged changes and ask which files to stage (or infer from context). Stage them, then re-read the diff.
3. **Default to segmenting.** If the staged changes touch more than one logical concern, propose groupings and draft all commit messages upfront. Show them together and ask the user to confirm or adjust before committing any of them. Once approved, execute each commit in order. Only skip segmenting when all changes form a single atomic unit - e.g., one bug fix spread across several files, or a feature alongside its own tests.
4. Derive a commit message:
   - **Format:** `<type>(<scope>): <description>` — imperative mood, no trailing period.
   - **Header case:** the entire header — type, scope, and description — must be all lowercase. No uppercase letters anywhere in the header.
   - **Types:** `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`, `perf`, `build`, `ci`, `revert`. Append `!` for breaking changes.
   - **Scope:** kebab-case from the changed file paths (feature/module folder). Follow CLAUDE.md if it defines scopes. Omit only for truly cross-cutting changes.
   - **Header length:** aim for ~50 chars, hard max 72. Drop articles and abbreviate before wrapping. Less is more.
   - **Body:** include unless the change is trivial. Explain *what* and *why*, not *how*, in prose — no bullet points or lists. Blank line between header and body; wrap at 72 chars.
5. Show the proposed message, confirm with the user, then commit via HEREDOC. (Skip confirmation if messages were already approved in step 3.)

If Claude participated in making any of the committed changes, append a `Co-Authored-By` trailer:

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <description>

<body>

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

Otherwise omit the trailer entirely.

## Rules

- Never use `--no-verify` or `--no-gpg-sign`.
- Never amend a pushed commit.
- Never commit secrets (`.env`, `appsettings.Local.json`, credentials, private keys).
- If a pre-commit hook fails, fix the issue and create a **new** commit — do not amend.
- Do not push unless the user explicitly asks.
