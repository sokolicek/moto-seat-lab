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

CREATE TABLE IF NOT EXISTS motorcycle_technical_profiles (
  motorcycle_slug text PRIMARY KEY REFERENCES motorcycles(slug) ON DELETE CASCADE,
  seat_height_mm integer,
  wet_weight_kg integer,
  riding_triangle_status text NOT NULL DEFAULT 'research_needed',
  usage_profile jsonb NOT NULL DEFAULT '[]'::jsonb,
  seat_comfort_risks jsonb NOT NULL DEFAULT '[]'::jsonb,
  required_measurements jsonb NOT NULL DEFAULT '[]'::jsonb,
  notes text,
  status text NOT NULL DEFAULT 'active',
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS seat_materials (
  key text PRIMARY KEY,
  name text NOT NULL,
  material_type text NOT NULL,
  comfort_role text,
  best_for text,
  avoid_when text,
  skill_level text,
  price_band text,
  durability_notes text,
  research_status text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS workshop_tools (
  key text PRIMARY KEY,
  name text NOT NULL,
  tool_type text NOT NULL,
  skill_level text,
  used_for text,
  risk_notes text,
  buying_notes text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS workshop_supplies (
  key text PRIMARY KEY,
  name text NOT NULL,
  supply_type text NOT NULL,
  skill_level text,
  used_for text,
  best_for text,
  risk_notes text,
  buying_notes text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS buying_channels (
  key text PRIMARY KEY,
  name text NOT NULL,
  channel_type text NOT NULL,
  country_code text REFERENCES countries(code) ON DELETE SET NULL,
  best_for text,
  affiliate_potential text,
  trust_level integer CHECK (trust_level BETWEEN 1 AND 5),
  notes text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS media_assets (
  key text PRIMARY KEY,
  title text NOT NULL,
  description text,
  local_path text NOT NULL,
  download_url text,
  source_page_url text NOT NULL,
  source_name text,
  creator text,
  license_name text NOT NULL,
  license_code text NOT NULL,
  license_url text,
  rights_status text NOT NULL,
  attribution_required boolean NOT NULL DEFAULT false,
  share_alike_required boolean NOT NULL DEFAULT false,
  modification_allowed boolean NOT NULL DEFAULT false,
  commercial_use_allowed boolean NOT NULL DEFAULT false,
  endorsement_warning boolean NOT NULL DEFAULT true,
  credit_line text,
  alt text NOT NULL,
  caption text,
  dominant_color text,
  aspect_ratio text,
  object_position text,
  recommended_usage jsonb NOT NULL DEFAULT '[]'::jsonb,
  notes text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE media_assets
  ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'active';

CREATE TABLE IF NOT EXISTS content_media_links (
  media_key text NOT NULL REFERENCES media_assets(key) ON DELETE CASCADE,
  entity_type text NOT NULL,
  entity_key text NOT NULL,
  usage text NOT NULL DEFAULT 'card',
  priority integer NOT NULL DEFAULT 10,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (media_key, entity_type, entity_key, usage)
);

CREATE TABLE IF NOT EXISTS video_resources (
  key text PRIMARY KEY,
  status text NOT NULL DEFAULT 'curation_needed',
  topic text NOT NULL,
  provider text NOT NULL DEFAULT 'youtube',
  provider_video_id text,
  provider_url text NOT NULL,
  embed_url text,
  source_page_url text,
  title text NOT NULL,
  channel_name text,
  language_code text,
  duration text,
  thumbnail_url text,
  fetched_description text,
  editor_summary text NOT NULL,
  what_to_look_for jsonb NOT NULL DEFAULT '[]'::jsonb,
  fit_for jsonb NOT NULL DEFAULT '[]'::jsonb,
  risk_notes text,
  embed_policy text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS content_video_links (
  video_key text NOT NULL REFERENCES video_resources(key) ON DELETE CASCADE,
  entity_type text NOT NULL,
  entity_key text NOT NULL,
  usage text NOT NULL DEFAULT 'learning',
  priority integer NOT NULL DEFAULT 10,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (video_key, entity_type, entity_key, usage)
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
CREATE INDEX IF NOT EXISTS idx_motorcycle_technical_profiles_status ON motorcycle_technical_profiles(riding_triangle_status);
CREATE INDEX IF NOT EXISTS idx_seat_materials_type ON seat_materials(material_type);
CREATE INDEX IF NOT EXISTS idx_workshop_tools_type ON workshop_tools(tool_type);
CREATE INDEX IF NOT EXISTS idx_workshop_supplies_type ON workshop_supplies(supply_type);
CREATE INDEX IF NOT EXISTS idx_buying_channels_country ON buying_channels(country_code);
CREATE INDEX IF NOT EXISTS idx_content_media_links_entity ON content_media_links(entity_type, entity_key, usage, priority);
CREATE INDEX IF NOT EXISTS idx_video_resources_status ON video_resources(status);
CREATE INDEX IF NOT EXISTS idx_video_resources_provider ON video_resources(provider, provider_video_id);
CREATE INDEX IF NOT EXISTS idx_content_video_links_entity ON content_video_links(entity_type, entity_key, usage, priority);

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
SELECT 'research_sources', count(*)::integer FROM research_sources
UNION ALL
SELECT 'technical_profiles', count(*)::integer FROM motorcycle_technical_profiles
UNION ALL
SELECT 'seat_materials', count(*)::integer FROM seat_materials
UNION ALL
SELECT 'workshop_tools', count(*)::integer FROM workshop_tools
UNION ALL
SELECT 'workshop_supplies', count(*)::integer FROM workshop_supplies
UNION ALL
SELECT 'buying_channels', count(*)::integer FROM buying_channels
UNION ALL
SELECT 'media_assets', count(*)::integer FROM media_assets
UNION ALL
SELECT 'content_media_links', count(*)::integer FROM content_media_links
UNION ALL
SELECT 'video_resources', count(*)::integer FROM video_resources
UNION ALL
SELECT 'content_video_links', count(*)::integer FROM content_video_links;

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
WHERE buying_checks IS NULL OR jsonb_array_length(buying_checks) = 0
UNION ALL
SELECT
  'motorcycle_technical_profiles',
  motorcycle_slug,
  'technical profile has no required measurements'
FROM motorcycle_technical_profiles
WHERE required_measurements IS NULL OR jsonb_array_length(required_measurements) = 0
UNION ALL
SELECT
  'seat_materials',
  key,
  'seat material has no comfort role'
FROM seat_materials
WHERE comfort_role IS NULL OR comfort_role = ''
UNION ALL
SELECT
  'workshop_tools',
  key,
  'workshop tool has no risk notes'
FROM workshop_tools
WHERE risk_notes IS NULL OR risk_notes = ''
UNION ALL
SELECT
  'workshop_supplies',
  key,
  'workshop supply has no risk notes'
FROM workshop_supplies
WHERE risk_notes IS NULL OR risk_notes = ''
UNION ALL
SELECT
  'buying_channels',
  key,
  'buying channel has no affiliate potential'
FROM buying_channels
WHERE affiliate_potential IS NULL OR affiliate_potential = ''
UNION ALL
SELECT
  'media_assets',
  key,
  'media asset has no local_path'
FROM media_assets
WHERE local_path IS NULL OR local_path = ''
UNION ALL
SELECT
  'media_assets',
  key,
  'media asset needs credit_line when attribution is required'
FROM media_assets
WHERE attribution_required = true
  AND (credit_line IS NULL OR credit_line = '')
UNION ALL
SELECT
  'media_assets',
  key,
  'media asset has no source page URL'
FROM media_assets
WHERE source_page_url IS NULL OR source_page_url = ''
UNION ALL
SELECT
  'media_assets',
  key,
  'media asset has no alt text'
FROM media_assets
WHERE alt IS NULL OR alt = ''
UNION ALL
SELECT
  'video_resources',
  key,
  'video has no provider URL'
FROM video_resources
WHERE provider_url IS NULL OR provider_url = ''
UNION ALL
SELECT
  'video_resources',
  key,
  'verified video has no provider video id'
FROM video_resources
WHERE status LIKE 'verified%'
  AND (provider_video_id IS NULL OR provider_video_id = '')
UNION ALL
SELECT
  'video_resources',
  key,
  'video has no editorial summary'
FROM video_resources
WHERE editor_summary IS NULL OR editor_summary = ''
UNION ALL
SELECT
  'video_resources',
  key,
  'video has no learning checklist'
FROM video_resources
WHERE what_to_look_for IS NULL OR jsonb_array_length(what_to_look_for) = 0
UNION ALL
SELECT
  'video_resources',
  key,
  'video is not linked to any section or entity'
FROM video_resources
WHERE NOT EXISTS (
  SELECT 1 FROM content_video_links WHERE content_video_links.video_key = video_resources.key
);

COMMIT;
