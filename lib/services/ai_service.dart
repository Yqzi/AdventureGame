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
