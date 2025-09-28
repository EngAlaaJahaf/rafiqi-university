import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // لم نعد بحاجة لهذه المكتبة هنا

class NotificationCard extends StatelessWidget {
  final String message;
  final String? relatedEntity;
  // final DateTime date; // <-- تم حذف التاريخ من هنا
  final bool isRead;
  final VoidCallback onDelete;
  final VoidCallback onToggleRead;

  const NotificationCard({
    super.key,
    required this.message,
    this.relatedEntity,
    // required this.date, // <-- تم حذفه من الكونستركتور
    required this.isRead,
    required this.onDelete,
    required this.onToggleRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = isRead ? Colors.grey : theme.colorScheme.primary;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRead ? Colors.grey.shade300 : theme.colorScheme.primary.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onToggleRead,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // الأيقونة
              Icon(
                isRead ? Icons.notifications_off_outlined : Icons.notifications_active,
                color: iconColor,
                size: 30,
              ),
              const SizedBox(width: 12),
              // المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isRead ? Colors.grey.shade600 : theme.textTheme.bodyLarge?.color,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // ✨ تم التعديل هنا: تم حذف السطر الذي يعرض التاريخ
                    if (relatedEntity != null && relatedEntity!.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.link, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            relatedEntity!,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // زر الحذف
              IconButton(
                icon: Icon(Icons.delete_outline, color: theme.colorScheme.error.withOpacity(0.8)),
                onPressed: onDelete,
                tooltip: 'حذف الإشعار',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
