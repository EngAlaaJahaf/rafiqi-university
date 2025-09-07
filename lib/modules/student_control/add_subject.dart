import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/services/database_helper.dart';

class AddSubjectDialog extends StatefulWidget {
  final Subject? subject;

  const AddSubjectDialog({super.key, this.subject});

  @override
  State<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _instructorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.subject_name);
    _codeController = TextEditingController(text: widget.subject?.subject_code);
    _instructorController = TextEditingController(text: widget.subject?.instructor_name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  Future<void> _saveSubject() async {
    if (_formKey.currentState!.validate()) {
      final subject = Subject(
        id: widget.subject?.id,
        subject_name: _nameController.text,
        subject_code: _codeController.text,
        instructor_name: _instructorController.text,
      );

      if (widget.subject == null) {
        await DatabaseHelper.instance.createSubject(subject);
      } else {
        await DatabaseHelper.instance.updateSubject(subject);
      }

      if (mounted) {
        Navigator.of(context).pop(true); // إرجاع true للإشارة إلى النجاح
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subject == null ? 'إضافة مادة جديدة' : 'تعديل المادة'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم المادة'),
                validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم المادة' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'رمز المادة (اختياري)'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _instructorController,
                decoration: const InputDecoration(labelText: 'اسم المدرس (اختياري)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _saveSubject,
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
