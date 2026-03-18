#!/usr/bin/env bash
set -euo pipefail

# Run DB migrations on a primary host via SSH
# Usage: run-migrations.sh <host>
# Expects env: SSH_USER, SSH_KEY_PATH, MIGRATION_COMMAND

HOST=${1:-}

if [ -z "$HOST" ]; then
  echo "Usage: $0 <host>"
  exit 2
fi

if [ -z "${MIGRATION_COMMAND:-}" ]; then
  echo "MIGRATION_COMMAND env var must be set"
  exit 2
fi

if [ -z "$SSH_USER" ] || [ -z "$SSH_KEY_PATH" ]; then
  echo "SSH_USER and SSH_KEY_PATH must be set"
  exit 2
fi

echo "Running migrations on $HOST"
ssh -i "$SSH_KEY_PATH" "$SSH_USER@$HOST" "bash -lc '$MIGRATION_COMMAND'"

echo "Migrations finished"
