// @ts-nocheck
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";
import { checkRateLimit } from "../_shared/rate_limit.ts";

// ── Product → tier mapping (must match verify-purchase) ────

const SUBSCRIPTION_TIERS: Record<string, { tier: string; maxCredits: number }> = {
  questborne_adventurer: { tier: "adventurer", maxCredits: 150 },
  questborne_champion:   { tier: "champion",   maxCredits: 600 },
};

// ── Main handler ───────────────────────────────────────────
//
// Called by the client on app launch and after "Restore purchases"
// to re-validate the subscription with Google Play and sync the
// database row.  Returns the current subscription state.
//
// Body (optional):
//   { purchase_token?: string, product_id?: string }
//
// If no token is provided, just returns the current DB state
// (and downgrades if expired).

Deno.serve(async (req: Request) => {
  console.log(
    "check-subscription invoked",
    JSON.stringify({ method: req.method, hasAuth: !!req.headers.get("Authorization") }),
  );

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // ── Auth ──
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) return jsonError("Missing Authorization header", 401);

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    const supabaseUser = createClient(
      supabaseUrl,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

    const { data: { user }, error: userError } = await supabaseUser.auth.getUser();
    if (userError || !user) return jsonError("Invalid or expired token", 401);

    // ── Rate limiting: 10 requests per 60 seconds ──
    const { data: rateResult, error: rateError } = await supabaseAdmin.rpc(
      "check_rate_limit",
      { p_user_id: user.id, p_function_name: "check-subscription", p_max_requests: 10, p_window_seconds: 60 },
    );
    if (rateError) return jsonError("Rate limit check failed", 500);
    if (rateResult && !rateResult.allowed) {
      return jsonError(`Too many requests. Try again in ${rateResult.retryAfterSeconds}s.`, 429);
    }

    // ── Read current subscription ──
    const { data: sub, error: subError } = await supabaseAdmin
      .from("user_subscriptions")
      .select()
      .eq("user_id", user.id)
      .maybeSingle();

    if (subError) {
      console.error("Subscription read error:", subError);
      return jsonError("Failed to read subscription", 500);
    }

    const now = new Date();

    // If no subscription row exists, return free tier defaults
    if (!sub) {
      return jsonOk({
        tier: "free",
        credits_remaining: 25,
        max_credits: 25,
        expires_at: null,
        verified: false,
      });
    }

    // ── Parse optional body (for re-verification with a receipt) ──
    let body: { purchase_token?: string; product_id?: string } = {};
    try { body = await req.json(); } catch { /* no body is fine */ }

    // ── If a purchase token is provided, re-verify with Google Play ──
    if (body.purchase_token && body.product_id) {
      const productInfo = SUBSCRIPTION_TIERS[body.product_id];
      if (!productInfo) return jsonError(`Unknown subscription: ${body.product_id}`, 400);

      const result = await verifyGooglePurchase(body.product_id, body.purchase_token);
      if (result.verified) {
        // Subscription is still valid — update expiry and tier
        const expiresAt = result.expiryTimeMillis
          ? new Date(result.expiryTimeMillis)
          : new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000);
        const resetAt = getNextMonthStart();

        await supabaseAdmin
          .from("user_subscriptions")
          .upsert({
            user_id: user.id,
            tier: productInfo.tier,
            credits_remaining: sub.credits_remaining > 0
              ? Math.min(sub.credits_remaining, productInfo.maxCredits)
              : productInfo.maxCredits,
            max_credits: productInfo.maxCredits,
            credits_reset_at: sub.credits_reset_at,
            expires_at: expiresAt.toISOString(),
            store_product_id: body.product_id,
            store_transaction_id: body.purchase_token,
            updated_at: now.toISOString(),
          });

        return jsonOk({
          tier: productInfo.tier,
          credits_remaining: Math.min(sub.credits_remaining, productInfo.maxCredits),
          max_credits: productInfo.maxCredits,
          expires_at: expiresAt.toISOString(),
          verified: true,
        });
      } else {
        // Token invalid — receipt check failed, downgrade to free
        await downgradeToFree(supabaseAdmin, user.id, now);
        return jsonOk({
          tier: "free",
          credits_remaining: Math.min(sub.credits_remaining, 25),
          max_credits: 25,
          expires_at: null,
          verified: false,
        });
      }
    }

    // ── No token provided — just check expiry and return state ──
    if (sub.tier !== "free" && sub.expires_at && new Date(sub.expires_at) < now) {
      // Subscription expired — downgrade
      await downgradeToFree(supabaseAdmin, user.id, now);
      return jsonOk({
        tier: "free",
        credits_remaining: Math.min(sub.credits_remaining, 25),
        max_credits: 25,
        expires_at: null,
        verified: false,
      });
    }

    // Active or free — return as-is
    return jsonOk({
      tier: sub.tier,
      credits_remaining: sub.credits_remaining,
      max_credits: sub.max_credits,
      expires_at: sub.expires_at,
      verified: sub.tier === "free" || (sub.expires_at && new Date(sub.expires_at) > now),
    });

  } catch (err) {
    console.error("Unhandled error:", err);
    return jsonError("Internal server error", 500);
  }
});

// ── Downgrade helper ───────────────────────────────────────

async function downgradeToFree(
  supabaseAdmin: ReturnType<typeof createClient>,
  userId: string,
  now: Date,
) {
  const resetAt = getNextMonthStart();
  await supabaseAdmin
    .from("user_subscriptions")
    .update({
      tier: "free",
      max_credits: 25,
      credits_remaining: 25, // Give them a fresh free allotment
      credits_reset_at: resetAt.toISOString(),
      expires_at: null,
      store_product_id: null,
      store_transaction_id: null,
      updated_at: now.toISOString(),
    })
    .eq("user_id", userId);
}

// ── Google Play verification (same as verify-purchase) ─────

async function verifyGooglePurchase(
  subscriptionId: string,
  purchaseToken: string,
): Promise<{ verified: boolean; expiryTimeMillis?: number }> {
  const saKeyJson = Deno.env.get("GOOGLE_SERVICE_ACCOUNT_KEY");
  if (!saKeyJson) {
    console.error("GOOGLE_SERVICE_ACCOUNT_KEY not configured — rejecting verification");
    return { verified: false };
  }

  try {
    const saKey = JSON.parse(saKeyJson);
    const accessToken = await getGoogleAccessToken(saKey);
    const packageName = "com.yusuf.questborne";

    const url =
      `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/subscriptionsv2/tokens/${purchaseToken}`;

    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${accessToken}` },
    });

    if (!res.ok) {
      const errText = await res.text();
      console.error(
        "Google verification failed:",
        res.status,
        errText,
        `package=${packageName} subscriptionId=${subscriptionId} serviceAccount=${saKey.client_email}`,
      );
      return { verified: false };
    }

    const data = await res.json();
    const state = data.subscriptionState;
    const isActive =
      state === "SUBSCRIPTION_STATE_ACTIVE" ||
      state === "SUBSCRIPTION_STATE_IN_GRACE_PERIOD";

    const expiryTimeMillis = getLatestExpiryTimeMillisFromV2(data);
    return { verified: isActive, expiryTimeMillis };
  } catch (e) {
    console.error("Google verification error:", e);
    return { verified: false };
  }
}

function getLatestExpiryTimeMillisFromV2(data: any): number | undefined {
  if (!data?.lineItems || !Array.isArray(data.lineItems)) {
    return undefined;
  }

  let latest = 0;
  for (const item of data.lineItems) {
    if (!item?.expiryTime) continue;
    const ms = Date.parse(item.expiryTime);
    if (!Number.isNaN(ms) && ms > latest) {
      latest = ms;
    }
  }

  return latest > 0 ? latest : undefined;
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
    .replace(/=+$/, "");

  const jwt = `${signInput}.${signature}`;

  const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });

  const tokenData = await tokenRes.json();
  return tokenData.access_token;
}

// ── Helpers ───────────────────────────────────────────────

function jsonOk(data: Record<string, unknown>): Response {
  return new Response(JSON.stringify(data), {
    status: 200,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function jsonError(message: string, status: number): Response {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function getNextMonthStart(): Date {
  const now = new Date();
  return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1));
}

function toBase64Url(str: string): string {
  return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}
