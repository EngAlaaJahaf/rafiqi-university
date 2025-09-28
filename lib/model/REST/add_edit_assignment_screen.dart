// lib/modules/assignments/add_edit_assignment_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ✨ 1. استيراد الموديلات الجديدة
import 'package:rafiqi_university/model/REST/assignment_rest.dart';
import 'package:rafiqi_university/model/REST/lecture_rest.dart';
import 'package:rafiqi_university/model/REST/lecture_view_rest.dart';
import 'package:rafiqi_university/model/REST/subject_rest.dart'; // استيراد موديل المواد
import 'package:rafiqi_university/model/REST/lecture_view_rest.dart'; // استيراد الـ ViewModel
import 'package:rafiqi_university/services/api_service.dart';

class AddEditAssignmentScreen extends StatefulWidget {
  final AssignmentRest? assignment;
  // ✨ 2. تعديل المُنشئ ليقبل دالة onSave
  final VoidCallback onSave; 

  const AddEditAssignmentScreen({
    super.key, 
    this.assignment,
    required this.onSave, // جعلها مطلوبة
  });

  @override
  State<AddEditAssignmentScreen> createState() => _AddEditAssignmentScreenState();
}

class _AddEditAssignmentScreenState extends State<AddEditAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  
  int? _selectedLectureId;
  DateTime? _selectedDueDate;

  // ✨ 3. تغيير أسماء متغيرات الحالة
  bool _isLoadingData = true; // لتتبع تحميل البيانات الأولية
  bool _isSaving = false;

  // ✨ 4. استخدام قائمة من الـ ViewModel بدلاً من LectureRest
  List<LectureViewRest> _lectureViewModels = [];
  String? _errorMessage; // لعرض رسائل الخطأ في جلب البيانات

  bool get _isEditing => widget.assignment != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.assignment?.assignTitle);
    _descriptionController = TextEditingController(text: widget.assignment?.assignDescription);
    _selectedDueDate = widget.assignment?.assignDueDate;
    _selectedLectureId = widget.assignment?.lectId;

    _fetchInitialData();
  }

  // ✨ 5. تحديث دالة جلب البيانات بالكامل
  Future<void> _fetchInitialData() async {
    // لا داعي لـ setState هنا لأن الـ build يعتمد على _isLoadingData
    try {
      final results = await Future.wait([
        _apiService.getLectures(),
        _apiService.getSubjects(),
      ]);

      final lectures = results[0] as List<LectureRest>;
      final subjects = results[1] as List<SubjectRest>;

      final subjectsMap = {for (var s in subjects) s.subjId: s.subjName};

      final viewModels = lectures.map((lecture) {
        final subjectName = subjectsMap[lecture.subjId] ?? 'مادة غير معروفة';
        return LectureViewRest(
          lectId: lecture.lectId,
          displayText: LectureViewRest.createDisplayText(subjectName, lecture.lectDate),
        );
      }).toList();

      if (mounted) {
        setState(() {
          _lectureViewModels = viewModels;
          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في جلب البيانات: $e';
          _isLoadingData = false;
        });
      }
    }
  }

  Future<void> _pickDueDate() async {
  // ✨ --- بداية التعديل --- ✨
  final now = DateTime.now();
  final initial = _selectedDueDate ?? now;

  // إذا كان التاريخ الأولي قبل اليوم، استخدم اليوم بدلاً منه
  final validInitialDate = initial.isBefore(now) ? now : initial;
  // ✨ --- نهاية التعديل --- ✨

  final pickedDate = await showDatePicker(
    context: context,
    // استخدم المتغيرات الجديدة
    initialDate: validInitialDate,
    firstDate: now, // أول تاريخ مسموح به هو اليوم
    lastDate: now.add(const Duration(days: 365)),
  );
  if (pickedDate != null && pickedDate != _selectedDueDate) {
    setState(() {
      _selectedDueDate = pickedDate;
    });
  }
}

  // ✨ 6. تحديث دالة الحفظ
  Future<void> _saveAssignment() async {
    if (_formKey.currentState?.validate() ?? false) {
      // التحقق من الحقول الأخرى يبقى كما هو
      if (_selectedLectureId == null || _selectedDueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إكمال كل الحقول المطلوبة'), backgroundColor: Colors.orange),
        );
        return;
      }

      setState(() => _isSaving = true);

      try {
        final assignmentData = AssignmentRest(
          assignId: widget.assignment?.assignId ?? 0, 
          lectId: _selectedLectureId!,
          assignTitle: _titleController.text,
          assignDescription: _descriptionController.text,
          assignDueDate: _selectedDueDate!,
          // تم تغيير اسم الحقل في الموديل
          isCompleted: widget.assignment?.isCompleted ?? false, assignIsCompleted: null,
        );

        if (_isEditing) {
          await _apiService.updateAssignment(assignmentData);
        } else {
          await _apiService.addAssignment(assignmentData);
        }
if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم الحفظ بنجاح!'), backgroundColor: Colors.green),
    );
    
    // استخدم هذا السطر للرجوع بشكل آمن
    Navigator.of(context, rootNavigator: true).pop(true);
    // ✨ --- نهاية التعديل --- ✨

  } catch (e) {
    if (!mounted) return; // تحقق هنا أيضاً
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل في حفظ التكليف: $e'), backgroundColor: Colors.red),
    );
  } finally {
    if (mounted) {
      setState(() => _isSaving = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'تعديل التكليف' : 'إضافة تكليف جديد'),
      ),
      // ✨ 7. تحديث منطق الـ build
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // ✨ 8. تحديث القائمة المنسدلة
                      DropdownButtonFormField<int>(
                        value: _lectureViewModels.any((vm) => vm.lectId == _selectedLectureId) 
                                ? _selectedLectureId 
                                : null,
                        hint: const Text('اختر المحاضرة'),
                        items: _lectureViewModels.map((viewModel) {
                          return DropdownMenuItem<int>(
                            value: viewModel.lectId,
                            child: Text(viewModel.displayText), 
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLectureId = value;
                          });
                        },
                        validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 20),

                      // (باقي الحقول تبقى كما هي)
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'عنوان التكليف',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value?.isEmpty ?? true) ? 'هذا الحقل مطلوب' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'الوصف (اختياري)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          _selectedDueDate == null
                              ? 'اختر تاريخ التسليم'
                              : 'تاريخ التسليم: ${DateFormat('yyyy-MM-dd').format(_selectedDueDate!)}',
                        ),
                        onTap: _pickDueDate,
                      ),
                      const SizedBox(height: 40),

                      _isSaving
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _saveAssignment,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('حفظ'),
                            ),
                    ],
                  ),
                ),
    );
  }
}
