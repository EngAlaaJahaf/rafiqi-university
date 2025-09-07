import 'package:flutter/material.dart';
import 'package:rafiqi_university/layout/custom_bottom_nav_bar.dart';
import  'package:rafiqi_university/modules/dashboard/settings_screen.dart';
import 'package:rafiqi_university/shared/components/components.dart';
// import 'package:rafiqi_university/main.dart';
import 'package:rafiqi_university/layout/mainlayoutwidget.dart';
class HomeScreen extends StatelessWidget {
  // const HomeScreen({super.key});
final VoidCallback toggleTheme;
final int _currentIndex = 0;

  // final _onItemTapped;
// const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

const HomeScreen({super.key , required this.toggleTheme, });
// MyApp({Key? key,required this. initialDarkMode}) :super(key: key);
  @override
  Widget build(BuildContext context,
  
    ) {
    return Center(
      // backgroundColor: Colors.blue,
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: (){
      //       Navigator.pushNamed(context, '/notificationsscreen');
      //     },
      //      icon: CircleAvatar(
      //       child:Icon(Icons.notification_important_outlined)),),
      //      title: Text('رفيقي الجامعي'),
      //      centerTitle: true,
      //      actions: [
            // IconButton(
            //   onPressed:(){
            //      Navigator.pushNamed(context, '/settingscreen');
            //   } 
            // , icon: Icon(Icons.settings)),
            // IconButton(
            //   onPressed:toggleTheme
            // , icon: Icon(Icons.brightness_6_outlined)),
        //     Builder(
        // builder: (context) => IconButton(
        //   icon: Icon(Icons.menu), // أيقونة القائمة
        //   onPressed: () => Scaffold.of(context).openEndDrawer(), // الأمر الذي يفتح القائمة اليمنى
        // ),
      // ),

          //  ],
         
      // ),
      //    endDrawer: customDrawer(toggleTheme: toggleTheme,
      //   context: context
      // ),
     
      //  bottomNavigationBar: CustomBottomNavBar(
      //   currentIndex: _currentIndex, onItemTapped: (int ) {  } ,
      //   // onItemTapped: _onItemTapped,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      
     
     child:  Column(
        children: [
        //  getCurrentScreen(toggleTheme:toggleTheme, context: context), 
         Text('الصفحة الرئيسية',
        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
     ],
      ),
    );
  }
}