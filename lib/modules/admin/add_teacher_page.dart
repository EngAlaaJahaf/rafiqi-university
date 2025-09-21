import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/repository/teachers_repository.dart';
import 'package:rafiqi_university/model/teacher.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';
import 'package:rafiqi_university/shared/components/reusable_list_item.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key, required VoidCallback toggleTheme});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final TeachersRepository _teachersRepo = TeachersRepository.instance;
  late Future<List<Teacher>> _teachersFuture;
@override
  void initState() {
    super.initState();
    _refreshTeachers();
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
  Future<void> _refreshTeachers() async {
    setState(() {
      _teachersFuture = TeachersRepository.instance.getAll();
    });
  }
  void _openAddDialog({Teacher? teacher}) {
    final fields = [
      FormFieldConfig(
        name: 'teach_name',
        label: 'اسم المدرس',
        initialValue: teacher?.name, // دعم التعديل
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم المدرس' : null,
        keyboardType: TextInputType.text,
      ),
      FormFieldConfig(
        name: 'teach_email',
        label: 'البريد الإلكتروني',
        initialValue: teacher?.email, // دعم التعديل
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'الرجاء إدخال البريد الإلكتروني';
        //   }
        //   final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        //   if (!emailRegex.hasMatch(value)) {
        //     return 'الرجاء إدخال بريد إلكتروني صالح';
        //   }
        //   return null;
        // },
        keyboardType: TextInputType.emailAddress,
      ),
      FormFieldConfig(
        name: 'teach_phone',
        label: 'رقم الهاتف',
        initialValue: teacher?.phone, // دعم التعديل
        // validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال رقم الهاتف' : null,
        keyboardType: TextInputType.phone,
      ),
    ];
    Future<void> onSave(Map<String, dynamic> data) async {
      final newTeacher = Teacher(
        id: teacher?.id,
        name: data['teach_name'],
        email: data['teach_email'],
        phone: data['teach_phone'],
      );
      if (teacher == null) {
            await _teachersRepo.create(newTeacher);
          } else {
            await _teachersRepo.update(newTeacher);
          }
          _refreshTeachers();
    }
    showDialog(
      context: context,
      builder: (context) => ReusableFormDialog(
        title: teacher == null ? 'إضافة مدرس جديد' : 'تعديل بيانات المدرس',
        fields: fields,
        onSave: onSave,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Teacher>>(
      future: _teachersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا يوجد مدرسين'));
        } else {
          final teachers = snapshot.data!;
          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return ReusableListItem(
                title: '${teacher.name}', 
                onEdit: () => _openAddDialog(teacher: teacher), 
                onDelete: () async {
                   await _teachersRepo.delete(teacher.id!);
                   
                  _refreshTeachers();
                }
            );
            },
          );
        }
      },
    );
  }
}
