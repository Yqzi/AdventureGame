-- Remove any direct write RLS policies — writes come ONLY from the
-- service-role key (used by the verify-purchase Edge Function).
-- No INSERT/UPDATE/DELETE policies for regular users.
-- The activate_subscription RPC is also dropped since purchase
-- verification is now handled server-side via Google Play receipts.

drop function if exists public.activate_subscription(text);
