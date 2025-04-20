class UserMessageModel {
  final String rol;
  final String message;
  final int id;

  UserMessageModel({
    required this.rol,
    required this.message,
    required this.id,
  });

  factory UserMessageModel.fromJson(Map<String, dynamic> json) {
    return UserMessageModel(
      rol: json['rol'],
      message: json['message'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'rol': rol, 'message': message, 'id': id};
  }
}
