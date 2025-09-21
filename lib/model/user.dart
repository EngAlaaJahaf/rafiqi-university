// lib/models/user.dart

class User {
  final int? id;
  final String username;
  final String fullName;
  final String? email;
  final String passwordHash;
  final String role;
  final int? deptId;
  final int? levelId;

  User({
    this.id,
    required this.username,
    required this.fullName,
    this.email,
    required this.passwordHash,
    this.role = 'student',
    this.deptId,
    this.levelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'username': username,
      'full_name': fullName,
      'email': email,
      'password_hash': passwordHash,
      'role': role,
      'dept_id': deptId,
      'level_id': levelId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'],
      username: map['username'],
      fullName: map['full_name'],
      email: map['email'],
      passwordHash: map['password_hash'],
      role: map['role'],
      deptId: map['dept_id'],
      levelId: map['level_id'],
    );
  }

  factory User.empty() {
  return User(
    id: 0,
    username: 'غير معروف',
    fullName: 'غير معروف',
    email: '',
    passwordHash: '',
    role: '',
  );
}
}
