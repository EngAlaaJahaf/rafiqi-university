// main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/modules/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✨ 1. تعريف الألوان الأساسية في مكان واحد لسهولة التعديل
const Color primaryColor = Color(0xFF038CF4); // الأزرق الأساسي الذي اخترته
const Color secondaryColor = Color(0xFF37BFE5); // لون ثانوي متناغم (أزرق سماوي)
const Color onPrimaryColor = Colors.white; // لون النصوص والأيقونات فوق اللون الأساسي

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
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

  void toggleTheme() async {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    // ✨ 2. إنشاء نظام ألوان دقيق للوضع الفاتح
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      // يمكنك تحديد ألوان أخرى هنا مثل error, surface, background
    );

    // ✨ 3. إنشاء نظام ألوان دقيق للوضع المظلم
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor, // غالبًا ما يكون اللون الأساسي ثابتًا
      secondary: secondaryColor,
      // في الوضع المظلم، قد ترغب في خلفيات أغمق
      // background: const Color(0xFF121212),
    );

    return ChangeNotifierProvider(
      create: (context) => FabViewModel(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'رفيقي الجامعي',

        // --- Theme الوضع الفاتح المُحسّن ---
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          appBarTheme: AppBarTheme(
            // سيأخذ لونه من colorScheme.primary تلقائيًا
            backgroundColor: lightColorScheme.primary,
            // الأيقونات والنصوص ستأخذ لونها من colorScheme.onPrimary
            foregroundColor: lightColorScheme.onPrimary,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontSize: 22.0, // تعديل بسيط للحجم
              fontWeight: FontWeight.bold,
            ),
          ),
          // يمكنك تخصيص مكونات أخرى هنا
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: lightColorScheme.secondary,
          ),
        ),

        // --- Theme الوضع المظلم المُحسّن ---
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          appBarTheme: AppBarTheme(
            backgroundColor: darkColorScheme.surface, // في الوضع المظلم، يفضل استخدام surface للـ AppBar
            foregroundColor: darkColorScheme.onSurface,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: LoginScreen(toggleTheme: toggleTheme),
      ),
    );
  }
}
