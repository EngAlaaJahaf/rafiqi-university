// lib/modules/login/signin.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✨ 1. استيراد Provider
import 'package:rafiqi_university/modules/login/login_screen.dart'; // للعودة لصفحة الدخول
import 'package:rafiqi_university/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SignInScreen({super.key, required this.toggleTheme});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // ✨ 2. إضافة متحكم لحقل الاسم الكامل
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // التخلص من كل المتحكمات
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // الوصول لخدمة المصادقة من Provider
      final authService = Provider.of<AuthService>(context, listen: false);

      // ✨ 3. استدعاء الدالة الجديدة وتمرير كل البيانات المطلوبة
      final user = await authService.createUserAndProfile(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text, // تمرير الاسم الكامل
        context: context,
      );

      // التحقق من أن الواجهة لا تزال موجودة قبل تحديث الحالة
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // ✨ 4. عند النجاح، StreamBuilder في main.dart سيتولى الانتقال تلقائياً
      // لا حاجة للانتقال اليدوي بعد الآن، هذا يجعل الكود أنظف
      if (user != null) {
        // يمكنك عرض رسالة نجاح إذا أردت
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الحساب وتخزين البيانات بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
        // لا تقم بالانتقال يدوياً، اترك StreamBuilder يقوم بعمله
        // Navigator.of(context).pushAndRemoveUntil(...) // ❌ تم حذف هذا السطر
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // تعديل بسيط على AppBar لإضافة زر الرجوع
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // العودة إلى شاشة تسجيل الدخول
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen(toggleTheme: widget.toggleTheme)),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              
              // ✨ 5. إضافة حقل "الاسم الكامل"
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسمك الكامل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'يرجى إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: const InputDecoration(
                  labelText: 'تأكيد كلمة المرور',
                  prefixIcon: Icon(Icons.lock_person_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'كلمتا المرور غير متطابقتين';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('إنشاء الحساب'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
