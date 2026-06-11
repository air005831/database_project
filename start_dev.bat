@echo off
title Dev Server Starter
echo ==================================================
echo         Starting Frontend and Backend Servers
echo ==================================================
echo.

:: Get the directory of the batch script
set "PROJECT_ROOT=%~dp0"

:: Start Backend (Django) in a new cmd window
echo [1/2] Launching Backend (Django)...
start "Backend Server - Django" cmd /k "cd /d "%PROJECT_ROOT%backend" && call env\Scripts\activate && python manage.py runserver"

:: Start Frontend (Vite) in a new cmd window
echo [2/2] Launching Frontend (Vite)...
start "Frontend Server - Vite" cmd /k "cd /d "%PROJECT_ROOT%frontend" && npm run dev"

echo.
echo ==================================================
echo  Both servers have been launched in new windows!
echo  - Close the separate windows to stop the servers.
echo ==================================================
echo.
pause
