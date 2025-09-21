import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/repository/subjects_repository.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart'; // استيراد الـ Widget الجديد


// دالة لفتح نافذة إضافة/تعديل المادة
Future<bool?> showSubjectDialog(BuildContext context, {Subject? subject}) {
  // 1. تحديد إعدادات الحقول (مع الأسماء الصحيحة)
  final fields = [
    FormFieldConfig(
      name: 'name', // <-- استخدم 'name' كما في الموديل
      label: 'اسم المادة',
      initialValue: subject?.name,
      validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم المادة' : null, keyboardType: TextInputType.text,
    ),
    FormFieldConfig(
      name: 'code', // <-- استخدم 'code' كما في الموديل
      label: 'رمز المادة (اختياري)',
      initialValue: subject?.code, keyboardType: TextInputType.text,
    ),
    FormFieldConfig(
      name: 'creditHours', // <-- استخدم 'creditHours' كما في الموديل
      label: 'عدد الساعات المعتمدة (اختياري)',
      // يجب تحويل الرقم إلى نص للعرض في الحقل
      initialValue: subject?.creditHours?.toString(), keyboardType: TextInputType.number, 
    ),
  ];

  // 2. تحديد منطق الحفظ
// 2. تحديد منطق الحفظ
// 2. تحديد منطق الحفظ (مع المفاتيح الصحيحة)
Future<void> onSave(Map<String, dynamic> data) async {
  // نقوم باستخراج وتحويل كل قيمة بأمان
  final String subjectName = data['name'] as String; // <-- اقرأ من 'name'
  final String? subjectCode = data['code'] as String?; // <-- اقرأ من 'code'
  final String? creditHoursString = data['creditHours'] as String?; // <-- اقرأ من 'creditHours'

  // الآن نتعامل مع متغيرات نعرف نوعها بالضبط
  final newSubject = Subject(
    id: subject?.id,
    name: subjectName,
    code: subjectCode ?? '',
    creditHours: (creditHoursString != null && creditHoursString.isNotEmpty)
        ? int.tryParse(creditHoursString)
        : null,
  );

  // ... باقي منطق الحفظ
  if (subject == null) {
    await SubjectsRepository.instance.create(newSubject);
  } else {
    await SubjectsRepository.instance.update(newSubject);
  }
}


  // 3. إظهار النافذة المنبثقة مع تمرير الإعدادات ومنطق الحفظ
  return showDialog<bool>(
    context: context,
    builder: (_) => ReusableFormDialog(
      title: subject == null ? 'إضافة مادة جديدة' : 'تعديل المادة',
      fields: fields,
      onSave: onSave,
    ),
  );
}
