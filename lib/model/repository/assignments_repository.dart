// lib/repositories/assignments_repository.dart
import 'package:rafiqi_university/model/assignment.dart';
import 'package:rafiqi_university/services/Database_helper.dart';

class AssignmentsRepository {
  final DatabaseHelper _dbService = DatabaseHelper.instance;

  Future<int> create(Assignment assignment) async {
    final db = await _dbService.database;
    return await db.insert('sem_assignments', assignment.toMap());
  }

  Future<List<Assignment>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_assignments', orderBy: 'due_date ASC');
    return result.map((json) => Assignment.fromMap(json)).toList();
  }
  
  // ... يمكنك إضافة باقي دوال CRUD (update, delete, getForSubject) بنفس الطريقة
}
