@echo off
echo Optimizing VPS for MT5 Trading...

REM Disable Windows Updates
sc config wuauserv start= disabled

REM Disable unnecessary services
sc config themes start= disabled
sc config superfetch start= disabled

REM Set high priority for MT5
wmic process where name="terminal64.exe" CALL setpriority "high priority"

REM Clear memory
echo off | clip

echo VPS Optimized for Trading!
pause