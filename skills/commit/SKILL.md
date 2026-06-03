---
name: commit
description: Creates a git commit following Conventional Commits conventions. Use when the user says "commit", "make a commit", "commit this", "commit my changes", or invokes /commit.
---

# Commit

## Process

1. Run `git status` and `git diff --staged` in parallel to understand staged state.
2. If nothing is staged, inspect unstaged changes and ask the user which files to stage — or infer from context if obvious. Stage them, then re-read the diff.
3. Derive a commit message:
   - **Format:** `<type>(<scope>): <description>`
   - **Types:** `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`, `perf`, `build`, `ci`, `revert`. Use `!` suffix for breaking changes (e.g. `feat!:`).
   - **Scope:** kebab-case. If the project's CLAUDE.md defines scopes or a scope convention, follow it. Otherwise derive from the changed file paths: feature/module folder names → kebab-case. Omit scope only if the change is truly cross-cutting with no single owner.
   - **Description:** imperative mood, all lowercase, no trailing period. Use only lowercase letters, digits, hyphens, and spaces.
   - **Header length:** aim for ~50 characters, hard limit 72. Shorten description (drop articles, abbreviate scope) rather than wrapping.
   - **Body:** always include a body unless the change is genuinely trivial (e.g. a typo fix). Explain *what* changed and *why* — not *how*. Wrap lines at 72 characters, blank line between header and body. Prefer 2–4 sentences; bullet points are fine for multi-part changes.
4. Show the proposed message to the user and ask for confirmation before committing.
5. Run the commit using a HEREDOC to avoid shell quoting issues.

## Rules

- Never use `--no-verify` or `--no-gpg-sign`.
- Never amend a commit that has already been pushed.
- Never commit files that likely contain secrets (`.env`, `appsettings.Local.json`, credentials, private keys).
- If a pre-commit hook fails, fix the underlying issue and create a **new** commit — do not amend.
- Do not push unless the user explicitly asks.

## Commit command template

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <short description (~50 chars, max 72)>

Optional body — wrap at 72 characters. Explain what and why,
not how. Leave a blank line between header and body.
EOF
)"
```
