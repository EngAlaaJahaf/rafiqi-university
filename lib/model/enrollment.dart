class Enrollment {
  int id; // تغيير من String إلى int لأن enrollment_id INTEGER
  int userId;
  int subjectId; // كان courseId أصبح subjectId لتتوافق مع subj_id
  DateTime enrollmentDate;
  String status;

  Enrollment({
    required this.id,
    required this.userId,
    required this.subjectId,
    required this.enrollmentDate,
    this.status = 'ACTIVE',
  });

  Map<String, dynamic> toMap() {
    return {
      'enrollment_id': id,
      'user_id': userId,
      'subj_id': subjectId, // تغيير من sem_id إلى subj_id
      'enroll_date': enrollmentDate.toIso8601String(),
      'status': status,
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      id: map['enrollment_id'] as int, // تغيير من enroll_id إلى enrollment_id
      userId: map['user_id'] as int,
      subjectId: map['subj_id'] as int, // تغيير من course_id إلى subj_id
      enrollmentDate: DateTime.parse(map['enroll_date']),
      status: map['status'] ?? 'ACTIVE',
    );
  }
}