// lib/widgets/main_layout.dart

import 'package:flutter/material.dart';

// 1. استورد فقط الـ Widgets التي تحتاجها (القوائم والشاشات)
import 'package:rafiqi_university/layout/app_drawer.dart';
import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';
import 'package:rafiqi_university/modules/admin/add_lecture_page.dart';

// استورد الشاشات التي سيتم عرضها
import 'package:rafiqi_university/modules/home/home_screen.dart';
import 'package:rafiqi_university/modules/dashboard/notifications_screen.dart';
import 'package:rafiqi_university/modules/dashboard/profile_screen.dart';
import 'package:rafiqi_university/modules/dashboard/settings_screen.dart';
import 'package:rafiqi_university/modules/admin/view_subjects_screen.dart';

// 2. تم تصحيح اسم الكلاس
class MainLayoutWidget extends StatefulWidget {
  final VoidCallback toggleTheme;
  const MainLayoutWidget({super.key, required this.toggleTheme});

  @override
  State<MainLayoutWidget> createState() => _MainLayoutWidgetState();
}

class _MainLayoutWidgetState extends State<MainLayoutWidget> {
  // ✨ هذا هو مصدر الحقيقة الوحيد للشاشة المعروضة
  Widget _currentScreen; 
  String _currentTitle = 'الرئيسية';
  
  // ✨ هذا المتغير يتتبع فقط العنصر النشط في القائمة السفلية
  int _bottomNavIndex = 0; 

  late final List<Widget> _mainScreens;
  late final List<String> _mainTitles;

  // تهيئة أولية
  _MainLayoutWidgetState() : _currentScreen = Container();

  @override
  void initState() {
    super.initState();
    
    _mainScreens = [
      HomeScreen(toggleTheme: widget.toggleTheme),
      NotificationsScreen(toggleTheme: widget.toggleTheme),
      ProfileScreen(toggleTheme: widget.toggleTheme),
      SettingsScreen(toggleTheme: widget.toggleTheme),
    ];
    _mainTitles = ['الرئيسية', 'الإشعارات', 'الملف الشخصي', 'الإعدادات'];

    // ابدأ بالشاشة الرئيسية
    _currentScreen = _mainScreens[0]; 
  }

  // دالة يتم استدعاؤها من القائمة السفلية والجانبية (للعناصر الرئيسية)
  void _navigateToMainScreen(int index) {
    setState(() {
      _bottomNavIndex = index;
      _currentScreen = _mainScreens[index];
      _currentTitle = _mainTitles[index];
    });
  }

  // دالة يتم استدعاؤها من القائمة الجانبية (للعناصر الثانوية)
  void _navigateToSecondaryScreen(Widget screen, String title) {
    setState(() {
      // ✨ أهم سطر: قم بتعيين -1 ليعرف شريط التنقل السفلي أنه لا يوجد عنصر نشط
      _bottomNavIndex = -1; 
      _currentScreen = screen;
      _currentTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
        centerTitle: true,
      ),
      
      endDrawer: AppDrawer(
        // مرر الـ index الخاص بالقائمة السفلية
        bottomNavIndex: _bottomNavIndex, 
        onMainNavigate: _navigateToMainScreen,
        onSecondaryNavigate: _navigateToSecondaryScreen,
        toggleTheme: widget.toggleTheme, currentIndex: _bottomNavIndex, onItemTapped: (_currentScreen ) {  },
      ),
      
      // ✨ دائمًا يعرض الشاشة الحالية
      body: _currentScreen, 
      
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        shape: const CircleBorder(),
        onPressed: () { print('object'); },/* ... */
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      bottomNavigationBar: CustomBottomNavBar(
        // مرر الـ index الخاص بالقائمة السفلية
        currentIndex: _bottomNavIndex, 
        onItemTapped: _navigateToMainScreen,
      ),
    );
  }
}