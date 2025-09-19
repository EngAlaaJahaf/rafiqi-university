import 'package:flutter/material.dart';

// 1. تعريف نوع الحقل (لتحديد نوع المدخل)
enum FormFieldType { text, number, date, time }

// 2. كلاس لتمثيل كل حقل في النموذج
class FormFieldConfig {
  final String name; // مفتاح فريد للحقل (مثل 'subject_name')
  final String label; // النص الذي يظهر للمستخدم (مثل 'اسم المادة')
  final FormFieldType type;
  final String? initialValue;
  final String? Function(String?)? validator; // دالة التحقق من الصحة

  FormFieldConfig({
    required this.name,
    required this.label,
    this.type = FormFieldType.text,
    this.initialValue,
    this.validator,
  });
}

// 3. الـ Widget الرئيسي القابل لإعادة الاستخدام
class ReusableFormDialog extends StatefulWidget {
  final String title; // عنوان النافذة (مثل 'إضافة مادة' أو 'تعديل تكليف')
  final List<FormFieldConfig> fields; // قائمة الحقول التي ستظهر في النموذج
  final Future<void> Function(Map<String, String> data) onSave; // دالة الحفظ

  const ReusableFormDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
  });

  @override
  State<ReusableFormDialog> createState() => _ReusableFormDialogState();
}

class _ReusableFormDialogState extends State<ReusableFormDialog> {
  final _formKey = GlobalKey<FormState>();
  // Map لتخزين وحدات التحكم (controllers) لكل حقل
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // إنشاء controller لكل حقل وتعيين القيمة الأولية
    _controllers = {
      for (var field in widget.fields)
        field.name: TextEditingController(text: field.initialValue)
    };
  }

  @override
  void dispose() {
    // التخلص من جميع الـ controllers لتجنب تسريب الذاكرة
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _handleSave() async {
    // التحقق من صحة جميع الحقول
    if (_formKey.currentState!.validate()) {
      // إنشاء Map تحتوي على البيانات المدخلة
      final data = _controllers.map((key, controller) => MapEntry(key, controller.text));
      
      // استدعاء دالة الحفظ التي تم تمريرها من الخارج
      await widget.onSave(data);

      // إغلاق النافذة بعد الحفظ بنجاح
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.fields.map((field) {
              // بناء TextFormField لكل حقل بناءً على الإعدادات
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextFormField(
                  controller: _controllers[field.name],
                  decoration: InputDecoration(
                    labelText: field.label,
                    border: const OutlineInputBorder(),
                  ),
                  validator: field.validator,
                  // يمكنك إضافة المزيد من الخصائص هنا بناءً على field.type
                  // keyboardType, onTap for date pickers, etc.
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
