class Subject {
  final int? id;
  final String subject_name;
  final String? subject_code;
  final String? instructor_name;

  Subject({this.id, required this.subject_name, this.subject_code, this.instructor_name});

  // دالة لتحويل الـ Model إلى Map لحفظه في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_name': subject_name,
      'subject_code': subject_code,
      'instructor_name': instructor_name,
    };
  }

  // دالة لتحويل الـ Map القادم من قاعدة البيانات إلى Model
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      subject_name: map['subject_name'],
      subject_code: map['subject_code'],
      instructor_name: map['instructor_name'],
    );
  }
}
