// notification_model.dart

class NotificationModel {
  final int notifId;
  final int userId;
  final String notifMessage;
  final DateTime notifDate;
  final bool isRead;
  final String notifRelatedEntity;
  final int notifRelatedId;

  NotificationModel({
    required this.notifId,
    required this.userId,
    required this.notifMessage,
    required this.notifDate,
    required this.isRead,
    required this.notifRelatedEntity,
    required this.notifRelatedId,
  });

  // دالة Factory لتحويل JSON إلى كائن NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notifId: json['notif_id'],
      userId: json['user_id'],
      notifMessage: json['notif_message'],
      notifDate: DateTime.parse(json['notif_date']),
      // تحويل 'Y'/'N' إلى true/false
      isRead: json['notif_is_read'] == 'Y',
      notifRelatedEntity: json['notif_related_entity'],
      notifRelatedId: json['notif_related_id'],
    );
  }
}
