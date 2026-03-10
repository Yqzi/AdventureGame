-- rate_limits: tracks per-user request timestamps for burst protection.
-- Edge Functions check this table before processing requests.

CREATE TABLE IF NOT EXISTS public.rate_limits (
  user_id     uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  function_name text NOT NULL,
  last_request_at timestamptz NOT NULL DEFAULT now(),
  request_count   int NOT NULL DEFAULT 1,
  window_start    timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, function_name)
);

-- RLS: no client access — only Edge Functions via service role.
ALTER TABLE public.rate_limits ENABLE ROW LEVEL SECURITY;

-- Index for fast lookups.
CREATE INDEX IF NOT EXISTS idx_rate_limits_lookup
  ON public.rate_limits (user_id, function_name);
