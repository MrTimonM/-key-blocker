#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$InstallDirectory = (Join-Path $env:LOCALAPPDATA 'KeyboardBracketBlocker'),
    [string]$AutoHotkeyPath = (Join-Path $env:ProgramFiles 'AutoHotkey\v2\AutoHotkey64.exe')
)
$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $InstallDirectory 'Block-Bracket.ahk'
foreach ($file in @($AutoHotkeyPath, $scriptPath, (Join-Path $InstallDirectory 'Lib\AutoHotInterception.dll'), (Join-Path $InstallDirectory 'Lib\x64\interception.dll'))) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "Missing: $file. Complete setup first." }
}
$startup = [Environment]::GetFolderPath('Startup')
$link = Join-Path $startup 'Keyboard Bracket Blocker.lnk'
if ($PSCmdlet.ShouldProcess($link, 'Create or update sign-in startup shortcut')) {
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($link)
    $shortcut.TargetPath = $AutoHotkeyPath
    $shortcut.Arguments = '"' + $scriptPath + '"'
    $shortcut.WorkingDirectory = $InstallDirectory
    $shortcut.Description = 'Block [ on the configured external Bluetooth and USB keyboard interfaces.'
    $shortcut.Save()
    Write-Host 'Enabled for this Windows user. Runs at sign-in, not before the login screen.'
    Write-Host 'Start-Blocker.cmd can start it now; otherwise it starts at your next sign-in.'
}
