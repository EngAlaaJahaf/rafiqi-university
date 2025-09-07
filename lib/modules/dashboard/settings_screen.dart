import 'package:flutter/material.dart';
import 'package:rafiqi_university/shared/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
// صفحة الإعدادات 
class SettingsScreen extends StatefulWidget {
  // const SettingsScreen({super.key});
final VoidCallback toggleTheme;

// const SettingsScreen({Key? key}) : super(key: key);
 const SettingsScreen({super.key , required this.toggleTheme});
@override
  State<StatefulWidget> createState() => SettingsScreenState();
}
class SettingsScreenState extends State <SettingsScreen> {
 bool switchValue = false;
  String email = "";
  String password = "";
//  late VoidCallback toggleTheme;
@override
  void initState() {
    super.initState();
    loadData();
    

  }
void loadData () async {
 final prefs = await SharedPreferences.getInstance();
    setState(() {
      // switchValue = prefs.getBool('switchValue') ?? false;
      email = prefs.getString('email') ?? "";
      password = prefs.getString('password') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      
      children: [
      // HeaderText(
      //   text:'البيانات المحفوظة'),
      
containerCard(
  header: 'البيانات المحفوظة',
   text: 'الإيميل : $email',
  text1: 'كلمة المرور : $password',
 
),
// cardCustom(body: 'الإيميل : $email',
// header: 'البيانات المحفوظة' ),
      ],
    ),
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed:widget.toggleTheme,
      //        icon: Icon(Icons.brightness_4)),
      //   title: Text('الإعدادات'),
      //   centerTitle: true,
      //   actions: [
          
      //   ],
      // ),
      // endDrawer: customDrawer(context: context, toggleTheme: widget.toggleTheme),
     
    );
  }
  
  
  
}