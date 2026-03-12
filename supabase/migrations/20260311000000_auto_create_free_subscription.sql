-- ============================================================
-- Auto-create a free-tier user_subscriptions row for every new user.
-- This ensures ALL authenticated users have credit tracking in one
-- table — no more falling through to device_credits.
-- ============================================================

-- 1. Trigger function: fires on auth.users INSERT
--    Skips anonymous users — only real sign-ins get a credits row.
create or replace function public.handle_new_user_subscription()
returns trigger as $$
begin
  -- Skip anonymous users (they must sign in properly to get credits)
  if new.raw_app_meta_data->>'provider' = 'anonymous'
     or new.raw_app_meta_data->>'provider' is null then
    return new;
  end if;

  insert into public.user_subscriptions (
    user_id, tier, credits_remaining, max_credits, credits_reset_at
  )
  values (
    new.id,
    'free',
    25,
    25,
    date_trunc('month', now()) + interval '1 month'
  )
  on conflict (user_id) do nothing;   -- idempotent if row already exists
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created_subscription on auth.users;
create trigger on_auth_user_created_subscription
  after insert on auth.users
  for each row execute function public.handle_new_user_subscription();

-- 2. Backfill: create rows for every existing user who doesn't have one yet.
insert into public.user_subscriptions (
  user_id, tier, credits_remaining, max_credits, credits_reset_at
)
select
  u.id,
  'free',
  25,
  25,
  date_trunc('month', now()) + interval '1 month'
from auth.users u
where not exists (
  select 1 from public.user_subscriptions s where s.user_id = u.id
)
on conflict (user_id) do nothing;
