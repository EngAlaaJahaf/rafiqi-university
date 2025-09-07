class Lecture {
  final int? id;
  final int subjectId;
  final String lectureTitle;
  final String lectureDate;
  final String startTime;
  final bool isCompleted;

  Lecture({
    this.id,
    required this.subjectId,
    required this.lectureTitle,
    required this.lectureDate,
    required this.startTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'lecture_title': lectureTitle,
      'lecture_date': lectureDate,
      'start_time': startTime,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    return Lecture(
      id: map['id'],
      subjectId: map['subject_id'],
      lectureTitle: map['lecture_title'],
      lectureDate: map['lecture_date'],
      startTime: map['start_time'],
      isCompleted: map['is_completed'] == 1,
    );
  }
}
