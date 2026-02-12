// lib/models/chat_message.dart (No Change)
enum MessageSender { player, ai }

class ChatMessage {
  final String id;
  final MessageSender sender;
  String text;
  final DateTime timestamp;
  bool isComplete;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isComplete = true,
  });

  factory ChatMessage.aiStreaming({
    required String id,
    required String text,
    required DateTime timestamp,
  }) {
    return ChatMessage(
      id: id,
      sender: MessageSender.ai,
      text: text,
      timestamp: timestamp,
      isComplete: false,
    );
  }
}
