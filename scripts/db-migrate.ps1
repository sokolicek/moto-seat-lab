$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "Checking PostgreSQL container..."
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

Write-Host "Creating backup before migrations..."
& "$PSScriptRoot\db-backup.ps1"

$migrations = Get-ChildItem "db/migrations" -Filter "*.sql" | Sort-Object Name
if ($migrations.Count -eq 0) {
  Write-Host "No migrations found."
  exit 0
}

foreach ($migration in $migrations) {
  Write-Host "Applying migration $($migration.Name)..."
  Get-Content $migration.FullName -Raw | docker compose exec -T db psql -U motoseatlab -d motoseatlab -v ON_ERROR_STOP=1
  if ($LASTEXITCODE -ne 0) {
    throw "Migration failed: $($migration.Name)"
  }
}

Write-Host "Running database health check..."
& "$PSScriptRoot\db-health-check.ps1"

Write-Host "Migration complete."
