import 'package:flutter/material.dart';
import 'package:rafiqi_university/shared/components/components.dart';
// لوحة التحكم
class DashBoardScreen extends StatelessWidget {
  // final dynamic floatingActionButtonLocation;
  final  VoidCallback toggleTheme;
  const DashBoardScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة التحكم'),
        centerTitle: true,
      ),
      endDrawer: customDrawer(context: context, toggleTheme: toggleTheme),
      body: Center(
        child: Text('صفحة لوحة التحكم',
        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
      ),
      floatingActionButton :customFloatingActionButton(context),
      bottomNavigationBar:custombottomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}