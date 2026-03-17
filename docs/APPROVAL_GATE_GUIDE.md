# Deployment Approval Gate Guide

## Overview

When deployments reach **Stage 5 (Manual Verification)**, an authorized team member must review and approve the green deployment before 100% of production traffic is switched.

This guide explains:
- ✅ How to receive approval requests
- ✅ What to check before approving
- ✅ How to approve or reject
- ✅ What happens next

---

## Receiving Approval Notifications

### GitHub Actions UI (Default)

1. **In GitHub, go to your repository**: https://github.com/SwipeDevUser/Fivem-server
2. **Click "Actions" tab**
3. **Select the running workflow** (e.g., "Deploy to Staging" or "Deploy to Production")
4. **Look for blue notification**: "This workflow is waiting for your review to continue"
5. **Click "Review deployments"** button

### Optional: Slack Integration (Advanced)

If configured, you'll receive a Slack message:
```
GitHub: Deployment review required
[Staging] Deployment by @alice
Canary deployment running: 10% traffic
[Review]  [Workflow Details]
```

---

## Pre-Approval Checklist

Before clicking "Approve", verify these items:

### 1. Source Code Review
- ✅ Check what's being deployed: Look at the commit message
- ✅ Verify the branch: Should be `main` (prod) or `release/*` (staging)
- ✅ Check for expected changes in commit diff

**In GitHub Actions UI:**
- Click the workflow run
- Scroll to "Summary"
- Click the commit hash to see code changes

### 2. Build & Test Results
- ✅ Verify "Test" job passed (green checkmark)
- ✅ All automated tests succeeded

**Why?** Tests are gating; they won't reach Stage 5 if they failed. But verify they ran.

### 3. Deployment to GREEN Servers
- ✅ Verify "Deploy to GREEN" job completed successfully
- ✅ Verify smoke tests passed on new version

**In GitHub Actions UI:**
- Click the "Deploy to GREEN" job
- Scroll through logs
- Look for: ✅ "Smoke tests PASSED"

### 4. Canary Metrics (10% Traffic)
- ✅ **Check error rates**: No spike vs. baseline
- ✅ **Check response times**: No degradation
- ✅ **Check server resources**: CPU/memory normal
- ✅ **Check application logs**: No exceptions or errors
- ✅ **Check player reports**: Any issues from users on 10% traffic?

**Where to check metrics:**
- **If you have Prometheus/Grafana**: Open dashboard
  ```
  http://your-grafana-host/d/fxserver-overview
  ```
  Look at last 5 minutes (when canary was running)

- **If you have Cloudflare**: Check analytics
  - Error rates (4xx, 5xx)
  - Traffic distribution shows ~10% to new pool

- **If you have Logger (Loki)**: Check recent logs
  - No exception spikes
  - Response times consistent

### 5. Previous Version Baseline
- ✅ Have a mental baseline of what "normal" looks like
- ✅ Compare 10% traffic metrics to this baseline

**Example:** "Normal error rate is 0.1%, canary shows 0.2% → possible issue"

---

## How to Approve

### Step 1: Navigate to Deployment Review
**In GitHub Actions UI:**

1. Go to the workflow run
2. You should see a banner: "This workflow is waiting for your review to continue"
3. Click **"Review deployments"** button

### Step 2: Select Environment
In the popup dialog:
- Choose the environment (usually just one, but could be "staging" or "production")
- It will show:
  - ✅ Who triggered the deployment
  - ✅ Which branches were deployed
  - ✅ Commit message

### Step 3: Leave Comments (Optional)
Add a comment if you want to document your approval:

**Good comments:**
```
✅ Approved - Metrics normal, no errors in canary phase. Ready for production.

Evidence:
- Error rate stable at 0.1%
- Response time unchanged
- No exception spikes in logs
- Verified with 2 test accounts
```

**Rejected comment example:**
```
❌ Rejected - Error rate spike detected (0.1% → 2.3%) in canary phase.

Issue:
- See logs: "Connection timeout to database"
- Likely database connection pool exhaustion

Action:
- Rollback to BLUE (previous version)
- Investigate database performance
- Retry deployment after fix
```

### Step 4: Click "Approve" or "Reject"

**Green Checkmark Icon** = Approve
- ✅ Approve & Deploy to 100% traffic
- ✅ Proceed to Stage 6 (final health check)

**Red X Icon** = Reject
- ❌ Reject & Trigger Automatic Rollback
- ❌ Traffic reverts to BLUE (previous version)
- ❌ Investigation required before retry

---

## After Your Decision

### If You Approved ✅

**Timeline:**
- **T+0sec**: Approval submitted
- **T+5sec**: Workflow resumes at Stage 5 (verify-and-switch job)
- **T+10sec**: Final health check runs on all GREEN hosts
- **T+15sec**: Traffic switches 100% to GREEN
- **T+30sec**: Public endpoint verified responding
- **T+1min**: Deployment marked "Complete"

**Messages you'll see:**
- ✅ "verify-and-switch" job succeeds (visible in GitHub Actions)
- ✅ Commit gets a green checkmark (deployment successful)
- Notification: "Deployment completed"

**What happens next:**
- 100% of user traffic now on new version
- BLUE servers still running (ready for quick rollback if needed)
- Monitoring continues; be alert for any issues

### If You Rejected ❌

**Timeline:**
- **T+0sec**: Rejection submitted
- **T+2sec**: Workflow stops at Stage 5
- **T+3sec**: "rollback-on-failure" job triggered automatically
- **T+5sec**: Cloudflare switches 100% traffic back to BLUE
- **T+10sec**: Rollback verified, all traffic on BLUE (old version)
- **T+1min**: Deployment marked "Failed; Rollback Complete"

**Messages you'll see:**
- ❌ "verify-and-switch" job fails (visible in GitHub Actions)
- ❌ "rollback-on-failure" job runs (automatically switches back to BLUE)
- ❌ Commit gets a red X (deployment failed)
- Notification: "Deployment failed; rolled back to previous version"

**What happens next:**
- Users are on previous (BLUE) version
- Development team investigates issue
- Fix is made, new commit pushed
- Pipeline re-runs automatically

---

## Common Scenarios & Decisions

### Scenario 1: "Everything Looks Normal"
```
Metrics on canary (10% traffic):
- Error rate: 0.1% (⟵ same as BLUE)
- Response time: 45ms (⟵ same as BLUE)
- Logs: No exceptions
- Player reports: None

Decision: ✅ APPROVE
```

### Scenario 2: "Minor Issue, But Not Critical"
```
Metrics on canary:
- Error rate: 0.5% (up from 0.1%, but <1%)
- Response time: 45ms (normal)
- Issue: 1 player reported slow loading, but might be network
- Investigation: Database query time increased 10ms

Decision: 🤔 DEPENDS
- If expected (new feature optimization still running): ✅ APPROVE
- If unexpected (performance regression): ❌ REJECT
- When unsure: ❌ REJECT (safer to rollback and investigate)
```

### Scenario 3: "Clear Problem"
```
Metrics on canary:
- Error rate: 5% (up from 0.1% ← RED FLAG)
- Response time: 500ms (up from 45ms ← RED FLAG)
- Logs: "Connection refused: database" (spam)
- Player reports: Game crashing for many users

Decision: ❌ REJECT IMMEDIATELY
- Automatic rollback to BLUE
- Users restored to working version
- Development team debugs issue
```

### Scenario 4: "Unsure / Can't Access Metrics"
```
You can't reach Grafana dashboard or logs are unclear

Decision: ⏰ DELAY / REACH OUT
- Comments: "Waiting for metrics access; can't verify canary stage"
- Action: Alert DevOps/SRE to check metrics
- Once verified: Approve or Reject
- If no one can verify: ❌ REJECT (security/safety first)
```

---

## Approval Authority

### Who Can Approve?

Only team members with **"Deployment Review"** permission can approve. This typically includes:

- ✅ DevOps/SRE team
- ✅ Release manager
- ✅ Technical lead
- ✅ Authorized developers

### How to Add More Approvers

**GitHub steps:**
1. Go to Repo Settings → Environments
2. Select "staging" or "production"
3. Under "Deployment branches and secrets" → "Required reviewers"
4. Add GitHub users who should be able to approve

---

## Troubleshooting Approval Issues

### "I Can't See the Review Button"

**Reasons:**
1. You don't have authorization for this environment
2. Workflow already moved past Stage 5
3. Workflow failed before reaching approval stage

**Solution:**
- Check your GitHub permissions
- Notify repo admin to add you to "Deployment Review" gate
- If workflow finished, wait for next deployment

### "The Approval Button is Greyed Out"

**Reason:** Workflow already finished or was cancelled

**Solution:**
- If still waiting: Refresh the page (F5)
- If workflow finished: Can't retroactively approve; wait for next deployment

### "I Accidentally Rejected, But I Meant to Approve"

**Consequence:**
- Automatic rollback to BLUE already happened
- Users back on previous version

**Recovery:**
1. Fix the issue that caused rejection
2. Push new commit to trigger pipeline
3. Approve when it reaches Stage 5 again

---

## Best Practices

✅ **DO:**
- Always review metrics before approving
- Document your approval reason in comments
- Have a test account logged in while canary is running
- Check logs for any "WARNING" or "ERROR" messages
- If unsure, reject and investigate

❌ **DON'T:**
- Approve without checking canary metrics
- Approve during known system maintenance windows
- Approve if you don't recognize the commit author
- Approve if tests were manually skipped
- Auto-approve as a routine (always review metrics)

---

## Escalation Path

### If Approval is Needed but No One Available

1. **Staging deployments**: Can wait; not urgent
2. **Production deployments**:
   - Check if it's business hours in your timezone
   - Reach out to on-call person (if established)
   - If no on-call: Can be rejected and retried with more visibility

### If Metrics Are Unclear

1. **Post in team chat**: "Canary metrics unclear, need help evaluating [workflow link]"
2. **Wait for expert review**: Don't guess
3. **Reject if unsure**: Safety > speed

---

## Reference

- 📊 **Metrics Dashboard**: http://your-grafana-host/d/fxserver-overview
- 📋 **Deployment Checklist**: [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
- 🔄 **Pipeline Architecture**: [PIPELINE_VISUALIZATION.md](PIPELINE_VISUALIZATION.md)
- 🚀 **Deployment Guide**: [SETUP_GUIDE.md](SETUP_GUIDE.md)
