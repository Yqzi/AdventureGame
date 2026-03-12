// @ts-nocheck
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";
import { checkRateLimit } from "../_shared/rate_limit.ts";

// ── Main handler ───────────────────────────────────────────

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // ── Auth: identify the calling user ──
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return jsonError("Missing Authorization header", 401);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    const supabaseUser = createClient(
      supabaseUrl,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

    const {
      data: { user },
      error: userError,
    } = await supabaseUser.auth.getUser();
    if (userError || !user) {
      return jsonError("Invalid or expired token", 401);
    }

    const userId = user.id;

    // ── Rate limiting: 3 requests per 60 seconds (atomic) ──
    const { data: rateResult, error: rateError } = await supabaseAdmin.rpc(
      "check_rate_limit",
      {
        p_user_id: userId,
        p_function_name: "delete-account",
        p_max_requests: 3,
        p_window_seconds: 60,
      },
    );
    if (rateError) {
      console.error("Rate limit check failed:", rateError);
      return jsonError("Rate limit check failed", 500);
    }
    if (!rateResult.allowed) {
      return jsonError(
        `Too many requests. Try again in ${rateResult.retryAfterSeconds}s.`,
        429,
      );
    }

    // ── Delete all user data from every table ──
    // Each delete is wrapped individually so a missing table doesn't abort.
    const tables = ["game_sessions", "player_saves", "user_subscriptions"];
    for (const table of tables) {
      try {
        await supabaseAdmin.from(table).delete().eq("user_id", userId);
      } catch (_) {
        // Table may not exist or have no rows — that's fine.
      }
    }

    // ── Delete the auth user itself ──
    const { error: deleteError } =
      await supabaseAdmin.auth.admin.deleteUser(userId);
    if (deleteError) {
      return jsonError(`Failed to delete auth user: ${deleteError.message}`, 500);
    }

    return new Response(
      JSON.stringify({ success: true }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      },
    );
  } catch (err) {
    return jsonError(err.message ?? "Internal server error", 500);
  }
});

// ── Helpers ────────────────────────────────────────────────

function jsonError(message: string, status: number) {
  return new Response(JSON.stringify({ error: message }), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
    status,
  });
}
