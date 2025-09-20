// lib/models/teacher.dart

class Teacher {
  final int? id;
  final String name;
  final String? email;
  final String? phone;

  Teacher({this.id, required this.name, this.email, this.phone});

  Map<String, dynamic> toMap() => {
        'teach_id': id,
        'teach_name': name,
        'teach_email': email,
        'teach_phone': phone,
      };

  factory Teacher.fromMap(Map<String, dynamic> map) => Teacher(
        id: map['teach_id'],
        name: map['teach_name'],
        email: map['teach_email'],
        phone: map['teach_phone'],
      );
}
