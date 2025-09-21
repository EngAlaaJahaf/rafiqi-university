// lib/repositories/users_repository.dart
import 'package:rafiqi_university/model/user.dart';
import 'package:rafiqi_university/services/database_service.dart';

class UsersRepository {
   static final UsersRepository instance = UsersRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  UsersRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(User user) async {
    final db = await _dbService.database;
    return await db.insert('sem_user', user.toMap());
  }

  Future<List<User>> getAll() async {
    final db = await _dbService.database;
    final result = await db.query('sem_user');
    return result.map((json) => User.fromMap(json)).toList();
  }
  Future<int> update(User user) async {
    final db = await _dbService.database;
    return await db.update(
      'sem_user',
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [user.id],
    );
  }
  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(
      'sem_user',
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }
  Future<User?> getById(int id) async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_user',
      where: 'user_id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null; // أو يمكنك رمي استثناء إذا لم يتم العثور على المستخدم
    }
  }
  
  // ... يمكنك إضافة باقي دوال CRUD (update, delete, getById) بنفس الطريقة
}
