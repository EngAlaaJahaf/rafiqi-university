// lib/repositories/class_rooms_repository.dart
import 'package:rafiqi_university/model/class_room.dart';
import 'package:rafiqi_university/services/database_service.dart';

class ClassRoomsRepository {
   static final ClassRoomsRepository instance = ClassRoomsRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  ClassRoomsRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(ClassRoom classRoom) async {
    final db = await _dbService.database;
    return await db.insert('sem_class', classRoom.toMap());
  }

  Future<List<ClassRoom>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_class', orderBy: 'cl_name ASC');
    return result.map((json) => ClassRoom.fromMap(json)).toList();
  }
}
