import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/app_drawer.dart';
import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/modules/admin/admin_dashboard_screen.dart';
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
  // ✨ 2. هذا هو المكدس الذي سيحفظ تاريخ التنقل
  late List<ScreenState> _navigationStack;

  int _bottomNavIndex = 0;

  late final List<ScreenState> _mainScreens;

  @override
  void initState() {
    super.initState();
    _mainScreens = [
      ScreenState(screen: HomeScreen(toggleTheme: widget.toggleTheme), title: 'الرئيسية'),
      ScreenState(screen: NotificationsScreen(toggleTheme: widget.toggleTheme), title: 'الإشعارات'),
      ScreenState(screen: ProfileScreen(toggleTheme: widget.toggleTheme), title: 'الملف الشخصي'),
      ScreenState(screen: SettingsScreen(toggleTheme: widget.toggleTheme), title: 'الإعدادات'),
    ];
    // ابدأ بالشاشة الرئيسية
    _navigationStack = [_mainScreens[0]];
  }

  // دالة للانتقال إلى الشاشات الرئيسية (تمسح المكدس)
  void _navigateToMainScreen(int index) {
    if (_bottomNavIndex == index && _navigationStack.length == 1) return;
    setState(() {
      _bottomNavIndex = index;
      // عند الانتقال إلى شاشة رئيسية، امسح المكدس وابدأ من جديد
      _navigationStack = [_mainScreens[index]];
    });
  }

  // دالة للانتقال إلى الشاشات الثانوية (تضيف إلى المكدس)
  void _navigateToSecondaryScreen(Widget screen, String title) {
    setState(() {
      _bottomNavIndex = -1;
      // أضف الشاشة الجديدة إلى قمة المكدس
      _navigationStack.add(ScreenState(screen: screen, title: title));
    });
  }

  // ✨ 3. دالة الرجوع (تزيل من المكدس)
  void _goBack() {
    if (_navigationStack.length > 1) {
      setState(() {
        // قم بإزالة الشاشة الحالية من المكدس
        _navigationStack.removeLast();
        // (اختياري) تحقق مما إذا كانت الشاشة الجديدة هي شاشة رئيسية وقم بتحديث _bottomNavIndex
        final lastScreenTitle = _navigationStack.last.title;
        _bottomNavIndex = _mainScreens.indexWhere((s) => s.title == lastScreenTitle);
      });
    }
  }

  // دالة تأكيد الخروج من التطبيق
  Future<bool> _onWillPop() async {
    // ✨ 4. (الحل) إذا كان هناك شيء في المكدس، قم بالرجوع بدلاً من الخروج
    if (_navigationStack.length > 1) {
      _goBack();
      return false; // امنع الخروج من التطبيق
    }

    // إذا كان المكدس فارغًا (أنت في الشاشة الرئيسية)، اطلب تأكيد الخروج
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

    // ✨ 5. احصل على الشاشة الحالية من قمة المكدس
    final currentScreenState = _navigationStack.last;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          // ✨ 6. (الحل) إظهار زر الرجوع إذا كان هناك شيء في المكدس
          leading: _navigationStack.length > 1
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                )
              : null, // لا تظهر الزر في الشاشات الرئيسية
          title: Text(currentScreenState.title),
          centerTitle: true,
          // لا نحتاج لـ endDrawer هنا لأن AppBar يعرض أيقونة القائمة تلقائيًا
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
