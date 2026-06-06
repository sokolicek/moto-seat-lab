BEGIN;

CREATE TABLE IF NOT EXISTS country_catalog_localizations (
  country_code text PRIMARY KEY REFERENCES countries(code) ON DELETE CASCADE,
  language_code text REFERENCES languages(code) ON DELETE SET NULL,
  title text NOT NULL,
  intro text NOT NULL,
  quick_relief jsonb NOT NULL DEFAULT '[]'::jsonb,
  buying_recommendations jsonb NOT NULL DEFAULT '[]'::jsonb,
  diy_recommendations jsonb NOT NULL DEFAULT '[]'::jsonb,
  availability_notes text NOT NULL,
  admin_priority text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_country_catalog_localizations_language ON country_catalog_localizations(language_code, country_code);

ANALYZE;

COMMIT;
