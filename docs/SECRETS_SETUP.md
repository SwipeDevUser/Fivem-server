# GitHub Secrets & Environments Setup Guide

This guide walks you through setting up GitHub Secrets and Environments for the FiveM blue/green deployment pipeline.

## Step 1: Generate SSH Deploy Key

Run this PowerShell script to generate your SSH key pair:

```powershell
$env:PATH = "C:\Users\elias\AppData\Local\Programs\Git\bin;C:\Users\elias\AppData\Local\Programs\Git\cmd;" + $env:PATH
cd "c:\Users\elias\Documents\FiveM Development\fivem-server"
.\scripts\generate-deploy-key.ps1
```

This will create:
- `deploy_key` (private key) — copy to GitHub Secrets
- `deploy_key.pub` (public key) — copy to server `~/.ssh/authorized_keys`

## Step 2: Create GitHub Environments

1. Go to https://github.com/SwipeDevUser/Fivem-server/settings/environments
2. Click **New environment**
3. Create these 4 environments:

| Environment | Required Reviewers | Purpose |
|-------------|-------------------|---------|
| `development` | No | Feature branches & development |
| `integration` | No | Develop branch testing |
| `staging` | Optional | Release branch QA |
| `production` | **YES** (add yourself) | Main branch live deploy |

For `production`: Check "Required reviewers" and add your GitHub username.

## Step 3: Add Repository Secrets

Go to https://github.com/SwipeDevUser/Fivem-server/settings/secrets/actions

Click **New repository secret** for each:

### Core Secrets (Required for all environments)

| Secret Name | Example Value | Notes |
|-----------|-------------|-------|
| `SSH_PRIVATE_KEY` | (multiline) | Output from `generate-deploy-key.ps1` |
| `SSH_USER` | `ubuntu` or `fxuser` | Deployment user on target hosts |
| `BLUE_HOSTS` | `10.0.0.5,10.0.0.6` | Comma-separated IPs/hostnames |
| `GREEN_HOSTS` | `10.0.0.7,10.0.0.8` | Comma-separated IPs/hostnames |

### Cloudflare Secrets (if using Cloudflare LB)

| Secret Name | How to Find | Notes |
|-----------|-----------|-------|
| `CF_API_TOKEN` | Cloudflare Dashboard → API Tokens → Create Token (scope: Load Balancer) | Keep secure! |
| `CF_LOAD_BALANCER_ID` | Cloudflare Dashboard → Load Balancing → Click LB → Settings (in URL bar) | Format: `<zone_id>:<lb_id>` |
| `CF_BLUE_POOL_ID` | Cloudflare Load Balancing → Pools → Click Blue Pool → ID in URL or overview | e.g., `abc123def456` |
| `CF_GREEN_POOL_ID` | Cloudflare Load Balancing → Pools → Click Green Pool → ID | e.g., `xyz789uvw456` |

### Optional Secrets

| Secret Name | Example | Notes |
|-----------|---------|-------|
| `MIGRATION_COMMAND` | `/opt/scripts/migrate-db.sh` | Leave blank if no DB migrations needed |

## Step 4: Environment-Specific Secrets (Optional)

If your **staging** and **production** environments use **different host IPs**, override secrets per environment:

1. Go to Environment (e.g., https://github.com/SwipeDevUser/Fivem-server/settings/environments/production)
2. Click **Add environment secret**
3. Override `BLUE_HOSTS`, `GREEN_HOSTS`, `CF_BLUE_POOL_ID`, etc. for that environment

Example:
- **production** environment: `BLUE_HOSTS = 192.168.1.5,192.168.1.6`
- **staging** environment: `BLUE_HOSTS = 10.0.1.5,10.0.1.6`

## Step 5: Configure Target Hosts

On each BLUE and GREEN host (VMs running FXServer):

```bash
# Create fxuser (if not exists)
sudo useradd -m -s /bin/bash fxuser

# Create .ssh directory
sudo mkdir -p /home/fxuser/.ssh
sudo chmod 700 /home/fxuser/.ssh

# Add public key to authorized_keys
# (Copy the deploy_key.pub content and paste:)
echo "[PASTE_deploy_key.pub_HERE]" | sudo tee -a /home/fxuser/.ssh/authorized_keys
sudo chmod 600 /home/fxuser/.ssh/authorized_keys
sudo chown -R fxuser:fxuser /home/fxuser/.ssh

# Create FXServer directories
sudo mkdir -p /opt/fxserver/blue /opt/fxserver/green
sudo chown -R fxuser:fxuser /opt/fxserver

# Test SSH access
ssh -i deploy_key fxuser@10.0.0.5 "echo 'SSH works!'"
```

## Step 6: Verify Configuration

Run a test deployment to verify secrets are working:

1. Go to GitHub → Actions → select `Build & Blue/Green Deploy (VMs)`
2. Click **Run workflow**
3. Select branch `develop` (safer for first test)
4. Monitor logs for SSH connection and deployment success

## Troubleshooting

**SSH Connection Refused:**
- Verify `SSH_PRIVATE_KEY` is the **private key** (starts with `-----BEGIN RSA PRIVATE KEY-----`)
- Verify `SSH_USER` matches the username on target hosts
- Verify public key is in `~/.ssh/authorized_keys` on target hosts
- Check firewall allows SSH (port 22)

**Cloudflare Pool Switch Not Working:**
- Verify `CF_API_TOKEN` has Load Balancer write permissions
- Verify `CF_LOAD_BALANCER_ID` is correct (copy from dashboard URL)
- Check API token hasn't expired

**Deployment Appears to Execute but No Changes:**
- Verify `/opt/fxserver/blue` and `/opt/fxserver/green` directories exist and are writable
- Check systemd unit file: `sudo systemctl status fxserver@blue`
- Review deploy logs: `sudo journalctl -u fxserver@blue -n 50`

## Next: Test a Deployment

Once secrets are configured:

1. Create a feature branch:
   ```bash
   git checkout -b feature/test-deploy develop
   ```

2. Make a minor change (e.g., update `package.json` version)

3. Commit and push:
   ```bash
   git add .
   git commit -m "Test deployment"
   git push origin feature/test-deploy
   ```

4. Go to GitHub Actions → Monitor the workflow run
5. Check deployment logs and target host for changes

---

For detailed deployment runbook, see [README.md](../README.md)
