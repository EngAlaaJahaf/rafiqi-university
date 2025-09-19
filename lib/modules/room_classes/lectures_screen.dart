import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/services/database_helper.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart'; // استيراد الـ Widget الجديد


// دالة لفتح نافذة إضافة/تعديل المادة
void showSubjectDialog(BuildContext context, {Subject? subject}) {
  // 1. تحديد إعدادات الحقول
  final fields = [
    FormFieldConfig(
      name: 'subject_name',
      label: 'اسم المادة',
      initialValue: subject?.subject_name,
      validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم المادة' : null,
    ),
    FormFieldConfig(
      name: 'subject_code',
      label: 'رمز المادة (اختياري)',
      initialValue: subject?.subject_code,
    ),
    FormFieldConfig(
      name: 'instructor_name',
      label: 'اسم المدرس (اختياري)',
      initialValue: subject?.instructor_name,
    ),
  ];

  // 2. تحديد منطق الحفظ
  Future<void> onSave(Map<String, String> data) async {
    final newSubject = Subject(
      id: subject?.id,
      subject_name: data['subject_name']!,
      subject_code: data['subject_code'],
      instructor_name: data['instructor_name'],
    );

    if (subject == null) {
      await DatabaseHelper.instance.createSubject(newSubject);
    } else {
      await DatabaseHelper.instance.updateSubject(newSubject);
    }
  }

  // 3. إظهار النافذة المنبثقة مع تمرير الإعدادات ومنطق الحفظ
  showDialog(
    context: context,
    builder: (_) => ReusableFormDialog(
      title: subject == null ? 'إضافة مادة جديدة' : 'تعديل المادة',
      fields: fields,
      onSave: onSave,
    ),
  );
}
