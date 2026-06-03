.PHONY: dev build check media-download db-up db-down db-logs db-seed db-check db-reset db-psql db-adminer

dev:
	npm run dev

build:
	npm run build

check:
	npm run check

media-download:
	powershell -NoProfile -ExecutionPolicy Bypass -File scripts/download-media-assets.ps1

db-up:
	docker compose up -d db

db-down:
	docker compose down

db-logs:
	docker compose logs -f db

db-seed:
	powershell -NoProfile -ExecutionPolicy Bypass -File scripts/db-seed.ps1

db-check:
	powershell -NoProfile -ExecutionPolicy Bypass -File scripts/db-check.ps1

db-reset:
	powershell -NoProfile -ExecutionPolicy Bypass -File scripts/db-reset.ps1

db-psql:
	docker compose exec db psql -U motoseatlab -d motoseatlab

db-adminer:
	docker compose --profile tools up -d adminer
