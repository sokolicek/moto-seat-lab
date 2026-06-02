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
