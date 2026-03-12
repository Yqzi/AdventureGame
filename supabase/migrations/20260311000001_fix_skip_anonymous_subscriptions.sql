-- ============================================================
-- Fix: skip anonymous users in the subscription trigger, and
-- delete junk rows that were backfilled for anonymous accounts.
-- ============================================================

-- 1. Replace the trigger function to skip anonymous users.
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
  on conflict (user_id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

-- 2. Delete subscription rows for anonymous / providerless users.
delete from public.user_subscriptions
where user_id in (
  select id from auth.users
  where raw_app_meta_data->>'provider' = 'anonymous'
     or raw_app_meta_data->>'provider' is null
);
