// lib/repositories/exams_repository.dart
import 'package:rafiqi_university/model/exam.dart';
import 'package:rafiqi_university/services/Database_service.dart';

class ExamsRepository {
   static final ExamsRepository instance = ExamsRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  ExamsRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Exam exam) async {
    final db = await _dbService.database;
    return await db.insert('sem_exams', exam.toMap());
  }

  Future<List<Exam>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_exams', orderBy: 'exam_date ASC');
    return result.map((json) => Exam.fromMap(json)).toList();
  }
  
  // ... يمكنك إضافة باقي دوال CRUD (update, delete, getForSubject) بنفس الطريقة
}
