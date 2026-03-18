# Complete Deployment Setup Checklist

This is your step-by-step checklist for setting up the entire FiveM blue/green deployment infrastructure.

## Phase 1: Local Repository Setup ✅
- [x] Create git repository locally
- [x] Add all deployment infrastructure files
- [x] Commit initial version
- [x] Push to GitHub (SwipeDevUser/Fivem-server)
- [x] Generate SSH deployment key pair

## Phase 2: GitHub Configuration
- [ ] **Add GitHub Secrets** (Settings → Secrets → Actions):
  - [ ] `SSH_PRIVATE_KEY` — copy from `deploy_key` file
  - [ ] `SSH_USER` — e.g., `ubuntu` or `fxuser`
  - [ ] `BLUE_HOSTS` — comma-separated IP list
  - [ ] `GREEN_HOSTS` — comma-separated IP list
  - [ ] `CF_API_TOKEN` — Cloudflare API token
  - [ ] `CF_LOAD_BALANCER_ID` — from Cloudflare dashboard
  - [ ] `CF_BLUE_POOL_ID` — blue pool ID
  - [ ] `CF_GREEN_POOL_ID` — green pool ID
  - [ ] `MIGRATION_COMMAND` (optional) — DB migration script

- [ ] **Create GitHub Environments** (Settings → Environments):
  - [ ] `development` environment
  - [ ] `integration` environment
  - [ ] `staging` environment
  - [ ] `production` environment (with required reviewers)

## Phase 3: Cloudflare Setup
- [ ] Create Cloudflare health check (port 30120, path /health)
- [ ] Create BLUE pool with your blue host IPs
- [ ] Create GREEN pool with your green host IPs
- [ ] Create Load Balancer pointing to default pool (BLUE)
- [ ] Get and save `CF_LOAD_BALANCER_ID`
- [ ] Get and save `CF_BLUE_POOL_ID`
- [ ] Get and save `CF_GREEN_POOL_ID`
- [ ] Create Cloudflare API token (Load Balancer scope)
- [ ] Test pool switching manually (optional)
- [ ] Update GitHub Secrets with Cloudflare IDs

## Phase 4: Target Hosts Setup (for each BLUE and GREEN host)

### SSH Access
- [ ] Create/verify `fxuser` account on host
- [ ] Add SSH public key to `~/.ssh/authorized_keys`
- [ ] Set correct permissions: `chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys`
- [ ] Test SSH locally: `ssh -i deploy_key fxuser@<HOST_IP> "echo 'works'"`

### Directory Structure
- [ ] Create `/opt/fxserver/blue` directory
- [ ] Create `/opt/fxserver/green` directory
- [ ] Set ownership: `sudo chown -R fxuser:fxuser /opt/fxserver`
- [ ] Set permissions: `sudo chmod 750 /opt/fxserver`
- [ ] Create `/var/log/fxserver` directory
- [ ] Set log dir ownership: `sudo chown fxuser:fxuser /var/log/fxserver`

### Systemd Configuration
- [ ] Copy `systemd/fxserver@.service` to `/etc/systemd/system/`
- [ ] Run `sudo systemctl daemon-reload`
- [ ] Create/copy `start.sh` to `/opt/fxserver/blue/` and `/opt/fxserver/green/`
- [ ] Make `start.sh` executable: `sudo chmod +x /opt/fxserver/*/start.sh`
- [ ] Test blue service: `sudo systemctl start fxserver@blue`
- [ ] Test green service: `sudo systemctl start fxserver@green`
- [ ] Enable both services:
  - [ ] `sudo systemctl enable fxserver@blue`
  - [ ] `sudo systemctl enable fxserver@green`

### Health Check Endpoint
- [ ] Deploy health check server (or use FXServer's built-in endpoint)
- [ ] Verify endpoint responds: `curl http://127.0.0.1:30120/health`
- [ ] Ensure it returns HTTP 200 with JSON response

### Logging & Monitoring
- [ ] Setup Promtail (optional):
  - [ ] Install promtail binary
  - [ ] Copy `monitoring/promtail-config.yaml` to `/opt/promtail/`
  - [ ] Copy `systemd/promtail.service` to `/etc/systemd/system/`
  - [ ] Enable and start: `sudo systemctl enable --now promtail`
- [ ] Setup node_exporter (optional):
  - [ ] Install node_exporter binary
  - [ ] Enable systemd unit or create one
  - [ ] Verify metrics available at `http://localhost:9100/metrics`

## Phase 5: Testing & Validation

### Local SSH Testing
- [ ] Test SSH to BLUE host: `ssh -i deploy_key fxuser@<BLUE_IP> "whoami"`
- [ ] Test SSH to GREEN host: `ssh -i deploy_key fxuser@<GREEN_IP> "whoami"`
- [ ] Test SCP to BLUE: `scp -i deploy_key testfile fxuser@<BLUE_IP>:/tmp/`
- [ ] Verify FXServer directories accessible via SSH
- [ ] Test health endpoint: `curl http://<HOST_IP>:30120/health`

### GitHub Actions Testing
- [ ] Run `SSH Connection Test` workflow manually
- [ ] Check Actions logs for successful SSH connection
- [ ] Verify test can access `/opt/fxserver` directories
- [ ] Confirm health endpoint is reachable from Actions

### Deployment Testing
- [ ] Create test branch: `git checkout -b feature/deployment-test develop`
- [ ] Make a minor change (e.g., package.json version)
- [ ] Push to feature branch: `git push origin feature/deployment-test`
- [ ] Watch GitHub Actions workflow run
- [ ] Monitor deployment logs for success
- [ ] Verify artifact deployed to GREEN hosts
- [ ] Test health check still responds
- [ ] Manually switch Cloudflare pool (optional test)
- [ ] Verify traffic routing to new pool

### Smoke Tests
- [ ] Connect to FXServer on BLUE hosts
- [ ] Connect to FXServer on GREEN hosts
- [ ] Test in-game functionality
- [ ] Check logs for errors: `sudo journalctl -u fxserver@blue -n 50`

## Phase 6: Documentation & Runbooks
- [ ] Review and bookmark:
  - [ ] [README.md](../README.md) — Overview & branching strategy
  - [ ] [docs/SECRETS_SETUP.md](SECRETS_SETUP.md) — GitHub Secrets configuration
  - [ ] [docs/CLOUDFLARE_SETUP.md](CLOUDFLARE_SETUP.md) — Cloudflare LB setup
  - [ ] [docs/SSH_TESTING.md](SSH_TESTING.md) — SSH troubleshooting
  - [ ] [docs/FXSERVER_SYSTEMD_SETUP.md](FXSERVER_SYSTEMD_SETUP.md) — Systemd configuration
- [ ] Create team documentation with your environment details
- [ ] Document custom start scripts and health endpoints
- [ ] Document backup/restore procedures

## Phase 7: Production Readiness
- [ ] Configure GitHub required reviewers for production environment
- [ ] Set up Slack/email notifications for deployment events (optional)
- [ ] Create incident response playbook for failed deployments
- [ ] Document rollback procedure
- [ ] Test rollback manually:
  - [ ] Deploy to GREEN
  - [ ] Switch Cloudflare to GREEN
  - [ ] Switch back to BLUE
  - [ ] Verify both pools respond to health checks
- [ ] Schedule team training on deployment procedures
- [ ] Document on-call procedures

## Phase 8: Monitoring & Maintenance
- [ ] Setup Prometheus scraping (if monitoring enabled)
- [ ] Setup Grafana dashboards (if monitoring enabled)
- [ ] Configure alerts for:
  - [ ] Health check failures
  - [ ] Deployment failures
  - [ ] High resource usage
  - [ ] FXServer crashes
- [ ] Schedule log rotation: `/var/log/fxserver/*.log`
- [ ] Document backup strategy for database

## Troubleshooting Quick Links

If something isn't working:

| Issue | Reference |
|-------|-----------|
| SSH connection fails | [SSH_TESTING.md](SSH_TESTING.md#common-ssh-errors--fixes) |
| Health endpoint not responding | [FXSERVER_SYSTEMD_SETUP.md](FXSERVER_SYSTEMD_SETUP.md#troubleshooting) |
| Systemd service won't start | Run `scripts/diagnose-deployment.sh` on host |
| Cloudflare pool not switching | [CLOUDFLARE_SETUP.md](CLOUDFLARE_SETUP.md#troubleshooting) |
| GitHub Actions workflow failing | Check Actions logs → Step output |
| Deployment not reaching hosts | Check SSH_PRIVATE_KEY secret & host SSH access |

## One-Time Commands for Reference

```bash
# Setup BLUE host
ssh -i deploy_key ubuntu@10.0.0.5 << 'EOF'
sudo useradd -r -d /opt/fxserver -s /bin/false fxuser
sudo mkdir -p /opt/fxserver/blue /opt/fxserver/green /var/log/fxserver
sudo chown -R fxuser:fxuser /opt/fxserver /var/log/fxserver
sudo cp systemd/fxserver@.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable fxserver@blue fxserver@green
EOF

# Setup GREEN host (same commands, different IP)
ssh -i deploy_key ubuntu@10.0.0.7 << 'EOF'
# ... (repeat above)
EOF

# Test SSH from GitHub Actions (run this in your Actions workflow)
ssh -o StrictHostKeyChecking=no -i ~/.ssh/deploy_key $SSH_USER@$BLUE_HOSTS "echo 'SSH works!'"

# Test pool switch via Cloudflare API
curl -X PATCH "https://api.cloudflare.com/client/v4/user/load_balancers/$CF_LOAD_BALANCER_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -d "{\"default_pool\": \"$CF_GREEN_POOL_ID\"}"
```

## Sign-Off

- [ ] All checks completed
- [ ] No outstanding issues
- [ ] Team trained on procedures
- [ ] Ready for first production deployment

**Last Updated**: [Add date]
**Prepared By**: [Add name]
