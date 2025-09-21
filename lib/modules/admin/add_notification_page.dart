// notifications_page.dart

import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/REST/notification_rest.dart';
import 'package:rafiqi_university/services/api_service.dart';
// استيراد النموذج

class NotificationsPage extends StatefulWidget {
   final VoidCallback toggleTheme;
  const NotificationsPage({super.key, required this.toggleTheme});
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationModel>> futureNotifications;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // بدء عملية جلب البيانات عند تحميل الصفحة
    futureNotifications = apiService.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('الإشعارات'),
      // ),
      body: FutureBuilder<List<NotificationModel>>(
        future: futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // عرض مؤشر تحميل أثناء جلب البيانات
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // عرض رسالة خطأ في حال فشل الطلب
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // عرض البيانات في ListView عند نجاح الطلب
            List<NotificationModel> notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: Icon(
                    notification.isRead ? Icons.notifications_off : Icons.notifications_active,
                    color: notification.isRead ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                  title: Text(notification.notifMessage),
                  subtitle: Text(
                    '${notification.notifRelatedEntity} - ${notification.notifDate.toLocal().toString().substring(0, 10)}'
                  ),
                  trailing: Text('المستخدم: ${notification.userId}'),
                );
              },
            );
          } else {
            // عرض رسالة في حال عدم وجود بيانات
            return Center(child: Text('لا توجد إشعارات'));
          }
        },
      ),
    );
  }
}
