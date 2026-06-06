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

ALTER TABLE countries
  ADD COLUMN IF NOT EXISTS slug text,
  ADD COLUMN IF NOT EXISTS flag_emoji text,
  ADD COLUMN IF NOT EXISTS native_name text,
  ADD COLUMN IF NOT EXISTS region text,
  ADD COLUMN IF NOT EXISTS market_tier text,
  ADD COLUMN IF NOT EXISTS currency_code text,
  ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'planned',
  ADD COLUMN IF NOT EXISTS priority integer NOT NULL DEFAULT 100,
  ADD COLUMN IF NOT EXISTS design_hints jsonb NOT NULL DEFAULT '{}'::jsonb,
  ADD COLUMN IF NOT EXISTS content_focus jsonb NOT NULL DEFAULT '[]'::jsonb;

CREATE TABLE IF NOT EXISTS languages (
  code text PRIMARY KEY,
  name text NOT NULL,
  native_name text NOT NULL,
  status text NOT NULL DEFAULT 'planned',
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS country_languages (
  country_code text NOT NULL REFERENCES countries(code) ON DELETE CASCADE,
  language_code text NOT NULL REFERENCES languages(code) ON DELETE CASCADE,
  is_primary boolean NOT NULL DEFAULT false,
  priority integer NOT NULL DEFAULT 10,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (country_code, language_code)
);

CREATE TABLE IF NOT EXISTS ui_translations (
  language_code text NOT NULL REFERENCES languages(code) ON DELETE CASCADE,
  translation_key text NOT NULL,
  translation_value text NOT NULL,
  status text NOT NULL DEFAULT 'draft',
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (language_code, translation_key)
);

CREATE TABLE IF NOT EXISTS localized_pages (
  country_code text NOT NULL REFERENCES countries(code) ON DELETE CASCADE,
  language_code text NOT NULL REFERENCES languages(code) ON DELETE CASCADE,
  page_key text NOT NULL,
  route_path text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  status text NOT NULL DEFAULT 'draft',
  content jsonb NOT NULL DEFAULT '{}'::jsonb,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (country_code, language_code, page_key)
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

CREATE TABLE IF NOT EXISTS seat_manufacturers (
  key text PRIMARY KEY,
  name text NOT NULL,
  manufacturer_type text NOT NULL,
  country text,
  website text,
  notes text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS seat_products (
  key text PRIMARY KEY,
  manufacturer_key text REFERENCES seat_manufacturers(key) ON DELETE SET NULL,
  name text NOT NULL,
  product_type text NOT NULL,
  status text NOT NULL,
  price_band text,
  price_note text,
  comfort_claims jsonb NOT NULL DEFAULT '[]'::jsonb,
  risks jsonb NOT NULL DEFAULT '[]'::jsonb,
  colors jsonb NOT NULL DEFAULT '[]'::jsonb,
  variants jsonb NOT NULL DEFAULT '[]'::jsonb,
  source_label text,
  source_url text,
  source_checked_at text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS seat_product_fitments (
  product_key text NOT NULL REFERENCES seat_products(key) ON DELETE CASCADE,
  motorcycle_slug text REFERENCES motorcycles(slug) ON DELETE SET NULL,
  brand text NOT NULL,
  model text NOT NULL,
  year_start integer,
  year_end integer,
  fitment_status text NOT NULL,
  notes text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (product_key, motorcycle_slug, brand, model)
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

CREATE TABLE IF NOT EXISTS country_seat_strategies (
  country_code text PRIMARY KEY REFERENCES countries(code) ON DELETE CASCADE,
  priority integer NOT NULL DEFAULT 100,
  market_mode text NOT NULL,
  lead_motorcycle_segments jsonb NOT NULL DEFAULT '[]'::jsonb,
  lead_motorcycles jsonb NOT NULL DEFAULT '[]'::jsonb,
  primary_pain_points jsonb NOT NULL DEFAULT '[]'::jsonb,
  first_recommendation text NOT NULL,
  budget_logic text NOT NULL,
  buying_priorities jsonb NOT NULL DEFAULT '[]'::jsonb,
  admin_notes text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS country_research_sources (
  key text PRIMARY KEY,
  country_code text NOT NULL REFERENCES countries(code) ON DELETE CASCADE,
  name text NOT NULL,
  url text NOT NULL,
  language_code text,
  source_type text NOT NULL DEFAULT 'forum',
  note text,
  status text NOT NULL DEFAULT 'active',
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS visitor_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  occurred_at timestamptz NOT NULL DEFAULT now(),
  country_code text REFERENCES countries(code) ON DELETE SET NULL,
  route_path text NOT NULL,
  event_type text NOT NULL DEFAULT 'page_view',
  visitor_hash text,
  consent_status text NOT NULL DEFAULT 'unknown',
  user_agent_family text,
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb
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

CREATE TABLE IF NOT EXISTS controlled_vocabularies (
  key text PRIMARY KEY,
  name text NOT NULL,
  description text,
  join_policy text NOT NULL DEFAULT 'optional_reference',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS controlled_vocabulary_terms (
  vocabulary_key text NOT NULL REFERENCES controlled_vocabularies(key) ON DELETE CASCADE,
  term_key text NOT NULL,
  label text NOT NULL,
  description text,
  sort_order integer NOT NULL DEFAULT 100,
  status text NOT NULL DEFAULT 'active',
  source_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (vocabulary_key, term_key)
);

CREATE INDEX IF NOT EXISTS idx_motorcycles_brand ON motorcycles(brand);
CREATE INDEX IF NOT EXISTS idx_countries_status ON countries(status);
CREATE INDEX IF NOT EXISTS idx_country_languages_language ON country_languages(language_code);
CREATE INDEX IF NOT EXISTS idx_ui_translations_key ON ui_translations(translation_key);
CREATE INDEX IF NOT EXISTS idx_localized_pages_route ON localized_pages(route_path);
CREATE INDEX IF NOT EXISTS idx_localized_pages_status ON localized_pages(status);
CREATE INDEX IF NOT EXISTS idx_motorcycles_status ON motorcycles(status);
CREATE INDEX IF NOT EXISTS idx_seat_options_motorcycle_slug ON seat_options(motorcycle_slug);
CREATE INDEX IF NOT EXISTS idx_seat_products_manufacturer ON seat_products(manufacturer_key);
CREATE INDEX IF NOT EXISTS idx_seat_products_status ON seat_products(status);
CREATE INDEX IF NOT EXISTS idx_seat_product_fitments_motorcycle ON seat_product_fitments(motorcycle_slug);
CREATE INDEX IF NOT EXISTS idx_seat_product_fitments_status ON seat_product_fitments(fitment_status);
CREATE INDEX IF NOT EXISTS idx_research_sources_motorcycle_slug ON research_sources(motorcycle_slug);
CREATE INDEX IF NOT EXISTS idx_motorcycle_technical_profiles_status ON motorcycle_technical_profiles(riding_triangle_status);
CREATE INDEX IF NOT EXISTS idx_seat_materials_type ON seat_materials(material_type);
CREATE INDEX IF NOT EXISTS idx_workshop_tools_type ON workshop_tools(tool_type);
CREATE INDEX IF NOT EXISTS idx_workshop_supplies_type ON workshop_supplies(supply_type);
CREATE INDEX IF NOT EXISTS idx_buying_channels_country ON buying_channels(country_code);
CREATE INDEX IF NOT EXISTS idx_country_seat_strategies_priority ON country_seat_strategies(priority, country_code);
CREATE INDEX IF NOT EXISTS idx_country_research_sources_country ON country_research_sources(country_code, source_type, status);
CREATE INDEX IF NOT EXISTS idx_visitor_events_country_time ON visitor_events(country_code, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_visitor_events_route_time ON visitor_events(route_path, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_content_media_links_entity ON content_media_links(entity_type, entity_key, usage, priority);
CREATE INDEX IF NOT EXISTS idx_video_resources_status ON video_resources(status);
CREATE INDEX IF NOT EXISTS idx_video_resources_provider ON video_resources(provider, provider_video_id);
CREATE INDEX IF NOT EXISTS idx_content_video_links_entity ON content_video_links(entity_type, entity_key, usage, priority);
CREATE INDEX IF NOT EXISTS idx_vocab_terms_status ON controlled_vocabulary_terms(vocabulary_key, status, sort_order);
CREATE INDEX IF NOT EXISTS idx_seat_options_motorcycle_confidence ON seat_options(motorcycle_slug, confidence DESC NULLS LAST);
CREATE INDEX IF NOT EXISTS idx_content_media_links_lookup ON content_media_links(entity_type, entity_key, priority, usage);
CREATE INDEX IF NOT EXISTS idx_content_video_links_lookup ON content_video_links(entity_type, entity_key, priority, usage);
CREATE INDEX IF NOT EXISTS idx_media_assets_rights ON media_assets(rights_status, commercial_use_allowed, attribution_required);
CREATE INDEX IF NOT EXISTS idx_video_resources_language_topic ON video_resources(language_code, topic, status);

CREATE OR REPLACE VIEW v_content_summary AS
SELECT 'countries' AS item, count(*)::integer AS count FROM countries
UNION ALL
SELECT 'languages', count(*)::integer FROM languages
UNION ALL
SELECT 'country_languages', count(*)::integer FROM country_languages
UNION ALL
SELECT 'ui_translations', count(*)::integer FROM ui_translations
UNION ALL
SELECT 'localized_pages', count(*)::integer FROM localized_pages
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
SELECT 'seat_manufacturers', count(*)::integer FROM seat_manufacturers
UNION ALL
SELECT 'seat_products', count(*)::integer FROM seat_products
UNION ALL
SELECT 'seat_product_fitments', count(*)::integer FROM seat_product_fitments
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
SELECT 'country_seat_strategies', count(*)::integer FROM country_seat_strategies
UNION ALL
SELECT 'country_research_sources', count(*)::integer FROM country_research_sources
UNION ALL
SELECT 'visitor_events', count(*)::integer FROM visitor_events
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
  'countries' AS table_name,
  code AS record_key,
  'country has no flag emoji' AS issue
FROM countries
WHERE flag_emoji IS NULL OR flag_emoji = ''
UNION ALL
SELECT
  'countries' AS table_name,
  code AS record_key,
  'country has no primary language link' AS issue
FROM countries
WHERE NOT EXISTS (
  SELECT 1
  FROM country_languages
  WHERE country_languages.country_code = countries.code
    AND country_languages.is_primary = true
)
UNION ALL
SELECT
  'ui_translations',
  language_code || ':' || translation_key,
  'translation has empty value'
FROM ui_translations
WHERE translation_value IS NULL OR translation_value = ''
UNION ALL
SELECT
  'localized_pages',
  country_code || ':' || page_key,
  'localized page has no title or description'
FROM localized_pages
WHERE title IS NULL OR title = '' OR description IS NULL OR description = ''
UNION ALL
SELECT
  'localized_pages',
  country_code || ':' || page_key,
  'localized page has no route path'
FROM localized_pages
WHERE route_path IS NULL OR route_path = ''
UNION ALL
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
  'seat_products',
  key,
  'seat product has no manufacturer'
FROM seat_products
WHERE manufacturer_key IS NULL
UNION ALL
SELECT
  'seat_products',
  key,
  'seat product has no source URL'
FROM seat_products
WHERE source_url IS NULL OR source_url = ''
UNION ALL
SELECT
  'seat_products',
  key,
  'seat product has no variants'
FROM seat_products
WHERE variants IS NULL OR jsonb_array_length(variants) = 0
UNION ALL
SELECT
  'seat_product_fitments',
  product_key,
  'seat product fitment has no motorcycle slug'
FROM seat_product_fitments
WHERE motorcycle_slug IS NULL
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
  'country_seat_strategies',
  country_code,
  'country strategy has no pain points'
FROM country_seat_strategies
WHERE primary_pain_points IS NULL OR jsonb_array_length(primary_pain_points) = 0
UNION ALL
SELECT
  'country_seat_strategies',
  country_code,
  'country strategy has no buying priorities'
FROM country_seat_strategies
WHERE buying_priorities IS NULL OR jsonb_array_length(buying_priorities) = 0
UNION ALL
SELECT
  'country_research_sources',
  key,
  'country research source has no URL'
FROM country_research_sources
WHERE url IS NULL OR url = ''
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

CREATE OR REPLACE VIEW v_duplicate_candidates AS
SELECT
  'seat_options.source_url' AS check_name,
  source_url AS duplicate_value,
  count(*)::integer AS row_count,
  jsonb_agg(key ORDER BY key) AS record_keys,
  'Review only: one manufacturer page may legitimately cover multiple fitments.' AS recommendation
FROM seat_options
WHERE source_url IS NOT NULL AND source_url <> ''
GROUP BY source_url
HAVING count(*) > 1
UNION ALL
SELECT
  'media_assets.local_path',
  local_path,
  count(*)::integer,
  jsonb_agg(key ORDER BY key),
  'Replace placeholder reuse with specific assets when final images are available.'
FROM media_assets
WHERE local_path IS NOT NULL AND local_path <> ''
GROUP BY local_path
HAVING count(*) > 1
UNION ALL
SELECT
  'video_resources.provider_video_id',
  provider || ':' || coalesce(provider_video_id, provider_url),
  count(*)::integer,
  jsonb_agg(key ORDER BY key),
  'Keep one resource per actual video unless different editorial summaries are required.'
FROM video_resources
GROUP BY provider, coalesce(provider_video_id, provider_url)
HAVING count(*) > 1;

CREATE OR REPLACE VIEW v_schema_health AS
SELECT 'validation_issues' AS check_name, count(*)::integer AS value, '0 required' AS target
FROM v_validation_issues
UNION ALL
SELECT 'duplicate_candidates', count(*)::integer, 'review, not always error'
FROM v_duplicate_candidates
UNION ALL
SELECT 'tables_with_dead_rows', count(*)::integer, 'run VACUUM ANALYZE after repeated seed imports'
FROM pg_stat_user_tables
WHERE n_dead_tup > 0
UNION ALL
SELECT 'controlled_vocabularies', count(*)::integer, '>= 6'
FROM controlled_vocabularies
UNION ALL
SELECT 'controlled_vocabulary_terms', count(*)::integer, 'grows with catalog'
FROM controlled_vocabulary_terms;

COMMIT;
