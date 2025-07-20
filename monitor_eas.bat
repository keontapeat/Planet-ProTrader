@echo off
:loop
echo Checking MT5 Terminals...

REM Check if MT5 processes are running
tasklist /FI "IMAGENAME eq terminal64.exe" 2>NUL | find /I /N "terminal64.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo MT5 Terminals are running
) else (
    echo Restarting MT5 Terminals...
    call start_all_mt5.bat
)

REM Wait 5 minutes before next check
timeout /t 300
goto loop