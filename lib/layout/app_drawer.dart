import 'package:flutter/material.dart';
import 'package:rafiqi_university/modules/admin/add_lecture_type_page.dart';
import 'package:rafiqi_university/modules/admin/view_subjects_screen.dart';

class AppDrawer extends StatelessWidget {
  final int bottomNavIndex;
  final Function(int) onMainNavigate;
  final Function(Widget, String) onSecondaryNavigate;
  final VoidCallback toggleTheme;

  // 1. تم تبسيط المُنشئ
  const AppDrawer({
    super.key,
    required this.bottomNavIndex,
    required this.onMainNavigate,
    required this.onSecondaryNavigate,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/200' ),
            ),
            accountName: const Text(
              'اسم المستخدم',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 13, 121, 121)),
            ),
            accountEmail: const Text(
              'user.email@example.com',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 13, 121, 121)),
            ),
            otherAccountsPictures: [
              IconButton(
                  onPressed: toggleTheme,
                  icon: const CircleAvatar(child: Icon(Icons.brightness_6_outlined))),
            ],
            decoration: const BoxDecoration(),
          ),
          
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
            leading: const Icon(Icons.category_rounded),
            title: const Text('إدارة أنواع المحاضرات'),
            onTap: () {
              Navigator.pop(context);
              onSecondaryNavigate(
                AddLectureTypePage(toggleTheme: toggleTheme),
                'أنواع المحاضرات',
              );
            },
          ),
          
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
        ],
      ),
    );
  }
}
