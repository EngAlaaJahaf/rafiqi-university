import 'package:flutter/material.dart';
import 'package:rafiqi_university/modules/admin/view_subjects_screen.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex; // ✨ 1. استقبل الـ index الحالي
  final Function(int) onItemTapped;
 final VoidCallback toggleTheme;
  const AppDrawer({
    super.key,
    required this.currentIndex, // ✨ 2. اجعله مطلوباً
    required this.onItemTapped, required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context,  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
         UserAccountsDrawerHeader(
          // صورة المستخدم الحالية
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage('https://picsum.photos/200' ),
          ),
          // اسم المستخدم
          accountName: Text(
            'اسم المستخدم',
            style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 13, 121, 121)),
          ),
          
          // البريد الإلكتروني
          accountEmail: Text('user.email@example.com',
          style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 13, 121, 121)),),
          // أيقونات أخرى (مثل حالة الاتصال)
          otherAccountsPictures: [
            
            // Icon(
            //   Icons.circle,
            //   color: const Color.fromARGB(255, 22, 248, 67),
            //   size: 14,
            // ),
            IconButton(
              onPressed:toggleTheme
            , icon: CircleAvatar(
              child:Icon(Icons.brightness_6_outlined))),
          ],
          // تصميم خلفية الهيدر
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: NetworkImage('https://picsum.photos/300/200' ),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
          // ✨ 3. استخدم خاصية `selected` لتلوين العنصر النشط
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('الصفحة الرئيسية'),
            selected: currentIndex == 0, // تحقق إذا كان هذا هو العنصر النشط
            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('الإشعارات'),
            selected: currentIndex == 1,
            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: const Text('الملف الشخصي'),
            selected: currentIndex == 2,
            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(2);
            },
          ),
          
          const Divider(),
//--------------------------------------------------
          // ListTile(
          //   leading: const Icon(Icons.book_outlined),
          //   title: const Text('المواد الدراسية'),
          //   onTap: () {
          //     Navigator.pop(context); // أغلق القائمة
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const ViewSubjectsScreen()),
          //     );
          //   },
          // ),
//=================================
        // ListTile(
        //     leading: const Icon(Icons.book_outlined),
        //     title: const Text('المواد الدراسية'),
        //     onTap: () {
        //       Navigator.pop(context); // أغلق القائمة
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => const ViewSubjectsScreen(toggleTheme: () {  },)),
        //       );
        //     },
        //   ),
//-=-=-=-=-=-=
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('الإعدادات'),
            selected: currentIndex == 3,
            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(3);
            },
          ),
          // ... (بقية العناصر مثل تسجيل الخروج)
        ],
      ),
    );
  }
}
