-- Re-create the subscription auto-create trigger.
-- This ensures new sign-ups (Google/Apple) get a free-tier row immediately,
-- not just on their first AI call.

create or replace function public.handle_new_user_subscription()
returns trigger as $$
begin
  -- Skip anonymous users
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

drop trigger if exists on_auth_user_created_subscription on auth.users;
create trigger on_auth_user_created_subscription
  after insert on auth.users
  for each row execute function public.handle_new_user_subscription();

-- Backfill any users missing a subscription row
insert into public.user_subscriptions (
  user_id, tier, credits_remaining, max_credits, credits_reset_at
)
select
  u.id, 'free', 25, 25, date_trunc('month', now()) + interval '1 month'
from auth.users u
where u.raw_app_meta_data->>'provider' is not null
  and u.raw_app_meta_data->>'provider' <> 'anonymous'
  and not exists (
    select 1 from public.user_subscriptions s where s.user_id = u.id
  )
on conflict (user_id) do nothing;
