#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEFAULT_MESSAGE="Deploy $(date '+%Y-%m-%d %H:%M:%S %Z')"
MESSAGE="${1:-$DEFAULT_MESSAGE}"
ASSET_VERSION="$(date '+%Y%m%d%H%M%S')"
export ASSET_VERSION

perl -0pi -e 's/(app\.js\?v=)[^"]+/$1 . $ENV{ASSET_VERSION}/ge; s/(styles\.css\?v=)[^"]+/$1 . $ENV{ASSET_VERSION}/ge' index.html

git add -A

if git diff --cached --quiet; then
  echo "No new changes to commit. Pushing current HEAD to origin/main..."
else
  git commit -m "$MESSAGE"
fi

git push origin HEAD:main
