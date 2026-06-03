param(
  [switch] $Force
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$registryPath = Join-Path $root "src\data\media\media-assets.json"

if (-not (Test-Path $registryPath)) {
  throw "Media registry not found: $registryPath"
}

$assets = Get-Content $registryPath -Raw | ConvertFrom-Json
$downloaded = 0
$skipped = 0
$failed = 0

foreach ($asset in $assets) {
  if ($asset.status -ne "active") {
    $skipped++
    continue
  }

  if (-not $asset.downloadUrl -or -not $asset.localPath) {
    Write-Warning "Skipping $($asset.key): missing downloadUrl or localPath."
    $skipped++
    continue
  }

  $relativePath = $asset.localPath.TrimStart("/")
  $targetPath = Join-Path $root ("public\" + ($relativePath -replace "/", "\"))
  $targetDir = Split-Path -Parent $targetPath

  if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
  }

  if ((Test-Path $targetPath) -and -not $Force) {
    Write-Host "SKIP $($asset.key) -> $targetPath"
    $skipped++
    continue
  }

  Write-Host "GET  $($asset.key)"
  Write-Host "     $($asset.downloadUrl)"
  try {
    Invoke-WebRequest -Uri $asset.downloadUrl -OutFile $targetPath -MaximumRedirection 10
  }
  catch {
    Write-Warning "FAILED $($asset.key): $($_.Exception.Message)"
    if (Test-Path $targetPath) {
      Remove-Item -LiteralPath $targetPath
    }
    $failed++
    continue
  }

  $file = Get-Item $targetPath
  if ($file.Length -lt 1024) {
    throw "Downloaded file is unexpectedly small: $targetPath"
  }

  Write-Host "OK   $($asset.localPath) ($($file.Length) bytes)"
  $downloaded++
}

Write-Host ""
Write-Host "Media download complete. Downloaded: $downloaded, skipped: $skipped, failed: $failed"

if ($failed -gt 0) {
  exit 1
}
