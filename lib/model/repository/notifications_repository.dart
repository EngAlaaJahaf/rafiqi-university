// lib/repositories/notifications_repository.dart
import 'package:rafiqi_university/model/notification.dart';
import 'package:rafiqi_university/services/Database_service.dart';

class NotificationsRepository {
   static final NotificationsRepository instance = NotificationsRepository._init();

  // 2. إنشاء مُنشئ خاص (private) لمنع إنشاء نسخ من الخارج
  NotificationsRepository._init();
  // --- الإضافة الجديدة تنتهي هنا ---

  // لا ننشئ نسخة جديدة هنا، بل نستخدم النسخة الوحيدة من الخدمة
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(AppNotification notification) async {
    final db = await _dbService.database;
    return await db.insert('sem_notifications', notification.toMap());
  }

  // قراءة كل الإشعارات لمستخدم معين
  Future<List<AppNotification>> getForUser(int userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'sem_notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'notif_date DESC',
    );
    return result.map((json) => AppNotification.fromMap(json)).toList();
  }
  
  // ... يمكنك إضافة باقي دوال CRUD (update, delete) بنفس الطريقة
}
