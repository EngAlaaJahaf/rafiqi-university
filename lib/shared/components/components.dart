import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
Widget DefaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required VoidCallback function,
  required String text, required TextEditingController emailController, required TextEditingController passwordController, required Future<void> Function() onPressed, required Text child,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
    //<=-=-=-=-=-=-=-=--=-=-==-=-=-=>

    Widget DefaultSmallButton({
  double width = 80.0,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required VoidCallback function,
  required String text, 
  //  required Future<void> Function() onPressed,
  required Text child,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
//العناوين الرئيسية
    Widget HeaderText({required String text})=>
     Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    // color: Colors.grey[50],
    border: Border.all(
      color: Colors.blueAccent.withOpacity(0.3),
      width: 1.5,
    ),
    // gradient: LinearGradient(
    //   begin: Alignment.centerRight, // ✅ تدرج من اليمين
    //   end: Alignment.centerLeft,
      // colors: [Colors.blue[50]!, Colors.white],
    // ),
    boxShadow: [
      // BoxShadow(
      //   color: Colors.blueAccent.withOpacity(0.1),
      //   blurRadius: 8,
      //   offset: Offset(0, 2),
      // ),
    ],
  ),
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  alignment: Alignment.centerRight, // ✅ محاذاة المحتوى لليمين
  child: Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      // color: Colors.blue[900],
      fontFamily: 'Cairo', // خط عربي جميل
    ),
    textAlign: TextAlign.right,
    textDirection: TextDirection.rtl,
  ),
);


Widget containerCard({required String header, 
    String text ='',String text1 ='',
 String text4 = '' ,String footer = '', }){
return Container(
  decoration: BoxDecoration(
    // color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color.fromARGB(255, 15, 90, 218),
      width: 1.5,
    ),
    // boxShadow: [
    //   BoxShadow(
    //     // color: Colors.grey.withOpacity(0.2),
    //     blurRadius: 8,
    //     offset: Offset(0, 4),
    //   ),
    // ],
  ),
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.end, // ✅ محاذاة لليمين
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        header,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          // color: Colors.blue[900],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      SizedBox(height: 15),
       Divider(color: const Color.fromARGB(255, 43, 53, 240), height: 1),
      SizedBox(height: 15),
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
          // color: Colors.grey[800],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      SizedBox(height: 10),
      Text(
        text1,
        style: TextStyle(
          fontSize: 16,
          // color: Colors.grey[800],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      SizedBox(height: 10),
      Text(
        text4,
        style: TextStyle(
          fontSize: 16,
          // color: Colors.grey[800],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      SizedBox(height: 15),
      Divider(color: const Color.fromARGB(255, 43, 53, 240), height: 1),
      SizedBox(height: 10),
      Text(
        footer,
        style: TextStyle(
          fontSize: 14,
          // color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    ],
  ),
);
}



Widget cardCustom({required String header,required String body}){
return Card(
  elevation: 6,
  margin: EdgeInsets.all(16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    side: BorderSide(color: Colors.blueAccent, width: 1),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text(header, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(body),
      ],
    ),
  ),
);
}

//==================-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//قائمة جانبية مخصصة مع خيار تبديل الوضع الداكن
// Widget customDrawer({required BuildContext context, required dynamic toggleTheme}) {
//   return Drawer(
//     child: ListView(
//       // مهم: لإزالة أي مسافات إضافية من الأعلى
//       padding: EdgeInsets.zero,
//       children: [
//         UserAccountsDrawerHeader(
//           // صورة المستخدم الحالية
//           currentAccountPicture: CircleAvatar(
//             backgroundImage: NetworkImage('https://picsum.photos/200' ),
//           ),
//           // اسم المستخدم
//           accountName: Text(
//             'اسم المستخدم',
//             style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 13, 121, 121)),
//           ),
          
//           // البريد الإلكتروني
//           accountEmail: Text('user.email@example.com',
//           style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 13, 121, 121)),),
//           // أيقونات أخرى (مثل حالة الاتصال)
//           otherAccountsPictures: [
            
//             // Icon(
//             //   Icons.circle,
//             //   color: const Color.fromARGB(255, 22, 248, 67),
//             //   size: 14,
//             // ),
//             IconButton(
//               onPressed:toggleTheme
//             , icon: CircleAvatar(
//               child:Icon(Icons.brightness_6_outlined))),
//           ],
//           // تصميم خلفية الهيدر
//           decoration: BoxDecoration(
//             // image: DecorationImage(
//             //   image: NetworkImage('https://picsum.photos/300/200' ),
//             //   fit: BoxFit.cover,
//             // ),
//           ),
//         ),
        
//         // -- عناصر القائمة --
//         ListTile(
//           leading: Icon(Icons.person_pin_outlined),
//           title: Text('الملف الشخصي'),
//           onTap: () {
//             Navigator.pop(context);
//             // Navigator.pushNamed(context, '/dashboardscreen');
//             // Navigator.pushReplacementNamed(context, '/profilescreen');
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.home_outlined),
//           title: Text('الصفحة الرئيسية'),
//           onTap: () {
//             // أغلق القائمة ثم انتقل
//             // Navigator.pop(context); 
//             // Navigator.pushNamed(context, '/homescreen');
//             // Navigator.pushReplacementNamed(context, '/homescreen');
//           },
//           //
//         ),
//         ListTile(
//           leading: Icon(Icons.dashboard_outlined),
//           title: Text('لوحة التحكم'),
//           onTap: () {
//             Navigator.pop(context);
//             // Navigator.pushNamed(context, '/dashboardscreen');
//             // Navigator.pushReplacementNamed(context, '/dashboardscreen');
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.book_outlined),
//           title: Text('المحاضرات'),
//           onTap: () {
//             Navigator.pop(context);
//             // Navigator.pushNamed(context, '/lecturesscreen');
//           },
//         ),
        
//         // خط فاصل لتنظيم القائمة
//         Divider(), 

//         ListTile(
//           leading: Icon(Icons.settings_outlined),
//           title: Text('الإعدادات'),
//           onTap: () {
//             Navigator.pop(context);
//             Navigator.pushNamed(context, '/settingscreen');
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.logout),
//           title: Text('تسجيل الخروج'),
//           onTap: () {
//             // أغلق القائمة أولاً
//             Navigator.pop(context);

//             // ثم أظهر رسالة الخروج
//             SnackBar snackBar = SnackBar(
//               content: Text('تم تسجيل الخروج بنجاح'),
//               duration: Duration(seconds: 2),
//             );
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
            
//             // يمكنك هنا إضافة منطق تسجيل الخروج الفعلي
//             // والانتقال إلى شاشة تسجيل الدخول
//             // Navigator.pushReplacementNamed(context, '/login');
//           },
//         ),
//       ],
//     ),
//   );
// }


//==================-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=->
//قائمة تنقل سفلية بسيطة مع زر عائم محفور
// Widget custombottomNavigationBar(BuildContext context) {
// return  BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 6.0,
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.home),
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/homescreen');
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.home),
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/homescreen');
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.home),
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/homescreen');
//               },
//             ),
//             Text(
//                '.'),
              
            
//             // IconButton(
//             //   icon: Icon(Icons.person),
//             //   onPressed: () {
//             //     // Navigator.pushReplacementNamed(context, '/profilescreen');
//             //   },
//             // ),
//           ],
//         ),
//       );
// }


      //الزر العائم منسق مع قائمة التنقل السفلية مع الخاصية التالية
      //  FloatingActionButtonLocation.endDocked;}
    Widget customFloatingActionButton(BuildContext context, {String pageName = '/homescreen'}) {
      return FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, pageName);
        },
        child: Icon(Icons.add_circle),
      );
    }
//==================-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=>

//قائمة تنقل سفلية مع تأثيرات متحركة 
Widget customNotchBottomBar(BuildContext context) {
final _controller = NotchBottomBarController(index: 0);
return  AnimatedNotchBottomBar(
  notchBottomBarController: _controller,

  color: Colors.white,
  showLabel: false, // إخفاء النصوص
  notchColor: Colors.blue,
  bottomBarItems: [
    BottomBarItem(
      inActiveItem: Icon(Icons.home_outlined, color: Colors.grey, size: 30),
      activeItem: Icon(Icons.home, color: Colors.blue, size: 35),
      itemLabel: 'Home',
    ),
    BottomBarItem(
      inActiveItem: Icon(Icons.person_outline, color: Colors.grey, size: 30),
      activeItem: Icon(Icons.person, color: Colors.blue, size: 35),
      itemLabel: 'Profile',
    ),
    // إضافة المزيد من العناصر حسب الحاجة
  ],
  onTap: (index) {
    // التعامل مع التنقل بين الصفحات بناءً على الفهرس
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/homescreen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profilescreen');
        break;
      // إضافة المزيد من الحالات حسب الحاجة
    }
  }, kIconSize: 15.0, kBottomRadius: 15.0,
);
}


//==================-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=>

