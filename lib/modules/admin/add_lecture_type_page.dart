import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. استيراد Provider
import 'package:rafiqi_university/layout/fab_view_model.dart'; // 2. استيراد الـ ViewModel
import 'package:rafiqi_university/model/lect_type.dart';
import 'package:rafiqi_university/model/repository/lecture_type_repository%20.dart';
// import 'package:rafiqi_university/lib/model/repository/lecture_type_repository.dart';
// import 'package:rafiqi_university/model/repository/lecture_type_repository.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';

class AddLectureTypePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const AddLectureTypePage({super.key, required this.toggleTheme});

  @override
  State<AddLectureTypePage> createState() => _AddLectureTypePageState();
}

class _AddLectureTypePageState extends State<AddLectureTypePage> {
  // لا حاجة لإنشاء نسخة هنا، يمكننا استخدام Singleton مباشرة
  // final LectureTypeRepository _lecturesTypeRepo = LectureTypeRepository.instance;
  
  late Future<List<LectType>> _lecturesFuture;
  
  @override
  void initState(){
    super.initState();
    // 3. (الحل) قم بتهيئة المتغير عند بدء تشغيل الشاشة
    _refreshLectureTypes();

    // 4. قم بتعيين وظيفة الزر العائم لهذه الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);
    });
  }

  @override
  void dispose() {
    // 5. (مهم) قم بإزالة وظيفة الزر عند مغادرة الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
      }
    });
    super.dispose();
  }

  // دالة لتحديث البيانات
  void _refreshLectureTypes() {
    setState(() {
      _lecturesFuture = LectureTypeRepository.instance.getAll();
    });
  }

  // وظيفة الزر العائم
  void _openAddDialog({LectType? lectType}) {
    final fields = [
      FormFieldConfig(
        name: 'lect_type_name',
        label: 'نوع المحاضرة',
        initialValue: lectType?.name, // دعم التعديل
        type: FormFieldType.text,
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال نوع المحاضرة' : null, keyboardType: TextInputType.text,
      ),
    ];

    Future<void> onSave(Map<String, dynamic> data) async {
      final newLectType = LectType(
        id: lectType?.id, // دعم التعديل
        name: data['lect_type_name'] as String,
      );

      if (lectType == null) {
        await LectureTypeRepository.instance.create(newLectType);
      } else {
        await LectureTypeRepository.instance.update(newLectType);
      }
      
      // أعد تحميل البيانات بعد الحفظ
      _refreshLectureTypes();
    }

    showDialog(
      context: context,
      builder: (context) => ReusableFormDialog(
        title: lectType == null ? 'إضافة نوع محاضرة' : 'تعديل نوع المحاضرة',
        fields: fields,
        onSave: onSave,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // لا يوجد Scaffold هنا، المحتوى فقط
    return FutureBuilder<List<LectType>>(
      future: _lecturesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد أنواع محاضرات. اضغط على زر + للإضافة.'));
        } else {
          final lectureTypes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: lectureTypes.length,
            itemBuilder: (context, index) {
              final lectType = lectureTypes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(lectType.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      // يمكنك إضافة نافذة تأكيد هنا
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: const Text('هل أنت متأكد من حذف هذا النوع؟'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('حذف', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ) ?? false;
                      if (confirm == true ) {
                      await LectureTypeRepository.instance.delete(lectType.id!);
                      _refreshLectureTypes();
                    };
                    },
                  ),
                  // عند الضغط على العنصر، افتح نافذة التعديل
                  onTap: () => _openAddDialog(lectType: lectType),
                ),
              );
            },
          );
        }
      },
    );
  }
}
