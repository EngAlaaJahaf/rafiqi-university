import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/lecture.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/model/repository/lectures_repository.dart';
import 'package:rafiqi_university/model/repository/subjects_repository.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';

class AddLecturePage extends StatefulWidget {
  const AddLecturePage({super.key, required VoidCallback toggleTheme});

  @override
  State<AddLecturePage> createState() => _AddLecturePageState();
}

class _AddLecturePageState extends State<AddLecturePage> {
  // إنشاء نسخ من الـ Repositories لجلب البيانات
  final LecturesRepository _lecturesRepo = LecturesRepository.instance;
  // final SubjectsRepository _subjectsRepo = SubjectsRepository();

  late Future<List<Lecture>> _lecturesFuture;
  late Future<List<Subject>> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    // تحميل البيانات عند بدء تشغيل الصفحة
    _lecturesFuture = LecturesRepository.instance.getAll(); // نفترض وجود دالة getAll في الـ repo
    // _subjectsFuture = _subjectsRepo.getAll();
    _subjectsFuture = SubjectsRepository.instance.getAll();
  }

  // دالة لفتح نافذة إضافة محاضرة جديدة
  void _showAddLectureDialog(List<Subject> subjects) {
    // تحويل قائمة المواد إلى خيارات للقائمة المنسدلة
    final subjectOptions = subjects.map((s) => DropdownOption(label: s.name, value: s.id)).toList();

    // 1. تحديد إعدادات الحقول
    final fields = [
      FormFieldConfig(
        name: 'subject_id',
        label: 'المادة',
        type: FormFieldType.dropdown,
        dropdownOptions: subjectOptions,
        validator: (value) => (value == null) ? 'الرجاء اختيار المادة' : null,
      ),
      FormFieldConfig(
        name: 'lecture_date',
        label: 'تاريخ المحاضرة',
        // ملاحظة: هنا يجب استخدام منتقي تاريخ حقيقي، لكن للتبسيط سنستخدم حقل نصي
        // يمكنك لاحقًا تطوير ReusableFormDialog لدعم DatePicker
        type: FormFieldType.DatePicker, 
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال التاريخ' : null,
      ),
      FormFieldConfig(
        name: 'notes',
        label: 'ملاحظات (اختياري)',
        type: FormFieldType.text,
      ),
    ];

    // 2. تحديد منطق الحفظ
    Future<void> onSave(Map<String, dynamic> data) async {
      final newLecture = Lecture(
        subjectId: data['subject_id'], // القيمة هنا هي ID المادة
        lectureDate: DateTime.parse(data['lecture_date']), // تحويل النص إلى تاريخ
        notes: data['notes'],
      );

      await _lecturesRepo.create(newLecture);

      // إعادة تحميل قائمة المحاضرات بعد الإضافة
      setState(() {
        // _lecturesFuture = _lecturesRepo.getAll();
      });
    }

    // 3. إظهار النافذة المنبثقة
    showDialog(
      context: context,
      builder: (_) => ReusableFormDialog(
        title: 'إضافة محاضرة جديدة',
        fields: fields,
        onSave: onSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المحاضرات'),
      ),
      // استخدام FutureBuilder لعرض البيانات بعد تحميلها من قاعدة البيانات
      body: FutureBuilder<List<dynamic>>(
        // دمج الـ Futures لجلب المواد والمحاضرات معًا
        future: Future.wait([_lecturesFuture, _subjectsFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد بيانات لعرضها.'));
          }

          final lectures = snapshot.data![0] as List<Lecture>;
          final subjects = snapshot.data![1] as List<Subject>;

          return ListView.builder(
            itemCount: lectures.length,
            itemBuilder: (context, index) {
              final lecture = lectures[index];
              // البحث عن اسم المادة باستخدام ID
              final subjectName = subjects.firstWhere((s) => s.id == lecture.subjectId, orElse: () => Subject(id:0, name:'غير معروف', code:'')).name;
              return ListTile(
                title: Text('محاضرة $subjectName'),
                subtitle: Text('التاريخ: ${lecture.lectureDate.toLocal().toString().split(' ')[0]}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // التأكد من جلب قائمة المواد قبل فتح النافذة
          final subjects = await _subjectsFuture;
          if (subjects.isNotEmpty) {
            _showAddLectureDialog(subjects);
          } else {
            // عرض رسالة خطأ إذا لم تكن هناك مواد لإضافتها للمحاضرة
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('الرجاء إضافة مواد أولاً!')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
