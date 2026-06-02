$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "This removes the local PostgreSQL container and named volume for Moto Seat Lab."
$confirmation = Read-Host "Type RESET to continue"
if ($confirmation -ne "RESET") {
  Write-Host "Reset cancelled."
  exit 0
}

docker compose down -v
& "$PSScriptRoot\db-seed.ps1"
