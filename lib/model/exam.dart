// lib/models/exam.dart

class Exam {
  final int? id;
  final int subjectId;
  final int? examTypeId;
  final DateTime examDate;
  final String? notes;

  Exam({
    this.id,
    required this.subjectId,
    this.examTypeId,
    required this.examDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'exam_id': id,
      'subj_id': subjectId,
      'exam_type_id': examTypeId,
      'exam_date': examDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['exam_id'],
      subjectId: map['subj_id'],
      examTypeId: map['exam_type_id'],
      examDate: DateTime.parse(map['exam_date']),
      notes: map['notes'],
    );
  }
}
