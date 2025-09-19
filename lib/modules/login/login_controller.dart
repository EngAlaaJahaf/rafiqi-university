// controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // .obs تجعل المتغير "مُراقبًا" ويعاد بناء الواجهة عند تغيره
  var loginCount = 0.obs;

  // هذه الدالة يتم استدعاؤها تلقائيًا عند إنشاء الـ Controller لأول مرة
  @override
  void onInit() {
    super.onInit();
    _loadLoginCount(); // تحميل العدد المحفوظ عند بدء تشغيل التطبيق
  }

  // دالة خاصة لتحميل العدد من ذاكرة الهاتف
  Future<void> _loadLoginCount() async {
    final prefs = await SharedPreferences.getInstance();
    // اقرأ القيمة، وإذا لم تكن موجودة، استخدم القيمة الافتراضية 0
    loginCount.value = prefs.getInt('loginCount') ?? 0;
  }

  // دالة عامة لزيادة العداد وحفظه (سنستدعيها من شاشة تسجيل الدخول)
  Future<void> incrementLoginCount() async {
    loginCount.value++; // زد العداد
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loginCount', loginCount.value); // احفظ القيمة الجديدة

    // إظهار إشعار للمستخدم باستخدام GetX!
    Get.snackbar(
      'تسجيل دخول ناجح!', // العنوان
      'هذه هي المرة رقم ${loginCount.value} التي تسجل فيها الدخول.', // الرسالة
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
}
