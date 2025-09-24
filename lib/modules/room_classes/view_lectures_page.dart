// lib/modules/lectures/view_lectures_page.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rafiqi_university/model/lecture.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/model/teacher.dart';
import 'package:rafiqi_university/model/time_slot.dart';
import 'package:rafiqi_university/model/lecture_type.dart';
import 'package:rafiqi_university/model/class_room.dart';

// استيراد كل الـ Repositories المطلوبة
import 'package:rafiqi_university/model/repository/lectures_repository.dart';
import 'package:rafiqi_university/model/repository/subjects_repository.dart';
import 'package:rafiqi_university/model/repository/teachers_repository.dart';
import 'package:rafiqi_university/model/repository/time_slots_repository.dart';
import 'package:rafiqi_university/model/repository/lecture_types_repository.dart';
import 'package:rafiqi_university/model/repository/class_rooms_repository.dart';

import 'package:rafiqi_university/shared/components/lecture_card.dart';

// ✨ 1. كلاس لتجميع كل البيانات المساعدة (نفس الكلاس السابق)
class LectureDisplayData {
  final List<Subject> subjects;
  final List<Teacher> teachers;
  final List<TimeSlot> timeSlots;
  final List<LectType> lectureTypes;
  final List<ClassRoom> classRooms;

  LectureDisplayData({
    required this.subjects,
    required this.teachers,
    required this.timeSlots,
    required this.lectureTypes,
    required this.classRooms,
  });
}

class ViewLecturesPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const ViewLecturesPage({super.key, required this.toggleTheme});

  @override
  State<ViewLecturesPage> createState() => _ViewLecturesPageState();
}

class _ViewLecturesPageState extends State<ViewLecturesPage> {
  // ✨ 2. دمج الـ Futures في Future واحد لتسهيل التعامل
  late Future<Map<String, dynamic>> _pageDataFuture;
  DateTime _focusedDate = DateTime.now(); // اليوم الذي يحدد الأسبوع الحالي
  DateTime? _selectedDay; // اليوم الذي يختاره المستخدم من التبويبات

  @override
  void initState() {
    super.initState();
    // تهيئة دعم اللغة العربية للتواريخ
    initializeDateFormatting('ar', null);
    _pageDataFuture = _loadPageData();
    _selectedDay = _focusedDate; // ابدأ باختيار اليوم الحالي
  }

  Map<String, DateTime> _getWeekBounds(DateTime date) {
    // نحول يوم الأسبوع في Dart (الاثنين=1, الأحد=7) إلى نظامنا (السبت=0, الجمعة=6)
    // (date.weekday % 7) + 1 ينتج عنه: السبت=0, الأحد=1, ..., الجمعة=6
    // لكن بما أن الأحد هو 7 في Dart، نحتاج لتعديل بسيط
    final dayOfWeek = date.weekday; // الاثنين=1, ..., السبت=6, الأحد=7
    // نريد أن نطرح عدد الأيام التي مضت منذ يوم السبت
    // السبت: نطرح 0, الأحد: نطرح 1, الاثنين: نطرح 2, ..., الجمعة: نطرح 6
    final daysToSubtract = (dayOfWeek == 6) ? 0 : (dayOfWeek % 7) + 1;

    final startOfWeek = DateTime(
      date.year,
      date.month,
      date.day - daysToSubtract,
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return {'start': startOfWeek, 'end': endOfWeek};
  }

  List<DateTime> _getDaysInWeek(DateTime date) {
    final start = _getWeekBounds(date)['start']!;
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  // ✨ 3. دوال لتغيير الأسبوع
  void _goToPreviousWeek() {
    setState(() {
      _focusedDate = _focusedDate.subtract(const Duration(days: 7));
      _selectedDay = _getWeekBounds(
        _focusedDate,
      )['start']; // اختر أول يوم في الأسبوع الجديد
    });
  }

  void _goToNextWeek() {
    setState(() {
      _focusedDate = _focusedDate.add(const Duration(days: 7));
      _selectedDay = _getWeekBounds(
        _focusedDate,
      )['start']; // اختر أول يوم في الأسبوع الجديد
    });
  }

  // ✨ 3. دالة واحدة لجلب كل البيانات المطلوبة للصفحة
  Future<Map<String, dynamic>> _loadPageData() async {
    // جلب كل البيانات بالتوازي لتحسين الأداء
    final results = await Future.wait([
      LecturesRepository.instance.getAll(), // 0: lectures
      SubjectsRepository.instance.getAll(), // 1: subjects
      TeachersRepository.instance.getAll(), // 2: teachers
      TimeSlotRepository.instance.getAll(), // 3: timeSlots
      LectureTypeRepository.instance.getAll(), // 4: lectureTypes
      ClassRoomsRepository.instance.getAll(), // 5: classRooms
    ]);

    // تنظيم البيانات في Map لسهولة الوصول إليها
    return {
      'lectures': results[0] as List<Lecture>,
      'displayData': LectureDisplayData(
        subjects: results[1] as List<Subject>,
        teachers: results[2] as List<Teacher>,
        timeSlots: results[3] as List<TimeSlot>,
        lectureTypes: results[4] as List<LectType>,
        classRooms: results[5] as List<ClassRoom>,
      ),
    };
  }

  // ✨ 4. دالة لتحديث البيانات عند السحب للأسفل
  Future<void> _refreshData() async {
    setState(() {
      _pageDataFuture = _loadPageData();
    });
  }

  //-=-=-=-=--=-===-=-=-=-=-=-=-=-=
 void _showCompletionDialog(Lecture lecture) {
  // ✨ 1. المتغير المحلي للـ Checkbox يجب أن يكون bool
  bool isChecked = lecture.isCompleted;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('تأكيد حضور المحاضرة'),
            content: CheckboxListTile(
              title: const Text('هل تم أخذ هذه المحاضرة؟'),
              // ✨ 2. الـ Checkbox يأخذ قيمة bool
              value: isChecked,
              onChanged: (bool? newValue) {
                setDialogState(() {
                  // ✨ 3. تحديث متغير الـ bool المحلي
                  isChecked = newValue ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updatedLecture = Lecture(
                    id: lecture.id,
                    subjectId: lecture.subjectId,
                    lectureDate: lecture.lectureDate,
                    teacherId: lecture.teacherId,
                    timeSlotId: lecture.timeSlotId,
                    lectureTypeId: lecture.lectureTypeId,
                    classId: lecture.classId,
                    notes: lecture.notes,
                    // ✨ الحقل في الموديل bool، لذا نمرر القيمة مباشرة
                    isCompleted: isChecked,
                  );

                  await LecturesRepository.instance.update(updatedLecture);

                  if (mounted) {
                    Navigator.of(context).pop();
                    _refreshData();
                  }
                },
                child: const Text('حفظ'),
              ),
            ],
          );
        },
      );
    },
  );
}

  //-=-==-=-=-=-
  @override
  Widget build(BuildContext context) {
    final weekBounds = _getWeekBounds(_focusedDate);
    final startOfWeek = weekBounds['start']!;
    final endOfWeek = weekBounds['end']!;
    final daysOfWeek = _getDaysInWeek(_focusedDate);
    return FutureBuilder<Map<String, dynamic>>(
      future: _pageDataFuture,
      builder: (context, snapshot) {
        // --- حالات التحميل والخطأ ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('لا توجد بيانات لعرضها.'));
        }

        // --- حالة النجاح ---
        final lectures = snapshot.data!['lectures'] as List<Lecture>;
        final displayData = snapshot.data!['displayData'] as LectureDisplayData;

        if (lectures.isEmpty) {
          return const Center(child: Text('لا توجد محاضرات حاليًا.'));
        }

        // --- بناء الواجهة ---
        return Scaffold(
          // ✨ 4. بناء AppBar الديناميكي
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _goToPreviousWeek,
              tooltip: 'الأسبوع السابق',
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: _goToNextWeek,
                tooltip: 'الأسبوع التالي',
              ),
            ],
            title: Text(
              '${startOfWeek.day} - ${endOfWeek.day} ${DateFormat.MMMM('ar').format(endOfWeek)}',
              style: const TextStyle(fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // ✨ 5. بناء شريط تبويبات الأيام
              _buildDayTabs(daysOfWeek),

              // ✨ 6. بناء قائمة المحاضرات المفلترة
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _pageDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('لا توجد بيانات.'));
                    }

                    final allLectures =
                        snapshot.data!['lectures'] as List<Lecture>;
                    final displayData =
                        snapshot.data!['displayData'] as LectureDisplayData;

                    // --- فلترة المحاضرات حسب اليوم المحدد ---
                    final lecturesForSelectedDay = allLectures.where((lecture) {
                      return lecture.lectureDate.year == _selectedDay!.year &&
                          lecture.lectureDate.month == _selectedDay!.month &&
                          lecture.lectureDate.day == _selectedDay!.day;
                    }).toList();

                    if (lecturesForSelectedDay.isEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد محاضرات ليوم ${DateFormat.EEEE('ar').format(_selectedDay!)}',
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        itemCount: lecturesForSelectedDay.length,
                        itemBuilder: (context, index) {
                          final lecture = lecturesForSelectedDay[index];

                          // --- جلب البيانات المساعدة لعرضها ---
                          final subjectName = displayData.subjects
                              .firstWhere(
                                (s) => s.id == lecture.subjectId,
                                orElse: () => Subject(
                                  id: 0,
                                  name: 'مادة محذوفة',
                                  code: '',
                                ),
                              )
                              .name;
                          final lectureTypeName = displayData.lectureTypes
                              .firstWhere(
                                (lt) => lt.id == lecture.lectureTypeId,
                                orElse: () => LectType(id: 0, name: 'غير محدد'),
                              )
                              .name;
                          final teacherName = displayData.teachers
                              .firstWhere(
                                (t) => t.id == lecture.teacherId,
                                orElse: () => Teacher(id: 0, name: 'غير محدد'),
                              )
                              .name;
                          final classRoomName = displayData.classRooms
                              .firstWhere(
                                (cr) => cr.id == lecture.classId,
                                orElse: () => ClassRoom(
                                  id: 0,
                                  name: 'غير محددة',
                                  toggleTheme: () {},
                                ),
                              )
                              .name;
                          final timeSlot = displayData.timeSlots.firstWhere(
                            (ts) => ts.id == lecture.timeSlotId,
                            orElse: () => TimeSlot(
                              id: 0,
                              startTime: '',
                              endTime: '',
                              name: '',
                            ),
                          );
                          final timeSlotName = (timeSlot.id == 0)
                              ? 'غير محدد'
                              : '${timeSlot.startTime} - ${timeSlot.endTime}';

                          // --- استخدام LectureCard للعرض فقط ---
                          return LectureCard(
                            subjectName: subjectName,
                            lectureTypeName: lectureTypeName,
                            teacherName: teacherName,
                            classRoomName: classRoomName,
                            timeSlotName: timeSlotName,
                            isCompleted: lecture.isCompleted ? 1 : 0,
                            // ✨ 5. تمرير دوال فارغة لأن هذه الصفحة للعرض فقط
                            onEdit: () {
                              // يمكنك هنا عرض رسالة للمستخدم بأنه لا يمكن التعديل من هذه الشاشة
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'للتعديل، يرجى الذهاب إلى لوحة تحكم المسؤول.',
                                  ),
                                ),
                              );
                            },
                            onDelete: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'للحذف، يرجى الذهاب إلى لوحة تحكم المسؤول.',
                                  ),
                                ),
                              );
                            },
                            onTap: () => _showCompletionDialog(lecture),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayTabs(List<DateTime> days) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: days.map((day) {
            final isSelected =
                day.year == _selectedDay!.year &&
                day.month == _selectedDay!.month &&
                day.day == _selectedDay!.day;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDay = day;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat.E('ar').format(day), // اسم اليوم (مثال: سبت)
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${day.day}', // رقم اليوم
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
