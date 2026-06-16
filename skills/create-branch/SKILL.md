---
name: create-branch
description: Creates a git branch following Conventional Commits naming conventions. Use when the user says "create a branch", "make a branch", "new branch", "checkout a new branch", or invokes /create-branch.
---

# Create Branch

## Naming Convention

Format: `<type>/<kebab-case-description>`

**Types:** `feature`, `bugfix`, `hotfix`, `chore`

**Examples:**
- `feature/user-authentication`
- `bugfix/login-redirect-loop`
- `hotfix/payment-timeout`
- `chore/update-dependencies`

Rules:
- All lowercase, no spaces — hyphens as word separators
- Description: 3–6 words, imperative mood
- Omit issue numbers from the branch name itself

## Process

1. Determine the branch **type** from the user's intent:
   - `feature` — new functionality
   - `bugfix` — non-urgent bug fix
   - `hotfix` — urgent production fix
   - `chore` — maintenance, tooling, dependency updates
2. Derive a concise **kebab-case description** from the task.
3. Show the proposed branch name and confirm with the user.
4. Check that the working tree is clean; if not, warn the user and ask how to proceed.
5. Create and switch to the branch:
   ```bash
   git checkout -b <type>/<description>
   ```

## Rules

- Never branch off a dirty working tree without warning.
- Default base is the current branch unless the user specifies otherwise.
- If the branch already exists, warn and stop — do not force-recreate.
- Do not push unless the user explicitly asks.
