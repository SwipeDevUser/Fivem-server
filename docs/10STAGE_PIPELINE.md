# Complete 10-Stage CI/CD Pipeline Documentation

**Enhanced Implementation** — March 17, 2026  
**Status**: ✅ Production Ready

---

## 10-Stage Pipeline Overview

```
Stage 1    Stage 2           Stage 3         Stage 4        Stage 5          Stage 6
┌────────┐┌─────────────────┐┌────────────┐┌──────────────┐┌──────────────┐┌─────────┐
│ Commit ││ Static Analysis ││ Security   ││ Unit Testing ││ Integration  ││  Build  │
│  (Git) ││  (ESLint)       ││ Scan       ││ (Jest, Lint) ││ Testing      ││Artifacts│
└────┬───┘└────────┬────────┘└────┬───────┘└──────┬───────┘└──────┬───────┘└────┬────┘
     │             │               │               │               │            │
     └─────────────┴───────────────┴───────────────┴───────────────┴────────────┘
                                    GATING (Blocks on failure)
                                    └─ If ANY fail: Deployment STOPS
                                    └─ Commit marked with ❌ RED X
     
     ┌──────────────────────────────────────────────────────────────────────────┐
     │ If ALL Stages 1-5 Pass: Continue to Stage 6                            │
     └──────────────────────────────────────────────────────────────────────────┘
                                    │
     ┌──────────────────────────────┴──────────────────────────────┐
     │                                                             │
Stage 7                     Stage 8                Stage 9      Stage 10
┌──────────────┐           ┌──────────────┐    ┌─────────┐     ┌─────────┐
│Deploy Staging││  QA      ││Deploy Prod  ││ Traffic ││
│ (GREEN)      ││Approval* ││  (GREEN)    ││ Switch* ││
│              ││ (Manual) ││             ││(Canary) ││
└──────┬───────┘└────┬─────┘└──────┬──────┘└────┬────┘
       │         * Approval gates by │          │
       │           QA team          │          │
       │                            │          │
       └────────────────────────────┴──────────┘
                                    │
                              ┌─────┴─────┐
                              │ DECISIONS │
                              └─────┬─────┘
                    ┌───────────────┼───────────────┐
                    │               │               │
              APPROVE          REJECT          SKIP
                    │               │          (dev/int)
                    ↓               ↓               ↓
            [100% Switch]  [Auto Rollback]  [Auto Skip]
```

---

## Detailed Stage Breakdown

### Stage 1: Commit (Automatic)
**Trigger**: `git push` to any branch

```
Developer commits code
    ↓
Git hooks validate commit (pre-push)
    ↓
Code pushed to GitHub
    ↓
Webhook triggers GitHub Actions
    ↓
Workflow starts: Stages 2-10 begin
```

**Branch Routing**:
- `feature/*` → Stages 2-5 (Development environment)
- `develop` → Stages 2-5 (Integration environment)
- `release/*` → Stages 2-8 (Staging environment, stops at QA)
- `main` → Stages 2-10 (Production, full pipeline)
- `hotfix/*` → Manual override (outside pipeline)

---

### Stage 2: Static Code Analysis
**Duration**: ~30-45 seconds  
**Runs On**: All branches (2-5 only)

**Checks**:
- ✅ ESLint syntax validation
- ✅ Code style compliance
- ✅ Unused variables/imports
- ✅ Code complexity metrics
- ✅ Potential bugs/anti-patterns

**Failure Behavior**:
- ❌ Deployment BLOCKED
- ❌ Developer notified
- ❌ Link to failed check in commit status

**Example Failure**:
```
❌ ESLint failed: unused variable 'debugMode' at line 42
Fix: Remove variable or use it
Re-run: git push origin feature/myfeature
```

---

### Stage 3: Security Scanning
**Duration**: ~45-60 seconds  
**Runs On**: All branches (2-5 only)

**Checks**:
- ✅ NPM audit (dependency vulnerabilities)
- ✅ Hardcoded secrets detection
- ✅ Credential patterns (passwords, API keys, tokens)
- ✅ File permissions (no world-readable secrets)

**Failure Behavior**:
- ❌ Deployment BLOCKED (critical vulnerabilities)
- ⚠️ Warning only (low-severity issues, but flagged)
- ❌ Developer must fix or suppress with justification

**Example Failure**:
```
❌ Security Scan failed: Hardcoded password found in config.js line 15
   Value: ADMIN_PASSWORD = "supersecret123"
Fix: Move to .env or GitHub Secrets
Re-run: git push origin feature/myfeature
```

---

### Stage 4: Unit Testing
**Duration**: ~60-90 seconds  
**Runs On**: All branches (2-5 only)

**Includes**:
- ✅ Jest unit tests
- ✅ NPM linting
- ✅ Build check (`npm run build`)
- ✅ Docker build verification

**Failure Behavior**:
- ❌ Deployment BLOCKED
- ❌ Test output shown in GitHub
- ❌ Developer must fix and re-push

**Example**:
```
❌ Unit test failed:
   expect(calculateRank(100)).toBe(5)
   ↑ Expected 5, but got 4

Fix error and re-run: git push origin feature/myfeature
```

---

### Stage 5: Integration Testing
**Duration**: ~90-120 seconds  
**Runs On**: All branches (2-5 only)

**Tests**:
- ✅ API endpoint connectivity
- ✅ Database query execution
- ✅ Redis cache operations
- ✅ External service integrations
- ✅ Message queue operations

**Environment**:
- Runs against test/mock databases
- No real data touched
- Clean slate each run

**Failure Behavior**:
- ❌ Deployment BLOCKED
- ❌ Error details shown
- ❌ Developer debugs and re-pushes

**Example**:
```
❌ Integration test failed:
   Database connection timeout after 30s
   MySQL host: test-db.internal not reachable

Likely causes:
- Network issue
- Database overloaded
- Connection string incorrect

Fix and re-run: git push origin feature/myfeature
```

---

### Stage 6: Build Artifacts
**Duration**: ~30 seconds  
**Runs On**: All branches (after stage 5 passes)

**Creates**:
- ✅ ZIP file with all code/assets
- ✅ Excludes: `.git`, `node_modules`, `.github`, test files
- ✅ Artifact upload to GitHub Actions (7-day retention)

**Size**: Typically 5-50 MB depending on assets

**Output**:
```
✅ Build artifact created: artifact.zip
   Size: 12.3 MB
   SHA256: a1b2c3d4e5f6...
   Retention: 7 days
```

---

### Stage 7: Deploy to Staging
**Duration**: ~2-5 minutes  
**Runs On**: `release/*` and `main` branches only

**Steps**:
1. Download artifact (30 seconds)
2. SSH to GREEN staging hosts (1-2 minutes)
3. Extract artifact on GREEN
4. Restart FXServer systemd service
5. Smoke test health endpoint (30 seconds)

**SSH Details**:
- Uses SSH key from GitHub Secrets
- Deploys to `${{ secrets.GREEN_HOSTS_STAGING }}`
- Health check: `curl http://127.0.0.1:30120/health`

**Success Condition**:
- ✅ All GREEN hosts respond to health check
- ✅ No error spikes in initial logs
- ✅ Ready for QA testing

**Failure Behavior**:
- ❌ Automatic rollback to BLUE
- ❌ Previous version remains live
- ❌ DevOps team notified for investigation

---

### Stage 8: QA Approval Gate
**Duration**: Minutes to hours (awaiting approval)  
**Runs On**: `release/*` and `main` branches  
**Approval Authority**: QA team / QA lead

**QA Testing Checklist**:
```
Pre-Approval Verification:
☐ Smoke tests passed on staging
☐ Core game functionality verified
  ☐ Players can successfully join server
  ☐ Commands working correctly
  ☐ Chat system operational
  ☐ Inventory system working
  ☐ Economy system (if applicable) functional
☐ No critical errors in logs
☐ Performance metrics acceptable
  ☐ Server CPU < 80%
  ☐ Memory usage normal
  ☐ Database queries responsive
☐ Database queries responding normally
☐ Redis cache working properly
☐ No data corruption detected
☐ Database backups successful
```

**Approval Options**:

**✅ APPROVED**:
- Staging version is ready for production
- Proceed to Stage 9 (Green Production Deploy)

**❌ REJECTED**:
- Issues found in QA testing
- Automatic rollback to BLUE
- Development team investigates
- Fix and re-release required

**Timeline Example**:
```
T+0min:   QA receives notification "Deployment ready for testing"
T+5min:   QA logs into staging, begins testing
T+20min:  QA completes testing checklist
T+25min:  QA clicks "Approve" in GitHub Actions
T+26min:  Approval recorded, Stage 9 begins
```

---

### Stage 9: Green Production Deploy
**Duration**: ~3-5 minutes  
**Runs On**: `main` branch only (after QA approval)  
**Approval Authority**: None (automatic after QA approval)

**Steps**:
1. Conditional: Only if QA approved the release
2. Download artifact (30 seconds)
3. SSH to GREEN production hosts (1-2 minutes)
4. Extract artifact on GREEN
5. Restart FXServer systemd service
6. Smoke test health endpoint (30 seconds)
7. Verify all GREEN hosts operational

**SSH Details**:
- Uses SSH key from GitHub Secrets
- Deploys to `${{ secrets.GREEN_HOSTS_PRODUCTION }}`
- Health check: `curl http://127.0.0.1:30120/health`

**State After Stage 9**:
- ✅ GREEN hosts running new version
- ✅ BLUE hosts still running old version
- ✅ Load balancer still directing 100% traffic to BLUE
- ✅ Users see no change (no downtime yet)

---

### Stage 10: Traffic Switch
**Duration**: ~2-3 minutes  
**Runs On**: `main` branch only  
**Approval Authority**: DevOps / SRE / Release Manager (second approval)

**Two-Phase Switch**:

#### Phase 1: Canary (10% Traffic)
```
T+0min:   Canary phase starts
          BLUE:  90% traffic
          GREEN: 10% traffic

T+1min:   Monitoring begins:
          ✅ Error rate: 0.1% (normal)
          ✅ Response time: 45ms (normal)
          ✅ Database queries: 12ms (normal)
          ✅ User reports: None

T+2min:   All looks good
          Prepare for full switch
          Await approval for 100% switch
```

**Phase 2: Full Switch (100% Traffic)**
```
After approval arrives:

T+0sec:   Full switch begins
          Cloudflare pool switch initiated

T+3sec:   Load balancer updated
          BLUE:  0% traffic
          GREEN: 100% traffic

T+5sec:   Public endpoint verified responding
          curl https://fivem.example.com/health → 200 OK

T+10sec:  Deployment complete
          All users on new version
          BLUE servers still running (ready for rollback)
```

**Manual Approval Checklist**:
```
Before approving full switch to 100%:
☐ Canary metrics look good (error rate ~0.1%)
☐ No unusual patterns in logs
☐ Performance stable
☐ Database still responsive
☐ Players on 10% traffic reporting OK
☐ Ready to switch 90% more players
```

**Post-Switch State**:
- ✅ GREEN: 100% production traffic
- ✅ BLUE: 0% production traffic (available for rollback)
- ✅ Can rollback in <30 seconds if needed
- ✅ New version fully live

---

## Environment-Specific Behaviors

### Development Environment (feature/* branches)
```
Stage 2: Static Analysis          ✅ (required)
  ↓
Stage 3: Security Scan            ✅ (required)
  ↓
Stage 4: Unit Tests               ✅ (required)
  ↓
Stage 5: Integration Tests        ✅ (required)
  ↓
Stage 6: Build Artifacts          ✅ (automatic)
  ↓
AUTOMATIC DEPLOYMENT TO DEV
  ✅ No staging (skipped)
  ✅ No approval needed
  ✅ 100% traffic automatic
  ✅ Immediate feedback to developer
  
Duration: ~5 minutes
Approval Gates: NONE
```

### Integration Environment (develop branch)
```
Stage 2: Static Analysis          ✅ (required)
  ↓
Stage 3: Security Scan            ✅ (required)
  ↓
Stage 4: Unit Tests               ✅ (required)
  ↓
Stage 5: Integration Tests        ✅ (required)
  ↓
Stage 6: Build Artifacts          ✅ (automatic)
  ↓
AUTOMATIC DEPLOYMENT TO INTEGRATION
  ✅ No staging (skipped)
  ✅ No approval needed
  ✅ 100% traffic automatic
  ✅ Ready for manual testing
  
Duration: ~5 minutes
Approval Gates: NONE
```

### Staging Environment (release/* branches)
```
Stage 2: Static Analysis          ✅ (required)
  ↓
Stage 3: Security Scan            ✅ (required)
  ↓
Stage 4: Unit Tests               ✅ (required)
  ↓
Stage 5: Integration Tests        ✅ (required)
  ↓
Stage 6: Build Artifacts          ✅ (automatic)
  ↓
Stage 7: Deploy to Staging        ✅ (automatic)
  ↓
Stage 8: QA Approval              ✅ (MANUAL - QA Team)
  ⏳ Waiting for QA sign-off
  ├─ Approve → Continue to production
  └─ Reject → Rollback and wait for fixes
  
Duration: ~5 minutes + QA testing time
Approval Gates: 1 (QA Team)
Progression: STOPS here for release/* branches
           CONTINUES to Stage 9 for main branch after QA approval
```

### Production Environment (main branch)
```
Stage 2: Static Analysis          ✅ (required)
  ↓
Stage 3: Security Scan            ✅ (required)
  ↓
Stage 4: Unit Tests               ✅ (required)
  ↓
Stage 5: Integration Tests        ✅ (required)
  ↓
Stage 6: Build Artifacts          ✅ (automatic)
  ↓
Stage 7: Deploy to Staging        ✅ (automatic - same as release)
  ↓
Stage 8: QA Approval              ✅ (MANUAL - QA Team)
  ⏳ Waiting for QA sign-off
  
  **After QA Approval**:
  ↓
Stage 9: Deploy to Production     ✅ (automatic after QA)
  ↓
Stage 10: Traffic Switch          ✅ (MANUAL - DevOps/SRE)
  ⏳ Phase 1: Canary 10% (automatic monitoring)
  ⏳ Phase 2: Approval required for 100% switch
  ├─ Approve → 100% switch to GREEN
  └─ Reject → Automatic rollback to BLUE
  
Duration: ~5 minutes + QA testing + production monitoring
Approval Gates: 2 (QA Team + DevOps/SRE)
Final State: 100% production traffic on new version
```

---

## Failure & Rollback Scenarios

### Scenario 1: Test Failure (Stage 2-5)
```
Developer pushes code with lint error

GitHub Actions Triggered:
├─ Stage 2: Static Analysis
│  └─ ❌ FAILS: Unused variable found
│
├─ Workflow STOPS
├─ Commit marked with ❌ RED X
├─ Developer notified via GitHub
└─ No deployment happens

Developer Fixes:
├─ Removes unused variable
├─ git push origin feature/x
├─ Tests re-run and PASS ✅
└─ Deployment proceeds

Timeline: 5 minutes (first attempt) + 5 minutes (retry) = 10 minutes total
Result: Eventually successful deployment
```

### Scenario 2: Staging Deployment Fails (Stage 7)
```
SSH connection to staging GREEN host fails

Stage 7: Deploy to Staging
├─ ❌ FAILS: SSH host unreachable
├─ Rollback job triggered
└─ Staging BLUE remains active (users unaffected)

Rollback Actions:
├─ Load balancer confirmed on BLUE
├─ BLUE version still serving all traffic
├─ GREEN servers reboot/checked
└─ DevOps notified

Timeline: 2-3 minutes detection + <1 minute rollback
User Impact: NONE (previous version still serving)
Next Steps: DevOps investigates, retries after fix
```

### Scenario 3: QA Testing Finds Issues (Stage 8)
```
QA testing on staging finds game-breaking bug

QA Approval Stage:
├─ QA tests new version
├─ ❌ Critical bug found: Players can't save progress
├─ QA clicks "REJECT"
└─ Automatic rollback to BLUE

Rollback Actions:
├─ Staging BLUE remains active
├─ QA team notifies developers
├─ Git issue created with QA notes
└─ Developers fix and create new release

Timeline: Development time varies
User Impact: NONE (staging ≠ production)
Next Steps: Fix, merge to release branch, retry pipeline
```

### Scenario 4: Production Canary Shows Errors (Stage 10 Phase 1)
```
Traffic switched to 10% on production

Canary Phase Monitoring (10% traffic on GREEN):
├─ T+30sec: Error rate spikes to 2% (was 0.1%)
├─ T+45sec: Database connection warnings in logs
├─ T+60sec: RED FLAG - Issue detected
│
└─ ❌ Canary fails - Don't proceed to 100% switch

Manual Approval Not Needed:
├─ DevOps sees metrics degrades
├─ Does NOT approve Phase 2 (100% switch)
├─ Automatic rollback initiated

Rollback Actions:
├─ Traffic switches back to BLUE (100%)
├─ GREEN servers isolated for investigation
├─ BLUE (old version) serves all traffic
├─ Post-incident review scheduled

Timeline: <30 seconds to detect + <30 seconds to rollback
User Impact: <1 minute potential issues for 10% of users
Resolution: DevOps investigates root cause (DB overload, etc.)
```

### Scenario 5: Production 100% Switch Fails (Stage 10 Phase 2)
```
PhDev approves 100% switch after canary looks good

Traffic Switching (90% more traffic to GREEN):
├─ Load balancer begins switch
├─ T+5sec: 90% → GREEN, 10% → BLUE
├─ T+10sec: Health check via public endpoint
├─ ❌ HTTP 500 errors returned
│
└─ Switch FAILS or is manually stopped

Rollback Actions:
├─ DevOps immediately rejects approval
├─ Automatic rollback triggered
├─ Traffic → BLUE (100%)
├─ Error investigation begins

Timeline: <30 seconds to detect + <30 seconds to rollback
User Impact: <1 minute for subset of users who hit GREEN
Resolution: Hotfix required, OR redeploy with debugging
```

---

## Approval Workflows

### QA Approval (Stage 8)

**Who**: QA Team Lead or designated QA member  
**When**: After staging deployment, before production deploy  
**Where**: GitHub Actions workflow run, "Review deployments" button

**Steps**:
1. GitHub notifies QA: "Staging deployment ready for review"
2. QA tests manually on staging environment
3. QA checks: Functionality, performance, data integrity
4. QA makes decision: Approve or Reject
5. QA clicks button in GitHub Actions UI
6. Approval recorded with timestamp and approver name

**If Approved** ✅:
- Proceeds to Stage 9 (production deploy)
- Includes milestone/commit comment
- Logged in audit trail

**If Rejected** ❌:
- Stops pipeline
- Staging rolls back to BLUE
- Development team notified with reasons
- Issue created for developers to fix

---

### DevOps/SRE Approval (Stage 10 Phase 2)

**Who**: DevOps, SRE, or Release Manager  
**When**: After canary phase monitoring (60 secsonds), before 100% switch  
**Where**: GitHub Actions workflow run, "Review deployments" button

**Steps**:
1. GitHub notifies DevOps: "Production canary ready for full switch"
2. DevOps reviews canary metrics (error rate, response time)
3. DevOps checks application logs for errors
4. DevOps monitors database, cache, external services
5. DevOps makes decision: Approve for 100% switch or Reject
6. DevOps clicks button in GitHub Actions UI

**Pre-Approval Checklist**:
- [ ] Error rate stable or improved
- [ ] Response times acceptable
- [ ] No database connection issues
- [ ] External integrations working
- [ ] Cache hit rates normal
- [ ] User reports: None/minimal

**If Approved** ✅:
- Full 100% traffic switch to GREEN
- Deployment complete
- New version live for all users
- BLUE remains running (instant rollback available)

**If Rejected** ❌:
- Stops at 10% canary
- Does NOT progress to 100%
- Automatic rollback to BLUE
- Troubleshooting required before retry

---

## GitHub Secrets Required

### For All Deployments:
```
SSH_PRIVATE_KEY              = Deploy SSH private key (4096-bit RSA)
SSH_USER                     = SSH user (e.g., 'fxuser' or 'ubuntu')
```

### For Staging Deployments:
```
GREEN_HOSTS_STAGING          = Comma-separated IP addresses/hostnames
  Example: "10.0.0.5,10.0.0.6,10.0.0.7"
BLUE_HOSTS_STAGING          = Previous version hosts (for quick rollback)
```

### For Production Deployments:
```
GREEN_HOSTS_PRODUCTION      = Comma-separated IP addresses/hostnames
  Example: "10.1.0.5,10.1.0.6,10.1.0.7"
BLUE_HOSTS_PRODUCTION       = Previous version hosts (for quick rollback)
```

### For Cloudflare Load Balancer:
```
CLOUDFLARE_API_TOKEN        = API token with load balancing permissions
CF_LOAD_BALANCER_ID         = Load balancer ID
CF_BLUE_POOL_ID             = Pool ID for BLUE hosts
CF_GREEN_POOL_ID            = Pool ID for GREEN hosts
```

### Optional (for database migrations):
```
MIGRATION_COMMAND           = Command to run before deployment
  Example: "npm run migrate:latest"
TEST_DATABASE_URL           = Database URL for integration tests
TEST_REDIS_URL              = Redis URL for integration tests
```

---

## Performance & Timing

### Total Pipeline Duration (By Branch)

| Branch | Stages | Estimated Time | Breakdown |
|--------|--------|-----------------|-----------|
| feature/* | 2-6 | ~5 minutes | Analysis (1) + Security (1) + Unit (1.5) + Integration (1.5) + Build (0.5) |
| develop | 2-6 | ~5 minutes | Same as feature/* |
| release/* | 2-8 | ~5 min + QA time | Stages 2-6 (5 min) + Deploy (2 min) + QA (variable) |
| main | 2-10 | ~10 min + QA + approvals | Stages 2-6 (5 min) + Deploy (2 min) + QA (variable) + Production Deploy (2 min) + Traffic Switch (1 min + approval time) |

### Stage Timings (Typical)

| Stage | Typical Duration | Min | Max |
|-------|------------------|-----|-----|
| Static Analysis | 45 sec | 30 sec | 90 sec |
| Security Scan | 60 sec | 45 sec | 120 sec |
| Unit Tests | 75 sec | 60 sec | 120 sec |
| Integration Tests | 105 sec | 90 sec | 180 sec |
| Build Artifacts | 30 sec | 20 sec | 60 sec |
| Deploy Staging | 3 min | 2 min | 5 min |
| QA Approval | Variable | Minutes | Hours |
| Deploy Production | 3 min | 2 min | 5 min |
| Traffic Switch | 2 min | 90 sec | 5 min |

---

## Monitoring During Deployment

### During Canary Phase (10% Traffic)

**Monitor These Metrics**:
1. **Error Rate**: Spike detection
2. **Response Time**: Latency comparison
3. **Error Logs**: New exception patterns
4. **Server Resources**: CPU, memory, disk I/O
5. **Database**: Connection pool, query times
6. **Cache**: Hit rates, eviction rates
7. **External Services**: API response times
8. **Player Reports**: User-reported issues

**Tools**:
- Prometheus (metrics)
- Grafana (dashboards)
- Loki (logs)
- Cloudflare Analytics
- Custom monitoring

**Health Check Endpoints**:
- `/health` → Basic liveness
- `/health/deep` → Database, cache, external service checks
- `/metrics` → Prometheus metrics

---

## Incident Response

### Rollback Procedure

**Automatic Rollback** (triggered by pipeline):
1. Failure detected (test, deploy, canary, approval rejection)
2. Rollback job created automatically
3. Load balancer switches to BLUE pool
4. Previous version restored
5. Timeline: <30 seconds

**Manual Rollback** (if automatic fails):
```bash
# SSH to load balancer or use Cloudflare dashboard
bash deploy/switch-pool.sh <LB_ID> <BLUE_POOL_ID>
```

### Post-Incident Checklist

After any failed deployment:
1. [ ] Root cause identified
2. [ ] Fix implemented and tested
3. [ ] Monitoring dashboard reviewed
4. [ ] Team debriefing completed
5. [ ] Ticket/documentation updated
6. [ ] Preventive measures discussed
7. [ ] Deployment retried

---

## Migration Pattern (Deployment Steps)

```
Minutes  BLUE State         GREEN State        Traffic    Log Entry
─────────────────────────────────────────────────────────────────────
-5       Running v1         Offline            100%→BLUE   ---
-4       Running v1         Downloading v2     100%→BLUE   Downloaded
-3       Running v1         Extracting v2      100%→BLUE   Extracted
-2       Running v1         Starting v2        100%→BLUE   Started
-1       Running v1         Warming up v2      100%→BLUE   Health OK
 0       Running v1         Ready v2           100%→BLUE   [CANARY START]
 0.5     Running v1         Serving v2         90%→BLUE    Canary active
                                              10%→GREEN
 1       Running v1         Serving v2         90%→BLUE    Metrics: OK
 1.5     Running v1         Serving v2         90%→BLUE    Metrics: OK
 2       Running v1         Serving v2         90%→BLUE    Approval ready
 2.5     Running v1         Serving v2         100%→BLUE   [APPROVAL WAIT]
 3       Running v1         Serving v2         100%→BLUE   Approved!
 3.5     Running v1         Serving v2         100%→GREEN  [SWITCHING]
 4       Idle v1 (backup)   Serving v2         100%→GREEN  Switch complete
         
         ✅ v2 live, v1 available for rollback
```

---

## Configuration Examples

### GitHub Actions Secrets Setup
```yaml
# For SSH access
SSH_PRIVATE_KEY=-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----

SSH_USER=fxuser

# Staging
GREEN_HOSTS_STAGING=10.0.0.5,10.0.0.6,10.0.0.7
BLUE_HOSTS_STAGING=10.0.0.1,10.0.0.2,10.0.0.3

# Production  
GREEN_HOSTS_PRODUCTION=10.1.0.5,10.1.0.6,10.1.0.7
BLUE_HOSTS_PRODUCTION=10.1.0.1,10.1.0.2,10.1.0.3

# Cloudflare
CLOUDFLARE_API_TOKEN=<token>
CF_LOAD_BALANCER_ID=27d8ddb1-5ac5-4c43-955e-7c8c0f33b4d2
CF_BLUE_POOL_ID=cbf534d4-cc79-4470-aad6-8ddc0b9ec7e5
CF_GREEN_POOL_ID=9d7bf3c8-2c56-4d59-8ae6-21a18fcc8f5a
```

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Stage 2 fails (linting) | Code has style issues | Fix linting errors, push again |
| Stage 3 fails (security) | Vulnerable dependency | Update dependency, security review |
| Stage 4 fails (unit tests) | Test failure | Debug test, fix code, re-push |
| Stage 5 fails (integration) | API/DB not responding | Check test environment, retry |
| Stage 7 fails (SSH deploy) | Host unreachable | Check SSH key, host IP, firewall |
| Stage 8 stalled (QA approval) | QA not responding | Ping QA team, escalate if urgent |
| Stage 10 canary fails | High error rate on 10% | Investigate metrics, review logs, rollback |
| Rollback fails | Connectivity issue | Manual switch via Cloudflare dashboard |

---

## See Also

- [WORKFLOW_TRAINING.md](WORKFLOW_TRAINING.md) — Team training guide
- [APPROVAL_GATE_GUIDE.md](APPROVAL_GATE_GUIDE.md) — Approval workflow details
- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) — Setup instructions
- [SETUP_GUIDE.md](SETUP_GUIDE.md) — Infrastructure overview
