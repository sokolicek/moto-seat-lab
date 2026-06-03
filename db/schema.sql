BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS countries (
  code text PRIMARY KEY,
  name text NOT NULL,
  language_code text NOT NULL,
  market_notes text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS motorcycles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text UNIQUE NOT NULL,
  brand text NOT NULL,
  model text NOT NULL,
  segment text,
  country_priority text,
  status text NOT NULL DEFAULT 'planned',
  guide_path text,
  seat_pain_focus text,
  why_next text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS solution_paths (
  key text PRIMARY KEY,
  title text NOT NULL,
  summary text NOT NULL,
  best_for text,
  not_ideal_for text,
  cost text,
  confidence text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS product_categories (
  key text PRIMARY KEY,
  name text NOT NULL,
  problem_solved text,
  limitations text,
  price_band text,
  first_test text,
  avoid_when text,
  buying_checks jsonb NOT NULL DEFAULT '[]'::jsonb,
  affiliate_status text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS seat_options (
  key text PRIMARY KEY,
  motorcycle_slug text REFERENCES motorcycles(slug) ON DELETE SET NULL,
  name text NOT NULL,
  maker text NOT NULL,
  option_type text,
  fitment text,
  market text,
  price_note text,
  best_for text,
  watch_out text,
  comfort_logic text,
  research_status text,
  confidence integer CHECK (confidence BETWEEN 1 AND 5),
  affiliate_status text,
  image_path text,
  image_alt text,
  source_label text,
  source_url text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS research_sources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  motorcycle_slug text REFERENCES motorcycles(slug) ON DELETE SET NULL,
  title text NOT NULL,
  url text NOT NULL,
  notes text,
  confidence integer CHECK (confidence BETWEEN 1 AND 5),
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS import_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  label text NOT NULL,
  imported_at timestamptz NOT NULL DEFAULT now(),
  row_counts jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_motorcycles_brand ON motorcycles(brand);
CREATE INDEX IF NOT EXISTS idx_motorcycles_status ON motorcycles(status);
CREATE INDEX IF NOT EXISTS idx_seat_options_motorcycle_slug ON seat_options(motorcycle_slug);
CREATE INDEX IF NOT EXISTS idx_research_sources_motorcycle_slug ON research_sources(motorcycle_slug);

CREATE OR REPLACE VIEW v_content_summary AS
SELECT 'countries' AS item, count(*)::integer AS count FROM countries
UNION ALL
SELECT 'motorcycles', count(*)::integer FROM motorcycles
UNION ALL
SELECT 'active_motorcycles', count(*)::integer FROM motorcycles WHERE status = 'active'
UNION ALL
SELECT 'solution_paths', count(*)::integer FROM solution_paths
UNION ALL
SELECT 'product_categories', count(*)::integer FROM product_categories
UNION ALL
SELECT 'seat_options', count(*)::integer FROM seat_options
UNION ALL
SELECT 'research_sources', count(*)::integer FROM research_sources;

CREATE OR REPLACE VIEW v_validation_issues AS
SELECT
  'motorcycles' AS table_name,
  slug AS record_key,
  'active motorcycle has no guide_path' AS issue
FROM motorcycles
WHERE status = 'active'
  AND (guide_path IS NULL OR guide_path = '')
UNION ALL
SELECT
  'seat_options',
  key,
  'seat option has no motorcycle_slug'
FROM seat_options
WHERE motorcycle_slug IS NULL
UNION ALL
SELECT
  'seat_options',
  key,
  'seat option has no source_url'
FROM seat_options
WHERE source_url IS NULL OR source_url = ''
UNION ALL
SELECT
  'seat_options',
  key,
  'seat option has no image_path'
FROM seat_options
WHERE image_path IS NULL OR image_path = ''
UNION ALL
SELECT
  'seat_options',
  key,
  'seat option confidence is missing'
FROM seat_options
WHERE confidence IS NULL
UNION ALL
SELECT
  'research_sources',
  title,
  'research source has no URL'
FROM research_sources
WHERE url IS NULL OR url = ''
UNION ALL
SELECT
  'solution_paths',
  key,
  'solution path has no cost band'
FROM solution_paths
WHERE cost IS NULL OR cost = ''
UNION ALL
SELECT
  'product_categories',
  key,
  'product category has no buying checks'
FROM product_categories
WHERE buying_checks IS NULL OR jsonb_array_length(buying_checks) = 0;

COMMIT;
