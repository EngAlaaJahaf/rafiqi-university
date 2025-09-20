import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; // 1. استيراد Provider
import 'package:rafiqi_university/layout/fab_view_model.dart'; // 2. استيراد الـ ViewModel
import 'package:rafiqi_university/modules/login/login_controller.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 3. أخبر الـ ViewModel أنه لا يوجد زر عائم لهذه الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
    });
  }

  @override
  Widget build(BuildContext context) {
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
