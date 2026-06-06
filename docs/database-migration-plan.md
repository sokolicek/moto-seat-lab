# Database Backup And Migration Plan

## Goal

Keep the local PostgreSQL database reproducible while allowing schema evolution from the current MVP into a maintainable catalog/admin system.

## Rule

Every schema migration must be:

- backed up first,
- additive when possible,
- idempotent where practical,
- validated with `make db-health`,
- performance checked with `make db-performance` for common page queries.

## Backup

Create a local SQL backup:

```powershell
make db-backup
```

Backups are written to:

```text
backups/db/
```

These files are local safety artifacts and should not be committed.

## Migration

Apply migrations:

```powershell
make db-migrate
```

The migration script:

1. starts PostgreSQL,
2. creates a backup,
3. applies every SQL file in `db/migrations/` in filename order,
4. runs the database health check.

## Current Migration

`0001_normalization_foundation.sql` adds:

- controlled vocabulary tables,
- vocabulary terms generated from current status/type/entity values,
- future-facing indexes for common lookups,
- duplicate candidate reporting,
- schema health summary view.

It does not delete data and does not force new joins into the page rendering path.

## Old-To-New Data Strategy

The current source of truth remains the JSON files in `src/data/`. PostgreSQL mirrors them.

Migration path:

1. Back up the current database.
2. Apply schema migration.
3. Re-run seed generation and seeding if JSON data changed.
4. Run `make db-health`.
5. Run `make db-performance`.
6. Only after validation, update application queries to use new normalized tables where they add value.

## Rollback

For local development, the safest rollback is:

1. stop the app,
2. restore from the latest SQL backup manually through `psql`,
3. or reset and reseed from JSON if no local manual edits need to be preserved.

Because the current migration is additive, rollback is normally not needed for page rendering.
