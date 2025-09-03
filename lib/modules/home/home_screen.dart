import 'package:flutter/material.dart';
import 'package:rafiqi_university/main.dart';
class HomeScreen extends StatelessWidget {
  // const HomeScreen({super.key});
final VoidCallback toggleTheme;
// const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);
const HomeScreen({Key? key , required this.toggleTheme}) :super(key: key);
// MyApp({Key? key,required this. initialDarkMode}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){},
           icon: Icon(Icons.menu)),
           title: Text('رفيقي الجامعي'),
           centerTitle: true,
           actions: [
            IconButton(
              onPressed:(){} 
            , icon: Icon(Icons.search)),
            IconButton(
              onPressed:toggleTheme
            , icon: Icon(Icons.brightness_6_outlined)),
            
           ],
      ),

    );
  }
}