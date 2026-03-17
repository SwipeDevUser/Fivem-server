# SSH Connection Testing & Troubleshooting

This guide helps you test and debug SSH connections for GitHub Actions deployments.

## Test 1: Local SSH Connection (from your PC)

Before testing in GitHub Actions, verify SSH works locally.

```powershell
# Set PATH to Git SSH
$env:PATH = "C:\Users\elias\AppData\Local\Programs\Git\bin;" + $env:PATH

# Navigate to repo
cd "c:\Users\elias\Documents\FiveM Development\fivem-server"

# Test SSH connection to BLUE host
ssh -v -i deploy_key -o StrictHostKeyChecking=no ubuntu@10.0.0.5 "echo 'SSH works!'; whoami; pwd"

# Expected output: ubuntu (username)
```

If this fails, check:
1. **Private key file exists**: `ls deploy_key`
2. **Public key on host**: `ssh -v -i deploy_key ubuntu@10.0.0.5 "cat ~/.ssh/authorized_keys"`
3. **Network connectivity**: `ping 10.0.0.5`
4. **Host is accepting SSH**: `ssh -v ubuntu@10.0.0.5` (verbose output shows handshake)

## Test 2: Test SCP (file copy to host)

```powershell
# Copy a test file to host
"test content" | Out-File test.txt
scp -i deploy_key test.txt ubuntu@10.0.0.5:/tmp/test.txt

# Verify on host
ssh -i deploy_key ubuntu@10.0.0.5 "cat /tmp/test.txt"
```

## Test 3: Verify Deployment User & Directories

```powershell
# Check if deployment user exists
ssh -i deploy_key ubuntu@10.0.0.5 "id ubuntu"

# Check if fxserver dirs exist
ssh -i deploy_key ubuntu@10.0.0.5 "ls -la /opt/fxserver/"

# Expected: blue/ and green/ directories should exist and be writable
ssh -i deploy_key ubuntu@10.0.0.5 "touch /opt/fxserver/blue/test.txt && rm /opt/fxserver/blue/test.txt && echo 'Blue dir writable'"
```

## Test 4: Test FXServer Health Endpoint

```powershell
# Deploy a minimal app first, or test manually
ssh -i deploy_key ubuntu@10.0.0.5 "curl -s http://127.0.0.1:30120/health | head -20"

# Should return JSON like: {"status":"ok"}
```

## Test 5: GitHub Actions SSH Deployment Test

Create a test workflow to verify GitHub Actions can SSH:

1. Go to GitHub → Actions → **New workflow** → **set up a workflow yourself**

2. Paste this test workflow:

```yaml
name: SSH Connection Test

on:
  workflow_dispatch:

jobs:
  test-ssh:
    runs-on: ubuntu-latest
    steps:
      - name: Prepare SSH key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/deploy_key
          chmod 600 ~/.ssh/deploy_key
          ssh-keyscan -H ${{ secrets.BLUE_HOSTS }} >> ~/.ssh/known_hosts 2>/dev/null || true

      - name: Test SSH connection
        run: |
          host=$(echo "${{ secrets.BLUE_HOSTS }}" | cut -d',' -f1)
          ssh -o StrictHostKeyChecking=no -i ~/.ssh/deploy_key ${{ secrets.SSH_USER }}@$host "echo 'SSH SUCCESS'; whoami"

      - name: List FXServer directories
        run: |
          host=$(echo "${{ secrets.BLUE_HOSTS }}" | cut -d',' -f1)
          ssh -o StrictHostKeyChecking=no -i ~/.ssh/deploy_key ${{ secrets.SSH_USER }}@$host "ls -la /opt/fxserver/"
```

3. Save as `.github/workflows/test-ssh.yml`
4. Go to Actions → **SSH Connection Test** → **Run workflow**
5. Monitor logs for success/failure

## Common SSH Errors & Fixes

### Error: "Permission denied (publickey)"

**Cause**: Public key not on host or not in correct location

**Fix**:
```bash
# On target host
sudo cat ~/.ssh/authorized_keys | grep "ssh-rsa"

# If not found, add it:
echo "ssh-rsa AAAA...rest-of-key..." | sudo tee -a ~/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/authorized_keys
```

### Error: "Connection refused"

**Cause**: SSH service not running or firewall blocking

**Fix**:
```bash
# On target host
sudo systemctl status ssh
sudo systemctl start ssh
sudo ufw allow 22
```

### Error: "Connection timed out"

**Cause**: Network unreachable or wrong IP

**Fix**:
```powershell
# On local machine
ping 10.0.0.5          # Check network connectivity
tracert 10.0.0.5       # Check route to host
```

### Error: "Host key verification failed"

**Cause**: Host not in `known_hosts`

**Fix**: Add `-o StrictHostKeyChecking=no` flag (what we do in workflows)

```bash
ssh -o StrictHostKeyChecking=no -i deploy_key ubuntu@10.0.0.5 "hostname"
```

### Error: "Bad permissions on deploy_key"

**Cause**: SSH key has insecure permissions

**Fix**:
```bash
chmod 600 deploy_key
ls -la deploy_key  # Should show: -rw------- (600)
```

## Test Matrix (running all tests)

Here's a comprehensive test checklist:

```powershell
# 1. Verify private key format
cat deploy_key | head -1  # Should show: -----BEGIN OPENSSH PRIVATE KEY-----

# 2. Verify public key format  
cat deploy_key.pub | head -1  # Should show: ssh-rsa AAAA...

# 3. Test basic SSH
ssh -i deploy_key ubuntu@10.0.0.5 "hostname"

# 4. Verify sudo access (if needed)
ssh -i deploy_key ubuntu@10.0.0.5 "sudo systemctl status ssh"

# 5. Test file copy
echo "test" | Out-File test.txt
scp -i deploy_key test.txt ubuntu@10.0.0.5:/tmp/test.txt

# 6. Test directory permissions
ssh -i deploy_key ubuntu@10.0.0.5 "touch /opt/fxserver/blue/test && rm /opt/fxserver/blue/test"

# 7. Test systemd unit
ssh -i deploy_key ubuntu@10.0.0.5 "sudo systemctl status fxserver@blue"
```

## Debugging Script

Create a helper script to diagnose SSH issues:

```bash
#!/bin/bash
# diagnose-ssh.sh

HOST=$1
USER=${2:-ubuntu}
KEY=${3:-deploy_key}

echo "=== SSH Diagnostics for $USER@$HOST ==="
echo ""

echo "1. Testing connectivity (ping)..."
ping -c 1 $HOST || echo "  ❌ Ping failed"

echo ""
echo "2. Testing SSH port (22)..."
nc -zv $HOST 22 || echo "  ❌ SSH port not accessible"

echo ""
echo "3. Testing SSH key permissions..."
ls -la $KEY
stat -c "%A %n" $KEY | grep -q "^-rw-------" && echo "  ✅ Key permissions OK" || echo "  ❌ Key permissions incorrect"

echo ""
echo "4. Testing SSH connection..."
ssh -o StrictHostKeyChecking=no -i $KEY $USER@$HOST "echo '✅ SSH Connection Success'" || echo "  ❌ SSH Connection Failed"

echo ""
echo "5. Testing sudo access..."
ssh -o StrictHostKeyChecking=no -i $KEY $USER@$HOST "sudo whoami" && echo "  ✅ Sudo access granted" || echo "  ⚠️  Sudo access denied"

echo ""
echo "6. Checking /opt/fxserver..."
ssh -o StrictHostKeyChecking=no -i $KEY $USER@$HOST "ls -la /opt/fxserver/" || echo "  ❌ Directory not accessible"
```

Usage:
```bash
bash diagnose-ssh.sh 10.0.0.5 ubuntu ./deploy_key
```

## Next Steps

Once all tests pass:
1. ✅ Add secrets to GitHub
2. ✅ Run the actual deployment workflows
3. ✅ Monitor Actions logs for success
