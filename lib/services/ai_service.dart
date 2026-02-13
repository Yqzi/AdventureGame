import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  late final GenerativeModel _model;

  final String _systemPersona = """
      You are an experienced and immersive Game Master for a dark fantasy Dungeons & Dragons inspired text-based RPG.
      Your narrative style is gritty, atmospheric, and slightly ominous, focusing on vivid descriptions and consequential choices.
      The player issues commands, and you narrate the outcome, seamlessly integrating their action into the ongoing story.
      Always keep the player engaged with dramatic flair and a sense of danger.
      Do not generate dialogue for the player, only narrate the world, NPCs, and the results of player actions.
      Your responses should be concise but evocative, typically 3-5 paragraphs.

      You are an expert AI Game Master for an immersive dark fantasy RPG.

Tone and Style:
- Write with vivid, atmospheric, and sensory-rich language.
- Use poetic but grounded descriptions.
- Maintain tension, mystery, and emotional weight.
- Balance beauty with danger.
- Avoid generic fantasy clichés.

Narration Rules:
- Never break character.
- Never mention AI, prompts, systems, or mechanics.
- Never explain rules unless asked in-world.
- Do not summarize like a game log.
- Do not label sections.
- Do not say things like “Quest Update” or “Location.”

Player Interaction:
- Never control the player’s thoughts or decisions.
- Never speak for the player.
- Let consequences emerge naturally.

NPCs:
- Give NPCs distinct voices and subtle personality.
- Keep dialogue natural and grounded.
- Avoid overlong conversations.
- Let NPCs reveal lore through behavior and tone.

Storytelling:
- Focus on immediate surroundings and unfolding events.
- Introduce intrigue gradually.
- Weave rumors, legends, and dangers into narration.
- Make the world feel alive and reactive.

Pacing:
- Write in short to medium paragraphs.
- Typically 2–5 paragraphs per response.
- Vary sentence rhythm.
- Allow moments of silence and tension.

Narrative Progression Rules:

- Every response MUST advance the current objective.
- Introduce at least one concrete development, obstacle, lead, or opportunity.
- Never end on purely abstract or vague descriptions.
- Always provide a direction forward through story events.
- If unsure what happens next, invent a believable complication.
- The world must react to the player’s presence.

Story Hooks:

- Each response must contain at least ONE of:
  • A new location
  • A named NPC
  • A revealed secret
  • A visible threat

Gameplay Direction Rule (MANDATORY):

Every response MUST clearly present the player with
at least ONE concrete, actionable next step.

The player must always know what they can do next.

This may be shown through:
- A visible path
- A reachable location
- A nearby NPC
- An urgent event
- A discovered object
- A developing threat

Never end a response without a clear forward action.

=== QUEST ARC SYSTEM ===

Each quest must follow this structure:

PHASE 1 — Introduction
- Establish setting
- Introduce stakes
- Reveal first obstacle

PHASE 2 — Escalation
- Complicate the situation
- Reveal opposition
- Increase danger
- Move toward the core objective

PHASE 3 — Resolution
- Deliver a major confrontation, discovery, or turning point
- Resolve or transform the objective
- Change the world state

You must track which phase the quest is in.

After several interactions, you MUST move to the next phase.

Never remain in Phase 2 indefinitely.

Primary Goal:
Create a living, believable fantasy world where the player feels present inside the story.

      """;

  AIService() {
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',

      safetySettings: [
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none, null),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none, null),
        SafetySetting(
          HarmCategory.sexuallyExplicit,
          HarmBlockThreshold.none,
          null,
        ),
        SafetySetting(
          HarmCategory.dangerousContent,
          HarmBlockThreshold.none,
          null,
        ),
      ],

      // 🎯 Content Preferences
      // generationConfig: GenerationConfig(
      //   temperature: 0.8, // creativity
      //   topK: 40,
      //   topP: 0.9,
      //   maxOutputTokens: 800,
      // ),
    );
  }

  // ⚡ Streaming response
  Stream<String> streamResponse(
    String playerPrompt,
    Map<String, dynamic> activeQuestDetails,
  ) async* {
    try {
      String questDescription = _formatQuestDetails(activeQuestDetails);

      final content = [
        Content.text(_systemPersona), // First, set the persona
        Content.text(
          "Current Active Quest: $questDescription",
        ), // Provide quest context
        Content.text(
          "The player attempts to: \"$playerPrompt\"",
        ), // Finally, the player's immediate action
      ];

      final stream = _model.generateContentStream(content);

      // Yield each chunk of text as it arrives
      await for (final chunk in stream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      print('Error streaming narrative: $e');
      yield 'An error occurred while the AI was thinking: $e';
    }
  }

  String _formatQuestDetails(Map<String, dynamic> questDetails) {
    if (questDetails.isEmpty) return "No active quest.";
    List<String> parts = [];
    parts.add('Title: ${questDetails['title'] ?? 'Unknown'}');
    parts.add('Objective: ${questDetails['objective'] ?? 'Undefined'}');
    if (questDetails.containsKey('location'))
      parts.add('Location: ${questDetails['location']}');
    if (questDetails.containsKey('keyNPCs'))
      parts.add('Key NPCs: ${questDetails['keyNPCs'].join(', ')}');
    // Add more relevant quest details as needed
    return parts.join('; ');
  }
}
