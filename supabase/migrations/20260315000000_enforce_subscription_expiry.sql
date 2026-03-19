-- ============================================================
-- Enforce subscription expiry in the use_credit function.
--
-- If a paid subscription has expired (expires_at < now()),
-- automatically downgrade the user to free tier, reset their
-- credits to the free-tier max, and let them continue playing.
--
-- Also: the generate-story Edge Function now reads the tier
-- from use_credit's return value and enforces model/token
-- limits server-side (no longer trusts the client).
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

  -- ── NEW: Check subscription expiry for paid tiers ──
  -- If the paid subscription has expired, downgrade to free.
  if v_row.tier <> 'free' and v_row.expires_at is not null and v_now >= v_row.expires_at then
    v_new_reset := date_trunc('month', v_now) + interval '1 month';
    update public.user_subscriptions
      set tier = 'free',
          max_credits = 25,
          credits_remaining = least(v_row.credits_remaining, 25),
          credits_reset_at = v_new_reset,
          expires_at = null,
          store_product_id = null,
          store_transaction_id = null,
          updated_at = v_now
      where user_id = p_user_id;

    -- Re-read the updated row
    select * into v_row
      from public.user_subscriptions
      where user_id = p_user_id;
  end if;

  -- Reset credits if past the reset date
  if v_now >= v_row.credits_reset_at then
    v_new_reset := date_trunc('month', v_now) + interval '1 month';
    update public.user_subscriptions
      set credits_remaining = v_row.max_credits - 1,
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
