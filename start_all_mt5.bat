@echo off
echo Starting Multiple MT5 Terminals for GOLDEX AI...

REM Start MT5 Terminal 1 - Account 1
start "" "C:\Program Files\MetaTrader 5\terminal64.exe" /config:account1

REM Wait 10 seconds
timeout /t 10

REM Start MT5 Terminal 2 - Account 2  
start "" "C:\Program Files\MetaTrader 5_Account2\terminal64.exe" /config:account2

REM Wait 10 seconds
timeout /t 10

REM Start MT5 Terminal 3 - Account 3
start "" "C:\Program Files\MetaTrader 5_Account3\terminal64.exe" /config:account3

echo All MT5 Terminals Started!
pause