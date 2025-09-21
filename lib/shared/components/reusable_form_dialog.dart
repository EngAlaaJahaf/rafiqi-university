import 'package:flutter/material.dart';
import 'package:rafiqi_university/shared/components/components.dart';

// 1. تعريف أنواع الحقول المتاحة
enum FormFieldType { text, number, date, time, dropdown, DatePicker }

// 2. كلاس لتمثيل كل عنصر في القائمة المنسدلة
class DropdownOption {
  final String label; // النص الذي يراه المستخدم (مثل "هندسة البرمجيات")
  final dynamic value;  // القيمة التي يتم تخزينها (مثل ID المادة)

  DropdownOption({required this.label, required this.value});
}

// 3. كلاس إعدادات الحقل (مع دعم القوائم المنسدلة)
class FormFieldConfig {
  final String name;
  final String label;
  final FormFieldType type;
  final String? initialValue;
  final String? Function(String?)? validator;
  final List<DropdownOption>? dropdownOptions; // قائمة الخيارات للقوائم المنسدلة

  FormFieldConfig({
    required this.name,
    required this.label,
    this.type = FormFieldType.text,
    this.initialValue,
    this.validator,
    this.dropdownOptions, required TextInputType keyboardType, // تأكد من أن هذا النوع مدعوم
  });
}

// 4. الـ Widget الرئيسي (مع منطق بناء القوائم المنسدلة)
class ReusableFormDialog extends StatefulWidget {
  // ... (باقي الكود كما هو)
  final String title;
  final List<FormFieldConfig> fields;
  final Future<void> Function(Map<String, dynamic> data) onSave; // تم تغيير النوع ليدعم أنواع مختلفة

  const ReusableFormDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave, 
    // required Future<Null> Function(dynamic formData) onSubmit,
  });

  @override
  State<ReusableFormDialog> createState() => _ReusableFormDialogState();
}

class _ReusableFormDialogState extends State<ReusableFormDialog> {
  final _formKey = GlobalKey<FormState>();
  // Map لتخزين القيم المحددة (وليس فقط controllers)
  late Map<String, dynamic> _formValues;

  @override
  void initState() {
    super.initState();
    _formValues = {
      for (var field in widget.fields)
        field.name: field.initialValue
    };
  }

  // ... (dispose غير مطلوب الآن لأننا لا نستخدم controllers لكل شيء)

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // حفظ قيم النموذج
      await widget.onSave(_formValues);
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  // دالة لبناء الحقل بناءً على نوعه
  Widget _buildFormField(FormFieldConfig field) {
    switch (field.type) {
      case FormFieldType.dropdown:
        return DropdownButtonFormField<dynamic>(
          value: _formValues[field.name],
          decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
          items: field.dropdownOptions?.map((option) {
            return DropdownMenuItem<dynamic>(
              value: option.value,
              child: Text(option.label),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _formValues[field.name] = value;
            });
          },
          validator: (value) => field.validator?.call(value?.toString()),
          onSaved: (value) => _formValues[field.name] = value,
        );
        case FormFieldType.date:
      // نستخدم controller هنا لتحديث النص في الحقل بسهولة
      final controller = TextEditingController(text: _formValues[field.name] as String?);
      return TextFormField(
        controller: controller,
        readOnly: true, // نجعل الحقل للقراءة فقط لمنع الكتابة اليدوية
        decoration: InputDecoration(
          labelText: field.label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today), // أيقونة التقويم
        ),
        validator: (value) => field.validator?.call(value),
        onTap: () async {
          // عند الضغط على الحقل، نفتح منتقي التاريخ
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            // تنسيق التاريخ بالشكل الذي نريده (YYYY-MM-DD)
            String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            setState(() {
              // تحديث النص في الحقل
              controller.text = formattedDate;
              // حفظ القيمة في الـ Map
              _formValues[field.name] = formattedDate;
            });
          }
        },
        onSaved: (value) => _formValues[field.name] = value,
      );
      // يمكنك إضافة case لـ date و time هنا
      default: // الحالة الافتراضية هي حقل نصي
        return TextFormField(
          initialValue: field.initialValue,
          decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
          validator: field.validator,
          onSaved: (value) => _formValues[field.name] = value,
        );
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildFormField(field),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
        ElevatedButton(onPressed: _handleSave, child: const Text('حفظ')),
       DefaultSmallButton(
        // onPressed: _handleSave, 
        function: _handleSave,
         text: 'حفظ',
          child: const Text('حفظ'),
          ),


      ],
    );
  }
}
