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

const SUBSCRIPTION_TIERS: Record<string, { tier: string; maxCredits: number }> = {
  questborne_adventurer: { tier: "adventurer", maxCredits: 150 },
  questborne_champion:   { tier: "champion",   maxCredits: 600 },
};

// ── Main handler ───────────────────────────────────────────

Deno.serve(async (req: Request) => {
  console.log(
    "verify-purchase invoked",
    JSON.stringify({ method: req.method, hasAuth: !!req.headers.get("Authorization") }),
  );

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

    // ── Look up tier from subscription ID ──
    const productInfo = SUBSCRIPTION_TIERS[body.product_id];
    if (!productInfo) {
      return jsonError(`Unknown subscription: ${body.product_id}`, 400);
    }

    // ── Verify with Google Play ──
    let expiryTimeMillis: number | undefined;
    if (body.platform === "android") {
      const result = await verifyGooglePurchase(
        body.product_id,
        body.purchase_token,
      );
      if (!result.verified) {
        return jsonError("Purchase verification failed", 403);
      }
      expiryTimeMillis = result.expiryTimeMillis;
    }
    // TODO: Add Apple receipt verification for iOS when needed.

    // ── Upsert subscription ──
    const now = new Date();
    const expiresAt = expiryTimeMillis
      ? new Date(expiryTimeMillis)
      : new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000);
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
  subscriptionId: string,
  purchaseToken: string,
): Promise<{ verified: boolean; expiryTimeMillis?: number }> {
  // Use the Google Play Developer API via a service account.
  // The GOOGLE_SERVICE_ACCOUNT_KEY env var should contain the JSON key.
  const saKeyJson = Deno.env.get("GOOGLE_SERVICE_ACCOUNT_KEY");
  if (!saKeyJson) {
    console.error("GOOGLE_SERVICE_ACCOUNT_KEY not configured — rejecting purchase");
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

function toBase64Url(str: string): string {
  return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}
