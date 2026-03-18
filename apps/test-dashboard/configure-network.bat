@echo off
REM FiveM Server Network Configuration Script
REM Run this as Administrator to configure firewall and port forwarding

echo ========================================
echo FiveM Server Network Setup
echo ========================================
echo.

REM Check for administrator privileges
openfiles >nul 2>&1
if errorlevel 1 (
    echo ERROR: This script must be run as Administrator!
    echo Please right-click this file and select "Run as Administrator"
    pause
    exit /b 1
)

echo [1/3] Opening Windows Firewall for FiveM Server...
netsh advfirewall firewall add rule name="FiveM Server TCP 30120" dir=in action=allow protocol=tcp localport=30120 remoteip=any program=any enable=yes profile=any
netsh advfirewall firewall add rule name="FiveM Server UDP 30120" dir=in action=allow protocol=udp localport=30120 remoteip=any program=any enable=yes profile=any

if errorlevel 0 (
    echo ✓ Firewall rules added successfully
) else (
    echo ! Firewall configuration had issues (may already exist)
)

echo.
echo [2/3] Current Network Configuration:
echo Your Local IP: 
ipconfig | findstr /R "IPv4 Address"

echo.
echo [3/3] Important Next Steps:
echo ========================================
echo 1. NOTE YOUR LOCAL IP ADDRESS above (usually 192.168.x.x)
echo.
echo 2. Access your Router:
echo    - Open browser: http://192.168.1.1 or http://192.168.0.1
echo    - Login with router admin credentials
echo    - Find "Port Forwarding" settings
echo.
echo 3. Set up Port Forwarding:
echo    - External Port: 30120 (TCP)
echo    - Internal Port: 30120 (TCP)
echo    - Internal IP: [YOUR LOCAL IP from above]
echo    - Repeat for UDP
echo.
echo 4. Test your server:
echo    - Players can connect to: krb6e7.cfx.me
echo    - Check server status at: http://YOUR_PUBLIC_IP:40120/
echo.
echo Server Info:
echo - FiveM Port: 30120
echo - txAdmin Port: 40120
echo - Dashboard: http://localhost:3000/
echo.
echo ========================================
pause
