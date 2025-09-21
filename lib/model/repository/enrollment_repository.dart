import 'package:rafiqi_university/model/enrollment.dart';
import 'package:rafiqi_university/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class EnrollmentRepository {
  static final EnrollmentRepository instance = EnrollmentRepository._init();
  EnrollmentRepository._init();
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(int userId, int semesterId) async {
    final db = await _dbService.database;
    return await db.insert('sem_enrollments', {
      'user_id': userId,
      'sem_id': semesterId,
      'enroll_date': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Enrollment>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_enrollments',
      orderBy: 'enroll_date DESC',
    );
    return result.map((json) => Enrollment.fromMap(json)).toList();
  }

  Future<int> createEnrollment(int userId, int semesterId) async {
    final db = await _dbService.database;
    return await db.insert('sem_enrollments', {
      'user_id': userId,
      'sem_id': semesterId,
      'enroll_date': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllEnrollments() async {
    final db = await _dbService.database;
    return await db.query('sem_enrollments', orderBy: 'enroll_date DESC');
  }

  Future<List<Map<String, dynamic>>> updateEnrollments() async {
    final db = await _dbService.database;
    return await db.query('sem_enrollments', orderBy: 'enroll_date DESC');
  }

  Future<List<Map<String, dynamic>>> getEnrollmentsByUserId(int userId) async {
    final db = await _dbService.database;
    return await db.query(
      'sem_enrollments',
      where: 'user_id=?',
      whereArgs: [userId],
      orderBy: "sem_id DESC",
    );
  }

  Future<List<Map<String, dynamic>>> getEnrolledSemesters(int userId) async {
    final db = await _dbService.database;
    return await db.query(
      'sem_enrollments',
      where: 'user_id=?',
      whereArgs: [userId],
      orderBy: "sem_id DESC",
    );
  }

  Future<int> delete(int enrollmentId) async {
    final db = await _dbService.database;
    return await db.delete(
      'sem_enrollments',
      where: 'enroll_id = ?',
      whereArgs: [enrollmentId],
    );
  }

  Future<bool> isUserEnrolledInSemester(int userId, int semesterId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_enrollments',
      where: 'user_id = ? AND sem_id = ?',
      whereArgs: [userId, semesterId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> updateEnrollmentDate(int enrollmentId) async {
    final db = await _dbService.database;
    await db.update(
      'sem_enrollments',
      {'enroll_date': DateTime.now().toIso8601String()},
      where: 'enroll_id = ?',
      whereArgs: [enrollmentId],
    );
  }

  Future<int?> getEnrollmentIdByUserIdAndSemesterId(
    int userId,
    int semesterId,
  ) async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_enrollments',
      columns: ['enroll_id'],
      where: 'user_id = ? AND sem_id = ?',
      whereArgs: [userId, semesterId],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['enroll_id'] as int;
    } else {
      return null; // User not enrolled in the specified semester.
    }
  }

  Future<int> getEnrollmentCountForSemester(int semesterId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sem_enrollments WHERE sem_id = ?',
      [semesterId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getEnrollmentCountForUser(int userId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sem_enrollments WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getEnrollmentCountForUserAndSemester(
    int userId,
    int semesterId,
  ) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sem_enrollments WHERE user_id = ? AND sem_id = ?',
      [userId, semesterId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalEnrollmentCount() async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sem_enrollments',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getUserEnrollmentCount(int userId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sem_enrollments WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
