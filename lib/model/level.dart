// lib/models/level.dart

class Level {
  final int? id;
  final int number;
  final String name;

  Level({this.id,
   required this.number,
    required this.name});

  Map<String, dynamic> toMap() => {
        'level_id': id,
        'level_number': number,
        'level_name': name,
      };

  factory Level.fromMap(Map<String, dynamic> map) => Level(
        id: map['level_id'],
        number: map['level_number'],
        name: map['level_name'],
      );
}
