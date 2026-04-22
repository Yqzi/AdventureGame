-- ============================================================
-- RPC to grant pending daily credits WITHOUT deducting one.
--
-- Called on app open so the user sees their up-to-date balance.
-- Uses server-side current_date — immune to device clock tricks.
-- Returns the refreshed subscription row as JSONB.
-- ============================================================

create or replace function public.refresh_daily_credits()
returns jsonb
language plpgsql
security definer
as $$
declare
  v_user_id uuid := auth.uid();
  v_row public.user_subscriptions%rowtype;
  v_today date := current_date;
  v_days int;
begin
  if v_user_id is null then
    return jsonb_build_object('updated', false);
  end if;

  select * into v_row
    from public.user_subscriptions
    where user_id = v_user_id
    for update;

  if not found then
    return jsonb_build_object('updated', false);
  end if;

  -- Only applies to daily-credit users (free tier)
  if v_row.daily_credits > 0
     and v_row.last_daily_grant_at is not null
     and v_today > v_row.last_daily_grant_at then

    v_days := v_today - v_row.last_daily_grant_at;

    update public.user_subscriptions
      set credits_remaining = least(
            credits_remaining + (v_row.daily_credits * v_days),
            v_row.max_credits
          ),
          last_daily_grant_at = v_today
      where user_id = v_user_id;
  end if;

  -- Return the (possibly updated) row
  select * into v_row
    from public.user_subscriptions
    where user_id = v_user_id;

  return jsonb_build_object(
    'updated', true,
    'credits_remaining', v_row.credits_remaining,
    'max_credits', v_row.max_credits,
    'daily_credits', v_row.daily_credits,
    'tier', v_row.tier,
    'expires_at', v_row.expires_at,
    'credits_reset_at', v_row.credits_reset_at
  );
end;
$$;

-- Allow authenticated users to call (uses auth.uid() — self-only)
revoke execute on function public.refresh_daily_credits() from anon;
grant execute on function public.refresh_daily_credits() to authenticated;
