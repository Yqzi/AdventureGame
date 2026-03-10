import { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

interface RateLimitConfig {
  /** Max requests allowed in the window. */
  maxRequests: number;
  /** Window duration in seconds. */
  windowSeconds: number;
}

interface RateLimitResult {
  allowed: boolean;
  retryAfterSeconds?: number;
}

/**
 * Sliding-window rate limiter backed by the `rate_limits` table.
 *
 * Call with the **service-role** Supabase client so it bypasses RLS.
 */
export async function checkRateLimit(
  admin: SupabaseClient,
  userId: string,
  functionName: string,
  config: RateLimitConfig,
): Promise<RateLimitResult> {
  const now = new Date();
  const windowStart = new Date(now.getTime() - config.windowSeconds * 1000);

  // Fetch the current rate-limit row (if any).
  const { data: row } = await admin
    .from("rate_limits")
    .select("last_request_at, request_count, window_start")
    .eq("user_id", userId)
    .eq("function_name", functionName)
    .single();

  if (!row) {
    // First request ever — create a row and allow.
    await admin.from("rate_limits").upsert({
      user_id: userId,
      function_name: functionName,
      last_request_at: now.toISOString(),
      request_count: 1,
      window_start: now.toISOString(),
    });
    return { allowed: true };
  }

  const rowWindowStart = new Date(row.window_start);

  // If the stored window has expired, reset it.
  if (rowWindowStart < windowStart) {
    await admin
      .from("rate_limits")
      .update({
        request_count: 1,
        window_start: now.toISOString(),
        last_request_at: now.toISOString(),
      })
      .eq("user_id", userId)
      .eq("function_name", functionName);
    return { allowed: true };
  }

  // Window is still active — check the count.
  if (row.request_count >= config.maxRequests) {
    const windowEnd = new Date(rowWindowStart.getTime() + config.windowSeconds * 1000);
    const retryAfter = Math.ceil((windowEnd.getTime() - now.getTime()) / 1000);
    return { allowed: false, retryAfterSeconds: Math.max(retryAfter, 1) };
  }

  // Increment and allow.
  await admin
    .from("rate_limits")
    .update({
      request_count: row.request_count + 1,
      last_request_at: now.toISOString(),
    })
    .eq("user_id", userId)
    .eq("function_name", functionName);

  return { allowed: true };
}
