# my-app (sample)

This repository contains a minimal Node.js application plus Kubernetes manifests and a GitHub Actions workflow that demonstrates a build → staging → production pipeline with blue/green/rollback-ready deployment.

Git Branching Strategy (GitFlow variant)
----------------------------------------

This project uses the following branching strategy with automatic environment routing:

| Branch | Environment | Deploy Target | Purpose |
|--------|-------------|-----------------|---------|
| `main` | production | Production (Blue/Green) | Live user traffic |
| `release` | staging | Staging (Blue/Green) | QA & acceptance testing |
| `develop` | integration | Integration | Feature integration testing |
| `feature/*` | development | Development | Individual feature development |
| `hotfix/*` | *skipped* | Manual emergency deploy | Critical production fixes |

Workflow triggers:
- **feature/*** branches: Build & deploy to *development* environment for testing
- **develop**: Merge features here; auto-deploys to *integration*
- **release**: Create release branch from develop; auto-deploys to *staging* for QA
- **main**: Merge release → main; auto-deploys to *production* with manual approval gate
- **hotfix/\***: Branches directly from main for emergency fixes; requires manual promotion to production

For hotfix workflow:
1. Create branch: `git checkout -b hotfix/critical-issue main`
2. Fix and commit
3. Test in dev/staging manually (CI will skip auto-deploy for hotfix/*)
4. When ready: merge to main and run GitHub Action manually to deploy to production

Quick commands:

```powershell
npm install
npm start
docker build -t my-app:local .
```

Adjust `k8s/deployment.yaml` and the GitHub Actions workflow for your cluster, registry, and secrets.

Deployment runbook (Blue/Green VM)
---------------------------------

1. Prepare hosts
	 - Ensure each host has a user matching `fxuser` (or update `systemd/fxserver@.service`).
	 - Place your FXServer `start.sh` and config under `/opt/fxserver/blue` and `/opt/fxserver/green` respectively after first deploy.

2. Required GitHub Secrets (repository Settings → Secrets → Actions):
	 - `SSH_PRIVATE_KEY` — private key for the deploy user
	 - `SSH_USER` — SSH username (e.g., `fxuser`)
	 - `BLUE_HOSTS` — comma-separated host list for blue pool (e.g., `10.0.0.5,10.0.0.6`)
	 - `GREEN_HOSTS` — comma-separated host list for green pool
	 - `CF_API_TOKEN` — Cloudflare API token with Load Balancer permissions
	 - `CF_LOAD_BALANCER_ID` — Cloudflare load balancer id
	 - `CF_GREEN_POOL_ID` / `CF_BLUE_POOL_ID` — pool ids for each color
	 - `MIGRATION_COMMAND` (optional) — command to run DB migrations on a primary host
   
   **Environment-specific secrets** (optional, for multi-env setups):
   - Create GitHub Environments for each: `development`, `integration`, `staging`, `production`
   - In each environment's settings, you can override `SSH_PRIVATE_KEY`, `BLUE_HOSTS`, `GREEN_HOSTS`, etc. per environment
   - If not overridden, the repo-level secrets are used as fallback
   
   **Getting SSH_PRIVATE_KEY:**
   
   Generate a new SSH key pair on your local machine:
   
   ```bash
   ssh-keygen -t rsa -b 4096 -f deploy_key -N ""
   cat deploy_key  # Copy this full output to SSH_PRIVATE_KEY secret
   # Add deploy_key.pub to ~/.ssh/authorized_keys on each target host
   ```

- To test locally (without GitHub Actions):

```powershell
# Build artifact
zip -r out/artifact.zip . -x .git\* .github\* node_modules\*

# Copy to a host (example)
scp -i C:\keys\deploy_key out/artifact.zip fxuser@10.0.0.5:/tmp/artifact.zip
ssh -i C:\keys\deploy_key fxuser@10.0.0.5 'sudo systemctl stop fxserver@green || true; unzip -o /tmp/artifact.zip -d /opt/fxserver/green-new; sudo mv -T /opt/fxserver/green-new /opt/fxserver/green; sudo systemctl start fxserver@green'
```

- To test in GitHub Actions: set the secrets above and run the workflow manually. Monitor the Actions run log for each step and watch the smoke test results.

3. Automated Deployment by Branch:

   When you push to any of the configured branches, the appropriate workflow triggers automatically:
   
   - **Push to `main`** → Triggers `deploy.yml` and `deploy-vm.yml` → deploys to **production** with manual approval gate
   - **Push to `release`** → deploys to **staging** for QA testing
   - **Push to `develop`** → deploys to **integration** for team validation
   - **Push to `feature/**` → deploys to **development** environment
   - **Push to `hotfix/**` → CI skips auto-deploy; use **Hotfix Emergency Deploy** workflow instead
   
   For **manual hotfix emergency deploy**:
   1. Go to GitHub Actions tab
   2. Select **Hotfix Emergency Deploy** workflow
   3. Click **Run workflow**
   4. Choose target environment (`production` or `staging`)
   5. Monitor the run and verify smoke tests pass
   6. After deployment: manually switch Cloudflare pool if needed

Logging & Metrics (sample)
--------------------------

You can run a small monitoring stack to collect metrics and logs. Example files are provided under `monitoring/`.

**Local monitoring setup (docker-compose):**

```bash
cd monitoring
docker-compose -f loki-docker-compose.yml up -d
# This starts Loki (log aggregation) and Promtail (log shipper)
# Access Loki at http://127.0.0.1:3100
```

**On each FXServer host (production):**

1. Install Promtail and node_exporter:
   ```bash
   wget https://github.com/grafana/loki/releases/download/v2.8.2/promtail-linux-amd64.zip
   unzip promtail-linux-amd64.zip
   sudo mv promtail-linux-amd64 /usr/bin/promtail
   
   # node_exporter for system metrics
   wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
   tar xzf node_exporter-1.5.0.linux-amd64.tar.gz
   sudo cp node_exporter-1.5.0.linux-amd64/node_exporter /usr/bin/
   ```

2. Copy Promtail config and systemd unit:
   ```bash
   sudo cp monitoring/promtail-config.yaml /opt/promtail/
   sudo cp systemd/promtail.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable --now promtail.service
   sudo systemctl enable --now node_exporter.service
   ```

3. Configure Prometheus to scrape your hosts (see `monitoring/prometheus.yml`):
   ```yaml
   scrape_configs:
     - job_name: 'fxserver-blue'
       static_configs:
         - targets: ['10.0.0.5:30120','10.0.0.6:30120']
     - job_name: 'fxserver-green'
       static_configs:
         - targets: ['10.0.0.7:30120','10.0.0.8:30120']
     - job_name: 'node'
       static_configs:
         - targets: ['10.0.0.5:9100','10.0.0.6:9100','10.0.0.7:9100','10.0.0.8:9100']
   ```

**Grafana dashboards:**

The dashboard provisioning files are in `monitoring/grafana/provisioning/`. Import the example dashboard:

```bash
curl -X POST http://127.0.0.1:3000/api/dashboards/db \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <grafana-api-token>" \
  -d @monitoring/grafana/dashboards/fxserver-overview.json
```

- Datasources (Prometheus + Loki) are auto-provisioned via `monitoring/grafana/provisioning/datasources/datasources.yml`.
- Customize or add dashboards in `monitoring/grafana/dashboards/`.
