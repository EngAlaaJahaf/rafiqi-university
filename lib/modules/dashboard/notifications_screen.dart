// // notifications_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rafiqi_university/model/REST/notification_rest.dart';
// // import 'package:rafiqi_university/models/notification_model.dart'; // تأكد من أن المسار صحيح
// import 'package:rafiqi_university/modules/dashboard/notifications_provider.dart';
// // import 'package:rafiqi_university/providers/notifications_provider.dart'; // استيراد الـ Provider

// // ✨ ملاحظة: لم نعد بحاجة لاستيراد api_service.dart هنا

// class NotificationsScreen extends StatelessWidget {
//   // ✨ لم نعد بحاجة لـ StatefulWidget لأن Provider سيتولى إدارة الحالة
//   final VoidCallback toggleTheme; // إذا كنت تحتاجه داخل هذه الشاشة

//   const NotificationsScreen({super.key, required this.toggleTheme});

//   @override
//   Widget build(BuildContext context) {
//     // ✨ 1. استخدم Consumer للاستماع إلى التغييرات في NotificationsProvider
//     return Consumer<NotificationsProvider>(
//       builder: (context, provider, child) {
//         // ✨ 2. تحقق مما إذا كان Provider يقوم بالتحميل حاليًا
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         // ✨ 3. احصل على قائمة الإشعارات من الـ Provider
//         final List<NotificationModel> notifications = provider.notifications;

//         // ✨ 4. تحقق مما إذا كانت القائمة فارغة
//         if (notifications.isEmpty) {
//           return const Center(
//             child: Text(
//               'لا توجد إشعارات لعرضها',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           );
//         }

//         // ✨ 5. إذا كانت هناك بيانات، قم بعرضها في ListView
//         return RefreshIndicator(
//           // ✨ إضافة: اسحب لتحديث القائمة
//           onRefresh: () => provider.fetchNotifications(),
//           child: ListView.builder(
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notifications[index];
//               return ListTile(
//                 leading: Icon(
//                   notification.isRead ? Icons.notifications_off_outlined : Icons.notifications_active,
//                   color: notification.isRead ? Colors.grey : Theme.of(context).colorScheme.primary,
//                 ),
//                 title: Text(notification.notifMessage),
//                 subtitle: Text(
//                   '${notification.notifRelatedEntity} - ${notification.notifDate.toLocal().toString().substring(0, 10)}',
//                 ),
//                 // يمكنك إضافة تفاعل هنا لاحقًا
//                 onTap: () {
//                   // TODO: تنفيذ ميزة "وضع علامة كمقروء" والانتقال إلى التفاصيل
//                   print('تم الضغط على الإشعار رقم: ${notification.notifId}');
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
