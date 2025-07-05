#!/bin/bash
source .env

TOKEN="$GITHUB_TOKEN"
USER="ITBUILDS"
REPO="site"
BRANCH="main"

# Create docs folder if it doesn't exist
mkdir -p docs

# Loop through all .md files in docs/
for FILE_PATH in docs/*.md; do
  [ -f "$FILE_PATH" ] || continue

  # Get filename only (strip "docs/")
  REL_PATH="${FILE_PATH}"

  echo "[•] Committing: $REL_PATH"

  # Read content
  DOC_CONTENT=$(cat "$FILE_PATH")

  # Encode content
  CONTENT_ENCODED=$(echo "$DOC_CONTENT" | base64)

  # Get SHA if file exists
  SHA=$(curl -s -H "Authorization: token $TOKEN" \
    https://api.github.com/repos/$USER/$REPO/contents/$REL_PATH \
    | grep '"sha":' | head -1 | cut -d '"' -f4)

  # Commit
  RESPONSE=$(curl -s -X PUT -H "Authorization: token $TOKEN" \
    -H "Content-Type: application/json" \
    -d @- https://api.github.com/repos/$USER/$REPO/contents/$REL_PATH <<EOF
{
  "message": "Auto-sync $REL_PATH via sync-docs",
  "committer": {
    "name": "Auto Bot",
    "email": "bot@example.com"
  },
  "content": "$CONTENT_ENCODED",
  "branch": "$BRANCH",
  "sha": "$SHA"
}
EOF
)

  echo "$RESPONSE" >> log.txt
  echo "[✓] $REL_PATH committed @ $(date -u)" >> log.txt
done
