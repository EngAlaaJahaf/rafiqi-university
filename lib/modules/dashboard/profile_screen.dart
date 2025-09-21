import 'package:flutter/material.dart';
// صفحة الملف الشخصي 
class ProfileScreen extends StatelessWidget {
  final  VoidCallback toggleTheme;

  const ProfileScreen({super.key, required this.toggleTheme });

  @override
  Widget build(BuildContext context, ) {
    return 
       Center(
        child: Text('صفحة الملف الشخصي',
        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
      );
    
    //   floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    //  floatingActionButton :customFloatingActionButton(context),
    //   bottomNavigationBar:custombottomNavigationBar(context),
      
     
    
  }
}