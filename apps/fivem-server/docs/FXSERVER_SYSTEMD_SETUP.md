# FXServer Systemd Setup Guide

This guide explains how to set up FXServer as a systemd service for blue/green deployments.

## Prerequisites

- Ubuntu/Debian-based Linux (systemd)
- FXServer binary or Docker container
- User account for running FXServer (e.g., `fxuser`)

## Step 1: Create FXServer User

```bash
# Create service user (no shell access)
sudo useradd -r -s /bin/false fxuser

# Or with home directory if needed
sudo useradd -r -d /opt/fxserver -s /bin/false fxuser

# Grant sudo for systemctl (optional, for restarts)
sudo usermod -aG sudo fxuser
echo "fxuser ALL=(ALL) NOPASSWD: /bin/systemctl" | sudo tee -a /etc/sudoers.d/fxuser
```

## Step 2: Create Directory Structure

```bash
# Create base directories
sudo mkdir -p /opt/fxserver/blue /opt/fxserver/green
sudo chown -R fxuser:fxuser /opt/fxserver
sudo chmod 750 /opt/fxserver

# Create log directory
sudo mkdir -p /var/log/fxserver
sudo chown fxuser:fxuser /var/log/fxserver
sudo chmod 755 /var/log/fxserver
```

## Step 3: Install systemd Unit Files

Copy the templated unit file to systemd:

```bash
sudo cp systemd/fxserver@.service /etc/systemd/system/

# Reload systemd to recognize new unit
sudo systemctl daemon-reload
```

## Step 4: Create FXServer Start Script

Create a wrapper script to start FXServer for each color:

```bash
# Create start script for blue
sudo mkdir -p /opt/fxserver/blue
sudo tee /opt/fxserver/blue/start.sh > /dev/null <<'EOF'
#!/bin/bash
set -euo pipefail

COLOR="blue"
WORK_DIR="/opt/fxserver/${COLOR}"
LOG_FILE="/var/log/fxserver/${COLOR}.log"

# Export environment variables
export FX_SERVER_PROFILE=${COLOR}
export PORT=30120

# Navigate to directory
cd "$WORK_DIR" || exit 1

# Log startup
echo "[$(date)] Starting FXServer (${COLOR}) on port ${PORT}" >> "$LOG_FILE"

# Start FXServer (adjust command to your setup)
# For Docker:
# docker run -d --name fxserver-${COLOR} --restart always -v ./data:/data -p ${PORT}:${PORT} fxserver:latest

# For native binary:
# ./cfx.exe +exec server.cfg

# For bash simulation (replace with actual server)
echo "FXServer running on port ${PORT}"
tail -f /dev/null  # Keep process alive
EOF

sudo chmod +x /opt/fxserver/blue/start.sh
sudo chown fxuser:fxuser /opt/fxserver/blue/start.sh

# Copy for green
sudo cp /opt/fxserver/blue/start.sh /opt/fxserver/green/start.sh
```

Adjust the start script for your actual FXServer setup:
- Native binary: `./cfx.exe +exec server.cfg`
- Docker: `docker run ... fxserver:latest`
- Node.js wrapper: `node server.js`

## Step 5: Create Health Check Endpoint

FXServer needs to expose a `/health` endpoint on port 30120 for Cloudflare checks.

### Option A: Node.js Wrapper (Recommended)

Create `/opt/fxserver/blue/health-server.js`:

```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', uptime: process.uptime() }));
  } else {
    res.writeHead(404);
    res.end();
  }
});

server.listen(30120, '127.0.0.1', () => {
  console.log('Health check server running on port 30120');
});
```

Start with: `node health-server.js`

### Option B: Simple Bash HTTP Server

```bash
# Using netcat
#!/bin/bash
while true; do
  (echo -ne "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 23\r\n\r\n"; echo '{"status":"ok"}') | nc -l -p 30120 -q 1
done
```

### Option C: Use Existing FXServer Health Endpoint

If FXServer already exposes `/health`, use that. Check:

```bash
curl -s http://127.0.0.1:30120/health
```

## Step 6: Enable & Start Services

```bash
# Enable blue service (start on boot)
sudo systemctl enable fxserver@blue.service

# Start blue service
sudo systemctl start fxserver@blue.service

# Check status
sudo systemctl status fxserver@blue.service

# View logs
sudo journalctl -u fxserver@blue.service -n 50 --follow

# Repeat for green
sudo systemctl enable fxserver@green.service
sudo systemctl start fxserver@green.service
```

## Step 7: Verify Services & Health Check

```bash
# Check if services are running
sudo systemctl is-active fxserver@blue
sudo systemctl is-active fxserver@green

# Test health check
curl -s http://127.0.0.1:30120/health

# Expected output:
# {"status":"ok","uptime":1234.567}
```

## Step 8: Update systemd Unit (if needed)

If your FXServer has different start requirements, edit the unit:

```bash
sudo systemctl edit fxserver@.service
# or
sudo nano /etc/systemd/system/fxserver@.service
```

Example custom unit:

```ini
[Unit]
Description=FXServer instance (%i)
After=network.target docker.service
Requires=docker.service

[Service]
Type=simple
User=fxuser
Restart=on-failure
RestartSec=10

# For Docker
ExecStart=/usr/bin/docker run --rm --name fxserver-%i \
  -v /opt/fxserver/%i:/data \
  -p 30120:30120 \
  -e FX_SERVER_PROFILE=%i \
  fxserver:latest

ExecStop=/usr/bin/docker stop fxserver-%i

[Install]
WantedBy=multi-user.target
```

Then reload:
```bash
sudo systemctl daemon-reload
sudo systemctl restart fxserver@blue
```

## Step 9: Manage Services

```bash
# Stop a service
sudo systemctl stop fxserver@blue

# Restart (for deployments)
sudo systemctl restart fxserver@blue

# Restart without downtime (graceful)
sudo systemctl reload fxserver@blue  # If service supports SIGHUP

# View real-time logs
sudo journalctl -u fxserver@blue -f

# View logs from specific time
sudo journalctl -u fxserver@blue --since "2 minutes ago"

# Check if running
sudo systemctl is-active fxserver@blue && echo "Running" || echo "Stopped"
```

## Step 10: Deployment Integration

When GitHub Actions deploys:

1. **Deploy script** extracts artifact to `/opt/fxserver/blue` or `/opt/fxserver/green`
2. **deploy-to-host.sh** calls `systemctl try-restart fxserver@{color}.service`
3. **Systemd** stops old instance, starts new one
4. **Health check** waits for `/health` endpoint to return 200

Example from `deploy/deploy-to-host.sh`:

```bash
COLOR="${1:-green}"
# ... unzip artifact ...
systemctl try-restart fxserver@${COLOR}.service
```

## Troubleshooting

### Service won't start

```bash
# Check systemd errors
sudo systemctl status fxserver@blue
sudo journalctl -u fxserver@blue

# Check if port is in use
sudo lsof -i :30120

# Check file permissions
sudo ls -la /opt/fxserver/blue/
```

### Health check failing

```bash
# Test endpoint manually
curl -v http://127.0.0.1:30120/health

# Check if process is running
ps aux | grep fxserver

# Check logs
sudo tail -f /var/log/fxserver/blue.log
```

### Systemd auto-restart not working

```bash
# Check RestartSec and Restart settings in unit
sudo systemctl cat fxserver@blue

# Manually test restart
sudo systemctl restart fxserver@blue
sudo sleep 2
sudo systemctl is-active fxserver@blue  # Should show "active"
```

## Reference

- Systemd Service Documentation: https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html
- Journalctl Guide: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-viewing_logs_with_journalctl
