// lib/main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/firebase_options.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/layout/main_layout.dart';
import 'package:rafiqi_university/modules/login/login_screen.dart';
import 'package:rafiqi_university/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// تعريف الألوان الأساسية في مكان واحد لسهولة التعديل
const Color primaryColor = Color(0xFF038CF4);
const Color secondaryColor = Color(0xFF37BFE5);
const Color onPrimaryColor = Colors.white;

void main() async {
  // التأكد من تهيئة Flutter قبل أي عمليات أخرى
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase قبل تشغيل التطبيق
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // جلب إعدادات الوضع المظلم من التخزين المحلي
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  // تشغيل التطبيق
  runApp(MyApp(initialDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;
  const MyApp({super.key, required this.initialDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.initialDarkMode;
  }

  // دالة لتبديل الثيم (الوضع المظلم/الفاتح)
  void toggleTheme() async {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    // إعدادات الثيم الفاتح
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
    );

    // إعدادات الثيم المظلم
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
    );

    // ✨ --- 1. تم نقل MultiProvider ليصبح هو الجذر الأعلى --- ✨
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FabViewModel()),
      ],
      // ✨ --- 2. StreamBuilder يغلف MaterialApp الآن --- ✨
      child: Builder(
        // استخدام Builder هنا مهم لضمان أن context لديه حق الوصول إلى الـ Providers أعلاه
        builder: (context) {
          return StreamBuilder<User?>(
            // ✨ --- هذا هو التعديل الجوهري --- ✨
            // اقرأ الـ stream من نفس النسخة التي يوفرها Provider
            stream: context.read<AuthService>().authStateChanges,
        builder: (context, snapshot) {
          // استخدام MaterialApp مباشرة هنا
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'رفيقي الجامعي',
            
            // تطبيق الثيم الفاتح
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              appBarTheme: AppBarTheme(
                backgroundColor: lightColorScheme.primary,
                foregroundColor: lightColorScheme.onPrimary,
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: lightColorScheme.secondary,
              ),
            ),

            // تطبيق الثيم المظلم
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
              appBarTheme: AppBarTheme(
                backgroundColor: darkColorScheme.surface,
                foregroundColor: darkColorScheme.onSurface,
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // تحديد الثيم الحالي بناءً على متغير isDarkMode
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

            // ✨ --- 3. تحديد الواجهة الرئيسية بناءً على حالة الـ Stream --- ✨
            home: _buildHomeScreen(snapshot),
          );
        },
      );
  }      ),
  );
  }

  // ✨ --- 4. دالة مساعدة لتحديد الواجهة الصحيحة --- ✨
  Widget _buildHomeScreen(AsyncSnapshot<User?> snapshot) {
    // الحالة 1: جاري التحقق من حالة المستخدم
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // الحالة 2: المستخدم قد سجل دخوله بنجاح
    if (snapshot.hasData) {
      return MainLayoutWidget(toggleTheme: toggleTheme);
    }
    // الحالة 3: المستخدم لم يسجل دخوله
    return LoginScreen(toggleTheme: toggleTheme);
  }
}
