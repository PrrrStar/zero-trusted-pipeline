#!/usr/bin/env bash

# GitHub source module
cat <<EOF > ~/.gitconfig
[url "https://$GH_TOKEN@github.com"]
  insteadOf = ssh://git@github.com
EOF

atlantis server \
  --atlantis-url="$URL" \
  --port="$PORT" \
  --gh-user="$GH_USER" \
  --gh-token="$GH_TOKEN" \
  --gh-webhook-secret="$GH_WEBHOOK_SECRET" \
  --repo-allowlist="$REPO_ALLOWLIST" \
  --repo-config="./repos.yaml" \
  --hide-prev-plan-comments \
  --data-dir="/atlantis-data" \
  --enable-diff-markdown-format \
  --automerge
