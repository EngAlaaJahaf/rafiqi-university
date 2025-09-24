import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/lecture.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/model/teacher.dart'; // استيراد موديل المدرس
import 'package:rafiqi_university/model/time_slot.dart'; // استيراد موديل الفترة الزمنية
import 'package:rafiqi_university/model/lecture_type.dart'; // استيراد موديل نوع المحاضرة
import 'package:rafiqi_university/model/class_room.dart'; // استيراد موديل القاعة

// استيراد كل الـ Repositories المطلوبة
import 'package:rafiqi_university/model/repository/lectures_repository.dart';
import 'package:rafiqi_university/model/repository/subjects_repository.dart';
import 'package:rafiqi_university/model/repository/teachers_repository.dart';
import 'package:rafiqi_university/model/repository/time_slots_repository.dart';
import 'package:rafiqi_university/model/repository/lecture_types_repository.dart';
import 'package:rafiqi_university/model/repository/class_rooms_repository.dart';

import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';
import 'package:rafiqi_university/shared/components/reusable_list_item.dart';

// ✨ 1. كلاس لتجميع كل بيانات القوائم المنسدلة معًا
class LectureFormData {
  final List<Subject> subjects;
  final List<Teacher> teachers;
  final List<TimeSlot> timeSlots;
  final List<LectType> lectureTypes;
  final List<ClassRoom> classRooms;

  LectureFormData({
    required this.subjects,
    required this.teachers,
    required this.timeSlots,
    required this.lectureTypes,
    required this.classRooms,
  });
}

class AddLecturePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const AddLecturePage({super.key, required this.toggleTheme});

  @override
  State<AddLecturePage> createState() => _AddLecturePageState();
}

class _AddLecturePageState extends State<AddLecturePage> {
  late Future<List<Lecture>> _lecturesFuture;
  late Future<LectureFormData> _formDataFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
    
    // ✨ 2. تعديل منطق زر الإضافة ليكون آمنًا
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FabViewModel>(context, listen: false).setFabAction(() async {
        // انتظر تحميل بيانات النموذج قبل فتح النافذة
        final formData = await _formDataFuture;
        _openAddOrEditDialog(formData);
      });
    });
  }

  // لا حاجة لـ dispose هنا لأن الحل المركزي في MainLayoutWidget يعالج الأمر

  // ✨ 3. دالة واحدة لجلب كل البيانات المطلوبة
  Future<void> _refreshData() async {
    setState(() {
      _lecturesFuture = LecturesRepository.instance.getAll();
      _formDataFuture = _loadFormData();
    });
  }

  Future<LectureFormData> _loadFormData() async {
    // جلب كل البيانات بالتوازي لتحسين الأداء
    final results = await Future.wait([
      SubjectsRepository.instance.getAll(),
      TeachersRepository.instance.getAll(),
      TimeSlotRepository.instance.getAll(),
      LectureTypeRepository.instance.getAll(),
      ClassRoomsRepository.instance.getAll(),
    ]);
    return LectureFormData(
      subjects: results[0] as List<Subject>,
      teachers: results[1] as List<Teacher>,
      timeSlots: results[2] as List<TimeSlot>,
      lectureTypes: results[3] as List<LectType>,
      classRooms: results[4] as List<ClassRoom>,
    );
  }

  // ✨ 4. دالة واحدة لفتح نافذة الإضافة أو التعديل
  void _openAddOrEditDialog(LectureFormData formData, {Lecture? lecture}) {
    final isEditing = lecture != null;

    // تحويل قوائم البيانات إلى خيارات للقوائم المنسدلة
    final subjectOptions = formData.subjects.map((s) => DropdownOption(label: s.name, value: s.id)).toList();
    final teacherOptions = formData.teachers.map((t) => DropdownOption(label: t.name, value: t.id)).toList();
    final timeSlotOptions = formData.timeSlots.map((ts) => DropdownOption(label: '${ts.startTime} - ${ts.endTime}', value: ts.id)).toList();
    final lectureTypeOptions = formData.lectureTypes.map((lt) => DropdownOption(label: lt.name, value: lt.id)).toList();
    final classRoomOptions = formData.classRooms.map((cr) => DropdownOption(label: cr.name, value: cr.id)).toList();

    final fields = [
      FormFieldConfig(
        name: 'subj_id',
        label: 'المادة',
        type: FormFieldType.dropdown,
        dropdownOptions: subjectOptions,
        initialValue: lecture?.subjectId,
        validator: (value) => (value == null) ? 'الرجاء اختيار المادة' : null,
      ),
      FormFieldConfig(
        name: 'lect_date',
        label: 'تاريخ المحاضرة',
        type: FormFieldType.date,
        initialValue: lecture?.lectureDate.toIso8601String().substring(0, 10),
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال التاريخ' : null,
      ),
      FormFieldConfig(
        name: 'teach_id',
        label: 'المدرس (اختياري)',
        type: FormFieldType.dropdown,
        dropdownOptions: teacherOptions,
        initialValue: lecture?.teacherId,
      ),
      FormFieldConfig(
        name: 'ts_id',
        label: 'الفترة الزمنية (اختياري)',
        type: FormFieldType.dropdown,
        dropdownOptions: timeSlotOptions,
        initialValue: lecture?.timeSlotId,
      ),
      FormFieldConfig(
        name: 'lect_type_id',
        label: 'نوع المحاضرة (اختياري)',
        type: FormFieldType.dropdown,
        dropdownOptions: lectureTypeOptions,
        initialValue: lecture?.lectureTypeId,
      ),
      FormFieldConfig(
        name: 'cl_id',
        label: 'القاعة (اختياري)',
        type: FormFieldType.dropdown,
        dropdownOptions: classRoomOptions,
        initialValue: lecture?.classId,
      ),
      FormFieldConfig(
        name: 'notes',
        label: 'ملاحظات (اختياري)',
        type: FormFieldType.text,
        initialValue: lecture?.notes,
      ),
      FormFieldConfig(
        name: 'is_completed',
        label: 'تم أخذ المحاضرة',
        type: FormFieldType.checkbox,
        // تحويل القيمة الأولية (0 أو 1) إلى bool (false أو true)
        initialValue: lecture?.isCompleted == 1,
      ),
    ];

    Future<void> onSave(Map<String, dynamic> data) async {
      final lectureToSave = Lecture(
        id: lecture?.id,
        subjectId: data['subj_id'],
        lectureDate: DateTime.parse(data['lect_date']),
        teacherId: data['teach_id'],
        timeSlotId: data['ts_id'],
        lectureTypeId: data['lect_type_id'],
        classId: data['cl_id'],
        notes: data['notes'],
        isCompleted: lecture?.isCompleted ?? false, // الحفاظ على الحالة الحالية أو 0
        
      );

      if (isEditing) {
        await LecturesRepository.instance.update(lectureToSave);
      } else {
        await LecturesRepository.instance.create(lectureToSave);
      }
      _refreshData(); // تحديث البيانات بعد الحفظ
    }

    showDialog(
      context: context,
      builder: (_) => ReusableFormDialog(
        title: isEditing ? 'تعديل محاضرة' : 'إضافة محاضرة جديدة',
        fields: fields,
        onSave: onSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      // ✨ 5. استخدام Future.wait لجلب بيانات المحاضرات والنموذج معًا
      future: Future.wait([_lecturesFuture, _formDataFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('لا توجد بيانات'));
        }

        final lectures = snapshot.data![0] as List<Lecture>;
        final formData = snapshot.data![1] as LectureFormData;

        if (lectures.isEmpty) {
          return const Center(child: Text('لا توجد محاضرات. اضغط على زر + للإضافة.'));
        }

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            itemCount: lectures.length,
            itemBuilder: (context, index) {
              final lecture = lectures[index];
              // البحث عن اسم المادة لعرضه في القائمة
              final subjectName = formData.subjects.firstWhere((s) => s.id == lecture.subjectId, orElse: () => Subject(id: 0, name: 'مادة محذوفة', code: '')).name;

              return ReusableListItem(
                leadingIcon: Icons.class_outlined,
                title: '$subjectName - ${lecture.lectureDate.toLocal().toString().substring(0, 10)}',
                subtitle: lecture.notes,
                onEdit: () => _openAddOrEditDialog(formData, lecture: lecture),
                onDelete: () async {
                  await LecturesRepository.instance.delete(lecture.id!);
                  _refreshData();
                },
              );
            },
          ),
        );
      },
    );
  }
}
