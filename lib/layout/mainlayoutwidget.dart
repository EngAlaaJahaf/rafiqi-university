import 'package:flutter/material.dart';
import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';
import 'package:rafiqi_university/layout/app_drawer.dart';
// import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';

// ... استورد كل شاشاتك هنا
import 'package:rafiqi_university/modules/home/home_screen.dart';
import 'package:rafiqi_university/modules/dashboard/notifications_screen.dart';
import 'package:rafiqi_university/modules/dashboard/profile_screen.dart';
import 'package:rafiqi_university/modules/dashboard/settings_screen.dart';
import 'package:rafiqi_university/modules/student_control/view_subjects_screen.dart';

class MainLayoutWidget extends StatefulWidget {
  final VoidCallback toggleTheme;
  const MainLayoutWidget( {super.key, required this.toggleTheme, });

  @override
  State<MainLayoutWidget> createState() => _MainLayoutWidgetState();
}

class _MainLayoutWidgetState extends State<MainLayoutWidget> {
  // ✨ 1. هذا هو المصدر الوحيد للحقيقة (Single Source of Truth)
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(toggleTheme: widget.toggleTheme,),
      NotificationsScreen(toggleTheme: widget.toggleTheme),
      ViewSubjectsScreen(toggleTheme: widget.toggleTheme),
      SettingsScreen(toggleTheme: widget.toggleTheme),
    ];
  }

  // ✨ 2. دالة مركزية لتحديث الحالة، سيتم استدعاؤها من كل القوائم
  void _onItemTapped(int index) {
    // التأكد من أننا لا نعيد بناء الواجهة إذا كانت الصفحة هي نفسها
    if (_currentIndex == index) return;
    
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context,
    ) {
    final theme = Theme.of(context);

    return Scaffold(
      // 3. AppBar بسيط يضيف أيقونة القائمة تلقائياً
      appBar: AppBar(
        title: const Text('رفيقي الجامعي'),
        centerTitle: true,
      ),

      // 4. تمرير الدالة إلى القائمة الجانبية
      endDrawer: AppDrawer(
        currentIndex: _currentIndex, // مرر الـ index الحالي
        onItemTapped: _onItemTapped, toggleTheme:widget.toggleTheme,
      ),

      // 5. عرض الشاشة بناءً على الحالة المركزية
      body: _screens[_currentIndex],

      // 6. الزر العائم
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () { /* ... */ },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 7. تمرير الحالة والدالة إلى القائمة السفلية
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
