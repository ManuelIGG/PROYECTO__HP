class UserModel {
  final int? id;
  final String fullName;
  final String email;
  final String password;
  final String? birthDate;
  final String? document;
  final String? createdAt;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.birthDate,
    this.document,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      birthDate: map['birthDate'],
      document: map['document'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password, // Nota: en producción deberías almacenar contraseñas hasheadas
      'birthDate': birthDate,
      'document': document,
      'created_at': createdAt,
    };
  }
}