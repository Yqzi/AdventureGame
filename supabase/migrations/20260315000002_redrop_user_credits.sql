-- Re-drop user_credits which was accidentally re-created by the
-- out-of-order 20260225_create_user_credits migration.

drop trigger if exists on_auth_user_created_credits on auth.users;
drop function if exists public.handle_new_user_credits();
drop table if exists public.device_registry;
drop table if exists public.user_credits;
