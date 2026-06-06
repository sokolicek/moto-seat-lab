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

$queries = @(
  @{
    Name = "motorcycle_with_seat_options"
    Sql = "EXPLAIN (ANALYZE, BUFFERS) SELECT m.slug, m.brand, m.model, so.key, so.name FROM motorcycles m LEFT JOIN seat_options so ON so.motorcycle_slug = m.slug WHERE m.slug = 'suzuki-gsx-s1000gx' ORDER BY so.confidence DESC NULLS LAST;"
  },
  @{
    Name = "motorcycle_media_assets"
    Sql = "EXPLAIN (ANALYZE, BUFFERS) SELECT ma.key, ma.title, cml.usage FROM content_media_links cml JOIN media_assets ma ON ma.key = cml.media_key WHERE cml.entity_type = 'motorcycle_profile' AND cml.entity_key = 'suzuki-gsx-s1000gx' ORDER BY cml.priority;"
  },
  @{
    Name = "foam_learning_videos"
    Sql = "EXPLAIN (ANALYZE, BUFFERS) SELECT v.key, v.title, cvl.usage FROM content_video_links cvl JOIN video_resources v ON v.key = cvl.video_key WHERE cvl.entity_type = 'page_section' AND cvl.entity_key = 'de-diy-schaumstoffe' ORDER BY cvl.priority;"
  },
  @{
    Name = "language_ui_translations"
    Sql = "EXPLAIN (ANALYZE, BUFFERS) SELECT translation_key, translation_value FROM ui_translations WHERE language_code = 'zh' ORDER BY translation_key;"
  },
  @{
    Name = "catalog_fitments"
    Sql = "EXPLAIN (ANALYZE, BUFFERS) SELECT sp.key, sp.name, sm.name AS maker, f.brand, f.model FROM seat_product_fitments f JOIN seat_products sp ON sp.key = f.product_key LEFT JOIN seat_manufacturers sm ON sm.key = sp.manufacturer_key WHERE f.motorcycle_slug = 'bmw-r-1300-gs' ORDER BY sm.name, sp.name;"
  }
)

foreach ($query in $queries) {
  Write-Host ""
  Write-Host "Performance probe: $($query.Name)"
  docker compose exec -T db psql -U motoseatlab -d motoseatlab -c $query.Sql
}

Write-Host ""
Write-Host "Performance probes complete. For this MVP, prefer simple joins plus targeted indexes over deep normalization."
