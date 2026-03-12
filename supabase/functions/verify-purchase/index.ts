// @ts-nocheck
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";
import { checkRateLimit } from "../_shared/rate_limit.ts";

// ── Types ──────────────────────────────────────────────────

interface RequestBody {
  platform: "android" | "ios";
  product_id: string;
  purchase_token: string;
}

// ── Product → tier mapping (server-side source of truth) ───

const PRODUCT_TIERS: Record<string, { tier: string; maxCredits: number; durationDays: number }> = {
  // Adventurer
  questborne_adventurer_monthly:  { tier: "adventurer", maxCredits: 150, durationDays: 30 },
  questborne_adventurer_6month:   { tier: "adventurer", maxCredits: 150, durationDays: 180 },
  questborne_adventurer_yearly:   { tier: "adventurer", maxCredits: 150, durationDays: 365 },
  // Champion
  questborne_champion_monthly:    { tier: "champion",   maxCredits: 600, durationDays: 30 },
  questborne_champion_6month:     { tier: "champion",   maxCredits: 600, durationDays: 180 },
  questborne_champion_yearly:     { tier: "champion",   maxCredits: 600, durationDays: 365 },
};

// ── Main handler ───────────────────────────────────────────

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // ── Auth ──
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

    // ── Rate limiting: 5 requests per 60 seconds (atomic) ──
    const { data: rateResult, error: rateError } = await supabaseAdmin.rpc(
      "check_rate_limit",
      {
        p_user_id: user.id,
        p_function_name: "verify-purchase",
        p_max_requests: 5,
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

    // ── Parse body ──
    const body: RequestBody = await req.json();
    if (!body.platform || !body.product_id || !body.purchase_token) {
      return jsonError("Missing required fields", 400);
    }

    // ── Look up tier from product ID ──
    const productInfo = PRODUCT_TIERS[body.product_id];
    if (!productInfo) {
      return jsonError(`Unknown product: ${body.product_id}`, 400);
    }

    // ── Verify with Google Play ──
    if (body.platform === "android") {
      const verified = await verifyGooglePurchase(
        body.product_id,
        body.purchase_token,
      );
      if (!verified) {
        return jsonError("Purchase verification failed", 403);
      }
    }
    // TODO: Add Apple receipt verification for iOS when needed.

    // ── Upsert subscription ──
    const now = new Date();
    const expiresAt = new Date(now.getTime() + productInfo.durationDays * 24 * 60 * 60 * 1000);
    const resetAt = getNextMonthStart();

    const { error: upsertError } = await supabaseAdmin
      .from("user_subscriptions")
      .upsert({
        user_id: user.id,
        tier: productInfo.tier,
        credits_remaining: productInfo.maxCredits,
        max_credits: productInfo.maxCredits,
        credits_reset_at: resetAt.toISOString(),
        expires_at: expiresAt.toISOString(),
        store_product_id: body.product_id,
        store_transaction_id: body.purchase_token,
        updated_at: now.toISOString(),
      });

    if (upsertError) {
      console.error("Upsert error:", upsertError);
      return jsonError("Failed to activate subscription", 500);
    }

    return new Response(
      JSON.stringify({
        success: true,
        tier: productInfo.tier,
        credits: productInfo.maxCredits,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  } catch (err) {
    console.error("Unhandled error:", err);
    return jsonError("Internal server error", 500);
  }
});

// ── Google Play verification ──────────────────────────────

async function verifyGooglePurchase(
  productId: string,
  purchaseToken: string,
): Promise<boolean> {
  // Use the Google Play Developer API via a service account.
  // The GOOGLE_SERVICE_ACCOUNT_KEY env var should contain the JSON key.
  const saKeyJson = Deno.env.get("GOOGLE_SERVICE_ACCOUNT_KEY");
  if (!saKeyJson) {
    console.error("GOOGLE_SERVICE_ACCOUNT_KEY not configured — skipping verification in dev");
    // In production this should return false. During setup, allow pass-through.
    return true;
  }

  try {
    const saKey = JSON.parse(saKeyJson);
    const accessToken = await getGoogleAccessToken(saKey);
    const packageName = "com.yusuf.questborne";

    const url =
      `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/subscriptions/${productId}/tokens/${purchaseToken}`;

    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${accessToken}` },
    });

    if (!res.ok) {
      const errText = await res.text();
      console.error("Google verification failed:", res.status, errText);
      return false;
    }

    const data = await res.json();
    // Payment state 1 = received, 2 = free trial. Both are valid.
    return data.paymentState === 1 || data.paymentState === 2;
  } catch (e) {
    console.error("Google verification error:", e);
    return false;
  }
}

async function getGoogleAccessToken(
  saKey: { client_email: string; private_key: string },
): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = btoa(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const payload = btoa(
    JSON.stringify({
      iss: saKey.client_email,
      scope: "https://www.googleapis.com/auth/androidpublisher",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600,
    }),
  );

  const signInput = `${header}.${payload}`;

  // Import the private key and sign
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
