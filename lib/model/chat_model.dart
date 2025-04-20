class ChatModel {
  final int? id;
  final int userId;
  final String title;
  final String? createdAt;

  ChatModel({
    this.id,
    required this.userId,
    required this.title,
    this.createdAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'created_at': createdAt,
    };
  }
}