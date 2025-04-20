class ChatMessageModel {
  final int? id;
  final int chatId;
  final String rol;
  final String message;
  final String? timestamp;

  ChatMessageModel({
    this.id,
    required this.chatId,
    required this.rol,
    required this.message,
    this.timestamp,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'],
      chatId: map['chat_id'],
      rol: map['rol'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_id': chatId,
      'rol': rol,
      'message': message,
      'timestamp': timestamp,
    };
  }
}