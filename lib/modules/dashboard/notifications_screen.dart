import 'package:flutter/material.dart';
import 'package:rafiqi_university/shared/components/components.dart';
// صفحة الإشعارات 
class NotificationsScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const NotificationsScreen({super.key, required this.toggleTheme });

  @override
  Widget build(BuildContext context,  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('صفحة الإشعارات',
        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
      ),
      floatingActionButton :customFloatingActionButton(context,pageName: '/settingscreen',),
      bottomNavigationBar:custombottomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      endDrawer: customDrawer(context: context, toggleTheme: toggleTheme),
    );
  }
}