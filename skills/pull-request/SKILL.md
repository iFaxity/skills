---
name: pull-request
description: Creates a pull request for the current branch on GitHub or Azure DevOps (auto-detected from the remote). Use when the user says "create a PR", "open a pull request", "make a PR", or invokes /pull-request.
---

# Pull Request

## Description Format

**Check project docs first.** Before applying anything below, look for PR instructions in `CLAUDE.md`/`AGENTS.md` (including files they `@`-include). Projects sometimes document their own template location and usage rules (e.g. "use verbatim, only replace placeholders" or "don't remove section headers") - if found, those rules take precedence over everything in this section. Only fall back to the format below when the project has no documented convention.

**Default format (no project convention found):** use this format for the PR description, using a discovered template as a structural guide but still applying these rules for content and emoji prefixes.

Output structure:
1. **Summary** — no header. Brief for short logs; narrative for long ones.
2. **⚠️ BREAKING CHANGES** — only if a commit uses `feat!:`, `fix!:`, or `BREAKING CHANGE:`. Bold the impact.
3. **## Key Changes** — single flat bulleted list; combine redundant commits.

References: only include refs from commit footers prefixed `Refs:`.
- ADO Work Item IDs → `#123456` (auto-links in ADO)
- GitHub issues/PRs → `#123` (auto-links in GitHub)
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

1. **Detect platform.** Run `git remote get-url origin`. Match against:
   - `dev.azure.com` (covers `git@ssh.dev.azure.com:v3/...` and `https://dev.azure.com/...`) → Azure DevOps
   - `github.com` (covers `git@github.com:...` and `https://github.com/...`) → GitHub
   - Anything else → stop and report unsupported remote.

2. **Load platform specifics.** `read` the matching sub-file:
   - Azure DevOps → [ADO.md](./ADO.md)
   - GitHub → [GITHUB.md](./GITHUB.md)

   Only the detected platform's file is loaded. It provides the exact commands and syntax for steps 3, 6, and 7 below.

3. **Gather context.** Run the shared commands:
   ```bash
   git branch --show-current
   git remote get-url origin
   git log --oneline origin/HEAD..HEAD 2>/dev/null || git log --oneline HEAD
   git diff --name-only origin/HEAD..HEAD 2>/dev/null
   ```
   Then run the **platform-specific** context commands defined in the loaded sub-file (e.g. ADO: `az repos show --detect --query defaultBranch --output tsv` and template path `.azuredevops/pull_request_template.md`; GitHub: `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name` and template path `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE.md`). The sub-file lists these verbatim.

   **Find the PR template.** Don't assume a fixed path — projects vary:
   - Check `CLAUDE.md`/`AGENTS.md` (and anything they `@`-include) and `docs/how-to/pull-requests.md` for a documented template path or PR-writing instructions first.
   - Otherwise search common locations: `.azuredevops/pull_request_template.md`, `docs/pull_request_template.md`, `docs/pull_request_template/branches/<default-branch>.md`, `.github/pull_request_template.md`, or `find . -iname '*pull_request_template*' -not -path '*/node_modules/*'`.
   - If none found, proceed with the default format below.

4. **Validate branch name.** Must match `(bugfix|feature|hotfix)/<kebab-case-description>`. If not, warn and stop.

5. **Push if needed.** Check upstream with `git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null`. If none, show then run: `git push --set-upstream origin <branch>`.

6. **Draft the PR.**
   - **Title:** conventional commits format — `<type>(<scope>): <description>`. Same rules as commit headers: imperative mood, all lowercase, no trailing period, ~50 chars, hard limit 72. Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`, `perf`, `build`, `ci`, `revert`. Use `!` for breaking changes. Derive scope from the changed paths (kebab-case module/folder name); omit only if truly cross-cutting. Do not copy the branch name verbatim.
   - **Description:** generate from the commit log per **## Description Format** above — follow the project's documented convention if one was found, otherwise the default format.
   - **Linked items:** platform-specific. The sub-file defines how:
     - ADO: ask user for work item IDs; skip `--work-items` if none.
     - GitHub: ask user for issue numbers to close; skip `Fixes #` lines if none.

7. **Confirm with user.** Show title, description, target branch, and linked items. Ask for approval; allow edits.

8. **Create the PR.** Use the exact command from the loaded sub-file:
   - ADO sub-file: `az repos pr create` with `--detect`, `--project`, HEREDOC `--description`, `--target-branch`, optional `--work-items`.
   - GitHub sub-file: `gh pr create` with `--base`, `--head`, `--title`, HEREDOC `--body`, optional `--draft` only if requested.

9. **Report the URL.** Parse and show the PR URL from the command output.

## Rules

- Never bypass platform policies or merge protections.
- Never create a draft PR unless explicitly asked.
- Never push to the default branch.
- If push is rejected, stop and report — do not force-push.
