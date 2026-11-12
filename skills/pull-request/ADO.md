# Azure DevOps PR Specifics

## Context commands

```bash
az repos show --detect --query defaultBranch --output tsv
```
Parse the ADO project name from the remote URL (format: `git@ssh.dev.azure.com:v3/<org>/<project>/<repo>`). Use the detected default branch as the PR target — do not hardcode `main` or a project name.

## PR template path

Check in order, use the first that exists:
1. `.azuredevops/pull_request_template.md`
2. `docs/pull_request_template.md`
3. `docs/pull_request_template/branches/<default-branch>.md` — branch-specific template
4. Any file directly inside `docs/pull_request_template/` (e.g. `docs/pull_request_template/default.md`) — list the directory if step 3 doesn't match
5. `find . -iname '*pull_request_template*' -not -path '*/node_modules/*'` as a last resort

`(none found)` if none of the above match.

## Existing PR check

```bash
az repos pr list --detect --project "<detected-project>" --source-branch refs/heads/<branch> --status active \
  --query "[0].{id:pullRequestId,url:repository.webUrl}" --output json
```
Same `<detected-project>` parsed from the remote URL in Context commands — `--detect` alone doesn't resolve project. Empty (`[]` or `null`) means no open PR for this branch — proceed. Otherwise build the URL as `<url>/pullrequest/<id>` and report it in step 4.

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

The JSON output's `pullRequestId` and `repository.webUrl` fields build the browser URL for step 9: `<repository.webUrl>/pullrequest/<pullRequestId>` — the plain `url` field is the REST API endpoint, not a browser link.

## Notes

- `az repos pr update` does not accept `--project`; omit it when updating an existing PR (out of scope for create, noted for reference).
