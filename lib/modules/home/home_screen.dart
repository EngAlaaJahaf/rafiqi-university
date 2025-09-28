// lib/screens/home_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/services/auth_service.dart';

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
    // إخفاء الزر العائم عند الدخول لهذه الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. الوصول لخدمة المصادقة
    final authService = Provider.of<AuthService>(context, listen: false);

    // 2. الحصول على المستخدم الحالي مباشرة.
    // بما أننا لا نصل لهذه الشاشة إلا والمستخدم مسجل دخوله،
    // فمن الآمن افتراض أن authService.currentUser ليس null.
    final User? currentUser = authService.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'الصفحة الرئيسية',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // 3. عرض بيانات المستخدم مباشرة بدون أي تعقيد
          // إذا كان currentUser لسبب ما null، نعرض رسالة خطأ بسيطة.
          // if (currentUser != null)
          //   Card(
          //     elevation: 4,
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
          //       child: Text(
          //         'مرحباً بك،\n${currentUser.email}',
          //         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   )
          // else
          //   // هذا الجزء لن يظهر في الحالة الطبيعية، لكنه موجود كاحتياط
          //   const Text('خطأ: لم يتم العثور على بيانات المستخدم.'),

          // const SizedBox(height: 20),

          // ElevatedButton.icon(
          //   icon: const Icon(Icons.logout),
          //   label: const Text('تسجيل الخروج'),
          //   onPressed: () async {
          //     await authService.signOut();
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Theme.of(context).colorScheme.error,
          //     foregroundColor: Theme.of(context).colorScheme.onError,
          //   ),
          // )
        ],
      ),
    );
  }
}
