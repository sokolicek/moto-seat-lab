$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
}

docker compose up -d db | Write-Host

Write-Host "Waiting for PostgreSQL..."
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

Write-Host "Applying schema..."
Get-Content "db/schema.sql" -Raw | docker compose exec -T db psql -U motoseatlab -d motoseatlab -v ON_ERROR_STOP=1
if ($LASTEXITCODE -ne 0) {
  throw "Schema apply failed."
}

Write-Host "Generating seed SQL..."
$nodeFallback = "C:\Program Files\nodejs\node.exe"
$nodeCommand = Get-Command node -ErrorAction SilentlyContinue
if (Test-Path $nodeFallback) {
  & $nodeFallback "scripts/generate-seed-sql.mjs"
} elseif ($nodeCommand) {
  & $nodeCommand.Source "scripts/generate-seed-sql.mjs"
} else {
  throw "Node.js was not found. Install Node.js or add it to PATH."
}

Write-Host "Applying seed data..."
Get-Content "db/seed.generated.sql" -Raw | docker compose exec -T db psql -U motoseatlab -d motoseatlab -v ON_ERROR_STOP=1
if ($LASTEXITCODE -ne 0) {
  throw "Seed apply failed."
}

Write-Host "Seed complete."
