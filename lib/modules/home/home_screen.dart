// modules/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 1. استيراد GetX
//import 'package:rafiqi_university/controllers/login_controller.dart';
import 'package:rafiqi_university/modules/login/login_controller.dart'; // 2. استيراد الـ Controller

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    // 3. الوصول إلى نفس نسخة الـ Controller
    final LoginController loginController = Get.find<LoginController>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'الصفحة الرئيسية',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          
          // 4. استخدام Obx لمراقبة وعرض قيمة العداد
          Obx(() {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                child: Text(
                  'إجمالي مرات تسجيل الدخول: ${loginController.loginCount.value}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
