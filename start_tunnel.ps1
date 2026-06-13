# UTF-8 Encoding
try {
    $BACKEND_PORT = 8088
    $FRONTEND_PORT = 5173
    
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    if (-not $ScriptDir) { $ScriptDir = Get-Location }
    Set-Location $ScriptDir

    Write-Host "Cleaning up old processes..." -ForegroundColor Gray
    Get-Process cloudflared -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    # 1. Start Backend
    Write-Host "Starting Django Backend..." -ForegroundColor Cyan
    $PYTHON_BIN = "python"
    if (Test-Path "backend\env\Scripts\python.exe") {
        $PYTHON_BIN = "$ScriptDir\backend\env\Scripts\python.exe"
    }
    Start-Process $PYTHON_BIN -ArgumentList "manage.py runserver 0.0.0.0:$BACKEND_PORT" -WorkingDirectory "$ScriptDir\backend" -NoNewWindow

    # 2. Start Backend Tunnel
    Write-Host "Starting Backend Tunnel..." -ForegroundColor Cyan
    $psi_be = New-Object System.Diagnostics.ProcessStartInfo
    $psi_be.FileName = "cloudflared"
    $psi_be.Arguments = "tunnel --url http://127.0.0.1:$BACKEND_PORT"
    $psi_be.UseShellExecute = $false
    $psi_be.RedirectStandardError = $true
    $be_proc = [System.Diagnostics.Process]::Start($psi_be)

    $backend_url = ""
    $start = Get-Date
    while (-not $backend_url) {
        if ($be_proc.HasExited) { throw "Backend tunnel failed to start." }
        if (((Get-Date) - $start).TotalSeconds -gt 30) { throw "Backend tunnel timeout." }
        $line = $be_proc.StandardError.ReadLine()
        if ($null -eq $line) { Start-Sleep -Milliseconds 200; continue }
        if ($line -match "https://[a-zA-Z0-9-]+\.trycloudflare\.com") {
            $backend_url = $matches[0]
        }
    }
    Write-Host "Backend URL: $backend_url" -ForegroundColor Green

    # 3. Start Frontend
    Write-Host "Starting Frontend Vite..." -ForegroundColor Cyan
    $env:VITE_API_BASE_URL = "$backend_url/api/"
    Start-Process "npm.cmd" -WorkingDirectory "$ScriptDir\frontend" -ArgumentList "run dev -- --port $FRONTEND_PORT --host 127.0.0.1" -NoNewWindow

    # 4. Start Frontend Tunnel
    Write-Host "Starting Frontend Tunnel..." -ForegroundColor Cyan
    $psi_fe = New-Object System.Diagnostics.ProcessStartInfo
    $psi_fe.FileName = "cloudflared"
    $psi_fe.Arguments = "tunnel --url http://127.0.0.1:$FRONTEND_PORT"
    $psi_fe.UseShellExecute = $false
    $psi_fe.RedirectStandardError = $true
    $fe_proc = [System.Diagnostics.Process]::Start($psi_fe)

    $frontend_url = ""
    $start = Get-Date
    while (-not $frontend_url) {
        if ($fe_proc.HasExited) { throw "Frontend tunnel failed to start." }
        if (((Get-Date) - $start).TotalSeconds -gt 30) { throw "Frontend tunnel timeout." }
        $line = $fe_proc.StandardError.ReadLine()
        if ($null -eq $line) { Start-Sleep -Milliseconds 200; continue }
        if ($line -match "https://[a-zA-Z0-9-]+\.trycloudflare\.com") {
            $frontend_url = $matches[0]
        }
    }
    Write-Host "Frontend URL: $frontend_url/nojo/" -ForegroundColor Green

    # Success Popup with QR Code
    $finalUrl = "$frontend_url/nojo/"
    $qrUrl = "https://qrenco.de/$finalUrl"
    
    $popupCmd = @"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host
Write-Host '==========================================' -FG Magenta
Write-Host 'SUCCESS! Project is now public.' -FG Green
Write-Host 'Backend API: $backend_url/api/'
Write-Host 'Frontend URL: $finalUrl' -FG White -BG Blue
Write-Host '==========================================' -FG Magenta
Write-Host 'Scan QR Code with your phone:' -FG Yellow
try {
    `$qr = Invoke-WebRequest -Uri '$qrUrl' -UserAgent 'curl/7.54.0' -UseBasicParsing -TimeoutSec 10
    Write-Host `$qr.Content
} catch {
    Write-Host 'Failed to load QR Code.'
}
Read-Host 'Press Enter to close this window'
"@
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($popupCmd)
    $encoded = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-EncodedCommand", $encoded

    Write-Host "`nRunning... Press Ctrl+C to stop." -ForegroundColor Yellow
    while ($true) { Start-Sleep -Seconds 1 }

} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
}
