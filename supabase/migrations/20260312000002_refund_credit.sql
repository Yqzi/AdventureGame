-- Refund a single credit back to the user's subscription.
-- Called when the AI call fails AFTER the credit was already decremented.

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
