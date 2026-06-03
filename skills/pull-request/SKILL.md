---
name: pull-request
description: Creates an Azure DevOps pull request for the current branch. Use when the user says "create a PR", "open a pull request", "make a PR", or invokes /pull-request.
---

# Pull Request

## Description Format

**Always use this format for the PR description.** When a PR template is found, use it as a structural guide but still apply these rules for content and emoji prefixes.

Output structure:
1. **Summary** — no header. Brief for short logs; narrative for long ones.
2. **⚠️ BREAKING CHANGES** — only if a commit uses `feat!:`, `fix!:`, or `BREAKING CHANGE:`. Bold the impact.
3. **## Key Changes** — single flat bulleted list; combine redundant commits.

References: only include refs from commit footers prefixed `Refs:`.
- Work Item IDs → `#123456` (auto-links in ADO)
- Commit hashes → append as `(a1b2c3d)` at end of bullet

Emoji per type (prefix every bullet):

| Emoji | Type                  |
|-------|-----------------------|
| ✨    | feat                  |
| 🐛    | fix                   |
| ♻️    | style                 |
| ⚙️    | chore / build / ci    |
| 🛠️    | refactor              |
| ⚡    | perf                  |
| 📝    | docs                  |
| 🧪    | test                  |

Use action-oriented language; focus on user/system impact.

## Process

1. **Gather context.** Run these commands to collect everything needed:
   ```bash
   git branch --show-current
   git remote get-url origin
   git log --oneline origin/HEAD..HEAD 2>/dev/null || git log --oneline HEAD
   git diff --name-only origin/HEAD..HEAD 2>/dev/null
   cat .azuredevops/pull_request_template.md 2>/dev/null || cat docs/pull_request_template.md 2>/dev/null || echo "(none found)"
   az repos show --detect --query defaultBranch --output tsv
   ```
   Parse the ADO project name from the remote URL (format: `git@ssh.dev.azure.com:v3/<org>/<project>/<repo>`). Use the detected default branch as the PR target — do not hardcode `main` or a project name.

2. **Validate branch name.** Must match `(bugfix|feature|hotfix)/<kebab-case-description>`. If not, warn and stop.

3. **Push if needed.** Check upstream with `git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null`. If none, show then run: `git push --set-upstream origin <branch>`.

4. **Draft the PR.**
   - **Title:** conventional commits format — `<type>(<scope>): <description>`. Same rules as commit headers: imperative mood, all lowercase, no trailing period, ~50 chars, hard limit 72. Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`, `perf`, `build`, `ci`, `revert`. Use `!` for breaking changes. Derive scope from the changed paths (kebab-case module/folder name); omit only if truly cross-cutting. Do not copy the branch name verbatim.
   - **Description:** generate from the commit log using the format defined in **## Description Format** above. If a PR template was found, use it as a guide for structure but always apply the Description Format rules.
   - **Work items:** ask the user for ADO work item IDs. Skip `--work-items` if none.

5. **Confirm with user.** Show title, description, target branch, and work items. Ask for approval; allow edits.

6. **Create the PR.**
   ```bash
   az repos pr create \
     --detect \
     --project "<detected-project>" \
     --title "<title>" \
     --description "$(cat <<'EOF'
   <description>
   EOF
   )" \
     --target-branch <default-branch> \
     --work-items <ids>   # omit if none
   ```
   Use a HEREDOC for `--description` so newlines are preserved as real line breaks in ADO. `--detect` reads org/repo from the remote; do not hardcode them.

7. **Report the URL.** Parse and show the `url` field from the JSON output.

## Rules

- Never bypass policies (`--bypass-policy`).
- Never create a draft PR unless explicitly asked.
- Never push to the default branch.
- If push is rejected, stop and report — do not force-push.
- `az repos pr update` does not accept `--project`; omit it when updating an existing PR.
