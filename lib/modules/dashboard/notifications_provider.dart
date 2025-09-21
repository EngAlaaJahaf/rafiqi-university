// // notifications_provider.dart
// import 'package:flutter/material.dart';
// import 'package:rafiqi_university/model/REST/notification_rest.dart';
// import 'package:rafiqi_university/services/api_service.dart'; // افترض أن هذا هو ملف الخدمة
// // import 'package:rafiqi_university/models/notification_model.dart'; // افترض أن هذا هو ملف النموذج

// class NotificationsProvider with ChangeNotifier {
//   final ApiService _apiService = ApiService();
//   List<NotificationModel> _notifications = [];
//   int _unreadCount = 0;
//   bool _isLoading = false;

//   List<NotificationModel> get notifications => _notifications;
//   int get unreadCount => _unreadCount;
//   bool get isLoading => _isLoading;

//   Future<void> fetchNotifications() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       _notifications = await _apiService.fetchNotifications();
//       // حساب عدد الإشعارات غير المقروءة
//       _unreadCount = _notifications.where((n) => !n.isRead).length;
//     } catch (error) {
//       // يمكنك التعامل مع الخطأ هنا
//       _unreadCount = 0;
//     }
//     _isLoading = false;
//     notifyListeners();
//   }
// }
