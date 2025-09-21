class Enrollment {
  String id;
  int usertId;
  int courseId;
  DateTime enrollmentDate;
  String status; // e.g., 'active', 'completed', 'dropped'

  Enrollment({
    required this.id,
    required this.usertId,
    required this.courseId,
    required this.enrollmentDate,
    this.status = 'active',
  });

  Map<String, dynamic> toMap() {
    return {
      'enroll_id': id,
      'student_id': usertId,
      'course_id': courseId,
      'enroll_date': enrollmentDate.toIso8601String(),
      'status': status,
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      id: map['enroll_id'],
      usertId: map['student_id'],
      courseId: map['course_id'],
      enrollmentDate: DateTime.parse(map['enroll_date']),
      status: map['status'],
    );
  }
}