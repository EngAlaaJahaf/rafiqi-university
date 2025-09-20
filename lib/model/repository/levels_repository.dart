// lib/repositories/levels_repository.dart
import 'package:rafiqi_university/model/level.dart';
import 'package:rafiqi_university/services/database_service.dart';

class LevelsRepository {
   static final LevelsRepository instance = LevelsRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  LevelsRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Level level) async {
    final db = await _dbService.database;
    return await db.insert('sem_levels', level.toMap());
  }

  Future<List<Level>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_levels', orderBy: 'level_number ASC');
    return result.map((json) => Level.fromMap(json)).toList();
  }
}
