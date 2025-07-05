#!/bin/bash
source .env

TOKEN="$GITHUB_TOKEN"
USER="ITBUILDS"
REPO="site"
BRANCH="main"

FILE_PATH="$1"
DOC_CONTENT="$2"
COMMIT_MSG="$3"

if [ -z "$FILE_PATH" ] || [ -z "$DOC_CONTENT" ]; then
  echo "Usage: bash push-docs.sh <file_path> <content> [commit_message]"
  exit 1
fi

[ -z "$COMMIT_MSG" ] && COMMIT_MSG="Update $FILE_PATH via script"

SHA=$(curl -s -H "Authorization: token $TOKEN" \
  https://api.github.com/repos/$USER/$REPO/contents/$FILE_PATH \
  | grep '"sha":' | head -1 | cut -d '"' -f4)

RESULT=$(curl -s -X PUT -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  -d @- https://api.github.com/repos/$USER/$REPO/contents/$FILE_PATH <<EOF
{
  "message": "$COMMIT_MSG",
  "committer": {
    "name": "Auto Bot",
    "email": "bot@example.com"
  },
  "content": "$(echo "$DOC_CONTENT" | base64)",
  "branch": "$BRANCH",
  "sha": "$SHA"
}
EOF
)

echo "$RESULT" >> log.txt
echo "[✓] $FILE_PATH committed @ $(date -u)" >> log.txt
