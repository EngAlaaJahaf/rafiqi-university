import 'package:flutter/material.dart';
import 'package:rafiqi_university/shared/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rafiqi_university/services/json_file.dart';

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
  Map<String, dynamic>? _studentData;
  final StorageService _storageService = StorageService();
//  late VoidCallback toggleTheme;
@override
  void initState() {
    super.initState();
    loadData();
    _loadStudentData();
    

  }

  void _loadStudentData() async {
    final data = await _storageService.readStudentData();
    setState(() {
      _studentData = data;
    });
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
    return SingleChildScrollView(child: Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      
      children: [
      // HeaderText(
      //   text:'البيانات المحفوظة'),
      
containerCard(
  header: 'البيانات المحفوظة (SharedPreferences)',
   text: 'الإيميل : $email',
  text1: 'كلمة المرور : $password',
 
),
if (_studentData != null)
  containerCard(
    header: 'بيانات الطالب (JSON)',
    text: 'الاسم: ${_studentData!['name'] ?? 'N/A'}',
    text1: 'الرقم الجامعي: ${_studentData!['id'] ?? 'N/A'}',
    // You can add more fields like this:
    text4: 'التخصص: ${_studentData!['major'] ?? 'N/A'}',
    footer: 'المستوى: ${_studentData!['level'] ?? 'N/A'}',
  )
else
  Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text('لا توجد بيانات طالب محفوظة في ملف JSON.'),
  ),
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