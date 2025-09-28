import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/REST/notification_rest.dart';
import 'package:rafiqi_university/services/api_service.dart';
import 'package:rafiqi_university/shared/components/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const NotificationsPage({super.key, required this.toggleTheme});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationRest>> _futureNotifications;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _futureNotifications = _apiService.getNotifications();
    });
  }

  Future<void> _deleteNotification(int notifId) async {
    try {
      await _apiService.deleteNotification(notifId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف الإشعار بنجاح'), backgroundColor: Colors.green),
      );
      _loadNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في حذف الإشعار: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _toggleReadStatus(NotificationRest notification) {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير حالة الإشعار (واجهة فقط)')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadNotifications(),
        child: FutureBuilder<List<NotificationRest>>(
          future: _futureNotifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('خطأ في جلب البيانات: ${snapshot.error}'),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('لا توجد إشعارات لعرضها.'));
            }

            final notifications = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                // ✨ تم التعديل هنا: لم نعد نمرر التاريخ إلى البطاقة
                return NotificationCard(
                  message: notification.notifMessage,
                  relatedEntity: notification.notifRelatedEntity,
                  // date: notification.notifDate, // <-- تم حذف هذا السطر
                  isRead: notification.isRead,
                  onDelete: () => _deleteNotification(notification.notifId),
                  onToggleRead: () => _toggleReadStatus(notification),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
