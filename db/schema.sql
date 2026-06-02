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

COMMIT;
