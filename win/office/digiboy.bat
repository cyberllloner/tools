@echo off
setlocal EnableExtensions EnableDelayedExpansion
title DigiBoy Auto Convert ^& Activate Office

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

:: ---------- 3. Detect license type (Retail or Volume) ----------
echo.
echo [INFO] Checking license type...
set "LICENSE_TYPE=UNKNOWN"

for /f "tokens=2 delims=:" %%A in ('cscript //nologo ospp.vbs /dstatus ^| findstr /i "LICENSE TYPE"') do (
    set "RAW_TYPE=%%A"
    set "RAW_TYPE=!RAW_TYPE: =!"
    if /i "!RAW_TYPE!"=="Retail" set "LICENSE_TYPE=RETAIL"
    if /i "!RAW_TYPE!"=="Volume" set "LICENSE_TYPE=VOLUME"
)

if "%LICENSE_TYPE%"=="RETAIL" (
    echo [WARN] Retail license detected. Converting to Volume is required.
    echo.
    echo [INFO] Running C2R-R2V-AIO converter...
    if exist "%~dp0C2R-R2V-AIO.cmd" (
        call "%~dp0C2R-R2V-AIO.cmd"
        echo [INFO] Conversion finished. Re-checking license...
    ) else (
        echo [ERROR] C2R-R2V-AIO.cmd not found next to this script.
        echo        Please download it from:
        echo        https://github.com/abbodi1406/C2R-R2V-AIO
        echo        and place it in the same folder as this .bat file.
        pause
        exit /b 3
    )
) else if "%LICENSE_TYPE%"=="VOLUME" (
    echo [INFO] Volume license detected. Skipping conversion.
) else (
    echo [WARN] Could not detect license type. Proceeding anyway...
)

:: ---------- 4. Set DigiBoy KMS host ----------
echo.
echo [INFO] Setting KMS host: kms.digiboy.ir
cscript //nologo ospp.vbs /sethst:kms.digiboy.ir

:: ---------- 5. Activate Office ----------
echo.
echo [INFO] Activating Office...
cscript //nologo ospp.vbs /act

:: ---------- 6. Show final status ----------
echo.
echo [INFO] Current activation status:
cscript //nologo ospp.vbs /dstatus

echo.
echo Done. If status is LICENSED, activation was successful.
pause
