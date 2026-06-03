# Moto Seat Lab Local Database

This folder contains the local PostgreSQL database schema and generated seed SQL.

The current database is intentionally simple:

- source JSON files remain the editorial source of truth for the static Astro MVP,
- PostgreSQL mirrors those JSON files for the future maintenance/admin tool,
- most rows keep `source_data jsonb` so the schema can evolve without losing imported fields.

## Commands

```powershell
copy .env.example .env
make db-up
make db-seed
make db-check
make db-psql
```

Optional Adminer:

```powershell
make db-adminer
```

Adminer URL: `http://127.0.0.1:8080`

Use:

- System: PostgreSQL
- Server: `db`
- Username: `motoseatlab`
- Password: `motoseatlab_dev`
- Database: `motoseatlab`

## Validation

`make db-check` prints `v_content_summary`, lists `v_validation_issues`, and exits with a failure when required editorial fields are missing.

Current checks include:

- active motorcycles must have a guide path,
- seat options must have a motorcycle, source URL, image, and confidence,
- research sources must have URLs,
- solution paths must have a cost band,
- product categories must have buying checks.
