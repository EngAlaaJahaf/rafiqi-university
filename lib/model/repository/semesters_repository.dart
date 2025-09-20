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
}
