// main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 1. استيراد GetX
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
    // 2. استخدم GetMaterialApp للسماح لـ GetX بالعمل
    return GetMaterialApp(    //تفعيل GetX: استبدال MaterialApp بـ GetMaterialApp للسماح لـ GetX بإدارة الإشعارات (Snackbars) والتنقل.
      debugShowCheckedModeBanner: false,
      title: 'رفيقي الجامعي',
      theme: ThemeData.light().copyWith(
        primaryColor: const Color.fromARGB(255, 33, 152, 243),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 3, 140, 244),
          iconTheme: IconThemeData(
            color: const Color.fromARGB(255, 240, 231, 231),
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 141, 235, 237)),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LoginScreen(toggleTheme: toggleTheme),
    );
  }
}
