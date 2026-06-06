BEGIN;

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

CREATE INDEX IF NOT EXISTS idx_country_seat_strategies_priority ON country_seat_strategies(priority, country_code);
CREATE INDEX IF NOT EXISTS idx_country_research_sources_country ON country_research_sources(country_code, source_type, status);
CREATE INDEX IF NOT EXISTS idx_visitor_events_country_time ON visitor_events(country_code, occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_visitor_events_route_time ON visitor_events(route_path, occurred_at DESC);

ANALYZE;

COMMIT;
