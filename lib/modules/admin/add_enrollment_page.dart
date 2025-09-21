import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/enrollment.dart';
import 'package:rafiqi_university/model/repository/enrollment_repository.dart';
import 'package:rafiqi_university/model/repository/subjects_repository.dart';
import 'package:rafiqi_university/model/repository/users_repository.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/model/user.dart';
import 'package:rafiqi_university/shared/components/dialog_helpers.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';
import 'package:rafiqi_university/shared/components/reusable_list_item.dart';

class AddEnrollmentPage extends StatefulWidget {
  const AddEnrollmentPage({super.key, required VoidCallback toggleTheme});

  @override
  State<AddEnrollmentPage> createState() => _AddEnrollmentPageState();
}

class _AddEnrollmentPageState extends State<AddEnrollmentPage> {
  late Future<List<Enrollment>> _enrollmentsFuture;
  late Future<List<User>> _usersFuture;
  late Future<List<Subject>> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  String _getStatusArabic(String status) {
    switch (status) {
      case 'ACTIVE': return 'نشط';
      case 'WITHDRAWN': return 'منسحب';
      case 'COMPLETED': return 'مكتمل';
      case 'FAILED': return 'راسب';
      default: return status;
    }
  }

  void _refreshData() {
    setState(() {
      _enrollmentsFuture = EnrollmentRepository.instance.getAll();
      _usersFuture = UsersRepository.instance.getAll();
      _subjectsFuture = SubjectsRepository.instance.getAll();
    });
  }

  void _openAddDialog({Enrollment? enrollment}) async {
    // لا نستخدم await هنا، بل نمرر الـ Futures مباشرة
    final users = await _usersFuture;
    final subjects = await _subjectsFuture;

    final userOptions = users
        .map((u) => DropdownOption(label: u.fullName, value: u.id.toString()))
        .toList();
    final subjectOptions = subjects
        .map((s) => DropdownOption(label: s.name, value: s.id.toString()))
        .toList();

    final fields = [
      FormFieldConfig(
        name: 'user_id',
        label: 'الطالب',
        type: FormFieldType.dropdown,keyboardType: TextInputType.text,
        dropdownOptions: userOptions,
        initialValue: enrollment?.userId.toString(),
        validator: (value) => (value == null) ? 'الرجاء اختيار الطالب' : null,
      ),
      FormFieldConfig(
        name: 'subj_id',
        label: 'المادة',
        type: FormFieldType.dropdown,
        dropdownOptions: subjectOptions,keyboardType: TextInputType.text,
        initialValue: enrollment?.subjectId.toString(),
        validator: (value) => (value == null) ? 'الرجاء اختيار المادة' : null,
      ),
      FormFieldConfig(
        name: 'status',
        label: 'حالة التسجيل',
        type: FormFieldType.dropdown,keyboardType: TextInputType.text,
        initialValue: enrollment?.status ?? 'ACTIVE',
        dropdownOptions:  [
          DropdownOption(label: 'نشط', value: 'ACTIVE'),
          DropdownOption(label: 'منسحب', value: 'WITHDRAWN'),
          DropdownOption(label: 'مكتمل', value: 'COMPLETED'),
          DropdownOption(label: 'راسب', value: 'FAILED'),
        ],
      ),
    ];

    // ✨ ================== بداية التعديل ================== ✨
    // لا يمكننا استخدام context مباشرة بعد await، لذلك نحفظه في متغير
    final currentContext = context;

    Future<void> onSave(Map<String, dynamic> data) async {
      try {
        final userId = int.parse(data['user_id'] as String);
        final subjectId = int.parse(data['subj_id'] as String);
        final status = data['status'] as String;

        if (enrollment == null) {
          await EnrollmentRepository.instance.create(userId, subjectId);
        } else {
          final updatedEnrollment = Enrollment(
            id: enrollment.id,
            userId: userId,
            subjectId: subjectId,
            status: status,
            enrollmentDate: enrollment.enrollmentDate,
          );
          await EnrollmentRepository.instance.update(updatedEnrollment);
        }
        
        _refreshData();

        // ✨ (الحل) استخدم الـ context المحفوظ لإغلاق النافذة
        if (currentContext.mounted) {
          Navigator.pop(currentContext);
        }
        
      } catch (e) {
        // يمكنك إظهار رسالة خطأ هنا إذا أردت
        if (currentContext.mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(content: Text('خطأ في الحفظ: ${e.toString()}')),
          );
        }
      }
    }
    // ✨ ================== نهاية التعديل ================== ✨

    if (mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => ReusableFormDialog(
          title: enrollment == null ? 'إضافة تسجيل جديد' : 'تعديل التسجيل',
          fields: fields,
          onSave: onSave,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([_enrollmentsFuture, _usersFuture, _subjectsFuture]),
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

        final enrollments = (snapshot.data![0] as List<Enrollment>?) ?? [];
        final users = (snapshot.data![1] as List<User>?) ?? [];
        final subjects = (snapshot.data![2] as List<Subject>?) ?? [];

        if (enrollments.isEmpty) {
          return const Center(child: Text('لا توجد تسجيلات. اضغط على زر + للإضافة.'));
        }

        return _buildEnrollmentListView(enrollments, users, subjects);
      },
    );
  }

  Widget _buildEnrollmentListView(List<Enrollment> enrollments, List<User> users, List<Subject> subjects) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: enrollments.length,
      itemBuilder: (context, index) {
        final enrollment = enrollments[index];
        final user = users.firstWhere((u) => u.id == enrollment.userId, orElse: () => User.empty());
        final subject = subjects.firstWhere((s) => s.id == enrollment.subjectId, orElse: () => Subject.empty());

        return ReusableListItem(
          title: 'تسجيل: ${user.fullName}',
          subtitle: 'المادة: ${subject.name} | الحالة: ${_getStatusArabic(enrollment.status)}',
          leadingIcon: Icons.app_registration,
          onEdit: () => _openAddDialog(enrollment: enrollment),
          onDelete: () async {
            final confirm = await showDeleteConfirmationDialog(context, itemName: 'تسجيل الطالب ${user.fullName}');
            if (confirm) {
              try {
                await EnrollmentRepository.instance.delete(enrollment.id);
                _refreshData();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ في الحذف: ${e.toString()}')),
                  );
                }
              }
            }
          },
        );
      },
    );
  }
}
