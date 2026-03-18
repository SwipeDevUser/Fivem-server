# Cloudflare Load Balancer Setup Guide

This guide walks you through setting up Cloudflare Load Balancer for blue/green deployments.

## Prerequisites

- Cloudflare account with at least one domain/zone
- Cloudflare Pro or higher plan (Load Balancing requires paid tier)
- Access to your DNS records

## Step 1: Create Health Check

1. Go to **Cloudflare Dashboard** → **Your Domain** → **Load Balancing**
2. Click **Health Checks** tab
3. Click **Create Health Check**
4. Configure:
   - **Monitor Type**: HTTP
   - **Protocol**: HTTP
   - **Port**: 30120 (or your FXServer port)
   - **Path**: `/health`
   - **Interval**: 10 seconds
   - **Timeout**: 5 seconds
   - **Retries**: 2
   - **Description**: FXServer Health Check
5. Click **Create**

## Step 2: Create Pools

### Create BLUE Pool

1. **Load Balancing** → **Pools** tab → **Create Pool**
2. Configure:
   - **Pool Name**: `blue-pool`
   - **Description**: Blue deployment pool
   - **Health Check**: Select the FXServer health check created above
   - **Origins**: Add your BLUE hosts
     - Click **Add Origin**
     - **Name**: `blue-1` (or similar)
     - **Address**: `10.0.0.5` (your BLUE host IP)
     - **Weight**: 100
     - Repeat for each BLUE host (`10.0.0.6`, etc.)
3. Click **Create**

### Create GREEN Pool

Repeat the same steps but name it `green-pool` and add GREEN host IPs (`10.0.0.7`, `10.0.0.8`, etc.)

## Step 3: Create Load Balancer

1. **Load Balancing** → **Load Balancers** tab
2. Click **Create Load Balancer**
3. Configure:
   - **Domain**: `yourserver.example.com` (or subdomain)
   - **Traffic Steering Policy**: Choose one:
     - **Geo-steering**: Route based on location
     - **Dynamic**: Route based on health checks (recommended)
     - **Latency-based**: Route to closest/fastest
     - **Standard**: Round-robin
   - For FiveM: recommend **Dynamic** or **Latency-based**
4. Click **Next**

### Set Default Pool & Fallback

1. **Default pool**: Select `blue-pool` (initially active)
2. **Fallback pool**: Select `green-pool` (fallback if all blue hosts unhealthy)
3. **Session affinity**: Enable (optional but recommended for game servers)
   - Keeps player connected to same server
   - Set to **IP Cookie** or **Secure**
4. Click **Next**

### Review & Create

- Review settings
- Click **Create**

## Step 4: Get Your IDs

After Load Balancer is created, you'll need these IDs for GitHub Secrets:

### Find CF_LOAD_BALANCER_ID

1. Go to **Load Balancing** → **Load Balancers**
2. Click your load balancer name
3. In the URL bar: `https://dash.cloudflare.com/.../<ZONE_ID>/load_balancing/load_balancers/<LB_ID>`
4. Copy: `<ZONE_ID>:<LB_ID>` (e.g., `abc123def456:xyz789uvw123`)
   - Or if workflow only needs LB_ID: `xyz789uvw123`

### Find CF_BLUE_POOL_ID & CF_GREEN_POOL_ID

1. Go to **Load Balancing** → **Pools**
2. Click on **blue-pool**
3. In URL or on page, copy the Pool ID
4. Repeat for **green-pool**

Or use API to get IDs (requires API token):

```bash
# Get all pools
curl -X GET "https://api.cloudflare.com/client/v4/user/load_balancers/pools" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" | jq '.result[] | {name, id}'

# Get all load balancers
curl -X GET "https://api.cloudflare.com/client/v4/user/load_balancers" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" | jq '.result[] | {name, id}'
```

## Step 5: Create API Token

1. Go to **My Profile** → **API Tokens**
2. Click **Create Token**
3. Choose template: **Load Balancer Write** (or Custom)
4. Grant permissions:
   - **Zone**: Load Balancing: Read & Write
   - **Account**: Load Balancing: Read & Write
5. Click **Create Token**
6. Copy the token (you'll only see it once!)

## GitHub Secrets to Add

Once you have the IDs:

```
CF_API_TOKEN = [your API token from step 5]
CF_LOAD_BALANCER_ID = [LB_ID from step 4]
CF_BLUE_POOL_ID = [blue-pool ID]
CF_GREEN_POOL_ID = [green-pool ID]
```

## Testing Pool Switching via API

Test switching pools manually:

```bash
export CF_API_TOKEN="your-token"
export LB_ID="your-lb-id"
export BLUE_POOL_ID="your-blue-pool-id"

# Switch to BLUE
curl -X PATCH "https://api.cloudflare.com/client/v4/user/load_balancers/$LB_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"default_pool\": \"$BLUE_POOL_ID\"}" | jq '.'

# Response should show: "default_pool": "<POOL_ID>"
```

## Troubleshooting

**Health checks failing:**
- Ensure `/health` endpoint responds with HTTP 200
- Check firewall allows port 30120 from Cloudflare IPs
- Verify hosts are running and healthy

**Pool switching not working:**
- Verify API token has correct permissions
- Check LB_ID and Pool IDs are correct
- Review API response for errors

**DNS not resolving:**
- Make sure DNS record for your domain points to Cloudflare LB
- DNS type should be **CNAME** (or **A** if Cloudflare IP)
- Check DNS cache (may take 5-10 min to propagate)

## Reference

- Cloudflare Load Balancing Docs: https://developers.cloudflare.com/load-balancing/
- API Reference: https://developers.cloudflare.com/api/operations/load-balancer-list-load-balancers
