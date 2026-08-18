#!/usr/bin/env bash
# Copy skills/ from this repo to ~/.agents/skills for local testing.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
DEST="$HOME/.agents/skills"

shopt -s nullglob
mkdir -p "$DEST"

for skill in "$SRC"/*/; do
  name="$(basename "$skill")"
  rm -rf "${DEST:?}/$name"
  cp -r "$skill" "$DEST/$name"
done

echo "Synced skills to $DEST"
