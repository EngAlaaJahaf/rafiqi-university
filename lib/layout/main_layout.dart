import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/app_drawer.dart';
import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/modules/admin/admin_dashboard_screen.dart';
// import 'package:rafiqi_university/modules/admin/view_import '
import 'package:rafiqi_university/modules/admin/view_subjects_screen.dart';

import 'package:rafiqi_university/modules/dashboard/notifications_screen.dart';
import 'package:rafiqi_university/modules/dashboard/profile_screen.dart';
import 'package:rafiqi_university/modules/dashboard/settings_screen.dart';
import 'package:rafiqi_university/modules/home/home_screen.dart';

// ✨ 1. إنشاء كلاس بسيط لحفظ حالة كل شاشة (المحتوى والعنوان)
class ScreenState {
  final Widget screen;
  final String title;
  ScreenState({required this.screen, required this.title});
}

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
      AdminDashboardScreen(toggleTheme: widget.toggleTheme, onSecondaryNavigate: (Widget , String ) {  },),
      ProfileScreen(toggleTheme: widget.toggleTheme),
      SettingsScreen(toggleTheme: widget.toggleTheme),
    ];
    _mainTitles = ['الرئيسية', 'الإشعارات', 'الملف الشخصي', 'الإعدادات'];
    _currentScreen = _mainScreens[0];
  }

  // دالة للانتقال إلى الشاشات الرئيسية (تمسح المكدس)
  void _navigateToMainScreen(int index) {
    if (_bottomNavIndex == index) return;
    setState(() {
      _bottomNavIndex = index;
      _currentScreen = _mainScreens[index];
      _currentTitle = _mainTitles[index];
    });
  }

  // دالة للانتقال إلى الشاشات الثانوية (تضيف إلى المكدس)
  void _navigateToSecondaryScreen(Widget screen, String title) {
    setState(() {
      _bottomNavIndex = -1;
      _currentScreen = screen;
      _currentTitle = title;
    });
  }

  // ✨ 1. (الحل) هذه هي الدالة التي سيتم استدعاؤها عند الضغط على زر الرجوع
  Future<bool> _onWillPop() async {
    // إظهار نافذة التأكيد
    final bool? shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في الخروج من التطبيق؟'),
        actions: <Widget>[
          TextButton(
            // عند الضغط على "لا"، أغلق النافذة وأرجع false (لا تخرج)
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('لا'),
          ),
          TextButton(
            // عند الضغط على "نعم"، أغلق النافذة وأرجع true (اخرج)
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('نعم'),
          ),
        ],
      ),
    );

    // إذا أغلق المستخدم النافذة بالضغط خارجها، ستكون النتيجة null
    // لذلك، نرجع false لضمان عدم الخروج
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabViewModel = Provider.of<FabViewModel>(context);

    // ✨ 2. (الحل) لف الـ Scaffold داخل WillPopScope
    return WillPopScope(
      // ربط الدالة بحدث onWillPop
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentTitle),
          centerTitle: true,
          // لا نحتاج لـ endDrawer هنا لأن AppBar يعرض أيقونة القائمة تلقائيًا
        ),
        endDrawer: AppDrawer(
          bottomNavIndex: _bottomNavIndex,
          onMainNavigate: _navigateToMainScreen,
          onSecondaryNavigate: _navigateToSecondaryScreen,
          toggleTheme: widget.toggleTheme,
        ),
        body: _currentScreen,
        floatingActionButton: fabViewModel.fabAction != null
            ? FloatingActionButton(
                onPressed: () => fabViewModel.fabAction!(),
                shape: const CircleBorder(),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                child: const Icon(Icons.add),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _bottomNavIndex,
          onItemTapped: _navigateToMainScreen,
        ),
      ),
    );
  }
}
