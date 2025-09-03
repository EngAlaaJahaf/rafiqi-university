import 'package:flutter/material.dart';
import 'package:rafiqi_university/login.dart';

void main() {
  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رفيقي الجامعي',
      theme: ThemeData(
       primaryColor: Colors.blue,
       appBarTheme: AppBarTheme(
        backgroundColor: Colors.lightBlue,
        iconTheme:IconThemeData(color: const Color.fromARGB(255, 235, 230, 230)) ,
        titleTextStyle: TextStyle(
          color:Colors.white ,fontSize: 24.0,fontWeight:FontWeight.bold ),
       ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 42, 241, 255)),
      ),
      home:  Login(),
    );
  }
}
