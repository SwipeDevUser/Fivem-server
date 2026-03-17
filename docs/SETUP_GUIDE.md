# 🚀 FiveM Blue/Green Deployment Infrastructure — Complete Setup Guide

**Repository**: https://github.com/SwipeDevUser/Fivem-server

This is your master guide to the complete blue/green deployment system for FiveM servers. It integrates CI/CD workflows, GitFlow branching, Cloudflare load balancing, and systemd-based service management.

## 📋 Architecture Overview

```
Developer
    ↓
GitHub (main/release/develop/feature/hotfix branches)
    ↓
GitHub Actions (Build → Test → Deploy)
    ↓
SSH to BLUE/GREEN hosts
    ↓
Systemd service start/restart
    ↓
Cloudflare Load Balancer (switch pool)
    ↓
Database + Redis + Logs (Loki/Prometheus)
```

## 📚 Documentation Map

### Getting Started
1. **[Deployment Checklist](DEPLOYMENT_CHECKLIST.md)** ← **START HERE**
   - Complete step-by-step checklist for all setup phases
   - One checkbox for each task

### Reference Guides
2. **[Secrets Setup](SECRETS_SETUP.md)**
   - How to generate SSH keys
   - GitHub Secrets configuration
   - Environment-specific secrets

3. **[Cloudflare Setup](CLOUDFLARE_SETUP.md)**
   - Create health checks, pools, load balancers
   - Get Cloudflare IDs for GitHub Secrets
   - Test API pool switching
   - Troubleshooting Cloudflare issues

4. **[SSH Testing](SSH_TESTING.md)**
   - Local SSH connection tests
   - GitHub Actions SSH verification
   - Common SSH errors & fixes
   - Diagnostic command reference

5. **[FXServer Systemd Setup](FXSERVER_SYSTEMD_SETUP.md)**
   - Create fxuser account
   - Setup directory structure
   - Install systemd unit templates
   - Create health check endpoint
   - Manage services

### Tools & Helpers
6. **Scripts in `scripts/`**:
   - `generate-deploy-key.ps1` — Generate SSH key pair (Windows PowerShell)
   - `diagnose-deployment.sh` — Run on target hosts to verify setup (bash)

### Workflow Reference
7. **[README.md](../README.md)**
   - Git branching strategy
   - How deployments are triggered
   - Testing locally
   - Rollback procedures

## 🎯 Quick Start (5 Minutes)

If you already have:
- ✅ Git repository set up
- ✅ SSH keys generated
- ✅ Target hosts ready

Jump to: [Deployment Checklist Phase 2](DEPLOYMENT_CHECKLIST.md#phase-2-github-configuration)

## 🔧 Do This First

### 1. Generate SSH Keys
```powershell
cd "c:\Users\elias\Documents\FiveM Development\fivem-server"
# SSH keys already exist at: ./deploy_key and ./deploy_key.pub
cat deploy_key       # Copy to GitHub Secret 'SSH_PRIVATE_KEY'
cat deploy_key.pub   # Copy to ~/.ssh/authorized_keys on each host
```

### 2. Setup Target Hosts (one-time)
Run these on each BLUE and GREEN host:
```bash
# SSH into host
ssh -i deploy_key ubuntu@10.0.0.5

# Run these commands (as root or with sudo)
sudo useradd -r -d /opt/fxserver -s /bin/false fxuser
sudo mkdir -p /opt/fxserver/blue /opt/fxserver/green /var/log/fxserver
sudo chown -R fxuser:fxuser /opt/fxserver /var/log/fxserver
sudo cp systemd/fxserver@.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable fxserver@blue fxserver@green

# Add public key
sudo mkdir -p /home/fxuser/.ssh
echo "ssh-rsa AAAA..." | sudo tee -a /home/fxuser/.ssh/authorized_keys
sudo chmod 700 /home/fxuser/.ssh
sudo chmod 600 /home/fxuser/.ssh/authorized_keys
sudo chown -R fxuser:fxuser /home/fxuser/.ssh
```

### 3. Add GitHub Secrets
Go to: https://github.com/SwipeDevUser/Fivem-server/settings/secrets/actions

Add these 8 secrets:
```
SSH_PRIVATE_KEY=     [from deploy_key file]
SSH_USER=            ubuntu
BLUE_HOSTS=          10.0.0.5,10.0.0.6
GREEN_HOSTS=         10.0.0.7,10.0.0.8
CF_API_TOKEN=        [from Cloudflare]
CF_LOAD_BALANCER_ID= [from Cloudflare]
CF_BLUE_POOL_ID=     [from Cloudflare]
CF_GREEN_POOL_ID=    [from Cloudflare]
```

### 4. Test SSH Connection
Go to GitHub Actions → **SSH Connection Test** → **Run workflow**

If successful ✅, move to next step.

## 📊 Deployment Flow by Branch

```
feature/my-feature
    ↓ (push)
Build artifact → Deploy to DEVELOPMENT env
    
develop (merge feature)
    ↓ (push)
Build artifact → Deploy to INTEGRATION env
    
release/1.0.0 (from develop)
    ↓ (push)
Build artifact → Deploy to STAGING env → QA tests
    
main (merge release)
    ↓ (push)
Build artifact → Deploy to PRODUCTION (approval required)
    → Health checks → Switch load balancer
    → Health checks → Verify endpoints
    → Rollback on failure
    
hotfix/critical-bug (from main)
    ↓ (push)
CI skips auto-deploy
    → Manual: GitHub Actions → Hotfix Emergency Deploy
    → Choose environment
    → Deploy to BLUE (current)
    → Manual pool switch required
```

## 🧪 Testing Checklist

Before first production deployment:

```bash
# 1. Test SSH locally
ssh -i deploy_key fxuser@10.0.0.5 "echo 'SSH works'"

# 2. Test deployment artifact creation
zip -r artifact.zip . -x '.git/*' '.github/*' 'node_modules/*'

# 3. Test artifact extraction on host
scp -i deploy_key artifact.zip fxuser@10.0.0.5:/tmp/
ssh -i deploy_key fxuser@10.0.0.5 "unzip -t /tmp/artifact.zip | head -10"

# 4. Test systemd service
ssh -i deploy_key fxuser@10.0.0.5 "sudo systemctl status fxserver@blue"

# 5. Test health endpoint
curl -s http://10.0.0.5:30120/health

# 6. Test GitHub Actions workflow (safe branch)
git checkout -b test/deploy-test develop
git push origin test/deploy-test
# Monitor Actions logs
```

## 📲 Monitoring & Alerts

### Health Checks
- Cloudflare automatically checks `/health` endpoint every 10 seconds
- Removes unhealthy hosts from pool
- Triggers metrics in Prometheus (if enabled)

### Logs
- Systemd logs: `sudo journalctl -u fxserver@blue -f`
- FXServer logs: `/var/log/fxserver/blue.log` (if configured)
- Deployment logs: GitHub Actions → Workflow run

### Metrics (Optional)
- Prometheus: Scrapes FXServer & node_exporter (if enabled)
- Grafana: Available dashboards at `http://monitoring-host:3000`
- Sample dashboard: `monitoring/grafana/dashboards/fxserver-overview.json`

## 🚨 Troubleshooting

| Problem | Solution |
|---------|----------|
| SSH connection denied | See [SSH_TESTING.md](SSH_TESTING.md#error-permission-denied-publickey) |
| Systemd service won't start | Run `scripts/diagnose-deployment.sh blue` on host |
| Health endpoint returns 503 | Check FXServer is running: `systemctl status fxserver@blue` |
| Cloudflare pool not switching | Verify `CF_LOAD_BALANCER_ID` and API token permissions |
| GitHub Actions fails | Check Actions logs for each step (SSH, deployment, health check) |
| Rollback needed | Switch Cloudflare pool back to BLUE or run manual hotfix |

## 📖 Common Commands

```bash
# Check deployment user setup
ssh -i deploy_key fxuser@10.0.0.5 "id"

# View FXServer systemd unit
sudo cat /etc/systemd/system/fxserver@.service

# Start FXServer service
sudo systemctl start fxserver@blue

# View real-time logs
sudo journalctl -u fxserver@blue -f

# Check port is listening
ss -tlnp | grep 30120

# Manually switch Cloudflare pool
bash deploy/switch-pool.sh <LB_ID> <POOL_ID>

# Run diagnostics on host
bash scripts/diagnose-deployment.sh blue
```

## 🔐 Security Best Practices

1. **SSH Keys**
   - Keep `deploy_key` (private) secret — store only in GitHub Secrets
   - Rotate keys annually
   - Use different keys per environment if needed

2. **Cloudflare API Token**
   - Use minimal permissions (Load Balancer only)
   - Rotate tokens regularly
   - Enable IP restrictions if possible

3. **GitHub Secrets**
   - Never commit secrets
   - Use separate secrets per environment
   - Audit secret usage in Actions logs

4. **Systemd Services**
   - Run under `fxuser` (non-root)
   - Use `RestartSec=10` to prevent rapid restart loops
   - Monitor for unexpected crashes

5. **Database**
   - Use backward-compatible migrations
   - Test migrations in staging first
   - Keep backups before production deployments

## 📞 Support & Contact

- **Repository Issues**: https://github.com/SwipeDevUser/Fivem-server/issues
- **GitHub Docs**: https://docs.github.com/actions
- **Cloudflare Docs**: https://developers.cloudflare.com/load-balancing/
- **Systemd Docs**: https://www.freedesktop.org/software/systemd/man/systemd.service.html

## 🎓 Next Steps

1. ✅ Read [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
2. ✅ Follow setup phases in order
3. ✅ Run diagnostic script (`diagnose-deployment.sh`) on each host
4. ✅ Test SSH connections locally
5. ✅ Add GitHub Secrets
6. ✅ Test workflow on safe branch (feature or develop)
7. ✅ Perform dry-run deployment to staging
8. ✅ Verify rollback procedure works
9. ✅ Document team procedures
10. ✅ Schedule first production deployment

---

**Version**: 1.0
**Last Updated**: March 17, 2026
**Repository**: https://github.com/SwipeDevUser/Fivem-server

**Ready to deploy?** Start with [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) →
