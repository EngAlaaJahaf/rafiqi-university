// lib/repositories/lectures_repository.dart
import 'package:rafiqi_university/model/lect_type.dart';
import 'package:rafiqi_university/model/lecture.dart';
import 'package:rafiqi_university/services/Database_service.dart';

class LectureTypeRepository {
   static final LectureTypeRepository instance = LectureTypeRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  LectureTypeRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(LectType lectType) async {
    final db = await _dbService.database;
    return await db.insert('sem_lect_type', lectType.toMap());
  }

  // قراءة كل المحاضرات لمادة معينة
  Future<List<LectType>> getForSubject(int lect_type_id) async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_lect_type',
      where: 'lect_type_id = ?',
      whereArgs: [lect_type_id],
      orderBy: 'lect_type_id ASC',
    );
    return result.map((json) => LectType.fromMap(json)).toList();
  }

// R - Read: قراءة كل المحاضرات
  Future<List<LectType>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_lect_type');
    return result.map((json) => LectType.fromMap(json)).toList();
  }
  Future<int> update(LectType lectType) async {
    final db = await _dbService.database;
    return await db.update('sem_lect_type', lectType.toMap(), where: 'lect_type_id = ?', whereArgs: [lectType.id]);
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('sem_lect_type', where: 'lect_type_id = ?', whereArgs: [id]);
  }
}
