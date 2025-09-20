// lib/models/department.dart

class Department {
  final int? id;
  final String name;
  final String? code;

  Department({this.id, required this.name, this.code});

  Map<String, dynamic> toMap() => {
        'dept_id': id,
        'dept_name': name,
        'dept_code': code,
      };

  factory Department.fromMap(Map<String, dynamic> map) => Department(
        id: map['dept_id'],
        name: map['dept_name'],
        code: map['dept_code'],
      );
}
