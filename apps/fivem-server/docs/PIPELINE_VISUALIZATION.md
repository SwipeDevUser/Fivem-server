# Enhanced Deployment Pipeline Visualization

## Complete Pipeline Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    FIVEM BLUE/GREEN DEPLOYMENT PIPELINE                     │
└─────────────────────────────────────────────────────────────────────────────┘

                              Developer
                                 ↓
                        git push to branch
                                 ↓
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
    feature/*              develop              release/x.x
        │                        │                        │
        ↓                        ↓                        ↓
    [BUILD]                  [BUILD]                  [BUILD]
   (Stage 1)                 (Stage 1)                (Stage 1)
        │                        │                        │
        ↓                        ↓                        ↓
    [TEST] ❌──────────────────❌❌ ────────────────────❌
   (Stage 2)     (Unit/Lint/Build checks)     (Deploy BLOCKED)
    GATE          │
    PASS          ✅
        │         │
        ↓         ↓
   [DEPLOY]   [DEPLOY]               [DEPLOY]
   to DEV     to INT                to STAGING
   (Stage 3)   (Stage 3)             (Stage 3)
        │         │                     │
        ↓         ↓                     ↓
   [SMOKE]   [SMOKE]               [SMOKE]
   TEST      TEST                  TEST
   PASS ✅   PASS ✅              PASS ✅
        │         │                     │
        ↓         ↓                     ↓
   AUTO         AUTO                CANARY
   SWITCH       SWITCH              (10% traffic)
   (100%)       (100%)              (Stage 4)
        │         │                     │
        ↓         ↓                     │
    LIVE          LIVE                 ↓
    on DEV        on INT          [MANUAL REVIEW]
    Env           Env              (Stage 5)
                                   ┌─ APPROVE → SWITCH (100%)
                                   │           to GREEN → LIVE on STAGING
                                   │
                                   └─ REJECT → ROLLBACK
                                              to BLUE

                        ┌─────────────────────────┐
                        │                         │
                        ↓                         ↓
                    main branch              hotfix/* branch
                        │                         │
                        ↓                         ↓
                    [BUILD]                   [BUILD]
                    (Stage 1)                 (Stage 1)
                        │                         │
                        ↓                         ↓
                    [TEST]                    [SKIP]
                    (Stage 2)                 (Unit tests)
                    GATE PASS                 (Manual only)
                        │                         │
                        ↓                         │
                    [DEPLOY]                     │
                    to PROD                      │
                    (Stage 3)                     │
                        │                         │
                        ↓                         │
                    [SMOKE]                       │
                    TEST PASS ✅                 │
                        │                         │
                        ↓                         │
                    CANARY                        │
                    (10% traffic)                 │
                    (Stage 4)                     │
                        │                         │
                        ↓                         │
                    [MANUAL APPROVAL]        [HOTFIX
                    Required by:              EMERGENCY]
                    Admin/DevOps                │
                    (Stage 5)                   ↓
                 ┌─────────┬─────────┐      Manual
                 │         │         │      Actions
              APPROVE   REJECT      │      Portal
                 │         │         │      (outside
                 ↓         ↓         │       pipeline)
              SWITCH   ROLLBACK ←────┘
              (100%)   to BLUE
              to GREEN
                 │
                 ↓
              VERIFY
              Public
              Endpoint
                 │
                 ↓
              LIVE ✅
              on PROD
```

## Environment & Branch Mapping

| Branch | Environment | Auto-Deploy | Tests Required | Traffic Switch | Approval Gate |
|--------|-------------|-------------|----------------|----------------|---------------|
| feature/* | development | ✅ Yes | ✅ Yes (blocks) | ✅ Auto (100%) | ❌ No |
| develop | integration | ✅ Yes | ✅ Yes (blocks) | ✅ Auto (100%) | ❌ No |
| release/* | staging | ✅ Yes | ✅ Yes (blocks) | 🔄 Canary → Manual | ✅ Yes |
| main | production | ✅ Yes | ✅ Yes (blocks) | 🔄 Canary → Manual | ✅ Yes (Required) |
| hotfix/* | (skipped) | ❌ No | ❌ Skipped | ❌ Manual only | ✅ Yes (Manual) |

## Pipeline Stages in Detail

### Stage 1: Build
- **Trigger**: Push to any configured branch
- **Action**: Create artifact (zip) with all code
- **Duration**: ~30 seconds
- **Output**: artifact.zip uploaded to GitHub

### Stage 2: Automated Tests (GATING)
- **Trigger**: Build succeeds
- **Actions**:
  - ✅ Linting (npm lint)
  - ✅ Unit tests (npm test)
  - ✅ Build check (npm build)
  - ✅ Docker build verification
  - ✅ File integrity check
- **Duration**: ~1-2 minutes
- **Gate**: ❌ FAILS → Deployment BLOCKED, no further steps
- **Gate**: ✅ PASSES → Proceed to Stage 3

### Stage 3: Deploy to GREEN
- **Trigger**: Tests pass
- **Actions**:
  - SSH to each GREEN host
  - Extract artifact
  - Restart systemd service
  - Run smoke tests on each host
- **Duration**: ~1-3 minutes
- **Output**: GREEN hosts running new code

### Stage 4: Canary Deployment
- **Trigger**: Smoke tests pass
- **Actions**:
  - Switch 10% traffic to GREEN (if applicable)
  - Monitor health checks for 30 seconds
  - Verify no spike in error rates
- **Conditions by environment**:
  - `development`/`integration`: Auto-skip (proceed to Stage 5)
  - `staging`/`production`: Canary required
- **Duration**: ~1 minute (30s monitoring + checks)
- **Output**: 10% traffic on GREEN (staging/production only)

### Stage 5: Manual Verification & Full Switch
- **Trigger**: Canary monitoring complete
- **For development/integration**: Auto-proceed (no manual gate)
- **For staging/production**: 
  - 🔒 **Requires manual approval** from authorized reviewer
  - Reviewer checks: logs, metrics, performance
  - Optionally attach screenshot evidence
- **Actions on approval**:
  - Final health check on all GREEN hosts
  - Switch 100% traffic to GREEN pool
  - Verify public endpoint responds
  - Record deployment timestamp
- **Duration**: ~1 minute (or awaiting approval)
- **Output**: 100% traffic on GREEN (deployment complete)

### Stage 6: Automatic Rollback
- **Trigger**: Any failure in stages 3-5
- **Actions**:
  - Switch load balancer back to BLUE
  - Verify rollback successful
  - Alert administrator
- **Duration**: ~30 seconds
- **Output**: Traffic restored to BLUE (previous version)

## Decision Tree: When to Approve/Reject

```
                    ┌─ Approval Required
                    │
              Stage 5: Manual Review
              /      │      \
             /       │       \
        CHECK:   CHECK:   CHECK:
      Logs OK?  Metrics  Public
              Healthy? Endpoint OK?
        │         │         │
        ✅        ✅        ✅
         \       │       /
          \      │      /
           \_____▼_____/
              APPROVE
                 │
              PROCEED
              to Full
              Traffic
              Switch
               (100%)
                 │
                 ✅
              LIVE on
             PRODUCTION


             If ANY check FAILS:
                 │
                 ↓
              REJECT
                 │
           Automatic
            Rollback
              to BLUE
                 │
              Previous
             Version
              LIVE
```

## Monitoring During Canary (10%)

While 10% of traffic is on GREEN:
1. **Error Rate**: Monitor for spikes
2. **Response Time**: Compare latency
3. **CPU/Memory**: Check GREEN host resources
4. **Application Logs**: Watch for exceptions
5. **Player Experience**: Verify game functionality

**If all metrics look good**: ✅ Approve full switch
**If any issues found**: ❌ Reject, automatic rollback to BLUE

## How to Manually Intervene

### Pause Deployment (after Stage 3, before Stage 4)
Not possible with current workflow, but you can:
1. Reject manual approval at Stage 5
2. Automatic rollback occurs
3. FXServer reverts to BLUE version

### Force Rollback
**Inside GitHub Actions UI:**
- If workflow still running: Cancel job → Rollback job triggered
- If deployment complete: Manually run "Hotfix Emergency Deploy" → select BLUE

**From command line:**
```bash
bash deploy/switch-pool.sh <LB_ID> <BLUE_POOL_ID>
# Switches traffic back to BLUE
```

### Emergency Hotfix
If production is broken:
1. Create hotfix branch: `git checkout -b hotfix/critical-fix main`
2. Make fixes
3. Push: `git push origin hotfix/critical-fix`
4. Manually run GitHub Actions → "Hotfix Emergency Deploy"
5. Choose environment (staging or production)
6. Deploys to BLUE (current) hosts
7. Manually verify and switch pool

## Metrics & Alerting

The pipeline automatically:
- ✅ Records deployment timestamp
- ✅ Captures environment
- ✅ Logs who approved
- ✅ Tracks success/failure
- ✅ Stores all step logs in GitHub

Recommended integrations (optional):
- **Slack**: Receive approval requests in Slack
- **PagerDuty**: Alert on deployment failures
- **DataDog**: Monitor canary traffic metrics
- **Sentry**: Track error spikes during deployment

## Rollback Timeline

```
T+0min:   User clicks "Reject" on manual approval
T+0.5sec: Rollback job triggered
T+1min:   Traffic switches back to BLUE
T+2min:   Verify public endpoint responding
T+3min:   Rollback complete - users back on old version

Total downtime: ~0-10 seconds (Cloudflare DNS TTL dependent)
```

---

**Reference**: See [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) for complete setup steps.
