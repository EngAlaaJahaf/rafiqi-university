// lib/repositories/semesters_repository.dart
import 'package:rafiqi_university/model/semester.dart';
import 'package:rafiqi_university/services/database_service.dart';

class SemestersRepository {
   static final SemestersRepository instance = SemestersRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  SemestersRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Semester semester) async {
    final db = await _dbService.database;
    return await db.insert('sem_semesters', semester.toMap());
  }

  Future<List<Semester>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_semesters', orderBy: 'sem_start_date DESC');
    return result.map((json) => Semester.fromMap(json)).toList();
  }
  Future<int> update(Semester semester) async {
    final db = await _dbService.database;
    return await db.update('sem_semesters', semester.toMap(), where: 'sem_id = ?', whereArgs: [semester.id]);
  }
  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('sem_semesters', where: 'sem_id = ?', whereArgs: [id]);
  }
  Future<Semester?> getCurrentSemester() async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_semesters',
      where: 'sem_is_current = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Semester.fromMap(result.first);
    }
    return null; // لا يوجد فصل دراسي حالي
  }
  Future<int> setCurrentSemester(int semesterId) async {
    final db = await _dbService.database;
    // أولاً، نجعل كل الفصول الدراسية غير حالية
    await db.update('sem_semesters', {'sem_is_current': 0});
    // ثم، نجعل الفصل الدراسي المحدد هو الحالي
    return await db.update('sem_semesters', {'sem_is_current': 1}, where: 'sem_id = ?', whereArgs: [semesterId]);
  }
  Future<int?> clearCurrentSemester(int id) async{
    final db = await _dbService.database;
    return await db.update('sem_semesters', {'sem_is_current': 0}, where: 'sem_id = ?', whereArgs: [id]);
  }
}
