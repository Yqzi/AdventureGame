-- ============================================================
-- Lock down SECURITY DEFINER functions so only the service role
-- can call them. Prevents users from calling refund_credit or
-- use_credit directly via the Supabase client.
-- ============================================================

-- Revoke public access from sensitive functions
revoke execute on function public.use_credit(uuid) from anon, authenticated;
revoke execute on function public.refund_credit(uuid) from anon, authenticated;
revoke execute on function public.check_rate_limit(uuid, text, int, int) from anon, authenticated;
