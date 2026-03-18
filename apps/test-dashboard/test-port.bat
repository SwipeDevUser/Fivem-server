@echo off
REM FiveM Server Port Testing Tool
REM This script tests if your port forwarding is working

title FiveM Server Port Testing

:menu
cls
echo ========================================
echo FiveM Server - Port Testing Utility
echo ========================================
echo.
echo Your Info:
echo - Local IP: 192.168.1.11
echo - Public IP: 108.188.113.251
echo - FiveM Port: 30120
echo.
echo ========================================
echo Choose a test:
echo ========================================
echo.
echo [1] Test Local Connection (127.0.0.1:30120)
echo [2] Test LAN Connection (192.168.1.11:30120)
echo [3] Test Public IP (108.188.113.251:30120)
echo [4] Show Network Configuration
echo [5] Copy Connection Commands
echo [0] Exit
echo.
set /p choice="Enter your choice (0-5): "

if "%choice%"=="1" goto local_test
if "%choice%"=="2" goto lan_test
if "%choice%"=="3" goto public_test
if "%choice%"=="4" goto show_config
if "%choice%"=="5" goto copy_commands
if "%choice%"=="0" exit /b

goto menu

:local_test
cls
echo Testing Local Connection: 127.0.0.1:30120
echo.
netstat -ano | findstr ":30120" > nul
if errorlevel 1 (
    echo ✗ Port 30120 is NOT listening
    echo Server may not be running. Check FXServer...
) else (
    echo ✓ Port 30120 is listening on localhost
    echo Use FiveM command: connect 127.0.0.1:30120
)
pause
goto menu

:lan_test
cls
echo Testing LAN Connection: 192.168.1.11:30120
echo.
echo Attempting to reach your server locally...
ping 192.168.1.11 -n 1 > nul
if errorlevel 1 (
    echo ✗ Local IP not responding
) else (
    echo ✓ Local IP is reachable
    echo Use FiveM command: connect 192.168.1.11:30120
)
pause
goto menu

:public_test
cls
echo Testing Public Connection: 108.188.113.251:30120
echo.
echo This tests if your port forwarding is working.
echo Please wait...
echo.
echo To properly test, use an external tool:
echo https://canyouseeme.org/
echo.
echo Or manually in FiveM console:
echo connect 108.188.113.251:30120
echo.
echo Or use your server ID:
echo connect krb6e7.cfx.me
pause
goto menu

:show_config
cls
echo ========================================
echo Your Network Configuration
echo ========================================
echo.
echo Current Network Adapters:
echo.
ipconfig /all | findstr /R "Description|IPv4|Subnet|Gateway|DHCP" | more
echo.
pause
goto menu

:copy_commands
cls
echo ========================================
echo FiveM Connection Commands
echo ========================================
echo.
echo Local Testing:
echo   connect 127.0.0.1:30120
echo.
echo LAN Testing:
echo   connect 192.168.1.11:30120
echo.
echo Public (with port forwarding):
echo   connect 108.188.113.251:30120
echo   connect krb6e7.cfx.me
echo.
echo Run these in FiveM console (press F8 in-game)
echo.
pause
goto menu
