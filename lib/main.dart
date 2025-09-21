// main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/modules/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // 1. قم بإنشاء نظام الألوان للوضع الفاتح
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 3, 140, 244),
      brightness: Brightness.light,
    );

    // 2. قم بإنشاء نظام الألوان للوضع المظلم
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 3, 140, 244),
      brightness: Brightness.dark,
    );

    return ChangeNotifierProvider(
      create: (context) => FabViewModel(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'رفيقي الجامعي',

        // --- الحل النهائي للـ Theme الفاتح ---
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme, // استخدم نظام الألوان مباشرة
          appBarTheme: AppBarTheme(
            // لا تحدد backgroundColor هنا، سيأخذها من colorScheme تلقائيًا
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // --- الحل النهائي للـ Theme المظلم ---
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme, // استخدم نظام الألوان مباشرة
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
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
