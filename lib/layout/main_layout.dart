// main_layout_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/app_drawer.dart';
import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/modules/admin/admin_dashboard_screen.dart';
import 'package:rafiqi_university/modules/dashboard/profile_screen.dart';
import 'package:rafiqi_university/modules/dashboard/settings_screen.dart';
import 'package:rafiqi_university/modules/home/home_screen.dart';

// ملاحظة: لقد أزلت استيراد الإشعارات بناءً على طلبك
// import 'package:rafiqi_university/modules/dashboard/notifications_screen.dart';

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
  late List<ScreenState> _navigationStack;
  int _bottomNavIndex = 0;
  late final List<ScreenState> _mainScreens;

  @override
  void initState() {
    super.initState();
    _mainScreens = [
      ScreenState(screen: HomeScreen(toggleTheme: widget.toggleTheme), title: 'الرئيسية'),
      ScreenState(screen: ProfileScreen(toggleTheme: widget.toggleTheme), title: 'الملف الشخصي'),
      ScreenState(screen: AdminDashboardScreen(toggleTheme: widget.toggleTheme, onSecondaryNavigate: (Widget , String ) {  },), title: 'الملف الشخصي'),
      ScreenState(screen: SettingsScreen(toggleTheme: widget.toggleTheme), title: 'الإعدادات'),
    ];
    _navigationStack = [_mainScreens[0]];
  }

  // ✨ --- دالة التنظيف المركزية --- ✨
  void _clearFabBeforeNavigation() {
    // استخدام listen: false هنا آمن لأننا لا نريد إعادة بناء الواجهة
    Provider.of<FabViewModel>(context, listen: false).clearFabAction();
  }

  void _navigateToMainScreen(int index) {
    if (_bottomNavIndex == index && _navigationStack.length == 1) return;
    
    _clearFabBeforeNavigation(); // ✨ نظّف الزر قبل الانتقال

    setState(() {
      _bottomNavIndex = index;
      _navigationStack = [_mainScreens[index]];
    });
  }

  void _navigateToSecondaryScreen(Widget screen, String title) {
    _clearFabBeforeNavigation(); // ✨ نظّف الزر قبل الانتقال

    setState(() {
      _bottomNavIndex = -1;
      _navigationStack.add(ScreenState(screen: screen, title: title));
    });
  }

  void _goBack() {
    if (_navigationStack.length > 1) {
      _clearFabBeforeNavigation(); // ✨ نظّف الزر قبل الرجوع

      setState(() {
        _navigationStack.removeLast();
        final lastScreenTitle = _navigationStack.last.title;
        _bottomNavIndex = _mainScreens.indexWhere((s) => s.title == lastScreenTitle);
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      _goBack();
      return false;
    }
    final bool? shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في الخروج من التطبيق؟'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('لا')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('نعم')),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabViewModel = Provider.of<FabViewModel>(context);
    final currentScreenState = _navigationStack.last;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: _navigationStack.length > 1
              ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBack)
              : null,
          title: Text(currentScreenState.title),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
        ),
        endDrawer: AppDrawer(
          bottomNavIndex: _bottomNavIndex,
          onMainNavigate: _navigateToMainScreen,
          onSecondaryNavigate: _navigateToSecondaryScreen,
          toggleTheme: widget.toggleTheme,
        ),
        body: currentScreenState.screen,
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
