import 'dart:convert'; // لتحويل البيانات من وإلى JSON
import 'dart:io';     // للتعامل مع الملفات
import 'package:path_provider/path_provider.dart'; // للحصول على مسار التخزين

class StorageService {

  // دالة للحصول على المسار المحلي للملف
  Future<String> get _localPath async {
    // احصل على مسار مجلد المستندات الخاص بالتطبيق
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // دالة للحصول على مرجع للملف الذي سنخزن فيه البيانات
  Future<File> get _localFile async {
    final path = await _localPath;
    // اسم الملف الذي سنستخدمه
    return File('$path/student_data.json');
  }

  // دالة لكتابة بيانات الطالب في الملف
  Future<File> writeStudentData(Map<String, dynamic> studentData) async {
    final file = await _localFile;

    // تحويل الخريطة إلى نص بصيغة JSON
    String jsonString = jsonEncode(studentData);

    // كتابة النص في الملف
    return file.writeAsString(jsonString);
  }

  // دالة لقراءة بيانات الطالب من الملف
  Future<Map<String, dynamic>?> readStudentData() async {
    try {
      final file = await _localFile;

      // تحقق مما إذا كان الملف موجودًا
      if (!await file.exists()) {
        return null;
      }
      void checkFileLocation() async {
  final file = await _localFile;
  print('الملف محفوظ في: ${file.path}');
  // output: /data/data/com.example.rafiqi_university/app_flutter/student_data.json
}
      // قراءة محتوى الملف كنص
      final contents = await file.readAsString();

      // تحويل النص من JSON إلى خريطة (Map)
      Map<String, dynamic> data = jsonDecode(contents);

      // إرجاع البيانات
      return data;

    } catch (e) {
      // في حال حدوث أي خطأ، أرجع رسالة خطأ
      print("حدث خطأ أثناء قراءة الملف: $e");
      return null;
    }
  }
}
