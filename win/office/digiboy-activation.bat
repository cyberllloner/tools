@echo off
setlocal EnableExtensions EnableDelayedExpansion
title DigiBoy Office KMS Activation

:: ---------- 1. Check Administrator privileges ----------
net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Please run this file as Administrator.
    pause
    exit /b 1
)

:: ---------- 2. Auto-detect ospp.vbs path ----------
set "OSPP="
for %%D in (
    "C:\Program Files\Microsoft Office\Office16"
    "C:\Program Files (x86)\Microsoft Office\Office16"
    "C:\Program Files\Microsoft Office\root\Office16"
    "C:\Program Files (x86)\Microsoft Office\root\Office16"
) do (
    if exist "%%~D\ospp.vbs" set "OSPP=%%~D"
)

if not defined OSPP (
    echo [ERROR] ospp.vbs not found. Office may not be installed.
    pause
    exit /b 2
)

echo [INFO] Found Office folder: %OSPP%
cd /d "%OSPP%"

:: ---------- 3. Set DigiBoy KMS host ----------
echo.
echo [INFO] Setting KMS host: kms.digiboy.ir
cscript //nologo ospp.vbs /sethst:kms.digiboy.ir

:: ---------- 4. Activate Office ----------
echo.
echo [INFO] Activating Office...
cscript //nologo ospp.vbs /act

:: ---------- 5. Show final activation status ----------
echo.
echo [INFO] Current activation status:
cscript //nologo ospp.vbs /dstatus

echo.
echo Done. If status is LICENSED, activation was successful.
pause
