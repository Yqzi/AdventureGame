-- ============================================================
-- Cap free-tier credit accumulation at 30 days' worth (300).
--
-- Repurposes max_credits as a hard ceiling for daily-credit
-- users. Free tier: max_credits changes from 25 → 300.
-- Accumulation via daily grants is clamped to max_credits.
-- Refund is also capped so it can't push above the ceiling.
-- ============================================================

-- ── 1. Backfill existing free-tier rows ─────────────────────

update public.user_subscriptions
  set max_credits = 300,
      credits_remaining = least(credits_remaining, 300)
  where tier = 'free';

-- ── 2. Rewrite use_credit with accumulation cap ─────────────

create or replace function public.use_credit(p_user_id uuid)
returns jsonb
language plpgsql
security definer
as $$
declare
  v_row public.user_subscriptions%rowtype;
  v_now timestamptz := now();
  v_today date := current_date;
  v_new_reset timestamptz;
  v_days int;
begin
  -- Lock the row so no concurrent request can read stale credits
  select * into v_row
    from public.user_subscriptions
    where user_id = p_user_id
    for update;

  if not found then
    -- Auto-create free tier row (already consumed 1 credit)
    insert into public.user_subscriptions
      (user_id, tier, credits_remaining, max_credits, credits_reset_at,
       daily_credits, last_daily_grant_at)
    values
      (p_user_id, 'free', 24, 300,
       date_trunc('month', v_now) + interval '1 month',
       10, v_today)
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

  -- ── Check subscription expiry for paid tiers ──
  if v_row.tier <> 'free' and v_row.expires_at is not null and v_now >= v_row.expires_at then
    v_new_reset := date_trunc('month', v_now) + interval '1 month';
    update public.user_subscriptions
      set tier = 'free',
          max_credits = 300,
          credits_remaining = least(v_row.credits_remaining, 300),
          credits_reset_at = v_new_reset,
          expires_at = null,
          store_product_id = null,
          store_transaction_id = null,
          daily_credits = 10,
          last_daily_grant_at = v_today,
          updated_at = v_now
      where user_id = p_user_id;

    -- Re-read the updated row
    select * into v_row
      from public.user_subscriptions
      where user_id = p_user_id;
  end if;

  -- ── Daily credit accumulation (free tier with daily_credits > 0) ──
  if v_row.daily_credits > 0 then
    -- Grant accumulated daily credits since last grant, capped at max_credits
    if v_row.last_daily_grant_at is not null and v_today > v_row.last_daily_grant_at then
      v_days := v_today - v_row.last_daily_grant_at;
      update public.user_subscriptions
        set credits_remaining = least(
              credits_remaining + (v_row.daily_credits * v_days),
              v_row.max_credits
            ),
            last_daily_grant_at = v_today
        where user_id = p_user_id;

      -- Re-read after daily grant
      select * into v_row
        from public.user_subscriptions
        where user_id = p_user_id;
    elsif v_row.last_daily_grant_at is null then
      -- First time — just set the date, no bonus (they got initial 25)
      update public.user_subscriptions
        set last_daily_grant_at = v_today
        where user_id = p_user_id;
    end if;

    -- Skip monthly reset for daily-credit users — fall through to deduction
  else
    -- ── Monthly reset for paid tiers (daily_credits = 0) ──
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
  end if;

  -- ── Check if credits are available ──
  if v_row.credits_remaining <= 0 then
    return jsonb_build_object(
      'allowed', false,
      'credits_remaining', 0,
      'max_credits', v_row.max_credits,
      'tier', v_row.tier
    );
  end if;

  -- ── Decrement atomically (row is already locked) ──
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

-- ── 3. Cap refund_credit to max_credits ─────────────────────

create or replace function public.refund_credit(p_user_id uuid)
returns void
language plpgsql
security definer
as $$
begin
  update public.user_subscriptions
    set credits_remaining = least(credits_remaining + 1, max_credits)
    where user_id = p_user_id;
end;
$$;

-- ── 4. Update new-user trigger (max_credits = 300) ──────────

create or replace function public.handle_new_user_subscription()
returns trigger as $$
begin
  -- Skip anonymous users
  if new.raw_app_meta_data->>'provider' = 'anonymous'
     or new.raw_app_meta_data->>'provider' is null then
    return new;
  end if;

  insert into public.user_subscriptions (
    user_id, tier, credits_remaining, max_credits, credits_reset_at,
    daily_credits, last_daily_grant_at
  )
  values (
    new.id,
    'free',
    25,
    300,
    date_trunc('month', now()) + interval '1 month',
    10,
    current_date
  )
  on conflict (user_id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

-- ── 5. Re-lock functions to service role only ───────────────

revoke execute on function public.use_credit(uuid) from anon, authenticated;
revoke execute on function public.refund_credit(uuid) from anon, authenticated;
