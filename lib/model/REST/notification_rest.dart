// lib/model/REST/notification_rest.dart

class NotificationRest {
  final int notifId;
  final int userId; // يتوقع رقم
  final String notifMessage;
  final DateTime notifDate;
  final bool isRead;
  final String? notifRelatedEntity; // قد يكون null
  final int? notifRelatedId;     // قد يكون null

  NotificationRest({
    required this.notifId,
    required this.userId,
    required this.notifMessage,
    required this.notifDate,
    required this.isRead,
    this.notifRelatedEntity,
    this.notifRelatedId,
  });

  factory NotificationRest.fromJson(Map<String, dynamic> json) {
    // دالة مساعدة لتحويل القيمة إلى رقم بأمان
    int? safeParseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return NotificationRest(
      notifId: safeParseInt(json['notif_id']) ?? 0,
      
      // ✨ --- هذا هو التصحيح --- ✨
      userId: safeParseInt(json['user_id']) ?? 0, // طبقنا الحل هنا أيضاً

      notifMessage: json['notif_message'] ?? 'No message',
      notifDate: json['notif_date'] != null
          ? DateTime.parse(json['notif_date'])
          : DateTime.now(),
      isRead: json['notif_is_read'] == 'Y',
      notifRelatedEntity: json['notif_related_entity'],
      notifRelatedId: safeParseInt(json['notif_related_id']),
    );
  }
}
