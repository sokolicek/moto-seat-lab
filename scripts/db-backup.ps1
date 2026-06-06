$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$backupDir = Join-Path $root "backups\db"
New-Item -ItemType Directory -Force $backupDir | Out-Null

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupFile = Join-Path $backupDir "motoseatlab-$timestamp.sql"

Write-Host "Creating PostgreSQL backup: $backupFile"
docker compose up -d db | Write-Host

for ($i = 0; $i -lt 40; $i++) {
  docker compose exec -T db pg_isready -U motoseatlab -d motoseatlab | Out-Null
  if ($LASTEXITCODE -eq 0) {
    break
  }
  Start-Sleep -Seconds 2
}

if ($LASTEXITCODE -ne 0) {
  throw "PostgreSQL did not become ready."
}

docker compose exec -T db pg_dump -U motoseatlab -d motoseatlab --clean --if-exists --no-owner --no-privileges | Set-Content -Encoding UTF8 $backupFile

Write-Host "Backup complete: $backupFile"
