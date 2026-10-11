param([string]$DestinationRoot = '')
$ErrorActionPreference = 'Stop'
$backupRoot = $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $backupRoot 'MANIFEST.json') -Raw | ConvertFrom-Json
foreach ($entry in $manifest.files.PSObject.Properties) {
    $filePath = Join-Path $backupRoot $entry.Name
    $actualHash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -ne $entry.Value.sha256) { throw "Backup checksum mismatch: $($entry.Name)" }
}
$restoreRoot = if ($DestinationRoot) { $DestinationRoot } else { Join-Path $backupRoot 'restored-vendor-apps' }
New-Item -ItemType Directory -Path $restoreRoot -Force | Out-Null
foreach ($entry in $manifest.archives.PSObject.Properties) {
    $archivePath = Join-Path $restoreRoot ($entry.Name + '.zip')
    if (Test-Path -LiteralPath $archivePath) { throw "Archive already exists: $archivePath. Use a fresh extraction folder." }
    $output = [System.IO.File]::Open($archivePath, [System.IO.FileMode]::CreateNew)
    try {
        foreach ($part in $entry.Value.parts) {
            $inputStream = [System.IO.File]::OpenRead((Join-Path $backupRoot $part))
            try { $inputStream.CopyTo($output) } finally { $inputStream.Dispose() }
        }
    } finally { $output.Dispose() }
    if ((Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.Value.sha256) {
        throw "Reconstructed archive checksum mismatch: $($entry.Name)"
    }
    $destination = Join-Path $restoreRoot $entry.Name
    if (Test-Path -LiteralPath $destination) { throw "Destination already exists: $destination" }
    Expand-Archive -LiteralPath $archivePath -DestinationPath $destination
    Write-Output "Verified and extracted $($entry.Name)"
}
Write-Output 'All backup checksums passed. Vendor applications were extracted; nothing was installed or executed.'
