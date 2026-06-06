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
Write-Host "Schema health"
docker compose exec -T db psql -U motoseatlab -d motoseatlab -c "select * from v_schema_health order by check_name;"

Write-Host ""
Write-Host "Duplicate candidates"
docker compose exec -T db psql -U motoseatlab -d motoseatlab -c "select * from v_duplicate_candidates order by check_name, duplicate_value;"

Write-Host ""
Write-Host "Table bloat signal"
docker compose exec -T db psql -U motoseatlab -d motoseatlab -c "select relname, n_live_tup, n_dead_tup from pg_stat_user_tables where n_dead_tup > 0 order by n_dead_tup desc, relname;"

Write-Host ""
Write-Host "Validation issues"
docker compose exec -T db psql -U motoseatlab -d motoseatlab -c "select * from v_validation_issues order by table_name, record_key;"

$issueCount = docker compose exec -T db psql -U motoseatlab -d motoseatlab -t -A -c "select count(*) from v_validation_issues;"
$issueCount = [int]($issueCount.Trim())

if ($issueCount -gt 0) {
  throw "Database validation failed with $issueCount issue(s)."
}

Write-Host ""
Write-Host "Database health check passed. Review duplicate candidates manually; they are not always errors."
