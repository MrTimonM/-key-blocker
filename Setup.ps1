#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$InstallDirectory = (Join-Path $env:LOCALAPPDATA 'KeyboardBracketBlocker')
)
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# This prepares files only: no driver installation, reboot, startup entry, or launch.
$stage = Join-Path ([IO.Path]::GetTempPath()) ('key-blocker-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stage -Force | Out-Null
function Get-VerifiedArchive {
    param([string]$Url, [string]$File, [string]$Sha256)
    Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $File
    if ((Get-FileHash -LiteralPath $File -Algorithm SHA256).Hash -ne $Sha256) {
        throw "Checksum mismatch: $File. Setup stopped; do not use that download."
    }
}
Get-VerifiedArchive `
    'https://github.com/evilC/AutoHotInterception/releases/download/v0.9.2/AutoHotInterception.zip' `
    (Join-Path $stage 'AHI.zip') `
    '5E0DD6C69A61FE0E6F040D9FD82D7099022A84A0E6BC3A338666EEB23CA4F0DA'
Get-VerifiedArchive `
    'https://github.com/oblitum/Interception/releases/download/v1.0.1/Interception.zip' `
    (Join-Path $stage 'Interception.zip') `
    'AD038963D6413055765128B0B931F6E765147C9916DBA79E65D872B261F9AF10'
Expand-Archive -LiteralPath (Join-Path $stage 'AHI.zip') -DestinationPath (Join-Path $stage 'AHI')
Expand-Archive -LiteralPath (Join-Path $stage 'Interception.zip') -DestinationPath (Join-Path $stage 'Interception')

$ahiRoot = Join-Path $stage 'AHI'
$driverRoot = Join-Path $stage 'Interception\Interception'
$lib = Join-Path $InstallDirectory 'Lib'
$driver = Join-Path $InstallDirectory 'Driver'
New-Item -ItemType Directory -Path $InstallDirectory, $lib, $driver -Force | Out-Null
Copy-Item -Path (Join-Path $ahiRoot 'AHK v2\Lib\*') -Destination $lib -Recurse -Force
Copy-Item -LiteralPath (Join-Path $ahiRoot 'Common\Lib\AutoHotInterception.dll') -Destination $lib -Force
foreach ($arch in @('x64', 'x86')) {
    New-Item -ItemType Directory -Path (Join-Path $lib $arch) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $driverRoot "library\$arch\interception.dll") -Destination (Join-Path $lib $arch) -Force
}
Copy-Item -LiteralPath (Join-Path $ahiRoot 'AHK v2\Monitor.ahk') -Destination $InstallDirectory -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Block-Bracket.ahk') -Destination $InstallDirectory -Force
Copy-Item -LiteralPath (Join-Path $ahiRoot 'LICENSE') -Destination (Join-Path $InstallDirectory 'AutoHotInterception-LICENSE.txt') -Force
Copy-Item -LiteralPath (Join-Path $driverRoot 'command line installer\install-interception.exe') -Destination $driver -Force
Copy-Item -LiteralPath (Join-Path $driverRoot 'licenses') -Destination $driver -Recurse -Force
Get-ChildItem -LiteralPath $InstallDirectory -File -Recurse | Unblock-File
Write-Host "Prepared: $InstallDirectory"
Write-Host 'Next: install AutoHotkey v2 if needed; install the driver as administrator; reboot. See README.md.'
Write-Host "Downloaded archives remain in $stage for an optional offline backup."
