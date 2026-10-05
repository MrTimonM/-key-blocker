@echo off
set "AHK_EXE=%ProgramFiles%\AutoHotkey\v2\AutoHotkey64.exe"
set "BLOCKER=%LOCALAPPDATA%\KeyboardBracketBlocker\Block-Bracket.ahk"
if not exist "%AHK_EXE%" (
  echo Install AutoHotkey v2 first. See README.md.
  pause
  exit /b 1
)
if not exist "%BLOCKER%" (
  echo Run Setup.ps1 first. See README.md.
  pause
  exit /b 1
)
start "" "%AHK_EXE%" "%BLOCKER%"
