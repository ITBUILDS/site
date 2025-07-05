#!/bin/bash

cd "$(dirname "$0")"
for FILE in docs/*.md; do
  if [ -f "$FILE" ]; then
    FILENAME=$(basename "$FILE")
    CONTENT=$(cat "$FILE")
    COMMIT_MSG="🔄 Sync $FILENAME on $(date)"
    bash push-docs.sh "$FILE" "$CONTENT" "$COMMIT_MSG"
  fi
done
