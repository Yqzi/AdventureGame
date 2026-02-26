-- ============================================================
-- user_credits — monthly AI usage credits per user
-- ============================================================

create table if not exists public.user_credits (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  credits    int  not null default 100,
  max_credits int not null default 100,
  reset_at   timestamptz not null default (date_trunc('month', now()) + interval '1 month'),
  created_at timestamptz not null default now()
);

-- RLS: users can only read their own row
alter table public.user_credits enable row level security;

create policy "Users can read own credits"
  on public.user_credits for select
  using (auth.uid() = user_id);

-- No client-side insert/update/delete — only the Edge Function (service_role) can modify credits.

-- ============================================================
-- Auto-create a credits row when a new user signs up
-- ============================================================

create or replace function public.handle_new_user_credits()
returns trigger as $$
begin
  insert into public.user_credits (user_id, credits, max_credits, reset_at)
  values (
    new.id,
    100,
    100,
    date_trunc('month', now()) + interval '1 month'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Fire after a new auth user is created
drop trigger if exists on_auth_user_created_credits on auth.users;
create trigger on_auth_user_created_credits
  after insert on auth.users
  for each row execute function public.handle_new_user_credits();

-- ============================================================
-- device_registry — ties device IDs to user accounts so new
-- accounts on the same device share the device's credit pool.
-- ============================================================

create table if not exists public.device_registry (
  device_id  text not null,
  user_id    uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (device_id, user_id)
);

alter table public.device_registry enable row level security;

-- No client-side access — only the Edge Function (service_role) manages this.
