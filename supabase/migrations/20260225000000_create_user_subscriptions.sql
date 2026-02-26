-- user_subscriptions: stores subscription tier, credits, and billing info per user.
-- A webhook from the IAP provider (RevenueCat / Apple / Google) writes to this
-- table when a subscription is created, renewed, or cancelled.

create table if not exists public.user_subscriptions (
  user_id  uuid primary key references auth.users(id) on delete cascade,
  tier     text not null default 'free'
           check (tier in ('free', 'adventurer', 'champion')),

  credits_remaining  int  not null default 30,
  max_credits        int  not null default 30,
  credits_reset_at   timestamptz not null default (date_trunc('month', now()) + interval '1 month'),

  expires_at         timestamptz,          -- null = free (never expires)
  store_product_id   text,                 -- e.g. 'questborne_adventurer_monthly'
  store_transaction_id text,               -- for receipt validation / dedup

  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- RLS: users can read their own subscription; only service-role can write.
alter table public.user_subscriptions enable row level security;

create policy "Users can read own subscription"
  on public.user_subscriptions
  for select
  using (auth.uid() = user_id);

-- Allow the service-role key (used by Edge Functions and webhooks) to do everything.
-- No INSERT/UPDATE/DELETE policy for regular users — writes come from
-- the server (Edge Functions with service-role key bypass RLS).

-- Index for the Edge Function lookup:
create index if not exists idx_user_subscriptions_user_id
  on public.user_subscriptions (user_id);
