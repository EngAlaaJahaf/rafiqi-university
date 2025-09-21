// lib/repositories/teachers_repository.dart
import 'package:rafiqi_university/model/teacher.dart';
import 'package:rafiqi_university/services/database_service.dart';

class TeachersRepository {
   static final TeachersRepository instance = TeachersRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  TeachersRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Teacher teacher) async {
    final db = await _dbService.database;
    return await db.insert('sem_teachers', teacher.toMap());
  }

  Future<List<Teacher>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_teachers', orderBy: 'teach_name ASC');
    return result.map((json) => Teacher.fromMap(json)).toList();
  }
  Future<int> update(Teacher teacher) async {
    final db = await _dbService.database;
    return await db.update('sem_teachers', teacher.toMap(), where: 'teach_id = ?', whereArgs: [teacher.id]);
  }
  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('sem_teachers', where: 'teach_id = ?', whereArgs: [id]);
  } 
  
}
