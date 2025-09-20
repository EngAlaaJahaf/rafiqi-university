import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/lecture.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/model/repository/lectures_repository.dart'; // تأكد من المسار الصحيح
import 'package:rafiqi_university/model/repository/subjects_repository.dart'; // تأكد من المسار الصحيح
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';

class AddLecturePage extends StatefulWidget {
  const AddLecturePage({super.key});

  @override
  State<AddLecturePage> createState() => _AddLecturePageState();
}

class _AddLecturePageState extends State<AddLecturePage> {
  final LecturesRepository _lecturesRepo = LecturesRepository.instance;
 // في صفحة AddLecturePage أو أي صفحة أخرى
final SubjectsRepository _subjectsRepo = SubjectsRepository.instance; // صحيح!
// تم إلغاء التعليق

  late Future<List<Lecture>> _lecturesFuture;
  late Future<List<Subject>> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    // الآن هذه الاستدعاءات صحيحة
    _lecturesFuture = _lecturesRepo.getAll(); 
    _subjectsFuture = _subjectsRepo.getAll();
  }

  void _showAddLectureDialog(List<Subject> subjects) {
    final subjectOptions = subjects.map((s) => DropdownOption(label: s.name, value: s.id)).toList();

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
        type: FormFieldType.date, // نفترض أنك قمت بتحديث ReusableFormDialog لدعم التاريخ
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال التاريخ' : null,
      ),
      FormFieldConfig(
        name: 'notes',
        label: 'ملاحظات (اختياري)',
        type: FormFieldType.text,
      ),
    ];

    Future<void> onSave(Map<String, dynamic> data) async {
      final newLecture = Lecture(
        subjectId: data['subject_id'],
        lectureDate: DateTime.parse(data['lecture_date']),
        notes: data['notes'],
      );

      await _lecturesRepo.create(newLecture);

      // إعادة تحميل قائمة المحاضرات بعد الإضافة
      setState(() {
        _lecturesFuture = _lecturesRepo.getAll(); // تم إلغاء التعليق
      });
    }

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
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_lecturesFuture, _subjectsFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }
          
          // يجب التحقق من أن البيانات ليست فارغة قبل الوصول إليها
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.length < 2) {
             return const Center(child: Text('لا توجد بيانات كافية لعرضها.'));
          }

          final lectures = snapshot.data![0] as List<Lecture>;
          final subjects = snapshot.data![1] as List<Subject>;

          // عرض رسالة إذا كانت قائمة المحاضرات فارغة
          if (lectures.isEmpty) {
            return const Center(child: Text('لا توجد محاضرات. قم بإضافة محاضرة جديدة.'));
          }

          return ListView.builder(
            itemCount: lectures.length,
            itemBuilder: (context, index) {
              final lecture = lectures[index];
              final subjectName = subjects.firstWhere((s) => s.id == lecture.subjectId, orElse: () => Subject(id:0, name:'مادة محذوفة', code:'')).name;
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
          final subjects = await _subjectsFuture;
          if (subjects.isNotEmpty) {
            _showAddLectureDialog(subjects);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('الرجاء إضافة مواد دراسية أولاً!')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
