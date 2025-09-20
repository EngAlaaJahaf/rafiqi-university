// lib/repositories/lectures_repository.dart
import 'package:rafiqi_university/model/lecture.dart';
import 'package:rafiqi_university/services/Database_service.dart';

class LecturesRepository {
   static final LecturesRepository instance = LecturesRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  LecturesRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Lecture lecture) async {
    final db = await _dbService.database;
    return await db.insert('sem_lectures', lecture.toMap());
  }

  // قراءة كل المحاضرات لمادة معينة
  Future<List<Lecture>> getForSubject(int subjectId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_lectures',
      where: 'subj_id = ?',
      whereArgs: [subjectId],
      orderBy: 'lect_date ASC',
    );
    return result.map((json) => Lecture.fromMap(json)).toList();
  }

// R - Read: قراءة كل المحاضرات
  Future<List<Lecture>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_lectures', orderBy: 'lect_date DESC');
    return result.map((json) => Lecture.fromMap(json)).toList();
  }
  Future<int> update(Lecture lecture) async {
    final db = await _dbService.database;
    return await db.update('sem_lectures', lecture.toMap(), where: 'lect_id = ?', whereArgs: [lecture.id]);
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('sem_lectures', where: 'lect_id = ?', whereArgs: [id]);
  }
}
