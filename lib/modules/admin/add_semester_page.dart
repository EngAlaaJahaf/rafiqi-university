import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/repository/semesters_repository.dart';
import 'package:rafiqi_university/model/semester.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';
import 'package:rafiqi_university/shared/components/reusable_list_item.dart';

class AddSemesterPage extends StatefulWidget {
  const AddSemesterPage({super.key, required VoidCallback toggleTheme});

  @override
  State<AddSemesterPage> createState() => _AddSemesterPageState();
}

class _AddSemesterPageState extends State<AddSemesterPage> {
  final SemestersRepository _semestersRepo = SemestersRepository.instance;
  late Future<List<Semester>> _semestersFuture;
  @override
  void initState() {
    super.initState();
    _refreshSemesters();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      // 4. اقرأ الـ ViewModel وقم بتعيين وظيفة الزر العائم الخاصة بهذه الشاشة
      Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
      }
    });
    super.dispose();
  }
  Future<void> _refreshSemesters() async {
    setState(() {
      _semestersFuture = SemestersRepository.instance.getAll();
    });
  }
  void _openAddDialog({Semester? semester}) {
    final String? initialStart = semester != null
        ? "${semester.startDate.year}-${semester.startDate.month.toString().padLeft(2, '0')}-${semester.startDate.day.toString().padLeft(2, '0')}"
        : null;
    final String? initialEnd = semester != null
        ? "${semester.endDate.year}-${semester.endDate.month.toString().padLeft(2, '0')}-${semester.endDate.day.toString().padLeft(2, '0')}"
        : null;

    final fields = [
      FormFieldConfig(
        name: 'name',
        label: 'اسم الفصل الدراسي',
        initialValue: semester?.name, // دعم التعديل
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم الفصل الدراسي' : null,
        keyboardType: TextInputType.text,
      ),
      FormFieldConfig(
        name: 'startDate',
        label: 'تاريخ البداية',
        type: FormFieldType.date,
        initialValue: initialStart,
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء اختيار تاريخ البداية' : null,
        keyboardType: TextInputType.datetime,
      ),
      FormFieldConfig(
        name: 'endDate',
        label: 'تاريخ النهاية',
        type: FormFieldType.date,
        initialValue: initialEnd,
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء اختيار تاريخ النهاية' : null,
        keyboardType: TextInputType.datetime,
      ),
      FormFieldConfig(
        name: 'isCurrent',
        label: 'الفصل الحالي؟',
        type: FormFieldType.dropdown,
        initialValue: (semester?.isCurrent ?? false).toString(),
        dropdownOptions: [
          DropdownOption(label: 'نعم', value: 'true'),
          DropdownOption(label: 'لا', value: 'false'),
        ],
        validator: (_) => null,
        keyboardType: TextInputType.text,
      ),
    ];

    Future<void> onSave(Map<String, dynamic> data) async {
      final DateTime start = DateTime.parse(data['startDate']);
      final DateTime end = DateTime.parse(data['endDate']);

      if (end.isBefore(start)) {
        // إظهار رسالة خطأ وإبقاء الحوار مفتوحًا
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تاريخ النهاية يجب أن يكون بعد تاريخ البداية')),
          );
        }
        return;
      }

      final newSemester = Semester(
        id: semester?.id,
        name: data['name'],
        startDate: start,
        endDate: end,
        isCurrent: (data['isCurrent'] ?? 'false') == 'true',
      );

      if (semester == null) {
        await _semestersRepo.create(newSemester);
      } else {
        await _semestersRepo.update(newSemester);
      }
      _refreshSemesters();
    }

    showDialog(
      context: context,
      builder: (context) => ReusableFormDialog(
        title: semester == null ? 'إضافة فصل دراسي' : 'تعديل الفصل الدراسي',
        fields: fields,
        onSave: onSave,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Semester>>(
      future: _semestersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: const Text('إضافة أول فصل دراسي'),);
        } else {
          final semesters = snapshot.data!;
          return ListView.builder(
            itemCount: semesters.length,
            itemBuilder: (context, index) {
              final sem = semesters[index];
              return ReusableListItem(
                title: '${sem.name} ',
                subtitle: 'مستوى- ${sem.startDate.year}/${sem.endDate.year}  ${sem.isCurrent ? "(الحالي)" : ""}',
                onTap: () => _openAddDialog(semester: sem),
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تأكيد الحذف'),
                      content: const Text('هل أنت متأكد من حذف هذا المستوى؟'),
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
                  );
                  if (confirm == true) {
                    await _semestersRepo.delete(sem.id!);
                    _refreshSemesters();
                  }
                },
                onEdit: () => _openAddDialog(semester: sem),
              );
            },
          );
        }
      },
    );
  }
}