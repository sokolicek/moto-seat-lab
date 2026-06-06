BEGIN;

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

INSERT INTO controlled_vocabularies (key, name, description, join_policy, updated_at)
VALUES
  ('record_status', 'Record status', 'Reusable status labels used by content and catalog tables.', 'optional_reference', now()),
  ('motorcycle_segment', 'Motorcycle segment', 'High-level motorcycle categories for filtering and advice.', 'optional_reference', now()),
  ('seat_option_type', 'Seat option type', 'Commercial and DIY option classes for seat comfort advice.', 'optional_reference', now()),
  ('product_type', 'Product type', 'Manufacturer product classes.', 'optional_reference', now()),
  ('media_entity_type', 'Media entity type', 'Entity keys used by content_media_links.', 'optional_reference', now()),
  ('video_entity_type', 'Video entity type', 'Entity keys used by content_video_links.', 'optional_reference', now())
ON CONFLICT (key) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  join_policy = EXCLUDED.join_policy,
  updated_at = now();

INSERT INTO controlled_vocabulary_terms (vocabulary_key, term_key, label, source_data, updated_at)
SELECT DISTINCT 'record_status', status, status, jsonb_build_object('source_table', 'motorcycles'), now()
FROM motorcycles
WHERE status IS NOT NULL AND status <> ''
ON CONFLICT (vocabulary_key, term_key) DO UPDATE SET
  label = EXCLUDED.label,
  source_data = controlled_vocabulary_terms.source_data || EXCLUDED.source_data,
  updated_at = now();

INSERT INTO controlled_vocabulary_terms (vocabulary_key, term_key, label, source_data, updated_at)
SELECT DISTINCT 'record_status', status, status, jsonb_build_object('source_table', 'video_resources'), now()
FROM video_resources
WHERE status IS NOT NULL AND status <> ''
ON CONFLICT (vocabulary_key, term_key) DO UPDATE SET
  label = EXCLUDED.label,
  source_data = controlled_vocabulary_terms.source_data || EXCLUDED.source_data,
  updated_at = now();

INSERT INTO controlled_vocabulary_terms (vocabulary_key, term_key, label, source_data, updated_at)
SELECT DISTINCT 'motorcycle_segment', segment, segment, jsonb_build_object('source_table', 'motorcycles'), now()
FROM motorcycles
WHERE segment IS NOT NULL AND segment <> ''
ON CONFLICT (vocabulary_key, term_key) DO UPDATE SET
  label = EXCLUDED.label,
  source_data = controlled_vocabulary_terms.source_data || EXCLUDED.source_data,
  updated_at = now();

INSERT INTO controlled_vocabulary_terms (vocabulary_key, term_key, label, source_data, updated_at)
SELECT DISTINCT 'seat_option_type', option_type, option_type, jsonb_build_object('source_table', 'seat_options'), now()
FROM seat_options
WHERE option_type IS NOT NULL AND option_type <> ''
ON CONFLICT (vocabulary_key, term_key) DO UPDATE SET
  label = EXCLUDED.label,
  source_data = controlled_vocabulary_terms.source_data || EXCLUDED.source_data,
  updated_at = now();

INSERT INTO controlled_vocabulary_terms (vocabulary_key, term_key, label, source_data, updated_at)
SELECT DISTINCT 'product_type', product_type, product_type, jsonb_build_object('source_table', 'seat_products'), now()
FROM seat_products
WHERE product_type IS NOT NULL AND product_type <> ''
ON CONFLICT (vocabulary_key, term_key) DO UPDATE SET
  label = EXCLUDED.label,
  source_data = controlled_vocabulary_terms.source_data || EXCLUDED.source_data,
  updated_at = now();

INSERT INTO controlled_vocabulary_terms (vocabulary_key, term_key, label, source_data, updated_at)
SELECT DISTINCT 'media_entity_type', entity_type, entity_type, jsonb_build_object('source_table', 'content_media_links'), now()
FROM content_media_links
WHERE entity_type IS NOT NULL AND entity_type <> ''
ON CONFLICT (vocabulary_key, term_key) DO UPDATE SET
  label = EXCLUDED.label,
  source_data = controlled_vocabulary_terms.source_data || EXCLUDED.source_data,
  updated_at = now();

INSERT INTO controlled_vocabulary_terms (vocabulary_key, term_key, label, source_data, updated_at)
SELECT DISTINCT 'video_entity_type', entity_type, entity_type, jsonb_build_object('source_table', 'content_video_links'), now()
FROM content_video_links
WHERE entity_type IS NOT NULL AND entity_type <> ''
ON CONFLICT (vocabulary_key, term_key) DO UPDATE SET
  label = EXCLUDED.label,
  source_data = controlled_vocabulary_terms.source_data || EXCLUDED.source_data,
  updated_at = now();

CREATE INDEX IF NOT EXISTS idx_vocab_terms_status ON controlled_vocabulary_terms(vocabulary_key, status, sort_order);
CREATE INDEX IF NOT EXISTS idx_seat_options_motorcycle_confidence ON seat_options(motorcycle_slug, confidence DESC NULLS LAST);
CREATE INDEX IF NOT EXISTS idx_content_media_links_lookup ON content_media_links(entity_type, entity_key, priority, usage);
CREATE INDEX IF NOT EXISTS idx_content_video_links_lookup ON content_video_links(entity_type, entity_key, priority, usage);
CREATE INDEX IF NOT EXISTS idx_media_assets_rights ON media_assets(rights_status, commercial_use_allowed, attribution_required);
CREATE INDEX IF NOT EXISTS idx_video_resources_language_topic ON video_resources(language_code, topic, status);

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

ANALYZE;

COMMIT;
