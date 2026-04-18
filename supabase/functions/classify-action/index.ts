// @ts-nocheck
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";

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

    // ── Block anonymous users ──
    const provider = user.app_metadata?.provider;
    if (!provider || provider === "anonymous") {
      return jsonError("Sign in with Google or Apple to play quests.", 403);
    }

    // ── Rate limit (atomic — prevents race conditions on spam) ──
    const { data: rl, error: rlError } = await admin.rpc("check_rate_limit", {
      p_user_id: user.id,
      p_function_name: "classify-action",
      p_max_requests: 30,
      p_window_seconds: 60,
    });
    if (rlError) {
      console.error("Rate limit check failed:", rlError);
      return jsonError("Rate limit check failed", 500);
    }
    if (!rl.allowed) {
      return jsonError(`Rate limited. Retry in ${rl.retryAfterSeconds}s`, 429);
    }

    // ── Credit read-check (defense in depth — don't waste AI calls) ──
    const { data: subRow } = await admin
      .from("user_subscriptions")
      .select("credits_remaining")
      .eq("user_id", user.id)
      .maybeSingle();

    if (!subRow || subRow.credits_remaining <= 0) {
      return jsonError("No credits remaining", 429);
    }

    // ── Parse body ──
    const body: RequestBody = await req.json();
    const { prompt, actionTypes } = body;

    if (!prompt || !actionTypes || Object.keys(actionTypes).length === 0) {
      return jsonError("Missing prompt or actionTypes", 400);
    }

    // ── Input length validation ──
    if (prompt.length > 2000) {
      return jsonError("Prompt is too long (max 2000 characters).", 400);
    }

    // ── Build classification prompt ──
    const actionList = Object.entries(actionTypes)
      .map(([num, desc]) => `${num}: ${desc}`)
      .join("\n");

    const systemPrompt = `You are an action classifier for a dark fantasy RPG. Given a player's input, classify it into exactly ONE action type from the numbered list below. Respond with ONLY the number — nothing else. No explanation, no punctuation, no quotes, no words.

RULES:
- If the player is trying to INFLUENCE someone (persuade, deceive, intimidate, beg, plead, taunt, bluff, lie, frame, manipulate, bargain, threaten verbally, or any social manipulation) → that is social (8), even if violence is mentioned as part of the deception.
- Assassination (5) is ONLY for actual stealth kills — backstabbing, poisoning, silent killing. It is NOT for framing, lying, or deceiving.
- Only respond with 13 (none) for truly passive actions: looking around, walking, resting with no social/combat component, asking simple questions, or exploring.

Action types:
${actionList}`;

    // ── Call OpenRouter ──
    const openrouterUrl = "https://openrouter.ai/api/v1/chat/completions";
    const openrouterPayload = JSON.stringify({
      model: "meta-llama/llama-3.1-8b-instruct",
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: "I swing my sword at the goblin" },
        { role: "assistant", content: "0" },
        { role: "user", content: "I cast a fireball at the enemy" },
        { role: "assistant", content: "2" },
        { role: "user", content: "I try to sneak past the guards" },
        { role: "assistant", content: "4" },
        { role: "user", content: "I try to persuade the merchant" },
        { role: "assistant", content: "8" },
        { role: "user", content: "I beg the elder for mercy" },
        { role: "assistant", content: "8" },
        { role: "user", content: "I lie and say the guard attacked me first" },
        { role: "assistant", content: "8" },
        { role: "user", content: "I cut my hand and blame it on the stranger" },
        { role: "assistant", content: "8" },
        { role: "user", content: "I threaten the shopkeeper to give me a discount" },
        { role: "assistant", content: "8" },
        { role: "user", content: "I walk down the hallway" },
        { role: "assistant", content: "13" },
        { role: "user", content: "I look around the room" },
        { role: "assistant", content: "13" },
        { role: "user", content: prompt },
      ],
      max_tokens: 5,
      temperature: 0,
    });
    const openrouterHeaders = {
      "Authorization": `Bearer ${openrouterApiKey}`,
      "Content-Type": "application/json",
      "HTTP-Referer": "https://questborne.app",
      "X-Title": "Questborne",
    };

    let response = await fetch(openrouterUrl, {
      method: "POST",
      headers: openrouterHeaders,
      body: openrouterPayload,
    });

    // Retry once on transient errors (429, 500, 503)
    if (response.status === 429 || response.status === 500 || response.status === 503) {
      console.warn(`OpenRouter classify returned ${response.status}, retrying in 2s...`);
      await new Promise((r) => setTimeout(r, 2000));
      response = await fetch(openrouterUrl, {
        method: "POST",
        headers: openrouterHeaders,
        body: openrouterPayload,
      });
    }

    if (!response.ok) {
      const errText = await response.text();
      console.error("OpenRouter error:", response.status, errText);
      return jsonError("Classification failed", 502);
    }

    const result = await response.json();
    console.log("REEEES:", result)
    const choice = result.choices?.[0]?.message;
    let raw = (choice?.content ?? "").trim();
    const validKeys = Object.keys(actionTypes);

    // Fallback: if content is empty (reasoning model used all tokens thinking),
    // try to extract a valid action number from the reasoning text.
    if (!raw && choice?.reasoning) {
      const reasoningText = choice.reasoning;
      // Look for an action type name in the reasoning (e.g. "throwAttack")
      for (const key of validKeys) {
        const actionName = actionTypes[key].split(":")[0].trim();
        if (reasoningText.includes(actionName)) {
          raw = key;
          break;
        }
      }
      // If no name match, try to find a bare number at the end of reasoning
      if (!raw) {
        const numMatch = reasoningText.match(/(\d{1,2})\s*$/);
        if (numMatch && validKeys.includes(numMatch[1])) {
          raw = numMatch[1];
        }
      }
    }

    // Validate: response should be a number key from the map
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
