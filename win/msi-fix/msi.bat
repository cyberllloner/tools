:: Turn off command echoing
@echo off

:: Associate the .msi file extension with the Msi.Package file type
assoc .msi=Msi.Package

:: Add the registry key to tell Windows to open .msi files using msiexec.exe (/f forces overwrite)
reg add "HKCR\Msi.Package\shell\Open\command" /ve /t REG_SZ /d "\"%SystemRoot%\System32\msiexec.exe\" /i \"%1\" %*" /f

:: Set the Windows Installer service (MSIServer) startup type to Manual (value 3)
REG add "HKLM\SYSTEM\CurrentControlSet\services\MSIServer" /v Start /t REG_DWORD /d 3 /f

:: Pause the script so the window stays open
pause
