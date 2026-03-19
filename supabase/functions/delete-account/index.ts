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

    // ── Cancel any active Google Play subscription ──
    try {
      const { data: sub } = await supabaseAdmin
        .from("user_subscriptions")
        .select("store_product_id, store_transaction_id, tier")
        .eq("user_id", userId)
        .maybeSingle();

      if (sub?.store_product_id && sub?.store_transaction_id && sub.tier !== "free") {
        await cancelGoogleSubscription(
          sub.store_product_id,
          sub.store_transaction_id,
        );
      }
    } catch (e) {
      // Log but don't block deletion — the sub will expire naturally
      console.error("Failed to cancel Google subscription:", e);
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

// ── Google Play subscription cancellation ──────────────────

async function cancelGoogleSubscription(
  subscriptionId: string,
  purchaseToken: string,
): Promise<void> {
  const saKeyJson = Deno.env.get("GOOGLE_SERVICE_ACCOUNT_KEY");
  if (!saKeyJson) {
    console.error("GOOGLE_SERVICE_ACCOUNT_KEY not set — cannot cancel sub");
    return;
  }

  const saKey = JSON.parse(saKeyJson);
  const accessToken = await getGoogleAccessToken(saKey);
  const packageName = "com.yusuf.questborne";

  const url =
    `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/subscriptions/${subscriptionId}/tokens/${purchaseToken}:cancel`;

  const res = await fetch(url, {
    method: "POST",
    headers: { Authorization: `Bearer ${accessToken}` },
  });

  if (!res.ok) {
    const errText = await res.text();
    console.error("Google cancel failed:", res.status, errText);
  } else {
    console.log(`Cancelled Google subscription ${subscriptionId} for deleted user`);
  }
}

async function getGoogleAccessToken(
  saKey: { client_email: string; private_key: string },
): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = toBase64Url(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const payload = toBase64Url(
    JSON.stringify({
      iss: saKey.client_email,
      scope: "https://www.googleapis.com/auth/androidpublisher",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600,
    }),
  );

  const signInput = `${header}.${payload}`;

  const pemContents = saKey.private_key
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\n/g, "");
  const keyBuffer = Uint8Array.from(atob(pemContents), (c) => c.charCodeAt(0));

  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    keyBuffer,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );

  const signatureBuffer = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    cryptoKey,
    new TextEncoder().encode(signInput),
  );

  const signature = btoa(
    String.fromCharCode(...new Uint8Array(signatureBuffer)),
  )
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/g, "");

  const jwt = `${signInput}.${signature}`;

  const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });

  const tokenData = await tokenRes.json();
  return tokenData.access_token;
}

function toBase64Url(str: string): string {
  return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}
