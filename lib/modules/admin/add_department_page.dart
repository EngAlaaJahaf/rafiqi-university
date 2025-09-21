import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/department.dart';
import 'package:rafiqi_university/model/repository/departments_repository.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';

class AddDepartmentPage extends StatefulWidget {
  const AddDepartmentPage({super.key, required VoidCallback toggleTheme});

  @override
  State<AddDepartmentPage> createState() => _AddDepartmentPageState();
}

class _AddDepartmentPageState extends State<AddDepartmentPage> {
  final DepartmentsRepository _departmentsRepo = DepartmentsRepository.instance;
 late Future<List<Department>> _departmentsFuture;
 @override
  void initState() {
    super.initState();
    // تحميل البيانات عند بدء تشغيل الصفحة
   _refreshDepartments(); 
   WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);
   });// نفترض وجود دالة getAll في الـ repo
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
  Future<void> _refreshDepartments() async {
    setState(() {
      _departmentsFuture = DepartmentsRepository.instance.getAll();
    });
  }
  void _openAddDialog({Department? department}) {
    final fields = [
      FormFieldConfig(
        name: 'dept_name',
        label: 'اسم القسم',
        initialValue: department?.name, // دعم التعديل
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم القسم' : null, keyboardType: TextInputType.text,
      ),
    ];
    
    Future<void> onSave(Map<String, dynamic> data) async {
      final newDepartment = Department(
        id: department?.id,
        name: data['dept_name'],
      );
      if (department == null) {
        await _departmentsRepo.create(newDepartment);
      } else {
        await _departmentsRepo.update(newDepartment);
      }
      _refreshDepartments();
    }
    
    showDialog(
      context: context,
      builder: (context) => ReusableFormDialog(
        title: department == null ? 'إضافة قسم جديد' : 'تعديل القسم',
        fields: fields,
        onSave: onSave,
      ),
    );
  }
 
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Department>>(
      future: _departmentsFuture, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد أقسام متاحة.'));
        } else {
          final departments = snapshot.data!;
          return ListView.builder(
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final dept = departments[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: ListTile(
                  title: Text(dept.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color.fromARGB(255, 27, 176, 239)),
                        onPressed: () => _openAddDialog(department: dept),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content: const Text('هل أنت متأكد من حذف هذا القسم؟'),
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
                          if (confirm == true ) {
                            await DepartmentsRepository.instance.delete(dept.id!);
                            _refreshDepartments();
                          };
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      });
  }
}