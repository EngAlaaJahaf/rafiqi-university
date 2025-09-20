// lib/repositories/departments_repository.dart
import 'package:rafiqi_university/model/department.dart';
import 'package:rafiqi_university/services/database_service.dart';

class DepartmentsRepository {
   static final DepartmentsRepository instance = DepartmentsRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  DepartmentsRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Department department) async {
    final db = await _dbService.database;
    return await db.insert('sem_departments', department.toMap());
  }

  Future<List<Department>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_departments', orderBy: 'dept_name ASC');
    return result.map((json) => Department.fromMap(json)).toList();
  }
  
  // ... يمكنك إضافة باقي دوال CRUD (update, delete) حسب الحاجة
}
