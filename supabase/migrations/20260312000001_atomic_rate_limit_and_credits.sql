-- Atomic rate limiting + credit decrement to prevent concurrent request abuse.
-- Replaces the non-atomic read-then-update pattern in the Edge Functions.

-- ============================================================
-- 1. Atomic rate limiter — single row-level lock per check
-- ============================================================

create or replace function public.check_rate_limit(
  p_user_id uuid,
  p_function_name text,
  p_max_requests int,
  p_window_seconds int
)
returns jsonb
language plpgsql
security definer
as $$
declare
  v_row rate_limits%rowtype;
  v_now timestamptz := now();
  v_window_start timestamptz := v_now - (p_window_seconds || ' seconds')::interval;
  v_window_end timestamptz;
  v_retry_after int;
begin
  -- Lock the row (or discover it doesn't exist yet)
  select * into v_row
    from public.rate_limits
    where user_id = p_user_id and function_name = p_function_name
    for update;

  if not found then
    -- First request ever — insert and allow
    insert into public.rate_limits (user_id, function_name, request_count, window_start, last_request_at)
    values (p_user_id, p_function_name, 1, v_now, v_now)
    on conflict (user_id, function_name) do update
      set request_count = 1, window_start = v_now, last_request_at = v_now;
    return jsonb_build_object('allowed', true);
  end if;

  -- If the stored window has expired, reset it
  if v_row.window_start < v_window_start then
    update public.rate_limits
      set request_count = 1, window_start = v_now, last_request_at = v_now
      where user_id = p_user_id and function_name = p_function_name;
    return jsonb_build_object('allowed', true);
  end if;

  -- Window still active — check count
  if v_row.request_count >= p_max_requests then
    v_window_end := v_row.window_start + (p_window_seconds || ' seconds')::interval;
    v_retry_after := greatest(ceil(extract(epoch from v_window_end - v_now))::int, 1);
    return jsonb_build_object('allowed', false, 'retryAfterSeconds', v_retry_after);
  end if;

  -- Increment and allow
  update public.rate_limits
    set request_count = v_row.request_count + 1, last_request_at = v_now
    where user_id = p_user_id and function_name = p_function_name;

  return jsonb_build_object('allowed', true);
end;
$$;


-- ============================================================
-- 2. Atomic credit decrement — prevents concurrent over-spend
-- ============================================================

create or replace function public.use_credit(p_user_id uuid)
returns jsonb
language plpgsql
security definer
as $$
declare
  v_row public.user_subscriptions%rowtype;
  v_now timestamptz := now();
  v_new_reset timestamptz;
begin
  -- Lock the row so no concurrent request can read stale credits
  select * into v_row
    from public.user_subscriptions
    where user_id = p_user_id
    for update;

  if not found then
    -- Auto-create free tier row (locked via insert)
    v_new_reset := date_trunc('month', v_now) + interval '1 month';
    insert into public.user_subscriptions
      (user_id, tier, credits_remaining, max_credits, credits_reset_at)
    values
      (p_user_id, 'free', 24, 25, v_new_reset)
    on conflict (user_id) do update
      set credits_remaining = public.user_subscriptions.credits_remaining - 1
      where public.user_subscriptions.credits_remaining > 0;

    -- Check if the upsert actually decremented
    select * into v_row
      from public.user_subscriptions
      where user_id = p_user_id;

    return jsonb_build_object(
      'allowed', true,
      'credits_remaining', v_row.credits_remaining,
      'max_credits', v_row.max_credits,
      'tier', v_row.tier
    );
  end if;

  -- Reset credits if past the reset date
  if v_now >= v_row.credits_reset_at then
    v_new_reset := date_trunc('month', v_now) + interval '1 month';
    update public.user_subscriptions
      set credits_remaining = max_credits - 1,
          credits_reset_at = v_new_reset
      where user_id = p_user_id;

    return jsonb_build_object(
      'allowed', true,
      'credits_remaining', v_row.max_credits - 1,
      'max_credits', v_row.max_credits,
      'tier', v_row.tier
    );
  end if;

  -- Check if credits are available
  if v_row.credits_remaining <= 0 then
    return jsonb_build_object(
      'allowed', false,
      'credits_remaining', 0,
      'max_credits', v_row.max_credits,
      'tier', v_row.tier
    );
  end if;

  -- Decrement atomically (row is already locked)
  update public.user_subscriptions
    set credits_remaining = v_row.credits_remaining - 1
    where user_id = p_user_id;

  return jsonb_build_object(
    'allowed', true,
    'credits_remaining', v_row.credits_remaining - 1,
    'max_credits', v_row.max_credits,
    'tier', v_row.tier
  );
end;
$$;
