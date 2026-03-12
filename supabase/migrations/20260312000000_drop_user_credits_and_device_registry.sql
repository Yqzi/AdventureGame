-- Drop unused tables: user_credits and device_registry.
-- Credits are fully managed in user_subscriptions; device_registry was never wired up.

-- 1. Remove the trigger that auto-created user_credits rows on signup
drop trigger if exists on_auth_user_created_credits on auth.users;

-- 2. Drop the associated function
drop function if exists public.handle_new_user_credits();

-- 3. Drop the tables
drop table if exists public.device_registry;
drop table if exists public.user_credits;
