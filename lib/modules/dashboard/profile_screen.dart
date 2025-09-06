import 'package:flutter/material.dart';
import 'package:rafiqi_university/shared/components/components.dart';
// صفحة الملف الشخصي 
class ProfileScreen extends StatelessWidget {
  final  VoidCallback toggleTheme;

  const ProfileScreen({super.key, required this.toggleTheme });

  @override
  Widget build(BuildContext context, ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي'),
        centerTitle: true,
        
      ),
        endDrawer: customDrawer(toggleTheme: toggleTheme,
        context: context
      ),
      body: Center(
        child: Text('صفحة الملف الشخصي',
        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
      ),
    
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
     floatingActionButton :customFloatingActionButton(context),
      bottomNavigationBar:custombottomNavigationBar(context),
      
     
    );
  }
}