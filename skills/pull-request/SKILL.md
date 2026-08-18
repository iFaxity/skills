---
name: pull-request
description: Creates a pull request for the current branch on GitHub or Azure DevOps (auto-detected from the remote). Use when the user says "create a PR", "open a pull request", "make a PR", or invokes /pull-request.
---

# Pull Request

## Process

1. **Detect platform.** Run `git remote get-url origin`. Match against:
   - `dev.azure.com` (covers `git@ssh.dev.azure.com:v3/...` and `https://dev.azure.com/...`) → Azure DevOps
   - `github.com` (covers `git@github.com:...` and `https://github.com/...`) → GitHub
   - Anything else → stop and report unsupported remote.

2. **Load platform specifics.** `read` the matching sub-file:
   - Azure DevOps → [ADO.md](./ADO.md)
   - GitHub → [GITHUB.md](./GITHUB.md)

   Only the detected platform's file is loaded. It provides the exact commands and syntax for steps 3, 6, and 8 below.

3. **Gather context.** Run the shared commands:
   ```bash
   git branch --show-current
   git remote get-url origin
   git log --oneline origin/HEAD..HEAD 2>/dev/null || git log --oneline HEAD
   ```
   The log is used only in step 6, to detect conventional-commit types and `!`/`BREAKING CHANGE:` markers — it does not drive the description content.

   Then run the **platform-specific** context commands defined in the loaded sub-file (default-branch detection and PR template search). The sub-file lists these verbatim.

   Once the default branch is known, also run `git diff <default-branch>...HEAD` (merge-base diff) — this is what step 6 drafts the description from.

   **Find the PR template.** Check `CLAUDE.md`/`AGENTS.md` (and anything they `@`-include) and `docs/how-to/pull-requests.md` for a documented template path first, otherwise use the platform-specific template search from the loaded sub-file. (Content conventions, as opposed to the template's path, are DESCRIPTION-FORMAT.md's own lookup in step 6.)

4. **Validate branch name.** Must match `(bugfix|feature|hotfix)/<kebab-case-description>`. If not, warn and stop.

5. **Push if needed.** Check upstream with `git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null`. If none, show then run: `git push --set-upstream origin <branch>`.

6. **Draft the PR.**
   - **Title:** conventional commits format — `<type>(<scope>): <description>`. Same rules as commit headers: imperative mood, all lowercase, no trailing period, ~50 chars, hard limit 72. Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`, `perf`, `build`, `ci`, `revert`. Use `!` for breaking changes. Derive scope from the changed paths (kebab-case module/folder name); omit only if truly cross-cutting. Do not copy the branch name verbatim.
   - **Description:** follow [DESCRIPTION-FORMAT.md](./DESCRIPTION-FORMAT.md), using the net diff gathered in step 3.
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
