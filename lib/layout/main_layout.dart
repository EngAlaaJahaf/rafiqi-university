// lib/widgets/main_layout.dart

import 'package:flutter/material.dart';

// 1. استورد فقط الـ Widgets التي تحتاجها (القوائم والشاشات)
import 'package:rafiqi_university/layout/app_drawer.dart';
import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';

// استورد الشاشات التي سيتم عرضها
import 'package:rafiqi_university/modules/home/home_screen.dart';
import 'package:rafiqi_university/modules/dashboard/notifications_screen.dart';
import 'package:rafiqi_university/modules/dashboard/profile_screen.dart';
import 'package:rafiqi_university/modules/dashboard/settings_screen.dart';
import 'package:rafiqi_university/modules/admin/view_subjects_screen.dart';

// 2. تم تصحيح اسم الكلاس
class MainLayoutWidget extends StatefulWidget {
  final VoidCallback toggleTheme;

  // 3. تم تصحيح المُنشئ (constructor)
  const MainLayoutWidget({super.key, required this.toggleTheme});

  @override
  State<MainLayoutWidget> createState() => _MainLayoutWidgetState();
}

class _MainLayoutWidgetState extends State<MainLayoutWidget> {
  int _currentIndex = 0;
  late final List<Widget> _screens;
late final List<String> _titles;
  @override
  void initState() {
    super.initState();
    
    // 4. تم تصحيح قائمة الشاشات
    // الصفحات الداخلية لا تحتاج إلى context أو currentIndex
    _screens = [
      HomeScreen(toggleTheme: widget.toggleTheme),
      NotificationsScreen(toggleTheme: widget.toggleTheme),
      ViewSubjectsScreen(toggleTheme: widget.toggleTheme),
      SettingsScreen(toggleTheme: widget.toggleTheme),
      
    ];
    _titles = [
     'الرئيسية',
     'الإشعارات',
     'المواد الدراسية',
     'الإعدادات',
    ];
  }

  // 5. تم إرجاع الدالة المسؤولة عن تحديث الحالة
  void _onItemTapped(int index) {
    // لا تقم بإعادة بناء الواجهة إذا كانت الصفحة هي نفسها
    if (_currentIndex == index) return;
    
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text(_titles[_currentIndex]) ,
        centerTitle: true,
      ),
      
      endDrawer: AppDrawer(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped, toggleTheme: widget.toggleTheme,
      ),
      
      body: _screens[_currentIndex], 
      
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // يمكنك إضافة وظيفة هنا
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // 6. تم تصحيح طريقة استدعاء شريط التنقل السفلي
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
