// lib/models/notification.dart

class AppNotification { // تم تغيير الاسم لتجنب التعارض مع كلاس Notification الخاص بـ Flutter
  final int? id;
  final int userId;
  final String message;
  final DateTime notificationDate;
  final bool isRead;

  AppNotification({
    this.id,
    required this.userId,
    required this.message,
    required this.notificationDate,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'notif_id': id,
      'user_id': userId,
      'message': message,
      'notif_date': notificationDate.toIso8601String(),
      'is_read': isRead ? 1 : 0,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['notif_id'],
      userId: map['user_id'],
      message: map['message'],
      notificationDate: DateTime.parse(map['notif_date']),
      isRead: map['is_read'] == 1,
    );
  }
}
