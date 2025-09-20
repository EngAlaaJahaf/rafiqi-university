import 'package:flutter/material.dart';
import 'package:rafiqi_university/layout/main_layout.dart';
import 'package:rafiqi_university/layout/mainlayoutwidget.dart';
import 'package:rafiqi_university/services/json_file.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const SignInScreen({super.key, required this.toggleTheme});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final StorageService _storageService = StorageService();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _majorController.dispose();
    _levelController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> studentData = {
        'name': _nameController.text,
        'id': _idController.text,
        'major': _majorController.text,
        'level': _levelController.text,
        'password': _passwordController.text,
      };

      try {
        await _storageService.writeStudentData(studentData);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ البيانات بنجاح, جاري تسجيل الدخول')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainLayoutWidget(toggleTheme: widget.toggleTheme),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل حفظ البيانات: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your ID' : null,
              ),
              TextFormField(
                controller: _majorController,
                decoration: InputDecoration(labelText: 'Major'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your major' : null,
              ),
              TextFormField(
                controller: _levelController,
                decoration: InputDecoration(labelText: 'Level'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your level' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your password' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}