// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rafiqi_university/model/REST/notification_rest.dart';

// import 'package.http/http.dart' as http;
// import 'notification_model.dart'; // استيراد النموذج الذي أنشأناه

class ApiService {
  final String _baseUrl = "https://oracleapex.com/ords/oracledb0/";

  Future<List<NotificationModel>> fetchNotifications( ) async {
    // الرابط الكامل لنقطة النهاية
    final response = await http.get(Uri.parse('${_baseUrl}sem_notifications/' ));

    if (response.statusCode == 200) {
      // إذا كان الطلب ناجحًا
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> items = jsonResponse['items'];

      // تحويل كل عنصر في القائمة إلى كائن NotificationModel
      return items.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      // إذا فشل الطلب، قم برمي استثناء
      throw Exception('Failed to load notifications from API');
    }
  }
}
