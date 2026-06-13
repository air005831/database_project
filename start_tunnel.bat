@echo off
cd /d "%~dp0"
title Cloudflare Tunnel Starter
echo Checking for cloudflared...
where cloudflared >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: cloudflared not found in PATH.
    echo Please install it from https://github.com/cloudflare/cloudflared/releases
    pause
    exit /b 1
)

echo Starting Tunnel via PowerShell...
powershell -NoProfile -ExecutionPolicy Bypass -File start_tunnel.ps1
if %errorlevel% neq 0 (
    echo.
    echo Script exited with error code %errorlevel%
    pause
)
