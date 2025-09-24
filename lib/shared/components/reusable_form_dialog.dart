import 'package:flutter/material.dart';
// لا تقم باستيراد 'components.dart' هنا إذا كان يسبب استيرادًا دائريًا.
// يمكنك استيراد الـ Widgets التي تحتاجها مباشرة.

// 1. تعريف أنواع الحقول المتاحة
enum FormFieldType { text, number, date, time, dropdown ,checkbox }

// 2. كلاس لتمثيل كل عنصر في القائمة المنسدلة
class DropdownOption {
  final String label;
  final dynamic value;

  DropdownOption({required this.label, required this.value});
}

// 3. كلاس إعدادات الحقل
class FormFieldConfig {
  final String name;
  final String label;
  final FormFieldType type;
  // ✨ تم تغيير النوع إلى dynamic? ليقبل أي نوع قيمة أولية (String, int, etc.)
  final dynamic initialValue;
  final String? Function(String?)? validator;
  final List<DropdownOption>? dropdownOptions;
  final TextInputType? keyboardType;

  FormFieldConfig({
    required this.name,
    required this.label,
    this.type = FormFieldType.text,
    this.initialValue,
    this.validator,
    this.dropdownOptions,
    this.keyboardType,
  });
}

// 4. الـ Widget الرئيسي
class ReusableFormDialog extends StatefulWidget {
  final String title;
  final List<FormFieldConfig> fields;
  final Future<void> Function(Map<String, dynamic> data) onSave;

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
  late Map<String, dynamic> _formValues;

  @override
  void initState() {
    super.initState();
    _formValues = {
      for (var field in widget.fields) field.name: field.initialValue
    };
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
       _formValues.forEach((key, value) {
        if (value is int && (value == 0 || value == 1)) {
          // لا تفعل شيئًا إذا كان المطلوب هو int
        }
      });
      await widget.onSave(_formValues);
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  // ✨ --- هذه هي الدالة النهائية والآمنة --- ✨
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
          validator: (value) {
            if (value == null) return field.validator?.call(null);
            return field.validator?.call(value.toString());
          },
          onSaved: (value) => _formValues[field.name] = value,
        );
      case FormFieldType.checkbox:
        return FormField<bool>(
          // عند البناء: حوّل الـ int (أو null) إلى bool
          initialValue: (_formValues[field.name] ?? 0) == 1,
          onSaved: (value) {
            // عند الحفظ: حوّل الـ bool مرة أخرى إلى int
            _formValues[field.name] = (value ?? false) ? 1 : 0;
          },
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              title: Text(field.label),
              value: state.value,
              onChanged: (bool? newValue) {
                state.didChange(newValue);
              },
              controlAffinity: ListTileControlAffinity.leading, // لجعل الـ checkbox على اليسار
              contentPadding: EdgeInsets.zero,
            );
          },
        );
      case FormFieldType.date:
      case FormFieldType.time:
        final controller = TextEditingController(text: _formValues[field.name]?.toString());
        return TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: field.label,
            border: const OutlineInputBorder(),
            suffixIcon: Icon(field.type == FormFieldType.date ? Icons.calendar_today : Icons.access_time_outlined),
          ),
          validator: (value) => field.validator?.call(value),
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (field.type == FormFieldType.date) {
              DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));
              if (pickedDate != null) {
                String formattedDate = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                setState(() {
                  controller.text = formattedDate;
                  _formValues[field.name] = formattedDate;
                });
              }
            } else {
              TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
              if (pickedTime != null) {
                String formattedTime = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                setState(() {
                  controller.text = formattedTime;
                  _formValues[field.name] = formattedTime;
                });
              }
            }
          },
          onSaved: (value) => _formValues[field.name] = value,
        );

      default: // text, number, etc.
        return TextFormField(
          // ✨ التحويل الآمن باستخدام .toString()
          initialValue: _formValues[field.name]?.toString(),
          decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
          keyboardType: field.keyboardType,
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
      ],
    );
  }
}
