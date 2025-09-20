// lib/models/assignment.dart

class Assignment {
  final int? id;
  final int subjectId;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isCompleted;

  Assignment({
    this.id,
    required this.subjectId,
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'assign_id': id,
      'subj_id': subjectId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted ? 0 : 1,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['assign_id'],
      subjectId: map['subj_id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['due_date']),
      isCompleted: map['is_completed'] == 0, // تحويل الرقم إلى bool
    );
  }
}
