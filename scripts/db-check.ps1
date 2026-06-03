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

Write-Host ""
Write-Host "Content summary"
docker compose exec -T db psql -U motoseatlab -d motoseatlab -c "select * from v_content_summary order by item;"

Write-Host ""
Write-Host "Validation issues"
docker compose exec -T db psql -U motoseatlab -d motoseatlab -c "select * from v_validation_issues order by table_name, record_key;"

$issueCount = docker compose exec -T db psql -U motoseatlab -d motoseatlab -t -A -c "select count(*) from v_validation_issues;"
$issueCount = [int]($issueCount.Trim())

if ($issueCount -gt 0) {
  throw "Database validation failed with $issueCount issue(s)."
}

Write-Host ""
Write-Host "Database validation passed."
