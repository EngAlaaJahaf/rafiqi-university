// lib/models/semester.dart

class Semester {
  final int? id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;

  Semester({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.isCurrent = false,
  });

  Map<String, dynamic> toMap() => {
        'sem_id': id,
        'sem_name': name,
        'sem_start_date': startDate.toIso8601String(),
        'sem_end_date': endDate.toIso8601String(),
        'sem_is_current': isCurrent ? 1 : 0,
      };

  factory Semester.fromMap(Map<String, dynamic> map) => Semester(
        id: map['sem_id'],
        name: map['sem_name'],
        startDate: DateTime.parse(map['sem_start_date']),
        endDate: DateTime.parse(map['sem_end_date']),
        isCurrent: map['sem_is_current'] == 1,
      );
}
