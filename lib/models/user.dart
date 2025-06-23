class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String securityAnswer;
  final DateTime createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.securityAnswer,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert User to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'security_answer': securityAnswer,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create User from Map (database result)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      securityAnswer: map['security_answer'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Create a copy of User with updated fields
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? securityAnswer,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      securityAnswer: securityAnswer ?? this.securityAnswer,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.securityAnswer == securityAnswer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        securityAnswer.hashCode;
  }
}
