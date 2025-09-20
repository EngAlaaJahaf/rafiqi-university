// lib/models/lecture.dart

class Lecture {
  final int? id;
  final int subjectId;
  final int? teacherId;
  final DateTime lectureDate;
  final int? timeSlotId;
  final int? lectureTypeId;
  final int? classId;
  final bool isCompleted;
  final String? notes;

  Lecture({
    this.id,
    required this.subjectId,
    this.teacherId,
    required this.lectureDate,
    this.timeSlotId,
    this.lectureTypeId,
    this.classId,
    this.isCompleted = false,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'lect_id': id,
      'subj_id': subjectId,
      'teach_id': teacherId,
      'lect_date': lectureDate.toIso8601String(), // تحويل التاريخ إلى نص
      'ts_id': timeSlotId,
      'lect_type_id': lectureTypeId,
      'cl_id': classId,
      'is_completed': isCompleted ? 1 : 0, // تحويل bool إلى رقم
      'notes': notes,
    };
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    return Lecture(
      id: map['lect_id'],
      subjectId: map['subj_id'],
      teacherId: map['teach_id'],
      lectureDate: DateTime.parse(map['lect_date']), // تحويل النص إلى تاريخ
      timeSlotId: map['ts_id'],
      lectureTypeId: map['lect_type_id'],
      classId: map['cl_id'],
      isCompleted: map['is_completed'] == 1, // تحويل الرقم إلى bool
      notes: map['notes'],
    );
  }
}
