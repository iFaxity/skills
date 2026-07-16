# GitHub PR Specifics

## Context commands

```bash
gh repo view --json defaultBranchRef --jq .defaultBranchRef.name
```
Use the detected default branch as the PR target — do not hardcode `main`.

## PR template path

`.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, or `docs/pull_request_template.md`; `(none found)` if absent. (`gh pr create` auto-applies the repo template if present, but read it to use as a structural guide for the Description Format.)

## Linked items

Ask the user for GitHub issue numbers to auto-close on merge. Add `Fixes #123` (one per issue) at the end of the description body. No CLI flag needed.

## Create command

```bash
gh pr create \
  --base <default-branch> \
  --head <branch> \
  --title "<title>" \
  --body "$(cat <<'EOF'
<description>
EOF
)"
```
Use a HEREDOC for `--body` so newlines are preserved. Add `--draft` only if the user explicitly asks for a draft.

## Notes

- `gh` reads org/repo from the remote automatically; no project flag needed.
- Work item / issue linking is via `Fixes #N` in the body, not a CLI flag.
