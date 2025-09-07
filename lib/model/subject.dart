class Subject {
  final int? id;
  final String name;
  final String? code;
  final String? instructor;

  Subject({this.id, required this.name, this.code, this.instructor});

  // دالة لتحويل الـ Model إلى Map لحفظه في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_name': name,
      'subject_code': code,
      'instructor_name': instructor,
    };
  }

  // دالة لتحويل الـ Map القادم من قاعدة البيانات إلى Model
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['subject_name'],
      code: map['subject_code'],
      instructor: map['instructor_name'],
    );
  }
}
