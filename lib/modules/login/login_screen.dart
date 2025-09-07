import 'package:flutter/material.dart';
import 'package:rafiqi_university/layout/mainlayoutwidget.dart';
import 'package:rafiqi_university/shared/components/components.dart';
// import 'package:rafiqi_university/layout/main_layout.dart' ; // 1. تأكد من صحة هذا المسار
import 'package:shared_preferences/shared_preferences.dart';

// استورد أي components أخرى تحتاجها
// import '../../shared/components/components.dart';

// 2. تم تعديل الكلاس ليستقبل دالة تغيير الثيم
class LoginScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const LoginScreen({super.key, required this.toggleTheme});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  // دالة حفظ البيانات (جيدة كما هي)
  Future<void> _saveUserData(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  // دالة لتسجيل الدخول
  Future<void> _login() async {
    // يمكنك هنا إضافة منطق التحقق من اسم المستخدم وكلمة المرور
    print(emailController.text);
    print(passwordController.text);

    // 3. انتظر حتى يتم حفظ البيانات قبل الانتقال
    await _saveUserData(emailController.text, passwordController.text);

    // 4. تحقق من أن الـ context لا يزال صالحاً قبل التنقل (ممارسة جيدة)
    if (!mounted) return;

    // 5. انتقل إلى الهيكل الرئيسي ومرر له الدالة الحقيقية
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainLayoutWidget(toggleTheme: widget.toggleTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // لجعل الزر يمتد
              children: [
                const Text(
                  'مرحباً بك',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "اسم المستخدم",
                    prefixIcon: Icon(Icons.mail_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !isPasswordVisible, // التحكم في الإظهار والإخفاء
                  decoration: InputDecoration(
                    labelText: "كلمة المرور",
                    prefixIcon: const Icon(Icons.lock_outline),
                    // 6. تم تفعيل زر إظهار/إخفاء كلمة المرور
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // 7. تم تعديل زر الدخول ليستدعي دالة _login
                DefaultButton(
                  emailController: emailController,
                  passwordController: passwordController,
                  onPressed: _login, // استدعاء دالة تسجيل الدخول
                  child: const Text('دخــول'),
                  function: () {
                    _login;
                    _saveUserData(emailController.text,passwordController.text);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            MainLayoutWidget(toggleTheme: widget.toggleTheme),
                      ),
                    );
                  },
                  text: 'دخــول',
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ليس لديك حساب؟'),
                    TextButton(
                      onPressed: () {
                        // يمكنك هنا الانتقال إلى شاشة إنشاء حساب
                      },
                      child: const Text('إنشاء حساب'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
