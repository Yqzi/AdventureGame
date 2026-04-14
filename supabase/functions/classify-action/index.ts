// @ts-nocheck
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";
import { checkRateLimit } from "../_shared/rate_limit.ts";

// ── Types ──────────────────────────────────────────────────

interface RequestBody {
  prompt: string;
  actionTypes: Record<string, string>; // e.g. { "meleeAttack": "Melee strikes, weapon swings", ... }
}

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
    const openrouterApiKey = Deno.env.get("OPENROUTER_API_KEY");

    if (!openrouterApiKey) {
      return jsonError("OPENROUTER_API_KEY not configured", 500);
    }

    const admin = createClient(supabaseUrl, supabaseServiceKey);

    // Verify JWT
    const token = authHeader.replace("Bearer ", "");
    const { data: { user }, error: authError } = await admin.auth.getUser(token);
    if (authError || !user) {
      return jsonError("Invalid or expired token", 401);
    }

    // ── Rate limit (generous — classification is cheap) ──
    const rl = await checkRateLimit(admin, user.id, "classify-action", {
      maxRequests: 30,
      windowSeconds: 60,
    });
    if (!rl.allowed) {
      return jsonError(`Rate limited. Retry in ${rl.retryAfterSeconds}s`, 429);
    }

    // ── Parse body ──
    const body: RequestBody = await req.json();
    const { prompt, actionTypes } = body;

    if (!prompt || !actionTypes || Object.keys(actionTypes).length === 0) {
      return jsonError("Missing prompt or actionTypes", 400);
    }

    // ── Build classification prompt ──
    const actionList = Object.entries(actionTypes)
      .map(([num, desc]) => `${num}: ${desc}`)
      .join("\n");

    const systemPrompt = `You are an action classifier for a dark fantasy RPG. Given a player's input, classify it into exactly ONE action type from the numbered list below. Respond with ONLY the number — nothing else. No explanation, no punctuation, no quotes, no words.

Action types:
${actionList}`;

    // ── Call OpenRouter ──
    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${openrouterApiKey}`,
        "Content-Type": "application/json",
        "HTTP-Referer": "https://questborne.app",
        "X-Title": "Questborne",
      },
      body: JSON.stringify({
        model: "openai/gpt-oss-120b:free",
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: prompt },
        ],
        max_tokens: 20,
        temperature: 0,
      }),
    });

    if (!response.ok) {
      const errText = await response.text();
      console.error("OpenRouter error:", response.status, errText);
      return jsonError("Classification failed", 502);
    }

    const result = await response.json();
    const raw = result.choices?.[0]?.message?.content?.trim() ?? "";

    // Validate: response should be a number key from the map
    const validKeys = Object.keys(actionTypes);
    const actionType = validKeys.includes(raw) ? raw : "0";

    return new Response(
      JSON.stringify({ actionType }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      },
    );
  } catch (err) {
    console.error("classify-action error:", err);
    return jsonError("Internal server error", 500);
  }
});

// ── Helpers ─────────────────────────────────────────────────

function jsonError(message: string, status: number): Response {
  return new Response(
    JSON.stringify({ error: message }),
    {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status,
    },
  );
}
