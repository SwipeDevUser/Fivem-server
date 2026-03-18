#!/usr/bin/env bash
set -euo pipefail

# Usage: deploy-to-host.sh <color> <artifact.zip>
# Expects env: SSH_USER, SSH_KEY_PATH, HOSTS (comma-separated), REMOTE_BASE (/opt/fxserver)

COLOR=${1:-green}
ARTIFACT=${2:-artifact.zip}

if [ -z "$SSH_USER" ] || [ -z "$SSH_KEY_PATH" ] || [ -z "$HOSTS" ]; then
  echo "SSH_USER, SSH_KEY_PATH and HOSTS env vars must be set"
  exit 2
fi

for host in $(echo "$HOSTS" | tr ',' ' '); do
  echo "Deploying $ARTIFACT to $host as $COLOR"
  scp -i "$SSH_KEY_PATH" "$ARTIFACT" "$SSH_USER@$host:/tmp/artifact.zip"
  ssh -i "$SSH_KEY_PATH" "$SSH_USER@$host" bash -s <<'EOF'
set -e
COLOR="${COLOR}"
REMOTE_BASE="${REMOTE_BASE:-/opt/fxserver}"
mkdir -p "$REMOTE_BASE"
unzip -o /tmp/artifact.zip -d "$REMOTE_BASE/$COLOR-new"
# atomic switch: move new into color directory then update symlink
mv -T "$REMOTE_BASE/$COLOR-new" "$REMOTE_BASE/$COLOR"
# restart systemd unit for this color if present
systemctl try-restart fxserver@${COLOR}.service || true
EOF
done

echo "Deploy complete"
