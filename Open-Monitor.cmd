@echo off
set "AHK_EXE=%ProgramFiles%\AutoHotkey\v2\AutoHotkey64.exe"
set "MONITOR=%LOCALAPPDATA%\KeyboardBracketBlocker\Monitor.ahk"
if not exist "%AHK_EXE%" (
  echo Install AutoHotkey v2 first. See README.md.
  pause
  exit /b 1
)
if not exist "%MONITOR%" (
  echo Run Setup.ps1 first. See README.md.
  pause
  exit /b 1
)
echo Exit the blocker before using Monitor. Select one keyboard at a time.
start "" "%AHK_EXE%" "%MONITOR%"
