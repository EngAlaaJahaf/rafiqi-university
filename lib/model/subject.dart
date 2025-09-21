// lib/models/subject.dart

class Subject {
  final int? id;
  final String name;
  final String code;
  final int? creditHours;

  Subject({
    this.id,
    required this.name,
    required this.code,
    this.creditHours,
  });

  // دالة لتحويل الكائن إلى Map لإدخاله في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'subj_id': id,
      'subj_name': name,
      'subj_code': code,
      'subj_credit_hours': creditHours,
    };
  }

  // دالة لبناء كائن من Map قادمة من قاعدة البيانات
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['subj_id'] as int?,
      name: map['subj_name'] as String,
      code: map['subj_code'] as String,
      creditHours: map['subj_credit_hours'] as int?,
    );
  }

  factory Subject.empty() {
  return Subject(
    id: 0,
    name: 'غير معروف',
    code: '',
  );
}
}
