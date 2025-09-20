// lib/repositories/subjects_repository.dart
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/services/database_service.dart';

class SubjectsRepository {
  // Singleton to allow usage like: SubjectsRepository.instance
  // SubjectsRepository._();
  
  static final SubjectsRepository instance = SubjectsRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  SubjectsRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;
  

  // إضافة مادة جديدة
  Future<int> create(Subject subject) async {
    final db = await _dbService.database;
    return await db.insert('sem_subjects', subject.toMap());
  }

  // قراءة كل المواد
  Future<List<Subject>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_subjects', orderBy: 'subj_name ASC');
    return result.map((json) => Subject.fromMap(json)).toList();
  }

  // قراءة مادة واحدة بواسطة ID
  Future<Subject?> getById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query('sem_subjects', where: 'subj_id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Subject.fromMap(maps.first);
    }
    return null;
  }

  // تحديث مادة
  Future<int> update(Subject subject) async {
    final db = await _dbService.database;
    return await db.update(
      'sem_subjects',
      subject.toMap(),
      where: 'subj_id = ?',
      whereArgs: [subject.id],
    );
  }

  // حذف مادة
  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('sem_subjects', where: 'subj_id = ?', whereArgs: [id]);
  }
}
