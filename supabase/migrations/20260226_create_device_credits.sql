-- ============================================================
-- device_credits — monthly AI credits tied to the DEVICE, not the user.
-- No matter how many accounts are created/deleted, the device
-- has a fixed monthly pool.
-- ============================================================

create table if not exists public.device_credits (
  device_id   text primary key,
  credits     int  not null default 2,
  max_credits int  not null default 2,
  reset_at    timestamptz not null default (date_trunc('month', now()) + interval '1 month'),
  created_at  timestamptz not null default now()
);

-- No RLS client access — only the Edge Function (service_role) manages this.
alter table public.device_credits enable row level security;
