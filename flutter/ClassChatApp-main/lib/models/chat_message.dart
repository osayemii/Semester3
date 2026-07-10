class ChatMessage {

  final String text;

  final String sender;

  final int timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(
    Map<dynamic, dynamic> data,
  ) {
    return ChatMessage(
      text: data['text'] ?? '',
      sender: data['sender'] ?? '',
      timestamp: data['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender,
      'timestamp': timestamp,
    };
  }
}