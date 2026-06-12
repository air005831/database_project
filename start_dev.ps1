# Get script root directory
$PROJECT_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "==================================================" -ForegroundColor Magenta
Write-Host "        Starting Frontend and Backend Servers" -ForegroundColor Magenta
Write-Host "==================================================" -ForegroundColor Magenta
Write-Host ""

# Start Backend (Django) in a new PowerShell window
Write-Host "[1/2] Launching Backend (Django)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PROJECT_ROOT\backend'; & .\env\Scripts\Activate.ps1; python manage.py runserver"

# Start Frontend (Vite) in a new PowerShell window
Write-Host "[2/2] Launching Frontend (Vite)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PROJECT_ROOT\frontend'; npm run dev"

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host " Both servers have been launched in new windows!" -ForegroundColor Green
Write-Host " - Close the separate windows to stop the servers." -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
