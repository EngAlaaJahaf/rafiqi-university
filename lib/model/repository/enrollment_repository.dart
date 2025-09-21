import 'package:rafiqi_university/model/enrollment.dart';
import 'package:rafiqi_university/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class EnrollmentRepository {
  static final EnrollmentRepository instance = EnrollmentRepository._init();
  EnrollmentRepository._init();
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(int userId, int subjectId) async {
    final db = await _dbService.database;
    return await db.insert('sem_enrollments', {
      'user_id': userId,
      'subj_id': subjectId, // تغيير من sem_id إلى subj_id
      'enroll_date': DateTime.now().toIso8601String(),
      'status': 'ACTIVE',
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

  Future<int> update(Enrollment enrollment) async {
    final db = await _dbService.database;
    return await db.update(
      'sem_enrollments',
      enrollment.toMap(),
      where: 'enrollment_id = ?', // تغيير من enroll_id إلى enrollment_id
      whereArgs: [enrollment.id],
    );
  }

  Future<int> delete(int enrollmentId) async {
    final db = await _dbService.database;
    return await db.delete(
      'sem_enrollments',
      where: 'enrollment_id = ?', // تغيير من enroll_id إلى enrollment_id
      whereArgs: [enrollmentId],
    );
  }

  Future<bool> isUserEnrolledInSubject(int userId, int subjectId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_enrollments',
      where: 'user_id = ? AND subj_id = ?', // تغيير من sem_id إلى subj_id
      whereArgs: [userId, subjectId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> updateEnrollmentDate(int enrollmentId) async {
    final db = await _dbService.database;
    await db.update(
      'sem_enrollments',
      {'enroll_date': DateTime.now().toIso8601String()},
      where: 'enrollment_id = ?', // تغيير من enroll_id إلى enrollment_id
      whereArgs: [enrollmentId],
    );
  }

  Future<int?> getEnrollmentIdByUserIdAndSubjectId(int userId, int subjectId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_enrollments',
      columns: ['enrollment_id'], // تغيير من enroll_id إلى enrollment_id
      where: 'user_id = ? AND subj_id = ?', // تغيير من sem_id إلى subj_id
      whereArgs: [userId, subjectId],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['enrollment_id'] as int;
    } else {
      return null;
    }
  }

  Future<int> getEnrollmentCountForSubject(int subjectId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sem_enrollments WHERE subj_id = ?', // تغيير من sem_id إلى subj_id
      [subjectId],
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

  Future<int> getEnrollmentCountForUserAndSubject(int userId, int subjectId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sem_enrollments WHERE user_id = ? AND subj_id = ?', // تغيير من sem_id إلى subj_id
      [userId, subjectId],
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

  // إزالة الدوال المكررة وغير المستخدمة
}