# FiveM Server Startup Script (PowerShell)
# Usage: .\start-server.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   FiveM Server Launcher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Change to script directory
Set-Location $PSScriptRoot

# Verify FXServer.exe exists
if (-not (Test-Path "FXServer.exe")) {
    Write-Host "ERROR: FXServer.exe not found!" -ForegroundColor Red
    Write-Host "Please ensure you are in the correct directory." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Verify server.cfg exists
if (-not (Test-Path "server.cfg")) {
    Write-Host "ERROR: server.cfg not found!" -ForegroundColor Red
    Write-Host "Please create a server.cfg file first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Get server config info
$serverName = Select-String -Path "server.cfg" -Pattern "sv_serverName" | Select-Object -First 1
$maxClients = Select-String -Path "server.cfg" -Pattern "sv_maxclients" | Select-Object -First 1

Write-Host "[*] Server Configuration:" -ForegroundColor Yellow
Write-Host "    $serverName" -ForegroundColor White
Write-Host "    $maxClients" -ForegroundColor White
Write-Host ""
Write-Host "[*] Starting FiveM Server..." -ForegroundColor Green
Write-Host "[*] Press Ctrl+C to stop the server" -ForegroundColor Cyan
Write-Host ""

# Start server
try {
    & .\FXServer.exe
}
catch {
    Write-Host "ERROR: Failed to start server" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
