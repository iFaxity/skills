# Azure DevOps PR Specifics

## Context commands

```bash
az repos show --detect --query defaultBranch --output tsv
```
Parse the ADO project name from the remote URL (format: `git@ssh.dev.azure.com:v3/<org>/<project>/<repo>`). Use the detected default branch as the PR target — do not hardcode `main` or a project name.

## PR template path

`.azuredevops/pull_request_template.md` or `docs/pull_request_template.md`; `(none found)` if absent.

## Linked items

Ask the user for ADO work item IDs. Pass via `--work-items <ids>`; omit the flag if none.

## Create command

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

## Notes

- `az repos pr update` does not accept `--project`; omit it when updating an existing PR (out of scope for create, noted for reference).
