@echo off
setlocal enabledelayedexpansion

REM FiveM Server Startup Script
REM This script starts the FiveM server with console output

color 0A
title FiveM Server - Admin Dashboard

echo.
echo ========================================
echo   FiveM Server Launcher
echo ========================================
echo.

REM Check if FXServer.exe exists
if not exist "FXServer.exe" (
    echo ERROR: FXServer.exe not found!
    echo Please ensure you are in the correct directory.
    pause
    exit /b 1
)

REM Check if server.cfg exists
if not exist "server.cfg" (
    echo ERROR: server.cfg not found!
    echo Please create a server.cfg file first.
    pause
    exit /b 1
)

echo [*] Starting FiveM Server...
echo [*] Server name: Admin Dashboard Server
echo [*] Configuration file: server.cfg
echo.
echo [*] Press Ctrl+C to stop the server
echo.

REM Start the server
FXServer.exe

pause
