import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. استيراد Provider
import 'package:rafiqi_university/layout/app_drawer.dart';
import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart'; // 2. استيراد الـ ViewModel
import 'package:rafiqi_university/modules/admin/view_subjects_screen.dart';
import 'package:rafiqi_university/modules/dashboard/notifications_screen.dart';
import 'package:rafiqi_university/modules/dashboard/profile_screen.dart';
import 'package:rafiqi_university/modules/dashboard/settings_screen.dart';
import 'package:rafiqi_university/modules/home/home_screen.dart';

class MainLayoutWidget extends StatefulWidget {
  final VoidCallback toggleTheme;
  const MainLayoutWidget({super.key, required this.toggleTheme});

  @override
  State<MainLayoutWidget> createState() => _MainLayoutWidgetState();
}

class _MainLayoutWidgetState extends State<MainLayoutWidget> {
  Widget _currentScreen;
  String _currentTitle = 'الرئيسية';
  int _bottomNavIndex = 0;

  late final List<Widget> _mainScreens;
  late final List<String> _mainTitles;

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
    _currentScreen = _mainScreens[0];
  }

  void _navigateToMainScreen(int index) {
    setState(() {
      _bottomNavIndex = index;
      _currentScreen = _mainScreens[index];
      _currentTitle = _mainTitles[index];
    });
  }

  void _navigateToSecondaryScreen(Widget screen, String title) {
    setState(() {
      _bottomNavIndex = -1;
      _currentScreen = screen;
      _currentTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. استخدم Consumer للاستماع للتغييرات في FabViewModel
    return Consumer<FabViewModel>(
      builder: (context, fabViewModel, child) {
        // fabViewModel هو نسختنا من "الصندوق السحري"
        return Scaffold(
          appBar: AppBar(
            title: Text(_currentTitle),
            centerTitle: true,
          ),
          endDrawer: AppDrawer(
            bottomNavIndex: _bottomNavIndex,
            onMainNavigate: _navigateToMainScreen,
            onSecondaryNavigate: _navigateToSecondaryScreen,
            toggleTheme: widget.toggleTheme,
          ),
          body: _currentScreen,
          
          // 4. قم ببناء الزر العائم بناءً على الحالة من الـ ViewModel
          floatingActionButton: fabViewModel.fabAction != null
              ? FloatingActionButton(
                  onPressed: fabViewModel.fabAction, // استخدم الوظيفة من الـ ViewModel
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                )
              : null, // إذا كانت الوظيفة null، قم بإخفاء الزر
              
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _bottomNavIndex,
            onItemTapped: _navigateToMainScreen,
          ),
        );
      },
    );
  }
}
