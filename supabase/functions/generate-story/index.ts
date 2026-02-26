// @ts-nocheck
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";

// ── Types ──────────────────────────────────────────────────

interface RequestBody {
  prompt: string;
  questDetails: string;
  playerContext: string;
  systemPersona: string;
  safetySettings: SafetySetting[];
  deviceId: string;
}

interface SafetySetting {
  category: string;
  threshold: string;
}

// ── Gemini threshold mapping ───────────────────────────────

const thresholdMap: Record<string, string> = {
  medium: "BLOCK_MEDIUM_AND_ABOVE",
  high: "BLOCK_LOW_AND_ABOVE",
};

const categoryMap: Record<string, string> = {
  hateSpeech: "HARM_CATEGORY_HATE_SPEECH",
  harassment: "HARM_CATEGORY_HARASSMENT",
  sexuallyExplicit: "HARM_CATEGORY_SEXUALLY_EXPLICIT",
  dangerousContent: "HARM_CATEGORY_DANGEROUS_CONTENT",
};

// ── Main handler ───────────────────────────────────────────

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // ── Auth: extract the JWT from the Authorization header ──
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return jsonError("Missing Authorization header", 401);
    }

    // Create a Supabase client authenticated as the user
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const geminiApiKey = Deno.env.get("GEMINI_API_KEY");

    if (!geminiApiKey) {
      return jsonError("GEMINI_API_KEY not configured", 500);
    }

    // User-scoped client (respects RLS for reading credits)
    const supabaseUser = createClient(
      supabaseUrl,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } }
    );

    // Service-role client (bypasses RLS for decrementing credits + device checks)
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

    // Get the authenticated user
    const {
      data: { user },
      error: userError,
    } = await supabaseUser.auth.getUser();
    if (userError || !user) {
      return jsonError("Invalid or expired token", 401);
    }

    // ── Block anonymous users from AI calls ──
    const provider = user.app_metadata?.provider;
    if (!provider || provider === "anonymous") {
      return jsonError(
        "Sign in with Google or Apple to play quests.",
        403
      );
    }

    // ── Parse request body ──
    const body: RequestBody = await req.json();
    if (!body.prompt || !body.systemPersona) {
      return jsonError("Missing required fields: prompt, systemPersona", 400);
    }

    // ── Device ID is REQUIRED ──
    if (!body.deviceId) {
      return jsonError("Device ID is required.", 400);
    }

    // ── Device-level credit enforcement ──
    // Credits live on the device, not the user. Accounts don't matter.
    let { data: deviceRow } = await supabaseAdmin
      .from("device_credits")
      .select("credits, max_credits, reset_at")
      .eq("device_id", body.deviceId)
      .single();

    if (!deviceRow) {
      // First time this device is seen — create a row
      const resetAt = getNextMonthStart();
      await supabaseAdmin.from("device_credits").upsert({
        device_id: body.deviceId,
        credits: 2,
        max_credits: 2,
        reset_at: resetAt.toISOString(),
      });
      deviceRow = { credits: 2, max_credits: 2, reset_at: resetAt.toISOString() };
    }

    let credits = deviceRow.credits;
    const resetAt = new Date(deviceRow.reset_at);

    // Reset credits if we're past the reset date
    if (new Date() >= resetAt) {
      const newReset = getNextMonthStart();
      await supabaseAdmin
        .from("device_credits")
        .update({
          credits: deviceRow.max_credits,
          reset_at: newReset.toISOString(),
        })
        .eq("device_id", body.deviceId);
      credits = deviceRow.max_credits;
    }

    if (credits <= 0) {
      return jsonError("No credits remaining. Resets monthly.", 429);
    }

    // ── Build Gemini request ──
    const safetySettings = (body.safetySettings ?? []).map((s) => ({
      category: categoryMap[s.category] ?? s.category,
      threshold: thresholdMap[s.threshold] ?? "BLOCK_ONLY_HIGH",
    }));

    const geminiBody = {
      contents: [
        {
          parts: [
            { text: body.systemPersona },
            { text: `Current Active Quest: ${body.questDetails}` },
            { text: `Current Player State: ${body.playerContext}` },
            { text: `The player attempts to: "${body.prompt}"` },
          ],
        },
      ],
      safetySettings,
      generationConfig: {
        temperature: 1.0,
      },
    };

    // ── Call Gemini streaming API ──
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:streamGenerateContent?alt=sse&key=${geminiApiKey}`;

    const geminiRes = await fetch(geminiUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(geminiBody),
    });

    if (!geminiRes.ok) {
      const errText = await geminiRes.text();
      console.error("Gemini error:", errText);
      return jsonError(`Gemini API error: ${geminiRes.status}`, 502);
    }

    // ── Decrement device credit (the request was accepted) ──
    await supabaseAdmin
      .from("device_credits")
      .update({ credits: credits - 1 })
      .eq("device_id", body.deviceId);

    // ── Stream the response back to the client ──
    const encoder = new TextEncoder();

    const stream = new ReadableStream({
      async start(controller) {
        try {
          const reader = geminiRes.body!.getReader();
          const decoder = new TextDecoder();
          let buffer = "";

          while (true) {
            const { done, value } = await reader.read();
            if (done) break;

            buffer += decoder.decode(value, { stream: true });

            // Process complete SSE events
            const lines = buffer.split("\n");
            buffer = lines.pop() ?? "";

            for (const line of lines) {
              if (line.startsWith("data: ")) {
                const jsonStr = line.slice(6).trim();
                if (jsonStr === "[DONE]") continue;
                try {
                  const parsed = JSON.parse(jsonStr);
                  const text =
                    parsed?.candidates?.[0]?.content?.parts?.[0]?.text;
                  if (text) {
                    controller.enqueue(encoder.encode(text));
                  }
                } catch {
                  // Skip malformed chunks
                }
              }
            }
          }
        } catch (err) {
          console.error("Stream error:", err);
        } finally {
          controller.close();
        }
      },
    });

    return new Response(stream, {
      headers: {
        ...corsHeaders,
        "Content-Type": "text/plain; charset=utf-8",
        "Transfer-Encoding": "chunked",
      },
    });
  } catch (err) {
    console.error("Unhandled error:", err);
    return jsonError("Internal server error", 500);
  }
});

// ── Helpers ──────────────────────────────────────────────────

function jsonError(message: string, status: number): Response {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function getNextMonthStart(): Date {
  const now = new Date();
  return new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1)
  );
}
