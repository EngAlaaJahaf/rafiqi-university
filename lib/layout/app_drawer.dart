// lib/widgets/app_drawer.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // ✨ 1. استيراد Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/modules/admin/admin_dashboard_screen.dart';
import 'package:rafiqi_university/modules/admin/view_subjects_screen.dart';
import 'package:rafiqi_university/modules/dashboard/webview_screen.dart';
import 'package:rafiqi_university/modules/room_classes/assignments_screen.dart';
import 'package:rafiqi_university/modules/room_classes/view_lectures_page.dart';
import 'package:rafiqi_university/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final int bottomNavIndex;
  final Function(int) onMainNavigate;
  final Function(Widget, String) onSecondaryNavigate;
  final VoidCallback toggleTheme;

  const AppDrawer({
    super.key,
    required this.bottomNavIndex,
    required this.onMainNavigate,
    required this.onSecondaryNavigate,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User? currentUser = authService.currentUser;

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ✨ --- 2. استخدام StreamBuilder لجلب بيانات المستخدم من Firestore --- ✨
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: authService.userDocumentStream,
                  builder: (context, snapshot) {
                    // الحالة 1: جاري التحميل
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return UserAccountsDrawerHeader(
                        accountName: const Text('جاري التحميل...'),
                        accountEmail: const Text(''),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                      );
                    }
                    // الحالة 2: حدث خطأ أو لا توجد بيانات
                    if (!snapshot.hasData || snapshot.hasError) {
                      return UserAccountsDrawerHeader(
                        accountName: const Text('مستخدم جديد'),
                        accountEmail: Text(currentUser?.email ?? 'لا يوجد بريد إلكتروني'),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                      );
                    }

                    // الحالة 3: تم جلب البيانات بنجاح
                    final userData = snapshot.data!.data();
                    final fullName = userData?['full_name'] ?? 'لا يوجد اسم';
                    final email = userData?['email'] ?? 'لا يوجد بريد';

                    return UserAccountsDrawerHeader(
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          email.isNotEmpty ? email.substring(0, 1).toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      accountName: Text(
                        fullName, // ✨ عرض الاسم من Firestore
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 13, 121, 121),
                        ),
                      ),
                      accountEmail: Text(
                        email, // ✨ عرض الإيميل من Firestore
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 13, 121, 121),
                        ),
                      ),
                      otherAccountsPictures: [
                        IconButton(
                          onPressed: toggleTheme,
                          icon: const CircleAvatar(child: Icon(Icons.brightness_6_outlined)),
                        ),
                      ],
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    );
                  },
                ),
                // ✨ -------------------------------------------------------------------- ✨

                // --- عناصر التنقل الرئيسي ---
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('الصفحة الرئيسية'),
                  selected: bottomNavIndex == 0,
                  selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  onTap: () {
                    Navigator.pop(context);
                    onMainNavigate(0);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('الإشعارات'),
                  selected: bottomNavIndex == 1,
                  selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  onTap: () {
                    Navigator.pop(context);
                    onMainNavigate(1);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outlined),
                  title: const Text('الملف الشخصي'),
                  selected: bottomNavIndex == 2,
                  selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  onTap: () {
                    Navigator.pop(context);
                    onMainNavigate(2);
                  },
                ),
                const Divider(),

                // --- عناصر التنقل الثانوي ---
                ListTile(
                  leading: const Icon(Icons.book_rounded),
                  title: const Text('إدارة المواد الدراسية'),
                  onTap: () {
                    Navigator.pop(context);
                    onSecondaryNavigate(
                      ViewSubjectsScreen(toggleTheme: toggleTheme),
                      'المواد الدراسية',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_outlined),
                  title: const Text('النسخة السحابية'),
                  onTap: () {
                    Navigator.pop(context);
                    onSecondaryNavigate(
                      WebViewScreen(
                        url: 'https://oracleapex.com/ords/r/oracledb0/mycollegebuddy/home?session=114555407062418',
                        title: 'النسخة السحابية',
                       ),
                      'النسخة السحابية',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('جدول المحاضرات'),
                  onTap: () {
                    Navigator.pop(context);
                    onSecondaryNavigate(
                      ViewLecturesPage(toggleTheme: toggleTheme),
                      'جدول المحاضرات',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text(' التكاليف'),
                  onTap: () {
                    Navigator.pop(context);
                    onSecondaryNavigate(
                      AssignmentsScreen(toggleTheme: toggleTheme),
                      'التكاليف ',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: const Text('لوحة تحكم المسؤول'),
                  onTap: () {
                    Navigator.pop(context);
                    onSecondaryNavigate(
                      AdminDashboardScreen(
                        onSecondaryNavigate: onSecondaryNavigate,
                        toggleTheme: toggleTheme,
                      ),
                      'لوحة التحكم',
                    );
                  },
                ),
              ],
            ),
          ),
          // --- قسم الإعدادات وتسجيل الخروج في الأسفل ---
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('الإعدادات'),
            selected: bottomNavIndex == 3,
            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              onMainNavigate(3);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            title: Text(
              'تسجيل الخروج',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () async {
              Navigator.pop(context); // إغلاق القائمة أولاً
              await authService.signOut(); // ثم تسجيل الخروج
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
