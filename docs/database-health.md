# Database Health And Normalization Notes

## Current Health

The local PostgreSQL database is healthy for the current Moto Seat Lab MVP.

Latest checked shape:

- 14 countries
- 13 languages
- 19 motorcycles
- 19 technical profiles
- 14 seat manufacturers
- 16 seat products
- 18 product fitments
- 39 media assets
- 13 video resources
- 910 UI translations
- 0 hard validation issues

## Normalization Assessment

The schema is already partially normalized:

- countries, languages, and country-language relations are separate,
- motorcycles are separate from technical profiles,
- seat manufacturers, products, and fitments are separate,
- media and video resources are separate from content links,
- source JSON is retained in `source_data` for import traceability.

The main remaining denormalized areas are deliberate:

- `source_data jsonb` keeps imported editorial fields without forcing a migration for every content change,
- arrays such as product claims, risks, colors, variants, usage profiles, and checklists stay JSONB because they are mostly displayed as content blocks,
- repeated status/type strings are now mirrored into controlled vocabulary tables, but the original columns remain text to avoid extra joins in common page reads.

## 3NF Target

Use full normalization for stable identity data:

- countries
- languages
- motorcycles
- manufacturers
- products
- fitments
- media assets
- video resources
- entity links

Keep controlled denormalization for editorial display data:

- lists of warnings, checks, claims, colors, variants,
- imported `source_data`,
- short labels used directly in static page rendering.

This keeps the database close to 3NF where it matters, without turning every page render into a chain of small joins.

## Duplicate Candidates

The health check reports duplicate candidates, not automatic failures:

- repeated `seat_options.source_url` can be valid when one manufacturer page covers multiple fitments,
- repeated `media_assets.local_path` is acceptable for temporary placeholders but should be replaced before publication,
- repeated video provider IDs should usually be merged unless the editorial summaries are intentionally different.

## Performance Baseline

Run:

```powershell
make db-performance
```

The current dataset is small, so most probes finish in well under a few milliseconds. PostgreSQL may choose sequential scans on tiny tables even when indexes exist; that is normal.

New targeted indexes were added for future growth:

- seat options by motorcycle and confidence,
- media links by entity and priority,
- video links by entity and priority,
- media rights filtering,
- video language/topic/status filtering.

## Maintenance Routine

After heavy reseeding or import work:

```powershell
make db-migrate
make db-health
```

If table bloat appears after repeated imports:

```powershell
docker compose exec -T db psql -U motoseatlab -d motoseatlab -c "VACUUM ANALYZE;"
```

## Next Schema Improvements

Good next steps:

- add an admin import audit table for source file name, checksum, import status, and importer version,
- add explicit product price observations as a separate table when affiliate/pricing work starts,
- add country-specific availability table for products and buying channels,
- add `canonical_entity_keys` if links grow beyond simple `entity_type + entity_key`,
- add material layer recipes only when the DIY calculator needs real computations.
