enum MessageType { text, emoji, sticker }

class Message {
  final String id;
  final String text;
  final String userId;
  final MessageType type;
  final DateTime timestamp;
  final String? stickerAsset;

  Message({
    required this.id,
    required this.text,
    required this.userId,
    required this.type,
    required this.timestamp,
    this.stickerAsset,
  });
}
