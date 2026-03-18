#!/usr/bin/env bash
set -euo pipefail

# Simple Cloudflare Load Balancer pool switcher
# Usage: switch-pool.sh <load-balancer-id> <pool-id> (expects CF_API_TOKEN env)

LB_ID=${1:-}
POOL_ID=${2:-}

if [ -z "$LB_ID" ] || [ -z "$POOL_ID" ]; then
  echo "Usage: $0 <load-balancer-id> <pool-id>"
  exit 2
fi

if [ -z "${CF_API_TOKEN:-}" ]; then
  echo "CF_API_TOKEN must be set in env"
  exit 2
fi

API="https://api.cloudflare.com/client/v4/zones"
# Note: you may need zone id and the load balancer details; this script assumes LB endpoint accepts default_pool change

echo "Switching load balancer $LB_ID default_pool -> $POOL_ID"

curl -sS -X PATCH "https://api.cloudflare.com/client/v4/user/load_balancers/$LB_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{ \"default_pool\": \"$POOL_ID\" }" | jq '.'

echo "Pool switch requested; verify via Cloudflare dashboard or API"
