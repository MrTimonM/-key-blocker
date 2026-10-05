#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess)]
param()
$ErrorActionPreference = 'Stop'
$link = Join-Path ([Environment]::GetFolderPath('Startup')) 'Keyboard Bracket Blocker.lnk'
if (Test-Path -LiteralPath $link) {
    if ($PSCmdlet.ShouldProcess($link, 'Remove sign-in startup shortcut')) {
        Remove-Item -LiteralPath $link
    }
}
Write-Host 'To stop a currently running blocker, right-click its green H tray icon and choose Exit.'
