// lib/models/class_room.dart

class ClassRoom {
  final int? id;
  final String name;

  ClassRoom({this.id, required this.name});

  Map<String, dynamic> toMap() => {
        'cl_id': id,
        'cl_name': name,
      };

  factory ClassRoom.fromMap(Map<String, dynamic> map) => ClassRoom(
        id: map['cl_id'],
        name: map['cl_name'],
      );
}
