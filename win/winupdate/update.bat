@echo off
:: Windows Update Manager - Enable/Disable Script
:: Must be run as Administrator

title Windows Update Manager

:MENU
cls
echo ========================================================
echo         Windows Update Manager (Run as Admin)
echo ========================================================
echo.
echo  [1] Disable Windows Update (Stop and Disable Services)
echo  [2] Enable Windows Update (Set to Automatic and Start)
echo  [3] Exit
echo.
set /p choice="Enter your choice (1/2/3): "

if "%choice%"=="1" goto :DISABLE
if "%choice%"=="2" goto :ENABLE
if "%choice%"=="3" exit /b
goto :MENU

:DISABLE
echo.
echo Disabling Windows Update services...
sc config wuauserv start= disabled
net stop wuauserv
sc config bits start= disabled
net stop bits
sc config dosvc start= disabled
net stop dosvc
echo.
echo [DONE] Windows Update has been disabled.
pause
goto :MENU

:ENABLE
echo.
echo Enabling Windows Update services...
sc config wuauserv start= auto
net start wuauserv
sc config bits start= auto
net start bits
sc config dosvc start= auto
net start dosvc
echo.
echo [DONE] Windows Update has been enabled.
pause
goto :MENU
