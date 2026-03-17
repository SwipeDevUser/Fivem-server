#!/bin/bash
# Comprehensive deployment diagnostics script
# Run this on each BLUE/GREEN host to verify setup

set -euo pipefail

COLOR=${1:-blue}
OUTPUT_FILE="/tmp/fxserver-diagnostics-${COLOR}.txt"

{
  echo "========================================"
  echo "FXServer Deployment Diagnostics"
  echo "Color: $COLOR"
  echo "Date: $(date)"
  echo "========================================"
  echo ""
  
  # 1. System Info
  echo "=== 1. SYSTEM INFO ==="
  echo "Hostname: $(hostname)"
  echo "Uptime: $(uptime)"
  echo "OS: $(lsb_release -d 2>/dev/null || echo 'Unknown')"
  echo "Kernel: $(uname -r)"
  echo ""
  
  # 2. User Check
  echo "=== 2. DEPLOYMENT USER ==="
  if id fxuser &>/dev/null; then
    echo "✅ User 'fxuser' exists"
    echo "UID: $(id -u fxuser)"
    echo "GID: $(id -g fxuser)"
    echo "Groups: $(groups fxuser)"
  else
    echo "❌ User 'fxuser' NOT found"
  fi
  echo ""
  
  # 3. Directory Structure
  echo "=== 3. DIRECTORY STRUCTURE ==="
  for dir in "/opt/fxserver" "/opt/fxserver/$COLOR" "/var/log/fxserver"; do
    if [ -d "$dir" ]; then
      echo "✅ $dir exists"
      ls -ld "$dir"
      echo "  Contents:"
      ls -lh "$dir" 2>/dev/null | tail -5 || true
    else
      echo "❌ $dir NOT found"
    fi
    echo ""
  done
  echo ""
  
  # 4. SSH Configuration
  echo "=== 4. SSH CONFIGURATION ==="
  if [ -d "/home/fxuser/.ssh" ]; then
    echo "✅ .ssh directory exists"
    echo "Authorized keys:"
    wc -l /home/fxuser/.ssh/authorized_keys 2>/dev/null || echo "  (file not found)"
    echo "First key fingerprint:"
    head -1 /home/fxuser/.ssh/authorized_keys 2>/dev/null | cut -c1-50 || echo "  (none)"
  else
    echo "❌ .ssh directory NOT found"
  fi
  echo ""
  
  # 5. Systemd Unit
  echo "=== 5. SYSTEMD SERVICE ==="
  if systemctl list-unit-files fxserver@.service >/dev/null 2>&1; then
    echo "✅ Systemd unit template exists"
    echo "Status: $(systemctl is-active fxserver@${COLOR} 2>/dev/null || echo 'not-started')"
    echo "Enabled: $(systemctl is-enabled fxserver@${COLOR} 2>/dev/null || echo 'disabled')"
    echo ""
    echo "Unit file location: /etc/systemd/system/fxserver@.service"
    echo "Last 10 lines of unit:"
    tail -10 /etc/systemd/system/fxserver@.service 2>/dev/null || echo "  (not found)"
  else
    echo "❌ Systemd unit NOT found"
  fi
  echo ""
  
  # 6. Service Status
  echo "=== 6. SERVICE STATUS ==="
  if systemctl is-active fxserver@${COLOR} >/dev/null 2>&1; then
    echo "✅ Service is RUNNING"
    systemctl status fxserver@${COLOR} | head -15
  else
    echo "⚠️  Service is NOT running"
  fi
  echo ""
  
  # 7. Port Check
  echo "=== 7. PORT 30120 ==="
  if ss -tlnp 2>/dev/null | grep -q 30120; then
    echo "✅ Port 30120 is LISTENING"
    ss -tlnp 2>/dev/null | grep 30120
  else
    echo "❌ Port 30120 is NOT listening"
  fi
  echo ""
  
  # 8. Health Check
  echo "=== 8. HEALTH CHECK ENDPOINT ==="
  if command -v curl &> /dev/null; then
    echo "Testing http://127.0.0.1:30120/health ..."
    if response=$(curl -s -m 3 http://127.0.0.1:30120/health 2>&1); then
      echo "✅ Connection successful"
      echo "Response: $response"
    else
      echo "❌ Connection failed or timeout"
    fi
  else
    echo "⚠️  curl not installed, skipping health check test"
  fi
  echo ""
  
  # 9. Logs
  echo "=== 9. RECENT SERVICE LOGS ==="
  if command -v journalctl &> /dev/null; then
    echo "Last 20 log entries:"
    sudo journalctl -u fxserver@${COLOR}.service -n 20 2>/dev/null || echo "(permission denied or not available)"
  else
    echo "⚠️  journalctl not available"
  fi
  echo ""
  
  # 10. Dependency Check
  echo "=== 10. DEPENDENCIES ==="
  for cmd in systemctl journalctl curl ss; do
    if command -v $cmd &> /dev/null; then
      echo "✅ $cmd available"
    else
      echo "⚠️  $cmd NOT found"
    fi
  done
  echo ""
  
  # 11. File Permissions
  echo "=== 11. FILE PERMISSIONS ==="
  echo "/opt/fxserver entry script:"
  ls -la /opt/fxserver/${COLOR}/start.sh 2>/dev/null || echo "  (not found)"
  echo ""
  echo "Fxuser home directory:"
  ls -la /opt/fxserver 2>/dev/null | head -3 || echo "  (not accessible)"
  echo ""
  
  # 12. Network
  echo "=== 12. NETWORK CONNECTIVITY ==="
  echo "IP Address:"
  hostname -I 2>/dev/null || echo "  (unknown)"
  echo ""
  echo "DNS Resolution:"
  nslookup github.com 2>/dev/null | grep "Address:" | head -2 || echo "  (DNS check skipped)"
  echo ""
  
  # 13. Summary
  echo "========================================"
  echo "END OF DIAGNOSTICS"
  echo "Generated: $(date)"
  echo "========================================"

} | tee "$OUTPUT_FILE"

echo ""
echo "✅ Diagnostics saved to: $OUTPUT_FILE"
echo ""
echo "Next steps:"
echo "1. Review output above for any ❌ or ⚠️  marks"
echo "2. Fix issues according to FXSERVER_SYSTEMD_SETUP guide"
echo "3. Run this script again to verify fixes"
