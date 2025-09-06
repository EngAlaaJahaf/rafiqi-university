import 'package:flutter/material.dart';
import 'package:rafiqi_university/modules/dashboard/dashboard_screen.dart';
import 'package:rafiqi_university/modules/dashboard/notifications_screen.dart';
import 'package:rafiqi_university/modules/dashboard/profile_screen.dart';
import 'package:rafiqi_university/modules/dashboard/settings_screen.dart';
import 'package:rafiqi_university/modules/home/home_screen.dart';
import 'package:rafiqi_university/modules/login/login_screen.dart';
import 'package:rafiqi_university/modules/room_classes/lectures_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(MyApp(initialDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  //  MyApp({super.key});
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
    return MaterialApp(
      routes: {
        '/': (context) => LoginScreen(),
        '/homescreen': (context) => HomeScreen(toggleTheme: toggleTheme , context: context),
        '/dashboardscreen': (context) => DashBoardScreen(toggleTheme: toggleTheme),
        '/lecturesscreen': (context) => LecturesScreen(),
        '/notificationsscreen': (context) => NotificationsScreen(toggleTheme: toggleTheme),
        '/profilescreen': (context) => ProfileScreen(toggleTheme: toggleTheme),
        '/settingscreen': (context) => SettingsScreen(toggleTheme: toggleTheme),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'رفيقي الجامعي',

      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue,
          iconTheme: IconThemeData(
            color: const Color.fromARGB(255, 1, 0, 0),
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      darkTheme: ThemeData.dark()
      // .copyWith(
        // appBarTheme: AppBarTheme(
        //   backgroundColor: Colors.blue[800], // لون مختلف للوضع الداكن
        //   iconTheme: IconThemeData(color: Colors.white),
        //   titleTextStyle: TextStyle(
        //     color: Colors.white,
        //     fontSize: 24.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: Colors.blueAccent,
        //   brightness: Brightness.dark, // مهم للوضع الداكن
        // ),
      ,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // home:  LoginScreen(),
    );
  }
}
